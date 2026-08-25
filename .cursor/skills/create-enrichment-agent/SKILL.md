---
name: create-enrichment-agent
description: >-
  Scaffold enrichment agents (RubyLLM + Langfuse). See agents.mdc for layout;
  bookend enrichment status in Enrichment::Base.
---

# Create enrichment agent

Use when adding AI content enrichment for `Enrichable` models (`Continent`, `Country`, `City`, `Region`, `DiveSite`, geo zones).

## Checklist

1. **Langfuse prompt** — create `enrichment/<entity>` in Langfuse (human task; blocked without it).
2. **Schema** — reuse `Schemas::GeoContent` via `Enrichment::GeoContent`; add `app/agents/schemas/<entity>.rb` only when fields differ.
3. **Serializer** — `app/serializers/enrichment/<entity>_blueprint.rb` → `Enrichment::<Entity>Blueprint`.
4. **Agent** — `app/agents/enrichment/<entity>.rb` → `Enrichment::<Entity> < Enrichment::GeoContent` when fields match geo content schema.
5. **Job** — register in `Agents::RunJob::ALLOWED`, enqueue `Agents::RunJob.perform_later('Enrichment::<Entity>', '<Model>', record.id)`.
6. **Tests** — serializer + `test/agents/enrichment/<entity>_test.rb` with `RubyLLM::Test` stubs.

## Agent layout

```
Agents::RunJob → Enrichment::<Entity> → Enrichment::Base
app/agents/schemas/<entity>.rb
app/agents/enrichment/<entity>.rb
```

Subclass declares:

```ruby
class Enrichment::Country < Enrichment::GeoContent
  self.prompt_name = 'enrichment/country'
  self.enrichment_blueprint = Enrichment::CountryBlueprint
  self.local_llm_model = 'qwen/...'  # optional; LM Studio only
end
```

`Enrichment::GeoContent` sets `schema_class = Schemas::GeoContent` and `content_field_names`. Do not add empty `Schemas::<Entity>` subclasses — RubyLLM does not inherit parent schema fields.

Register the agent in `Agents::RunJob::ALLOWED`.

## Record context (Blueprinter)

- Serializers live under `app/serializers/enrichment/`.
- Shared field exclusions: `Enrichment::FieldExclusions::RECORD` (geo, enrichment pipeline, timestamps).
- Base class: `Enrichment::BaseBlueprint` (`record_fields_for`, `top_diving_records`).
- Short association refs: `Enrichment::ReferenceBlueprint` view `:short` (name, description, kind when present).
- Entity blueprint: `Enrichment::<Entity>Blueprint` — record columns + counts + top-5 diving associations.

## Conventions

- **User prompt**: `enrichment_blueprint.render_as_hash(record)` as JSON (not raw `as_json`).
- **System prompt**: `AgentPrompts.fetch(prompt_name).prompt` via `with_instructions`.
- **Structured output**: `Schemas::GeoContent` via `Enrichment::GeoContent`; EN fields top-level + `fr` object for translations. JSON-LD (`schemas`) is app-generated, not LLM-enriched.
- **Nil-only apply**: assign EN columns and `translations['fr']` only where blank at start of run.
- **Validation retries**: up to 2 retries (3 attempts); re-ask LLM with `validation_errors` in user payload.
- **Queue**: `agents` in `config/queue.yml`; generic `Agents::RunJob` with `ALLOWED` registry.

## Testing

- `require 'ruby_llm/test'` + `ResolveWithTestProvider` in `test/test_helper.rb`; `RubyLLM::Test.reset` in teardown.
- Stub LLM with `RubyLLM::Test.stub_response` / `stub_responses` — no provider API calls.
- Stub `AgentPrompts.fetch` with Mocha.
- Cover: success, retry then success, retries exhausted → `failed`, nil-only slice, partial FR merge.
- Factory trait `:enrichment_pending` with blank content fields.
