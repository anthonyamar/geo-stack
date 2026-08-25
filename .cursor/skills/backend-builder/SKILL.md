---
name: backend-builder
description: >-
  Production-ready backend slices: ApplicationService, models/scopes/concerns,
  migrations, API v1, jobs, unit tests with edge cases. Ready for thin
  controllers. For parallel backend work or backend-builder subagent.
---

# Backend builder

Pure domain/backend logic — **no** ERB, ViewComponents, or page assembly.

## Scope

| You own | You don't (unless scoped) |
|---------|---------------------------|
| `app/services/`, model scopes/validations/concerns | HTML controllers, views, ViewComponents |
| `db/migrate/`, factories for new columns | Component/page Stimulus |
| `app/controllers/api/v1/` + routes under `namespace :api` | Duplicating business logic in controllers |
| `app/jobs/` for heavy/async work | Model callbacks (`before_*`/`after_*`) |

Explore siblings before inventing patterns (`Reviews::Create`, `StaticPages::Home::LoadContent`, existing API controllers).

## Workflow

1. Parse brief: domain action, inputs, persistence, API shape, controller ivars expected.
2. Schema first if needed → migration (`change`, SQL backfills per `migrations` rule).
3. Model/concern/scope updates — no callbacks; side effects in services/jobs.
4. Service(s): `ApplicationService`, `save_records` for writes, `true`/`false` or documented payload.
5. API only when brief requires JSON — inherit `Api::V1::BaseController`, follow index/search patterns.
6. Tests: model + service (+ API if added); happy path + main failure + risky edges.
7. `bin/rails test` on touched tests; `bin/rubocop` on Ruby.

Details → [reference.md](reference.md).

## Handoff (no TODOs)

Files · migration status · **service API** (`SomeService.call(...)` → return value) · **controller snippet** (ivars/params) · API route if any · test commands/results.
