# AGENTS_COMMON.md

Instructions for AI models on cross-cutting patterns that apply to all project types.

Reference this template alongside domain-specific templates (AGENTS_PYTHON.md, AGENTS_CLI.md, etc.) for patterns that span multiple concerns.

## Error Handling

### Error Classification

Classify errors by recoverability to determine handling strategy:

| Type | Description | Example | Handling |
|------|-------------|---------|----------|
| Recoverable | Can retry or use fallback | Network timeout, rate limit | Retry with backoff, use cache |
| User Error | Invalid input from user | Bad file path, wrong format | Return clear error message |
| Programming Error | Bug in the code | Null reference, type error | Log, crash, fix code |
| External Failure | Dependency unavailable | API down, disk full | Degrade gracefully, alert |
| Fatal | Cannot continue | Missing config, no permissions | Exit with clear message |

### Error Message Format

Structure error messages for actionability:

```
[WHAT happened] [WHERE it happened] [WHY it might have happened] [HOW to fix it]
```

**Examples:**

```python
# Bad - vague
raise Error("Operation failed")

# Good - actionable
raise Error(
    f"Failed to connect to database at {host}:{port}. "
    f"Connection timed out after {timeout}s. "
    f"Check network connectivity and firewall rules."
)
```

### Retry Patterns

Use exponential backoff for transient failures:

```python
import time
import random

def retry_with_backoff(
    func,
    max_attempts: int = 3,
    base_delay: float = 1.0,
    max_delay: float = 60.0,
    exceptions: tuple = (Exception,),
):
    for attempt in range(max_attempts):
        try:
            return func()
        except exceptions as e:
            if attempt == max_attempts - 1:
                raise
            delay = min(base_delay * (2 ** attempt), max_delay)
            jitter = random.uniform(0, delay * 0.1)
            time.sleep(delay + jitter)
```

### Error Boundaries

Isolate failures to prevent cascade:

```python
# Define boundary for external call
def fetch_user_data(user_id: str) -> dict | None:
    try:
        return external_api.get_user(user_id)
    except APIError as e:
        logger.warning(f"Failed to fetch user {user_id}: {e}")
        return None  # Boundary returns safe default

# Caller continues with partial data
user = fetch_user_data(user_id)
if user:
    process_user(user)
else:
    process_without_user()
```

## Security

### Input Validation

Validate all external input at system boundaries:

```python
from pydantic import BaseModel, Field, validator

class UserInput(BaseModel):
    username: str = Field(min_length=3, max_length=50)
    email: str
    age: int = Field(ge=0, le=150)

    @validator('username')
    def username_alphanumeric(cls, v):
        if not v.isalnum():
            raise ValueError('Username must be alphanumeric')
        return v

# Validate at entry point
def create_user(raw_data: dict):
    validated = UserInput(**raw_data)  # Raises on invalid
    # Safe to use validated.username, validated.email, validated.age
```

### Secret Management

| Do | Don't |
|----|-------|
| Environment variables for runtime secrets | Hardcode secrets in code |
| Secret managers (Vault, AWS Secrets Manager) | Commit secrets to git |
| Rotate secrets regularly | Share secrets via chat/email |
| Use different secrets per environment | Use production secrets in dev |
| Audit secret access | Log secret values |

**Environment variable pattern:**

```python
import os

def get_required_env(name: str) -> str:
    value = os.environ.get(name)
    if not value:
        raise ValueError(f"Required environment variable {name} not set")
    return value

# Fail fast on missing secrets
API_KEY = get_required_env("API_KEY")
DATABASE_URL = get_required_env("DATABASE_URL")
```

### Injection Prevention

| Attack | Prevention |
|--------|------------|
| SQL Injection | Parameterized queries, ORMs |
| Command Injection | Avoid shell=True, use subprocess with list args |
| XSS | Escape output, CSP headers, sanitize HTML |
| Path Traversal | Validate paths, use allowlists |
| SSRF | Allowlist URLs, validate schemes |

