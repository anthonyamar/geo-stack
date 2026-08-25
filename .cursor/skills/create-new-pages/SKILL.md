---
name: create-new-pages
description: >-
  Plan (Plan mode) and build new Rails pages. Slices work into parallel
  backend-builder and view-component-builder subagents, then assembles via
  routes/controllers/views. Owns Hotwire Turbo (frames/streams) for SPA-like or
  global interactivity. Controller + system tests when needed; playwright-cli
  for full-page validation. Use for end-to-end page delivery.
---

# Create new pages

Page orchestrator — **start in Plan mode**. You assemble backend + frontend through **routes and thin controllers**; subagents build the slices.

## Subagents (parallel, unlimited)

| Agent | Scope |
|-------|--------|
| `backend-builder` — `.cursor/agents/backend-builder.md` | Services, models, migrations, API, backend tests |
| `view-component-builder` — `.cursor/agents/view-component-builder.md` | ViewComponents, component tests |

Launch **as many Task calls in parallel** as the plan requires — one brief per independent slice.

## Scope

| You own | You delegate |
|---------|--------------|
| **Plan** — maximal parallel slices + assembly map | Backend slices → `backend-builder` |
| Routes, thin controllers, `app/views/` assembly | UI slices → `view-component-builder` |
| Design/interaction consistency across the page | Model/service/component unit tests (subagents) |
| **Hotwire Turbo** — frames, streams, `turbo_stream` responses (SPA-like / global interactivity) | Component-local Stimulus (subagent) |
| Controller tests; **system tests** only for major interactions | |
| Page-level / cross-component Stimulus (when Turbo isn't enough) | |
| Full-page check via **`playwright-cli`** when useful | |

Glue a slice yourself only when delegation costs more than a trivial wrapper.

## Inputs

- **Linear** project or parent issue — fetch children/issues via MCP.
- **Screenshot** of full page (optional) — section map for plan + briefs.
- Sibling pages as consistency baseline (`static_pages#home`, etc.).

Details → [reference.md](reference.md).

## Phases

### 1) Plan (Plan mode — mandatory first)

1. Linear context + repo exploration.
2. Decompose into **independent, parallelizable slices** (backend + components). Reuse existing code where possible.
3. Output: slice list (subagent briefs), route, controller ivars, view skeleton, **Turbo strategy** (full page vs frames/streams), test strategy, parallel launch plan.
4. Confirm with user if scope is ambiguous; then execute.

### 2) Delegate (parallel)

Fire all `backend-builder` and `view-component-builder` tasks in one message when slices are independent. Collect handoffs.

### 3) Assemble

1. Branch off `main` (`git-workflow`).
2. **Routes + thin controller** — wire subagent services; set ivars for views.
3. **View** — compose `render` examples; consistent sections/spacing/SEO (`content_for`, `main_class`).
4. **Turbo** — you decide and wire: `turbo_frame_tag`, lazy frames, `turbo_stream` in controllers, morphing partial updates. Prefer Turbo over bespoke JS for SPA-like or page-wide interactivity; delegate only isolated widget behavior to subagent Stimulus.
5. Page Stimulus only when Turbo cannot cover cross-section coordination.

### 4) Verify

- Controller tests on new/changed actions.
- System tests **only** for heavy multi-step interactions (auth flows, forms, turbo chains).
- **`playwright-cli`** — optional end-to-end page validation (see `00-core/playwright` rule for test accounts).
- `bin/rubocop` / `bin/eslint`; `bin/ci` before done.

## Handoff

Route · controller paths · view path · slices delegated (new vs existing) · tests run · playwright notes if used.
