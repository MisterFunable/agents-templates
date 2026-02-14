# AGENTS_EKS_WEBAPP.md

Instructions for AI models building simple web applications that run on Amazon EKS (Elastic Kubernetes Service).

Focus: Single containerized apps following 12-factor principles, production-ready for Kubernetes deployment.

## Application Structure

Standard structure for containerized web apps:

```
app-name/
├── src/
│   ├── app.py or index.js        # Application entry point
│   ├── routes/                    # API endpoints
│   ├── services/                  # Business logic
│   └── models/                    # Data models
├── tests/
│   ├── unit/
│   └── integration/
├── k8s/
│   ├── deployment.yaml            # Kubernetes deployment
│   ├── service.yaml               # Kubernetes service
│   ├── ingress.yaml               # Ingress configuration
│   └── configmap.yaml             # Configuration
├── Dockerfile                     # Multi-stage build
├── .dockerignore                  # Exclude from image
├── requirements.txt or package.json
├── README.md
└── .env.example                   # Example environment variables
```

**Key separation:**
- `src/` - Application code (stateless)
- `k8s/` - Kubernetes manifests (infrastructure)
- Dockerfile - Single-stage or multi-stage build
- Environment-specific config via ConfigMap/Secrets

## Containerization

### Multi-Stage Dockerfile

Use multi-stage builds for smaller images:

```dockerfile
# Build stage
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

# Production stage
FROM node:18-alpine
WORKDIR /app
COPY --from=build /app .
USER node
EXPOSE 3000
CMD ["node", "src/index.js"]
```

**Pattern:**
1. Build stage: Install deps, compile/build
2. Production stage: Copy artifacts only
3. Run as non-root user (`USER node`)
4. Single process per container

**Python example:**

```dockerfile
FROM python:3.11-slim AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.11-slim
WORKDIR /app
COPY --from=build /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY src/ ./src/
USER nobody
EXPOSE 8000
CMD ["python", "-m", "uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8000"]
```

### .dockerignore

Exclude unnecessary files from image:

```
node_modules/
.git/
.env
*.md
tests/
k8s/
*.log
.vscode/
.idea/
```

**Always exclude:** dev dependencies, tests, docs, secrets, VCS files.

## Configuration Management

### 12-Factor Configuration

**Environment variables for runtime config:**

```python
import os

# Configuration class
class Config:
    PORT = int(os.getenv("PORT", "8000"))
    DATABASE_URL = os.getenv("DATABASE_URL")  # Required
    LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
    REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379")

    @classmethod
    def validate(cls):
        if not cls.DATABASE_URL:
            raise ValueError("DATABASE_URL environment variable required")

# Fail fast on startup
Config.validate()
```

**Node.js example:**

```javascript
// config.js
const config = {
  port: process.env.PORT || 3000,
  databaseUrl: process.env.DATABASE_URL,
  logLevel: process.env.LOG_LEVEL || 'info',
  redisUrl: process.env.REDIS_URL || 'redis://localhost:6379'
};

// Validate required vars
if (!config.databaseUrl) {
  throw new Error('DATABASE_URL environment variable required');
}

module.exports = config;
```

### Kubernetes ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  LOG_LEVEL: "info"
  REDIS_URL: "redis://redis-service:6379"
```

**Use ConfigMap for:** Non-sensitive configuration (log levels, service URLs)
**Use Secrets for:** Sensitive data (database passwords, API keys)

## Health Checks

### Endpoints Required

Every app must expose:

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
async def health():
    """Liveness: Is app running?"""
    return {"status": "healthy"}

@app.get("/ready")
async def readiness():
    """Readiness: Can app handle traffic?"""
    db_ok = await check_database()
    cache_ok = await check_redis()

    if db_ok and cache_ok:
        return {"status": "ready", "database": "ok", "cache": "ok"}

    return JSONResponse(
        status_code=503,
        content={"status": "not ready", "database": db_ok, "cache": cache_ok}
    )
```

**Pattern:**
- `/health` (liveness) - Returns 200 if app is running
- `/ready` (readiness) - Returns 200 if app can serve traffic (checks dependencies)

**Kubernetes integration:**

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8000
  initialDelaySeconds: 10
  periodSeconds: 10
  failureThreshold: 3

readinessProbe:
  httpGet:
    path: /ready
    port: 8000
  initialDelaySeconds: 5
  periodSeconds: 5
  failureThreshold: 2