```python
# SQL - parameterized
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))

# Command - list args, no shell
subprocess.run(["ls", "-la", directory], check=True)

# Path - validate
def safe_join(base: Path, user_path: str) -> Path:
    result = (base / user_path).resolve()
    if not result.is_relative_to(base):
        raise ValueError("Path traversal detected")
    return result
```

### Authentication Best Practices

| Aspect | Recommendation |
|--------|---------------|
| Password storage | bcrypt or Argon2 with cost factor >= 10 |
| Session tokens | Cryptographically random, 256+ bits |
| JWT storage | httpOnly cookies (not localStorage) |
| Token expiration | Access: 15-60 min, Refresh: 7-30 days |
| MFA | TOTP or WebAuthn for sensitive operations |

## Performance

### Profiling First

Never optimize without measurement:

```python
# Python profiling
import cProfile
import pstats

profiler = cProfile.Profile()
profiler.enable()
# ... code to profile ...
profiler.disable()

stats = pstats.Stats(profiler)
stats.sort_stats('cumulative')
stats.print_stats(10)  # Top 10 functions
```

```bash
# Node.js profiling
node --prof app.js
node --prof-process isolate-*.log > processed.txt
```

### Common Optimizations

| Problem | Solution |
|---------|----------|
| N+1 queries | Batch queries, eager loading |
| Large response payloads | Pagination, field selection |
| Repeated calculations | Memoization, caching |
| Synchronous I/O blocking | Async/await, thread pools |
| Memory bloat | Streaming, generators |

### Caching Strategy

Choose cache level based on invalidation complexity:

| Level | Lifetime | Invalidation | Use Case |
|-------|----------|--------------|----------|
| Request | Single request | Automatic | Deduplication within handler |
| Memory | Process lifetime | Manual or TTL | Frequently accessed, rarely changed |
| Distributed | Cross-process | TTL + events | Session data, API responses |
| CDN | Hours to days | Purge API | Static assets, public pages |

```python
from functools import lru_cache

# In-memory cache with TTL
@lru_cache(maxsize=1000)
def get_user_permissions(user_id: str) -> list[str]:
    return database.query_permissions(user_id)

# Clear cache when permissions change
def update_permissions(user_id: str, permissions: list[str]):
    database.update_permissions(user_id, permissions)
    get_user_permissions.cache_clear()  # Invalidate all
```

### Database Optimization

| Issue | Solution |
|-------|----------|
| Slow queries | Add indexes on filter/sort columns |
| Full table scans | Use EXPLAIN, add WHERE clauses |
| Connection exhaustion | Connection pooling |
| Lock contention | Shorter transactions, optimistic locking |
| Large result sets | Pagination with cursor-based paging |

## Testing

### Test Pyramid

| Level | Count | Speed | Scope |
|-------|-------|-------|-------|
| Unit | Many (70%) | Fast (ms) | Single function/class |
| Integration | Some (20%) | Medium (s) | Component boundaries |
| E2E | Few (10%) | Slow (min) | Full user flows |

### Test Organization

```
tests/
├── unit/              # Fast, isolated tests
│   ├── test_utils.py
│   └── test_models.py
├── integration/       # Tests with real dependencies
│   ├── test_api.py
│   └── test_database.py
├── e2e/               # Full system tests
│   └── test_user_flow.py
├── fixtures/          # Shared test data
│   └── users.json
└── conftest.py        # Shared pytest fixtures
```

### Test Naming

```python
# Pattern: test_[what]_[scenario]_[expected_result]

def test_create_user_with_valid_data_returns_user():
    pass

def test_create_user_with_duplicate_email_raises_conflict():
    pass

def test_delete_user_as_admin_removes_user():
    pass
```

### Mocking Guidelines

| Mock | Don't Mock |
|------|------------|
| External APIs | Your own code |
| Time/randomness | Business logic |
| File system (usually) | Data transformations |
| Network calls | Pure functions |

