# EKS Web App Example

Simple Python web application ready for deployment on Amazon EKS (Elastic Kubernetes Service).

Demonstrates:
- 12-factor app principles
- Multi-stage Docker builds
- Health checks (liveness and readiness)
- Structured logging (JSON to STDOUT)
- Prometheus metrics
- Graceful shutdown (SIGTERM handling)
- Kubernetes manifests (Deployment, Service, Ingress, HPA)
- Security best practices

## Quick Start

### Prerequisites

- Docker
- kubectl
- AWS CLI (configured)
- eksctl (for EKS cluster creation)

### Local Development

1. **Clone and install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Run locally:**
   ```bash
   python -m uvicorn src.app:app --reload --port 8000
   ```

3. **Test endpoints:**
   ```bash
   curl http://localhost:8000/
   curl http://localhost:8000/health
   curl http://localhost:8000/ready
   curl http://localhost:8000/metrics
   curl http://localhost:8000/api/items
   ```

### Docker Build

1. **Build image:**
   ```bash
   docker build -t eks-webapp:1.0.0 .
   ```

2. **Run container:**
   ```bash
   docker run -p 8000:8000 \
     -e LOG_LEVEL=INFO \
     -e SERVICE_NAME=eks-webapp \
     eks-webapp:1.0.0
   ```

3. **Test health checks:**
   ```bash
   curl http://localhost:8000/health
   curl http://localhost:8000/ready
   ```

### Push to Registry

1. **Tag for ECR:**
   ```bash
   # Create ECR repository
   aws ecr create-repository --repository-name eks-webapp

   # Get ECR URI
   ECR_URI=$(aws ecr describe-repositories --repository-name eks-webapp --query 'repositories[0].repositoryUri' --output text)

   # Login to ECR
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URI

   # Tag and push
   docker tag eks-webapp:1.0.0 $ECR_URI:1.0.0
   docker push $ECR_URI:1.0.0
   ```

## EKS Deployment

### 1. Create EKS Cluster (if needed)

```bash
# Create cluster with eksctl
eksctl create cluster \
  --name my-cluster \
  --region us-east-1 \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes 3 \
  --nodes-min 1 \
  --nodes-max 4 \
  --managed
```

### 2. Install AWS Load Balancer Controller

Required for Ingress (ALB):

```bash
# Add IAM policy
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam-policy.json

# Create service account
eksctl create iamserviceaccount \
  --cluster=my-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::<ACCOUNT_ID>:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve

# Install controller
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=my-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

### 3. Update Kubernetes Manifests

1. **Update image in `k8s/deployment.yaml`:**
   ```yaml
   image: <your-ecr-uri>/eks-webapp:1.0.0
   ```

2. **Update domain in `k8s/ingress.yaml`:**
   ```yaml
   host: app.example.com  # Your domain
   ```

### 4. Deploy to EKS

```bash
# Apply all manifests
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/hpa.yaml
```

### 5. Verify Deployment

```bash
# Check deployment status
kubectl rollout status deployment/eks-webapp

# Check pods
kubectl get pods -l app=eks-webapp

# Check service
kubectl get svc eks-webapp-service

# Check ingress (ALB)
kubectl get ingress eks-webapp-ingress

# View logs
kubectl logs -l app=eks-webapp --tail=50 -f

