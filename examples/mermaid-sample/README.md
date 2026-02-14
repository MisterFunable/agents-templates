# E-Commerce Order System

A microservices-based order management system with event-driven architecture.

## Architecture

```mermaid
graph LR
    Client[Web Client] --> Gateway[API Gateway]
    Gateway --> Auth[Auth Service]
    Gateway --> Orders[Orders Service]
    Gateway --> Products[Products Service]

    Orders --> DB[(PostgreSQL)]
    Orders --> Queue[Message Queue]
    Products --> Cache[(Redis Cache)]

    Queue --> Notifications[Notification Service]
    Queue --> Inventory[Inventory Service]
```

The system consists of five core services:

- **Auth Service**: Handles user authentication and authorization
- **Orders Service**: Manages order lifecycle and state transitions
- **Products Service**: Catalog management with Redis caching
- **Notification Service**: Sends emails/SMS based on order events
- **Inventory Service**: Tracks stock levels and reservations

## Order Flow

When a user places an order:

```mermaid
sequenceDiagram
    participant User
    participant API
    participant Orders
    participant Inventory
    participant Queue

    User->>API: POST /orders
    API->>Orders: Create order
    Orders->>Inventory: Reserve items
    Inventory-->>Orders: Reservation confirmed
    Orders->>Queue: Publish order.created
    Queue-->>Orders: ACK
    Orders-->>API: order_id
    API-->>User: 201 Created

    Note over Queue: Async processing
    Queue->>Inventory: Update stock
    Queue->>Orders: Update status
```

## Order States

```mermaid
stateDiagram-v2
    [*] --> Pending
    Pending --> Processing: payment_confirmed
    Processing --> Shipped: items_shipped
    Processing --> Cancelled: payment_failed
    Shipped --> Delivered: delivery_confirmed
    Delivered --> [*]
    Cancelled --> [*]

    note right of Processing
        Inventory reserved
        Payment captured
    end note
```

## Data Model

```mermaid
classDiagram
    class User {
        +UUID id
        +String email
        +DateTime created_at
    }

    class Order {
        +UUID id
        +UUID user_id
        +OrderStatus status
        +Decimal total
        +place()
        +cancel()
    }

    class OrderItem {
        +UUID order_id
        +UUID product_id
        +Int quantity
        +Decimal price
    }

    class Product {
        +UUID id
        +String name
        +Decimal price
        +Int stock
    }

    User "1" --> "*" Order: places
    Order "1" --> "*" OrderItem: contains
    OrderItem "*" --> "1" Product: references
```

## Getting Started

```bash
# Install dependencies
npm install

# Start services
docker-compose up -d

# Run migrations
npm run migrate

# Start API gateway
npm start
```

## API Endpoints

See [API Documentation](docs/api/endpoints.md) for detailed endpoint descriptions and sequence diagrams.

## Architecture Decisions

See [ADRs](docs/decisions/) for architectural decision records with detailed diagrams.

## License

MIT
