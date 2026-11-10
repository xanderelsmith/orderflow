# Pattern 5: Event-Driven Architecture (`05-event-driven`)

**Asynchronous Primitives: `MessageCentral` Pub-Sub + Typed `FutureCall`s**

Decouples checkout and side effects (receipt emails, analytics sync, real-time notifications) using Serverpod's two built-in async primitives:
1. **Pub-Sub (`session.messages` / `MessageCentral`):** Real-time in-memory or Redis broadcast across server instances.
2. **Typed `FutureCall`s (`session.serverpod.futureCalls`):** Durable, database-backed background jobs.

## Structure (`orderflow_server/lib/`)

```text
lib/
├── server.dart
└── src/
    ├── endpoints/
    │   └── checkout_endpoint.dart
    ├── events/
    │   └── models/
    │       ├── order_created_event.spy.yaml
    │       └── user_signed_up_event.spy.yaml
    ├── future_calls/
    │   ├── send_email_call.dart
    │   └── sync_analytics_call.dart
    └── services/
        ├── checkout_service.dart
        └── notification_listener.dart
```

## Serverpod 4 Notes

* **Typed FutureCalls:** `SendEmailCall` and `SyncAnalyticsCall` extend `FutureCall` (unparameterized) with typed methods (`sendReceipt`, `trackSignup`). `serverpod generate` auto-registers them in `lib/src/generated/future_calls.dart`.
* **Scheduling:** `CheckoutService` dispatches jobs via `session.serverpod.futureCalls.callWithDelay(...).sendEmailCall.sendReceipt(event)` (requires `generated/serverpod.dart`).
* **Message Bus:** `CheckoutService` publishes via `await session.messages.postMessage('order_channel', event);`, and `NotificationEventListener.initialize(pod)` subscribes via `pod.server.messageCentral.addListener(session, 'order_channel', ...)` in `lib/server.dart`.

## When to Use It

* **Best for:** Fast client responses, resilient background retries (emails, webhooks, reports), and decoupling side effects—often combined with `03-vertical-slices` or `04-modular-monolith`.
* **Where it breaks:** Systems must handle out-of-order delivery, idempotency, and eventual consistency.

## Commands

```bash
cd orderflow_server
serverpod generate
dart analyze
```

Compare with `04-modular-monolith`:

```bash
git diff --stat 04-modular-monolith..05-event-driven
```
