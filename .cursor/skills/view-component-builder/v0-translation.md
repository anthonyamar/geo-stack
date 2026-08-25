# v0 → Rails (optional)

Only when parent attaches v0 React/TS or a v0 screenshot. Otherwise use sibling `app/components/`.

| React | Rails |
|-------|-------|
| `className`, shadcn | Tailwind + DaisyUI (`btn`, `card`, `badge`) |
| lucide/Heroicons | FontAwesome — check siblings first |
| `<Link>`, `<Image>` | `link_to`, `image_tag` |
| `useState`/`onClick` | Stimulus `data-action` + `data-*-value` |
| API hooks in component | Parent passes loaded data |
| `{children}` | `renders_one` + `<%= slot %>` |
| JSX strings | `t('.key')` + sidecar YAML |

Match neighborhood tokens: `rounded-2xl`, `hover:shadow-md`, `heading-1`, `text-primary`, `bg-base-100`.