```

## Logging

### Structured Logging to STDOUT

```python
import logging
import json
from datetime import datetime

class JSONFormatter(logging.Formatter):
    def format(self, record):
        log_data = {
            "timestamp": datetime.utcnow().isoformat(),
            "level": record.levelname,
            "message": record.getMessage(),
            "service": "app-name",
        }
        if record.exc_info:
            log_data["exception"] = self.formatException(record.exc_info)
        return json.dumps(log_data)

# Configure logger
handler = logging.StreamHandler()
handler.setFormatter(JSONFormatter())
logger = logging.getLogger()
logger.addHandler(handler)
logger.setLevel(logging.INFO)

# Usage
logger.info("Request processed", extra={"user_id": "123", "duration_ms": 45})
```

**Pattern:**
- Log to STDOUT/STDERR only (Kubernetes collects logs)
- Use structured JSON format
- Include context: service name, request ID, user ID
- No file logging (ephemeral containers)

## Kubernetes Deployment

### Deployment Manifest

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-name
  labels:
    app: app-name
spec:
  replicas: 3
  selector:
    matchLabels:
      app: app-name
  template:
    metadata:
      labels:
        app: app-name
    spec:
      containers:
      - name: app-name
        image: your-registry/app-name:1.0.0
        ports:
        - containerPort: 8000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: database-url
        envFrom:
        - configMapRef:
            name: app-config
        resources:
          requests:
            memory: "256Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 10
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 5
```

**Key elements:**
- `replicas: 3` - High availability (min 2 for zero-downtime)
- Resource requests/limits - Prevent resource starvation
- Health probes - Automatic recovery
- Secrets for sensitive data

### Service Manifest

```yaml
apiVersion: v1
kind: Service
metadata:
  name: app-name-service
spec:
  selector:
    app: app-name
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8000
  type: ClusterIP
```

**Pattern:**
- `ClusterIP` for internal services
- `LoadBalancer` for external exposure (or use Ingress)
- Port 80 external, container port internal

### Ingress (ALB)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-name-ingress
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/healthcheck-path: /health
spec:
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-name-service
            port:
              number: 80
```

**For EKS:** Use AWS Load Balancer Controller with ALB annotations.

## Resource Management

### Resource Requests and Limits

| App Type | Memory Request | Memory Limit | CPU Request | CPU Limit |
|----------|---------------|--------------|-------------|-----------|
| Small API | 128Mi | 256Mi | 50m | 200m |
| Medium API | 256Mi | 512Mi | 100m | 500m |
| Large API | 512Mi | 1Gi | 250m | 1000m |
| Background Worker | 256Mi | 512Mi | 100m | 500m |

**Guidelines:**
- Set requests = typical usage (for scheduling)
- Set limits = peak usage (to prevent runaway)
- CPU: 1000m = 1 CPU core
- Memory: Use Mi (mebibytes) not MB

**Horizontal Pod Autoscaling:**

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: app-name-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: app-name
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

## Graceful Shutdown

Handle SIGTERM for zero-downtime deployments:

```python
import signal
import sys

def graceful_shutdown(signum, frame):
    logger.info("Received shutdown signal, draining connections...")
    # Stop accepting new requests
    server.shutdown_flag = True
    # Wait for active requests to complete (max 30 seconds)
    server.wait_for_active_requests(timeout=30)
    logger.info("Shutdown complete")
    sys.exit(0)

signal.signal(signal.SIGTERM, graceful_shutdown)
```

**Node.js example:**

```javascript
process.on('SIGTERM', () => {
  console.log('Received SIGTERM, shutting down gracefully...');
  server.close(() => {
    console.log('Closed all connections');
    process.exit(0);
  });

  // Force shutdown after 30 seconds
  setTimeout(() => {
    console.error('Forced shutdown');
    process.exit(1);
  }, 30000);
});
```

**Kubernetes integration:**

```yaml
spec:
  terminationGracePeriodSeconds: 30
```

**Pattern:** Kubernetes sends SIGTERM → app stops accepting requests → drains connections → exits.

## Observability

### Metrics Endpoint

Expose Prometheus metrics:

```python
from prometheus_client import Counter, Histogram, generate_latest

# Metrics
request_count = Counter('http_requests_total', 'Total requests', ['method', 'endpoint', 'status'])
request_duration = Histogram('http_request_duration_seconds', 'Request duration')

@app.get("/metrics")
async def metrics():
    return Response(content=generate_latest(), media_type="text/plain")

