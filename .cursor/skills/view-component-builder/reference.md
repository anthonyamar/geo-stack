# ViewComponent builder — reference

Read when implementing. Rules: `45-ui/ui-hotwire`, `20-rails/rails-architecture`, `00-core/language-i18n`, `40-javascript/javascript`, `50-testing/testing-components`.

## Sidecar layout

```
app/components/namespace/component_name.rb
app/components/namespace/component_name/component_name.html.erb
app/components/namespace/component_name/component_name.yml
test/components/namespace/component_name_test.rb
```

## Ruby (`ApplicationComponent`)

- Presentation only — no DB, services, auth. Plain data in; keyword args; `renders_one`/`renders_many` for slots.
- Stimulus config via `data-*-value` methods (see `Search::AutocompleteFieldComponent`).

## ERB

- Tailwind 4 + DaisyUI 5; FontAwesome `fa-solid`/`fa-regular` with `aria-hidden="true"`.
- `t('.key')` + sidecar YAML (`en`/`fr`, sorted keys, double-quoted values).
- `data-component="kebab-name"` for test anchors; Stimulus via `data-controller`/`data-action` — no inline JS.

## Stimulus

New controller only when server-driven UI isn't enough. Register in `controllers/index.js`; keep thin.

## Tests

```ruby
render_inline(Namespace::ComponentName.new(...))
assert_selector "…"
```

Stub `Current`/policies/APIs. No Capybara unless parent asks.

## Pre-handoff

Sidecar complete · no hardcoded copy · tests green · rubocop/eslint if JS touched.
