# System Architecture Overview

This document describes the high-level architecture of the E-Commerce Order System.

## System Components

```mermaid
graph TD
    subgraph Frontend
        Web[Web Application]
        Mobile[Mobile App]
    end

    subgraph API Layer
        Gateway[API Gateway]
        Auth[Auth Service]
    end

    subgraph Core Services
        Orders[Orders Service]
        Products[Products Service]
        Inventory[Inventory Service]
        Notifications[Notification Service]
    end

    subgraph Data Layer
        DB[(PostgreSQL)]
        Cache[(Redis)]
        Queue[RabbitMQ]
    end

    Web --> Gateway
    Mobile --> Gateway
    Gateway --> Auth
    Gateway --> Orders
    Gateway --> Products

    Orders --> DB
    Orders --> Queue
    Products --> Cache
    Products --> DB

    Queue --> Inventory
    Queue --> Notifications

    Inventory --> DB
```

## Service Communication Patterns

### Synchronous (REST)

Used for: User-facing operations requiring immediate response

```mermaid
sequenceDiagram
    participant Client
    participant Gateway
    participant Orders

    Client->>Gateway: GET /orders/123
    Gateway->>Orders: Fetch order
    Orders-->>Gateway: Order data
    Gateway-->>Client: 200 OK
```

### Asynchronous (Message Queue)

Used for: Background processing, service decoupling

```mermaid
sequenceDiagram
    participant Orders
    participant Queue
    participant Inventory
    participant Notifications

    Orders->>Queue: order.created event
    Queue->>Inventory: Consume event
    Queue->>Notifications: Consume event

    Note over Inventory: Update stock
    Note over Notifications: Send email

    Inventory->>Queue: inventory.updated
    Notifications->>Queue: notification.sent
```

## Data Flow

### Order Creation Flow

```mermaid
graph TD
    A[User Request] --> B{Auth Valid?}
    B -->|No| C[Return 401]
    B -->|Yes| D{Items Available?}
    D -->|No| E[Return 400]
    D -->|Yes| F[Create Order]
    F --> G[Reserve Inventory]
    G --> H{Payment OK?}
    H -->|No| I[Cancel Order]
    H -->|Yes| J[Publish Event]
    J --> K[Return 201]

    I --> L[Release Inventory]
```

## Deployment Architecture

```mermaid
graph LR
    subgraph Production
        LB[Load Balancer]
        API1[API Instance 1]
        API2[API Instance 2]
        Orders1[Orders Instance 1]
        Orders2[Orders Instance 2]
    end

    subgraph Data
        PG[(PostgreSQL Primary)]
        PGR[(PostgreSQL Replica)]
        Redis[(Redis Cluster)]
    end

    LB --> API1
    LB --> API2
    API1 --> Orders1
    API2 --> Orders2
    Orders1 --> PG
    Orders2 --> PG
    API1 --> Redis
    API2 --> Redis
    PG --> PGR
```

## Scaling Strategy

| Component | Strategy | Max Load |
|-----------|----------|----------|
| API Gateway | Horizontal (auto-scale) | 10K req/sec |
| Orders Service | Horizontal (stateless) | 5K orders/sec |
| Database | Vertical + read replicas | 50K queries/sec |
| Message Queue | Clustered (3 nodes) | 100K msgs/sec |
| Cache | Redis Cluster (6 nodes) | 500K ops/sec |

## Failure Scenarios

### Service Outage

```mermaid
sequenceDiagram
    participant Client
    participant Gateway
    participant Orders
    participant Fallback

    Client->>Gateway: Request
    Gateway->>Orders: Forward
    Orders--xGateway: Timeout
    Gateway->>Fallback: Use cached data
    Fallback-->>Gateway: Stale data
    Gateway-->>Client: 200 (degraded)

    Note over Client: Response with warning header
```

### Database Failure

```mermaid
stateDiagram-v2
    [*] --> Healthy
    Healthy --> Degraded: Primary DB down
    Degraded --> ReadOnly: Failover to replica
    ReadOnly --> Healthy: Primary restored
    Degraded --> Down: Replica also down
    Down --> Healthy: Both restored
```

## Monitoring

Key metrics tracked:

- Request latency (p50, p95, p99)
- Error rates per service
- Queue depth and lag
- Database connection pool usage
- Cache hit rates

See [Monitoring Dashboard](../operations/monitoring.md) for details.

## Security

### Authentication Flow

```mermaid
sequenceDiagram
    participant User
    participant Auth
    participant DB

    User->>Auth: POST /login
    Auth->>DB: Verify credentials
    DB-->>Auth: User found
    Auth->>Auth: Generate JWT
    Auth-->>User: JWT token

    Note over User: Store token
    User->>Auth: Request with token
    Auth->>Auth: Verify JWT
    Auth-->>User: Protected resource
```

## Next Steps

- Review [API Documentation](../api/endpoints.md) for detailed endpoint specs
- See [ADR-0001](../decisions/0001-event-driven-architecture.md) for architecture rationale
- Check [Deployment Guide](../operations/deployment.md) for infrastructure setup
