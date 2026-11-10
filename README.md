# Pattern 1: Simple MVC (`01-simple-mvc`)

**Endpoints + Serverpod ORM — The Starting Point**

In this pattern, Serverpod `Endpoint` classes act as controllers and `.spy.yaml` files define database-backed models. Endpoints handle validation and talk directly to the database via `<Model>.db`.

## Structure (`orderflow_server/lib/src/`)

```text
lib/src/
├── endpoints/
│   ├── task_endpoint.dart
│   └── user_endpoint.dart
├── models/
│   ├── task.spy.yaml
│   └── user.spy.yaml
└── generated/
```

## How It Works

* `TaskEndpoint` validates input and calls `Task.db.insertRow(...)` / `Task.db.find(...)` directly.
* `UserEndpoint` calls `User.db.insertRow(...)` / `User.db.find(...)` directly.
* `user.spy.yaml` maps `User` to `table: app_users` to avoid colliding with PostgreSQL's reserved `user` keyword.

## When to Use It

* **Best for:** Hackathons, MVPs, and simple CRUD APIs with under ~10 endpoints.
* **Where it breaks:** Endpoints grow into 800+ line files mixing validation, transactions, third-party SDK calls, and database queries—making logic hard to test or reuse in background jobs.

## Commands

```bash
cd orderflow_server
serverpod generate
dart analyze
```

Compare with the next stage:

```bash
git diff --stat 01-simple-mvc..02-layered
```