# Check HPA
kubectl get hpa eks-webapp-hpa
```

### 6. Test Application

```bash
# Get ALB DNS name
ALB_DNS=$(kubectl get ingress eks-webapp-ingress -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Test endpoints
curl http://$ALB_DNS/
curl http://$ALB_DNS/health
curl http://$ALB_DNS/ready
curl http://$ALB_DNS/api/items
```

## Architecture

```
┌─────────────────┐
│   Internet      │
└────────┬────────┘
         │
┌────────▼────────────────────┐
│   ALB (Ingress)             │
│   app.example.com           │
└────────┬────────────────────┘
         │
┌────────▼────────────────────┐
│   Service (ClusterIP)       │
│   Port 80 → 8000            │
└────────┬────────────────────┘
         │
┌────────▼────────────────────┐
│   Deployment                │
│   ├─ Pod 1 (8000)           │
│   ├─ Pod 2 (8000)           │
│   └─ Pod 3 (8000)           │
└─────────────────────────────┘
```

## Key Features

### Health Checks

- **Liveness (`/health`)**: Kubernetes restarts pod if unhealthy
- **Readiness (`/ready`)**: Kubernetes routes traffic only to ready pods

```python
@app.get("/health")
async def health():
    return {"status": "healthy"}

@app.get("/ready")
async def readiness():
    # Check dependencies
    checks = {
        "database": await check_database(),
        "cache": await check_redis(),
    }
    if not all(checks.values()):
        return JSONResponse(status_code=503, content={"status": "not ready"})
    return {"status": "ready", "checks": checks}
```

### Structured Logging

All logs output to STDOUT in JSON format:

```json
{
  "timestamp": "2024-01-15T10:30:00.123Z",
  "level": "INFO",
  "message": "Request processed",
  "service": "eks-webapp",
  "method": "GET",
  "path": "/api/items",
  "status": 200,
  "duration_ms": 12.5
}
```

Kubernetes collects logs automatically. View with:

```bash
kubectl logs -l app=eks-webapp --tail=100 -f
```

### Metrics (Prometheus)

Metrics exposed at `/metrics`:

```
http_requests_total{method="GET",endpoint="/api/items",status="200"} 150
http_request_duration_seconds_bucket{le="0.1"} 120
http_request_duration_seconds_bucket{le="0.5"} 145
http_request_duration_seconds_count 150
```

### Graceful Shutdown

Handles SIGTERM signal for zero-downtime deployments:

1. Kubernetes sends SIGTERM
2. App stops accepting new requests
3. Existing requests complete (up to 30 seconds)
4. App exits cleanly

```python
def graceful_shutdown(signum, frame):
    logger.info("Received SIGTERM, shutting down gracefully...")
    shutdown_flag = True
    sys.exit(0)

signal.signal(signal.SIGTERM, graceful_shutdown)
```

### Horizontal Pod Autoscaling

Automatically scales based on CPU/memory:

- Min replicas: 3
- Max replicas: 10
- Scale up when CPU > 70% or memory > 80%
- Scale down after 5 minutes of low usage

```bash
# Watch scaling
kubectl get hpa eks-webapp-hpa --watch
```

## Configuration

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| PORT | No | 8000 | Application port |
| LOG_LEVEL | No | INFO | Logging level (DEBUG, INFO, WARNING, ERROR) |
| SERVICE_NAME | No | eks-webapp | Service name for logs |
| DATABASE_URL | No | - | Database connection string |
| REDIS_URL | No | - | Redis connection string |

Configure via `k8s/configmap.yaml` for non-sensitive values and Kubernetes Secrets for sensitive data.

### Example: Adding Database URL

1. **Create secret:**
   ```bash
   kubectl create secret generic eks-webapp-secrets \
     --from-literal=database-url='postgresql://user:pass@host:5432/db'
   ```

2. **Update deployment.yaml:**
   ```yaml
   env:
   - name: DATABASE_URL
     valueFrom:
       secretKeyRef:
         name: eks-webapp-secrets
         key: database-url
   ```

## Resource Requirements

Current configuration:

| Resource | Request | Limit |
|----------|---------|-------|
| CPU | 100m | 500m |
| Memory | 256Mi | 512Mi |

Adjust based on load testing:

```bash
# Monitor resource usage
kubectl top pods -l app=eks-webapp
```

## Troubleshooting

### Pods Not Starting

```bash
# Check pod status
kubectl get pods -l app=eks-webapp

# Describe pod
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>

# Common issues:
# - Image pull errors: Check ECR permissions
# - CrashLoopBackOff: Check application logs
# - Pending: Check node capacity
```

### Health Checks Failing

```bash
# Test health endpoint inside pod
kubectl exec <pod-name> -- curl localhost:8000/health
kubectl exec <pod-name> -- curl localhost:8000/ready

# Check probe configuration
kubectl describe pod <pod-name> | grep -A 10 Liveness
kubectl describe pod <pod-name> | grep -A 10 Readiness
```

### ALB Not Created

```bash
# Check ingress events
kubectl describe ingress eks-webapp-ingress

# Check load balancer controller logs
kubectl logs -n kube-system deployment/aws-load-balancer-controller

# Common issues:
# - Controller not installed
# - IAM permissions missing
# - Ingress class incorrect
```

### High Memory Usage

```bash
# Check current usage
kubectl top pods -l app=eks-webapp

# Increase memory limits in deployment.yaml
resources:
  limits:
    memory: "1Gi"  # Increase from 512Mi
```

## Cleanup

```bash
# Delete application
kubectl delete -f k8s/

# Delete EKS cluster
eksctl delete cluster --name my-cluster
```

## Best Practices Demonstrated

✅ Multi-stage Docker build (smaller images)
✅ Non-root user (security)
✅ Health and readiness probes
✅ Structured JSON logging to STDOUT
✅ Graceful shutdown (SIGTERM handling)
✅ Resource requests and limits
✅ Horizontal pod autoscaling
✅ Zero-downtime deployments (rolling update)
✅ Configuration via environment variables
✅ Prometheus metrics
✅ Security context (drop capabilities)

## Next Steps

1. **Add monitoring:** Install Prometheus and Grafana
2. **Add tracing:** Integrate OpenTelemetry or X-Ray
3. **Add CI/CD:** Automate build and deployment
4. **Add tests:** Unit and integration tests
5. **Add database:** PostgreSQL or DynamoDB
6. **Add caching:** Redis or ElastiCache
7. **Add authentication:** JWT or OAuth2

## See Also

- [AGENTS_EKS_WEBAPP.md](../../AGENTS_EKS_WEBAPP.md) - Template used to create this app
- [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)
- [EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [12-Factor App](https://12factor.net/)
