---
name: view-component-builder
description: >-
  Production-ready ViewComponents (sidecar, Tailwind/DaisyUI, FontAwesome,
  Stimulus, i18n, tests) from a written spec and existing patterns; screenshot or
  v0 snippet when provided. For parallel UI work or view-component-builder subagent.
---

# ViewComponent builder

Presentation-only ViewComponents. **Default input: written spec** — mirror sibling components in `app/components/` (that is the design system). Screenshot or v0 code only when attached; v0 → [v0-translation.md](v0-translation.md).

## Workflow

1. Search `app/components/` — compose `Ui::*` and domain components; don't duplicate.
2. `bin/rails generate view_component:erb Namespace::Name --sidecar` (add `.yml` + test if missing).
3. Implement: Ruby kwargs/slots, ERB, en/fr sidecar YAML, Stimulus only if needed.
4. Test: happy path + one variant; `bin/rails test test/components/...`; `bin/rubocop` on Ruby.

Implementation details → [reference.md](reference.md).

## Handoff (no TODOs)

Files · `<%= render … %>` example · initializer/slots · test command/result · parent wiring notes only.
