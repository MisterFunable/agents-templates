# Order API Endpoints

## POST /api/orders

Create a new order.

### Request Flow

```mermaid
sequenceDiagram
    participant Client
    participant Gateway
    participant Auth
    participant Orders
    participant Inventory
    participant Payment
    participant Queue

    Client->>Gateway: POST /orders
    Gateway->>Auth: Validate token
    Auth-->>Gateway: User ID

    Gateway->>Orders: Create order
    Orders->>Inventory: Check availability
    Inventory-->>Orders: Items available

    Orders->>Payment: Process payment
    alt Payment Success
        Payment-->>Orders: Payment confirmed
        Orders->>Inventory: Reserve items
        Orders->>Queue: Publish order.created
        Orders-->>Gateway: order_id
        Gateway-->>Client: 201 Created
    else Payment Failed
        Payment-->>Orders: Payment declined
        Orders-->>Gateway: Error
        Gateway-->>Client: 402 Payment Required
    end
```

### Request

```json
POST /api/orders
Authorization: Bearer <token>

{
  "items": [
    {
      "product_id": "prod_123",
      "quantity": 2
    }
  ],
  "shipping_address": {
    "street": "123 Main St",
    "city": "San Francisco",
    "postal_code": "94102"
  },
  "payment_method": "card_xyz"
}
```

### Response

```json
201 Created

{
  "order_id": "ord_456",
  "status": "pending",
  "total": 99.98,
  "created_at": "2024-01-15T10:30:00Z"
}
```

### Error Responses

```mermaid
graph TD
    A[POST /orders] --> B{Auth Valid?}
    B -->|No| C[401 Unauthorized]
    B -->|Yes| D{Items Available?}
    D -->|No| E[400 Bad Request: Out of Stock]
    D -->|Yes| F{Payment Valid?}
    F -->|No| G[402 Payment Required]
    F -->|Yes| H[201 Created]
```

## GET /api/orders/:id

Retrieve order details.

### Request Flow

```mermaid
sequenceDiagram
    participant Client
    participant Gateway
    participant Orders
    participant Cache
    participant DB

    Client->>Gateway: GET /orders/123
    Gateway->>Orders: Fetch order
    Orders->>Cache: Check cache
    alt Cache Hit
        Cache-->>Orders: Order data
    else Cache Miss
        Orders->>DB: Query order
        DB-->>Orders: Order data
        Orders->>Cache: Store in cache
    end
    Orders-->>Gateway: Order data
    Gateway-->>Client: 200 OK
```

### Response

```json
200 OK

{
  "order_id": "ord_456",
  "user_id": "usr_789",
  "status": "processing",
  "items": [
    {
      "product_id": "prod_123",
      "quantity": 2,
      "price": 49.99
    }
  ],
  "total": 99.98,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:35:00Z"
}
```

## PATCH /api/orders/:id/cancel

Cancel an order.

### Cancellation Rules

```mermaid
stateDiagram-v2
    [*] --> Pending
    Pending --> Processing
    Processing --> Shipped
    Shipped --> Delivered

    Pending --> Cancelled: Can cancel
    Processing --> Cancelled: Can cancel
    Shipped --> Cancelled: Cannot cancel
    Delivered --> Cancelled: Cannot cancel

    note right of Shipped
        Cannot cancel after shipping
    end note
```

### Request Flow

```mermaid
sequenceDiagram
    participant Client
    participant Orders
    participant Inventory
    participant Payment
    participant Queue

    Client->>Orders: PATCH /orders/123/cancel
    Orders->>Orders: Check if cancellable
    alt Can Cancel
        Orders->>Inventory: Release reservation
        Orders->>Payment: Refund payment
        Payment-->>Orders: Refund initiated
        Orders->>Queue: Publish order.cancelled
        Orders-->>Client: 200 OK
    else Cannot Cancel
        Orders-->>Client: 400 Bad Request
    end
```

## PUT /api/orders/:id/status

Update order status (Admin only).

### Status Transitions

```mermaid
stateDiagram-v2
    [*] --> Pending: Order created
    Pending --> Processing: payment_confirmed
    Processing --> Shipped: items_shipped
    Shipped --> Delivered: delivery_confirmed
    Processing --> Cancelled: cancel_requested
    Pending --> Cancelled: payment_failed

    Delivered --> [*]
    Cancelled --> [*]

    note left of Processing
        Inventory reserved
        Payment captured
    end note

    note right of Shipped
        Cannot be cancelled
    end note
```

### Request

```json
PUT /api/orders/123/status
Authorization: Bearer <admin_token>

{
  "status": "shipped",
  "tracking_number": "TRK123456",
  "carrier": "UPS"
}
```

## Webhook Events

Orders service publishes events for async processing:

```mermaid
sequenceDiagram
    participant Orders
    participant Queue
    participant Inventory
    participant Notifications
    participant Analytics

    Orders->>Queue: order.created
    Queue->>Inventory: Update stock
    Queue->>Notifications: Send confirmation
    Queue->>Analytics: Track event

    Orders->>Queue: order.cancelled
    Queue->>Inventory: Release reservation
    Queue->>Notifications: Send cancellation
    Queue->>Analytics: Track event
```

### Event Types

| Event | Description | Consumers |
|-------|-------------|-----------|
| order.created | New order placed | Inventory, Notifications, Analytics |
| order.cancelled | Order cancelled | Inventory, Notifications, Analytics |
| order.shipped | Order shipped | Notifications, Analytics |
| order.delivered | Order delivered | Notifications, Analytics |

## Rate Limiting

```mermaid
graph TD
    A[Request] --> B{Rate Limit OK?}
    B -->|Yes| C[Process Request]
    B -->|No| D[429 Too Many Requests]

    C --> E{Success?}
    E -->|Yes| F[200 OK]
    E -->|No| G[Error Response]

    style D fill:#f96
    style F fill:#9f6
```

Limits per user:
- 100 requests/minute for authenticated users
- 10 requests/minute for unauthenticated users

## Error Codes

| Code | Description | Example |
|------|-------------|---------|
| 400 | Bad Request | Invalid order items, out of stock |
| 401 | Unauthorized | Missing or invalid token |
| 402 | Payment Required | Payment declined |
| 404 | Not Found | Order does not exist |
| 409 | Conflict | Order already cancelled |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Database connection failed |

## See Also

- [System Architecture](../architecture/system-overview.md) for high-level design
- [ADR-0002: RESTful API Design](../decisions/0002-restful-api.md) for API principles
- [Error Handling Guide](error-handling.md) for error response formats