```python
from unittest.mock import patch, MagicMock

def test_fetch_user_handles_api_error():
    with patch('module.external_api') as mock_api:
        mock_api.get_user.side_effect = APIError("Timeout")

        result = fetch_user_data("123")

        assert result is None
        mock_api.get_user.assert_called_once_with("123")
```

## Observability

### Logging Levels

| Level | Purpose | Examples |
|-------|---------|----------|
| DEBUG | Detailed diagnostic | Variable values, loop iterations |
| INFO | Normal operations | Request received, job completed |
| WARNING | Unexpected but handled | Retry triggered, cache miss |
| ERROR | Operation failed | API error, validation failure |
| CRITICAL | System unusable | Database down, out of memory |

### Structured Logging

```python
import structlog

logger = structlog.get_logger()

# Include context in every log
logger.info(
    "order_processed",
    order_id=order.id,
    user_id=order.user_id,
    total=order.total,
    duration_ms=elapsed,
)
```

### Metrics to Track

| Category | Metrics |
|----------|---------|
| Latency | p50, p95, p99 response times |
| Traffic | Requests per second, active users |
| Errors | Error rate, error types |
| Saturation | CPU, memory, disk, connections |

### Health Checks

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

@app.get("/ready")
async def readiness_check():
    # Check dependencies
    db_ok = await check_database()
    cache_ok = await check_cache()

    if db_ok and cache_ok:
        return {"status": "ready", "database": "ok", "cache": "ok"}

    return JSONResponse(
        status_code=503,
        content={"status": "not ready", "database": db_ok, "cache": cache_ok}
    )
```

## Documentation

### Code Comments

| Comment Type | When to Use |
|--------------|-------------|
| Why | Non-obvious business logic, workarounds |
| What (complex) | Complex algorithms, regex patterns |
| TODO | Planned improvements with context |
| FIXME | Known bugs with explanation |
| WARNING | Dangerous operations, side effects |

```python
# Why: Stripe webhooks may arrive out of order, so we check
# the event timestamp against our last processed time
if event.created < last_processed_time:
    return  # Skip duplicate/out-of-order event

# TODO(username): Replace with batch API when available (Q2 2024)
for user in users:
    sync_user(user)

# WARNING: This deletes data permanently. No soft delete.
def purge_user_data(user_id: str):
    pass
```

### API Documentation

Include for every endpoint:
- HTTP method and path
- Request parameters (path, query, body)
- Response format and status codes
- Error responses
- Authentication requirements
- Rate limits

## Anti-Patterns

| Don't | Do |
|-------|-----|
| Catch all exceptions silently | Catch specific exceptions, log or re-raise |
| Store secrets in code | Use environment variables or secret managers |
| Trust user input | Validate and sanitize at boundaries |
| Optimize without profiling | Measure first, optimize bottlenecks |
| Write tests after code | Write tests alongside or before |
| Log sensitive data | Redact PII, tokens, passwords |
| Ignore error messages | Make errors specific and actionable |
| Skip health checks | Add liveness and readiness endpoints |

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Error format | What + Where + Why + How to fix |
| Retry strategy | Exponential backoff with jitter |
| Secret storage | Environment variables or secret manager |
| Input validation | Validate at system boundaries |
| Caching | TTL-based with explicit invalidation |
| Test ratio | 70% unit, 20% integration, 10% E2E |
| Logging | Structured with context |
| Health checks | /health (live) and /ready (dependencies) |
| Comments | Explain why, not what |

## When Building Any Project

1. Define error handling strategy before writing business logic
2. Set up structured logging from the start
3. Add health check endpoints early
4. Write tests alongside features
5. Validate all external input at boundaries
6. Never commit secrets; use environment variables
7. Profile before optimizing
8. Document non-obvious decisions
9. Add monitoring for latency, errors, and saturation
10. Review security checklist before deployment
