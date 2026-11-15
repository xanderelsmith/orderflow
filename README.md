# OrderFlow

Companion repository for the Medium article:
👉 **[How to Structure a Serverpod Backend: 5 Architecture Patterns That Scale](https://medium.com/@xanderelsmith/how-to-structure-a-serverpod-project-that-actually-scales-77c20055f11d)** by *Emmanuel Onyeji ~Xander*

A complete, production-ready Serverpod `4.0.4` reference implementation demonstrating **5 backend architecture patterns** paired with an interactive Flutter Web e-commerce storefront and live RPC Activity & Monitor drawer.

---

## Architecture Patterns & Branches

Each pattern is implemented on its own dedicated Git branch with isolated database storage and strongly-typed endpoints:

| Branch | Pattern | Architectural Structure | Key Concept |
| :--- | :--- | :--- | :--- |
| **[`01-simple-mvc`](https://github.com/xanderelsmith/orderflow/tree/01-simple-mvc)** | Simple MVC | `endpoints/` + `models/` talking directly to `.db` | Rapid MVP, hackathons, CRUD under 10 endpoints |
| **[`02-layered`](https://github.com/xanderelsmith/orderflow/tree/02-layered)** | Layered Architecture | `endpoints/` → `services/` → `repositories/` (`OrderStore`) | Transport decoupled from domain; auth-gated orders |
| **[`03-vertical-slices`](https://github.com/xanderelsmith/orderflow/tree/03-vertical-slices)** | Package by Feature (Tier 1) | `features/{auth,orders,payments}/` | Colocate models, services, & endpoints by capability |
| **[`04-modular-monolith`](https://github.com/xanderelsmith/orderflow/tree/04-modular-monolith)** | Modular Monolith (Tier 2) | `modules/{identity,billing}/{api,internal}/` + `platform/` | Strict boundary contracts (`api/` facades) vs private `.spy.yaml` |
| **[`05-event-driven`](https://github.com/xanderelsmith/orderflow/tree/05-event-driven)** | Event-Driven Architecture | `events/`, `future_calls/`, `MessageCentral` pub-sub | Instant client responses, resilient background jobs |

---

## Exploring Patterns with Git

Switch branches or inspect the structural diffs:

```bash
# Checkout any specific pattern
git checkout 01-simple-mvc
git checkout 03-vertical-slices
git checkout 05-event-driven

# Compare architectural changes between patterns
git diff --stat 01-simple-mvc..02-layered
git diff --stat 02-layered..03-vertical-slices
git diff --stat 03-vertical-slices..04-modular-monolith
```

---

## Running the Serverpod Backend (`orderflow_server/`)

Inside `orderflow_server/`:

```bash
cd orderflow_server

# Verify clean compilation
dart analyze

# Run migrations (automatically configured with isolated data paths per branch)
serverpod create-migration -f --no-interactive

# Start the server (runs on port 8080 by default)
dart bin/main.dart
```

---

## Running the Flutter Web Storefront (`orderflow_flutter/`)

* **On `main`**: A unified multi-backend dashboard allowing you to test, ping, and inspect RPC activity across all 5 architectures simultaneously.
* **On branches `01` to `05`**: A responsive e-commerce storefront featuring coffee and developer merch, with a **"Monitor & Logs"** top-bar button showing live Serverpod request/response payloads, latency metrics, and architectural tradeoffs.

```bash
cd orderflow_flutter
flutter run -d chrome
```

---

## Read the Full Article

For the deep-dive architectural trade-offs, common anti-patterns, and decision matrices, read the full post on Medium:
👉 **[How to Structure a Serverpod Backend: 5 Architecture Patterns That Scale](https://medium.com/@xanderelsmith/how-to-structure-a-serverpod-project-that-actually-scales-77c20055f11d)**
