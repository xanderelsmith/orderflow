# Pattern 4: Modular Monolith (`04-modular-monolith`)

**Tier 2 Recommendation for Major / Multi-Team Projects**

Each business module enforces strict **Contract (`api/`) vs. Implementation (`internal/`)** boundaries. Other modules may only call `api/*_facade.dart` and exchange public DTOs/scalar IDs—never internal `.spy.yaml` table models or internal services.

## Structure (`orderflow_server/lib/src/`)

```text
lib/src/
├── modules/
│   ├── identity/
│   │   ├── api/
│   │   │   ├── identity_facade.dart          # Public module contract
│   │   │   └── models/
│   │   │       └── user_summary.spy.yaml     # Public DTO
│   │   └── internal/
│   │       ├── identity_endpoint.dart
│   │       ├── identity_service.dart
│   │       └── models/
│   │           └── user_account.spy.yaml     # Private DB model
│   └── billing/
│       ├── api/
│       │   ├── billing_facade.dart           # Public module contract
│       │   └── models/
│       │       └── invoice_dto.spy.yaml      # Public DTO
│       └── internal/
│           ├── billing_endpoint.dart
│           ├── billing_service.dart
│           └── models/
│               └── ledger_entry.spy.yaml     # Private DB model
└── platform/                                 # Zero business logic
    ├── database/
    │   └── transaction_runner.dart
    └── logging/
        └── audit_logger.dart
```

## How Boundaries Work

* `BillingService` imports `IdentityFacade` and receives a public `UserSummary` DTO—it never touches `UserAccount` directly.
* `platform/` holds pure technical helpers (`TransactionRunner`, `AuditLogger`) with zero domain rules.

## When to Use It

* **Best for:** Larger codebases (5+ developers, multiple teams, compliance/billing isolation) where informal folder conventions break down.
* **Where it breaks:** Without code-review discipline or package-level separation, developers can still import `internal/` across modules.

## Commands

```bash
cd orderflow_server
serverpod generate
dart analyze
```

Compare stages:

```bash
git diff --stat 03-vertical-slices..04-modular-monolith
git diff --stat 04-modular-monolith..05-event-driven
```