# Instrument endpoints
@request_duration.time()
def handle_request():
    # ... handle request
    request_count.labels(method="GET", endpoint="/api/users", status="200").inc()
```

**Key metrics:**
- Request rate (requests/sec)
- Error rate (% of failed requests)
- Response time (p50, p95, p99)
- Resource usage (CPU, memory)

## Security

### Best Practices

| Aspect | Implementation |
|--------|---------------|
| Run as non-root | `USER node` or `USER nobody` in Dockerfile |
| Read-only filesystem | `readOnlyRootFilesystem: true` in securityContext |
| Drop capabilities | `drop: ["ALL"]` in securityContext |
| Scan images | Use Trivy or Snyk in CI/CD |
| Network policies | Restrict pod-to-pod communication |
| Secrets management | Use AWS Secrets Manager or Kubernetes Secrets |

**Security context example:**

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  capabilities:
    drop:
    - ALL
```

## Deployment Strategy

### Rolling Update (Default)

```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Max 1 extra pod during update
      maxUnavailable: 0  # Keep all pods available
```

**Pattern:** Deploy new version gradually, zero downtime.

### Deployment Checklist

Before deploying:

1. **Build and tag image:**
   ```bash
   docker build -t app-name:1.0.0 .
   docker tag app-name:1.0.0 your-registry/app-name:1.0.0
   docker push your-registry/app-name:1.0.0
   ```

2. **Update manifest with new image tag:**
   ```yaml
   image: your-registry/app-name:1.0.0  # Increment version
   ```

3. **Apply manifests:**
   ```bash
   kubectl apply -f k8s/configmap.yaml
   kubectl apply -f k8s/deployment.yaml
   kubectl apply -f k8s/service.yaml
   kubectl apply -f k8s/ingress.yaml
   ```

4. **Verify deployment:**
   ```bash
   kubectl rollout status deployment/app-name
   kubectl get pods -l app=app-name
   kubectl logs -l app=app-name --tail=50
   ```

5. **Test health endpoints:**
   ```bash
   kubectl port-forward deployment/app-name 8000:8000
   curl http://localhost:8000/health
   curl http://localhost:8000/ready
   ```

## Anti-Patterns

| Don't | Do |
|-------|-----|
| Store state in containers | Use external databases/caches (stateless apps) |
| Use `latest` image tag | Use semantic versions (1.0.0, 1.1.0) |
| Run as root user | Use `USER node` or `USER nobody` |
| Log to files | Log to STDOUT/STDERR (Kubernetes collects) |
| Hardcode configuration | Use environment variables and ConfigMaps |
| Skip health checks | Implement /health and /ready endpoints |
| Set no resource limits | Define requests and limits for CPU/memory |
| Ignore SIGTERM | Handle graceful shutdown (30 sec drain) |
| Build images in production | Build in CI/CD, push to registry |
| Use single replica | Use 3+ replicas for high availability |

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Container base | Alpine Linux or slim variants |
| Build | Multi-stage Dockerfile |
| User | Non-root (node, nobody) |
| Health checks | /health (liveness), /ready (readiness) |
| Logging | Structured JSON to STDOUT |
| Configuration | Environment variables + ConfigMap |
| Secrets | Kubernetes Secrets or AWS Secrets Manager |
| Replicas | Minimum 3 for HA |
| Resource requests | Set based on app size (see table) |
| Deployment strategy | RollingUpdate with maxUnavailable: 0 |
| Shutdown | Graceful (handle SIGTERM, 30 sec timeout) |
| Metrics | Prometheus endpoint at /metrics |

## When Building EKS Web Apps

1. Structure app with src/, tests/, k8s/ directories
2. Use multi-stage Dockerfile with non-root user
3. Configure via environment variables (fail fast on missing required vars)
4. Implement /health (liveness) and /ready (readiness) endpoints
5. Log structured JSON to STDOUT only
6. Set resource requests and limits based on app size
7. Use minimum 3 replicas for high availability
8. Handle SIGTERM for graceful shutdown (30 sec drain)
9. Use semantic versioning for image tags (not `latest`)
10. Test locally with `docker run` before deploying to EKS

## See Also

- AGENTS_PYTHON.md for Python web app patterns
- AGENTS_COMMON.md for error handling, security, and logging patterns
- AGENTS_WEBAPP.md for frontend/API development patterns
- AGENTS_README.md for documenting deployment procedures
