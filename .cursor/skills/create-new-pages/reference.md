# Create new pages — reference

Read during plan or execution. Rules: `20-rails/rails-architecture`, `20-rails/services`, `45-ui/ui-hotwire`, `50-testing/testing-controllers`, `50-testing/testing-services`, `git-workflow`, `ci`.

## Linear MCP

**Project:** `get_project` → `list_issues` with `project: "<id or slug>"`.

**Parent issue:** `get_issue` → `list_issues` with `parentId: "<identifier>"` for sub-issues.

Use issue titles/descriptions as component specs. Map labels or naming conventions to UI sections when present. Assign user on status updates per `project-management`.

## Page patterns (this app)

```ruby
# Thin controller — data via service
def home
  content = StaticPages::Home::LoadContent.call
  @countries = content.countries
  # ...
end
```

```erb
<%# app/views/static_pages/home.html.erb %>
<%= content_for :meta_title, t(".seo.meta_title") %>
<% content_for :main_class, "w-full max-w-none p-0" %>
<%= render StaticPages::Home::HeroComponent.new %>
<%= render StaticPages::Home::SectionComponent.new do %>
  <%= render Ui::Cards::SlidingCardsComponent.new(...) do |c| %>
```

- SEO: `content_for :meta_title`, `:meta_description`.
- Full-bleed pages: override `main_class` (see `application.html.erb`).
- Sections: reuse `StaticPages::Home::SectionComponent` or `Ui::Containers::MainComponent` / `WhiteCardComponent`.

## Backend subagent brief

```
Slice: StaticPages::About::LoadContent (read-only loader)
Inputs: none
Returns: OpenStruct or object with :team_members, :stats
Controller: @content = StaticPages::About::LoadContent.call
Sibling: app/services/static_pages/home/load_content.rb
Tests: happy path + empty DB edge
```

Invoke: `Task(subagent_type: "backend-builder", model: "composer-2.5-fast", prompt: …)`.

## Component subagent brief

```
Component: Namespace::Name
Props: record:, show_badges: true
Copy: (or lazy i18n keys)
Reuse: Ui::StarsComponent, Ui::Cards::CompactDestinationComponent
Screenshot: (crop if attached)
Sibling ref: app/components/destinations/community_picks_component.rb
```

Invoke: `Task(subagent_type: "view-component-builder", model: "composer-2.5-fast", prompt: …)`.

## Hotwire Turbo (orchestrator-owned)

Sits between front and backend — **not** delegated to subagents.

**You decide** during plan: full-page navigation vs partial updates.

| Need | Turbo tool |
|------|------------|
| Replace a page section | `turbo_frame_tag` + controller responding `format.turbo_stream` or frame layout |
| Push DOM updates after action | `turbo_stream` templates / `render turbo_stream: …` in controller |
| Lazy-loaded block | `turbo_frame_tag` with `loading: :lazy` + dedicated route |
| SPA-like tab/filter without full reload | Frames or streams — not a client router |

- Coordinate with `backend-builder` brief when controller must return streams or frame-only responses.
- Subagents render **Turbo-compatible** markup (`data-turbo-frame`, form `data-turbo-*`) but do **not** own frame/stream wiring.
- Prefer Turbo over page Stimulus; Stimulus for what streams cannot express cleanly.

## Page-level Stimulus (fallback)

- `app/javascript/controllers/<page>_controller.js` — only when Turbo is insufficient (scroll spy, coordinating non-streamable third-party widgets).
- Component-internal Stimulus stays in `view-component-builder` scope.

## Parallel launch

One `Task` per slice in a **single message** when independent:

```
Task(subagent_type: "backend-builder", model: "composer-2.5-fast", prompt: …)
Task(subagent_type: "view-component-builder", model: "composer-2.5-fast", prompt: …)
# … as many as the plan requires
```

Wait for handoffs before assembly (routes/controller/view).

## Tests (orchestrator)

**Controller** — always for new/changed actions (`testing-controllers`).

**System** — only for major interactions (multi-step forms, auth, turbo flows). One test at a time (`testing` rule).

**Playwright** — after assembly, load `playwright-cli` skill to smoke-test the full page (layout, JS, navigation). Not a substitute for unit tests.

Model/service/component tests stay with subagents.

## Consistency checklist

- Same container width/padding as sibling pages unless screenshot demands full-bleed.
- DaisyUI + existing `Ui::*` — no new design dialect.
- FontAwesome icons aligned with neighborhood components.
- Turbo-friendly markup; no inline JS in views.
