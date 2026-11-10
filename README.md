# Pattern 2: Layered Architecture (`02-layered`)

**Endpoint → Service → Repository → ORM**

This pattern decouples RPC transport and authentication checks (`endpoints/`) from business rules (`services/`) and data access (`repositories/`).

## Structure (`orderflow_server/lib/src/`)

```text
lib/src/
├── endpoints/             # Transport / RPC mapping & auth checks
│   ├── order_endpoint.dart
│   └── user_endpoint.dart
├── services/              # Business rules & transactions
│   ├── order_service.dart
│   └── user_service.dart
├── repositories/          # Optional encapsulated data-access layer
│   └── order_repository.dart
└── models/                # Serverpod .spy.yaml definitions & exceptions
    ├── create_order_request.spy.yaml
    ├── customer_order.spy.yaml
    ├── endpoint_exception.spy.yaml
    ├── order_response.spy.yaml
    └── user.spy.yaml
```

## Serverpod 4 Notes

* **Auth:** `session.authenticated` is synchronous (`AuthenticationInfo?`) and exposes `authInfo.userIdentifier` (`String`).
* **Custom Exceptions:** `EndpointException` is defined as a serializable `exception:` in `models/endpoint_exception.spy.yaml`.
* **Avoiding Name Collisions:** `CustomerOrder` and `OrderStore` (in `repositories/order_repository.dart`) avoid colliding with Serverpod's built-in `Order` sorting class and auto-generated `<Model>Repository` classes.

## When to Use It

* **Best for:** Separating HTTP/RPC handling from domain logic so services can be unit tested without mocking endpoints.
* **Where it breaks:** **Layer scattering**—adding a single field or feature forces jumping across `endpoints/`, `services/`, `repositories/`, and `models/`.

## Commands

```bash
cd orderflow_server
serverpod generate
dart analyze
```

Compare stages:

```bash
git diff --stat 01-simple-mvc..02-layered
git diff --stat 02-layered..03-vertical-slices
```
