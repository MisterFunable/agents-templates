# Multi-stage Dockerfile for production deployment
# Stage 1: Build stage
FROM python:3.11-slim AS build

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Production stage
FROM python:3.11-slim

WORKDIR /app

# Copy installed packages from build stage
COPY --from=build /root/.local /root/.local

# Copy application code
COPY src/ ./src/

# Run as non-root user for security
USER nobody

# Expose application port
EXPOSE 8000

# Set PATH to include user-installed packages
ENV PATH=/root/.local/bin:$PATH

# Health check (optional, Kubernetes handles this)
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# Start application
CMD ["python", "-m", "uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8000"]
