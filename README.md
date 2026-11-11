# orderflow

A Serverpod `4.0.4` reference repository demonstrating 5 backend architecture patterns across Git branches:

| Branch | Pattern | Structure |
| --- | --- | --- |
| `01-simple-mvc` | Simple MVC | `endpoints/` + `models/` talking directly to `.db` |
| `02-layered` | Layered Architecture | `endpoints/` → `services/` → `repositories/` → `models/` |
| `03-vertical-slices` | Package by Feature (Tier 1) | `features/{auth,orders,payments}/` |
| `04-modular-monolith` | Modular Monolith (Tier 2) | `modules/{identity,billing}/{api,internal}/` + `platform/` |
| `05-event-driven` | Event-Driven Architecture | `events/`, `future_calls/`, `MessageCentral` pub-sub |

## Usage

Switch between patterns or compare them with `git diff`:

```bash
git checkout 01-simple-mvc
git checkout 03-vertical-slices
git diff --stat 01-simple-mvc..03-vertical-slices
```

Inside `orderflow_server/`:

```bash
dart analyze
serverpod generate
```


## Flutter Web Client (`orderflow_flutter/`)

* On **`main`**, `orderflow_flutter` is a **Unified Multi-Backend Explorer** that connects to all 5 server backends (`01`–`05`) with per-backend Server URL configuration (`:8080`–`:8084` presets), greeting ping, auth support for `02-layered` & `03-vertical-slices`, and an RPC response console.
* On each branch (`01-simple-mvc` .. `05-event-driven`), `orderflow_flutter` is wired directly to that branch's strongly-typed `orderflow_client` endpoints.

Run as Flutter Web:

```bash
cd orderflow_flutter
flutter run -d chrome
```
