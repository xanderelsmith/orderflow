# Pattern 3: Package by Feature / Vertical Slices (`03-vertical-slices`)

**Tier 1 Recommendation for Small-to-Mid Projects**

Instead of grouping files by technical role (`endpoints/`, `services/`, `models/`), code is grouped by business capability under `lib/src/features/`. Because `serverpod generate` recursively scans `lib/src/` for `.spy.yaml` files, each feature slice owns its models, services, and endpoints together.

## Structure (`orderflow_server/lib/src/`)

```text
lib/src/
└── features/
    ├── auth/
    │   ├── auth_endpoint.dart
    │   ├── auth_service.dart
    │   └── models/
    │       └── user.spy.yaml
    ├── orders/
    │   ├── order_endpoint.dart
    │   ├── order_service.dart
    │   └── models/
    │       ├── endpoint_exception.spy.yaml
    │       ├── order_item.spy.yaml
    │       └── order_record.spy.yaml
    └── payments/
        ├── payment_endpoint.dart
        ├── payment_service.dart
        └── models/
            └── payment_record.spy.yaml
```

## Serverpod 4 Notes

* `OrderFeatureEndpoint` reads `session.authenticated` synchronously and passes `authInfo.userIdentifier` (`String`) into `OrderFeatureService`.
* `OrderRecord` (`order_record.spy.yaml`) avoids colliding with Serverpod's built-in `Order` sorting class.

## When to Use It

* **Best for:** Small-to-mid production apps optimizing for shipping velocity and high cognitive locality. Removing a feature means deleting one folder.
* **Where it breaks:** **The "Shared Dumpster"**—if features start importing each other's internal models or dumping domain entities into a global `shared/` folder, boundaries erode. Promote to `04-modular-monolith` when team scale demands strict contracts.

## Commands

```bash
cd orderflow_server
serverpod generate
dart analyze
```

Compare stages:

```bash
git diff --stat 02-layered..03-vertical-slices
git diff --stat 03-vertical-slices..04-modular-monolith
```
