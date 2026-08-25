# Geo stack

Opinionated Rails template for geo-aware apps: PostGIS, fuzzy search, Hotwire, DaisyUI, and production defaults copied from a live Coolify deploy.

## Stack

- Ruby 4.0.5 + Rails 8.1
- PostgreSQL + PostGIS (`pg_trgm`, `fuzzystrmatch`)
- Solid Queue (same primary database, Puma plugin)
- Tailwind CSS 4 + DaisyUI 5 (light/dark)
- jsbundling-rails + esbuild + Yarn
- Devise, ViewComponent, Pagy 43, Resend, Bugsnag (opt-in)

## New project

```bash
git clone git@github.com:anthonyamar/geo-stack.git new-app
cd new-app
git remote rename origin geo-stack
git remote add origin git@github.com:username/new-app.git
```

Change **only these constants** in `config/application.rb`:

- `GeoStack::APP_NAME`
- `GeoStack::DOMAIN`
- then rename the module `GeoStack` / `geo_stack` to your app name

Also update `config/meta.yml` and replace the markdown in `config/legal/`.

## Setup

Requires Ruby 4.0.5, Node 22, Yarn classic, and a local PostGIS database.

```bash
bin/setup
bin/dev
```

Visit [localhost:3000](http://localhost:3000/).

Emails in development: [localhost:3000/letter_opener](http://localhost:3000/letter_opener).

## Environment variables (all optional)

| Variable | Purpose |
| --- | --- |
| `RESEND_API_KEY` | Production mail via Resend |
| `WEBSITE_CONTACT_EMAIL` | Contact form destination |
| `BUGSNAG_API_KEY` | Error monitoring (ignored in local env) |
| `MISSION_CONTROL_HTTP_BASIC_USERNAME` / `PASSWORD` | Protect `/jobs` |
| `DATABASE_URL` | Production PostGIS URL (`postgres://` is rewritten to `postgis://`) |

See `config/application.yml.example`.

## CI

```bash
bin/ci          # setup, assets, rubocop, eslint, audits, brakeman, tests
bin/ci --sign   # same, then `gh signoff` (branch must track origin)
```

GitHub Actions runs `bin/ci` on pull requests.

## Production (Coolify)

The `Dockerfile` is the Coolify production image (Node 22, jemalloc, frozen lockfiles). Provide `DATABASE_URL` (PostGIS) and `RAILS_MASTER_KEY`.

## Geo concerns

Include on models that need coordinates / search:

```ruby
class City < ApplicationRecord
  include GeoCoordinates
  include GeoBoundingBox
  include Geocoderable
  include FuzzySearchable
end
```

See the comments in `app/models/concerns/` for the required columns.

## Licence

MIT. Open issues and PRs on GitHub.
