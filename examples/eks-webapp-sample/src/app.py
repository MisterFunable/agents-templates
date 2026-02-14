"""
Simple API application ready for EKS deployment.
Follows 12-factor app principles.
"""
import logging
import signal
import sys
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from prometheus_client import Counter, Histogram, generate_latest
from fastapi import Response

from .config import Config
from .logging_config import setup_logging

# Setup structured logging
logger = setup_logging()

# Prometheus metrics
request_count = Counter(
    'http_requests_total',
    'Total HTTP requests',
    ['method', 'endpoint', 'status']
)
request_duration = Histogram(
    'http_request_duration_seconds',
    'HTTP request duration'
)

# Graceful shutdown flag
shutdown_flag = False


def graceful_shutdown(signum, frame):
    """Handle SIGTERM for zero-downtime deployments."""
    global shutdown_flag
    logger.info("Received SIGTERM, initiating graceful shutdown...")
    shutdown_flag = True
    # Kubernetes gives 30 seconds before SIGKILL
    sys.exit(0)


signal.signal(signal.SIGTERM, graceful_shutdown)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Startup and shutdown events."""
    logger.info("Application starting up", extra={"config": Config.to_dict()})
    yield
    logger.info("Application shutting down")


app = FastAPI(
    title="EKS Web App",
    version="1.0.0",
    lifespan=lifespan
)


@app.middleware("http")
async def log_requests(request, call_next):
    """Log all requests with metrics."""
    import time
    start_time = time.time()

    response = await call_next(request)

    duration = time.time() - start_time
    request_count.labels(
        method=request.method,
        endpoint=request.url.path,
        status=response.status_code
    ).inc()
    request_duration.observe(duration)

    logger.info(
        "Request processed",
        extra={
            "method": request.method,
            "path": request.url.path,
            "status": response.status_code,
            "duration_ms": round(duration * 1000, 2)
        }
    )

    return response


@app.get("/")
async def root():
    """Root endpoint."""
    return {"message": "Hello from EKS!", "version": "1.0.0"}


@app.get("/health")
async def health():
    """
    Liveness probe: Is the application running?
    Kubernetes uses this to restart unhealthy pods.
    """
    if shutdown_flag:
        return JSONResponse(
            status_code=503,
            content={"status": "shutting down"}
        )
    return {"status": "healthy"}


@app.get("/ready")
async def readiness():
    """
    Readiness probe: Can the application serve traffic?
    Kubernetes uses this to route traffic to ready pods.
    """
    if shutdown_flag:
        return JSONResponse(
            status_code=503,
            content={"status": "not ready", "reason": "shutting down"}
        )

    # Check dependencies (database, cache, etc.)
    checks = {
        "app": True,  # Always true if we reach here
    }

    # Example: Add real checks
    # checks["database"] = await check_database()
    # checks["redis"] = await check_redis()

    all_ready = all(checks.values())

    if not all_ready:
        return JSONResponse(
            status_code=503,
            content={"status": "not ready", "checks": checks}
        )

    return {"status": "ready", "checks": checks}


@app.get("/metrics")
async def metrics():
    """Prometheus metrics endpoint."""
    return Response(content=generate_latest(), media_type="text/plain")


@app.get("/api/items")
async def list_items():
    """Example API endpoint."""
    return {
        "items": [
            {"id": 1, "name": "Item 1"},
            {"id": 2, "name": "Item 2"},
            {"id": 3, "name": "Item 3"},
        ]
    }


@app.get("/api/items/{item_id}")
async def get_item(item_id: int):
    """Get single item by ID."""
    if item_id > 3:
        raise HTTPException(status_code=404, detail="Item not found")

    return {"id": item_id, "name": f"Item {item_id}"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "src.app:app",
        host="0.0.0.0",
        port=Config.PORT,
        log_config=None  # Use our custom logging
    )
