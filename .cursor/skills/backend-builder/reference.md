# Backend builder — reference

Rules: `20-rails/rails-architecture`, `20-rails/services`, `20-rails/migrations`, `30-data-perf/data-performance`, `50-testing/testing-models`, `50-testing/testing-services`, `10-ruby/ruby-style`.

## Services

```ruby
class Reviews::Create < ApplicationService
  attr_reader :review

  def initialize(review:)
    super()
    @review = review
  end

  def call
    save_records { review.save! }
    review # documented payload exception
  end
end
```

- Class method: `Reviews::Create.call(review: review)`.
- Writes: all inside `save_records`; bang persistence APIs.
- Reads/loaders: no `save_records`; return data object or `true`/`false`.
- Params: `initialize(entity:, params:)` — not one kwarg per column.

## Models

- Scopes for repeated queries; no `default_scope`, no order on `has_many` declarations.
- Validations with `I18n.t('…')` when custom `message:` needed.
- Shared behavior: `app/models/concerns/`.
- **No ActiveRecord callbacks** — use services/jobs.

## Migrations

- Prefer `change`; backfills via SQL + French comment above each statement.
- Index columns used in new query patterns.

## API v1

- Base: `Api::V1::BaseController` (`ApiTokenAuthenticatable`, `SearchableIndexRenderable`).
- Routes: `config/routes.rb` under `namespace :api { namespace :v1`.
- Keep controllers thin — delegate to services/serializers already used in the app.
- Tests: `test/apis/` or project convention for API auth/index behavior.

## Jobs

- `ApplicationJob` + Solid Queue for heavy/off-request work.
- Enqueue from services, not models.

## Tests

**Models:** scopes, validations (Shoulda), instance methods (`testing-models`).

**Services:** happy + `false`/rollback + one risky guard (`testing-services`).

**Factories:** update when migrations add required columns.

## Controller integration snippet (for parent)

```ruby
def create
  @review = current_user.reviews.build(review_params)
  result = Reviews::Create.call(review: @review)
  # parent handles redirect/flash from result
end
```

Parent owns HTTP; you document what to pass and what comes back.
