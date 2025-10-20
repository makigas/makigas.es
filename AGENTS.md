# makigas.es

makigas.es is a Ruby on Rails application that serves both the public
website and the backoffice dashboard. The codebase dates back to Rails
4.x and still relies on several legacy conventions that new contributors
should keep in mind.

## Stack Notes

- Rails application with ERB and HAML templates alongside ViewComponent
  components.
- Paperclip/KtPaperclip is still used for file uploads; ActiveStorage is
  not enabled.
- JavaScript and CSS are bundled via a custom `esbuild` workflow
  (`npm run bundle:watch`). Bundled assets land in `app/assets/builds/`.
- Minimal client-side JavaScript; expect server-rendered HTML with light
  sprinkles for analytics, embeds, and simple interactions.

## Key Paths

- `app/controllers/`, `app/models/`, `app/views/`, `app/helpers/`:
  standard Rails layers.
- `app/components/`: ViewComponent implementations.
- `app/javascript/packs/`: `six` (public site) and `dashboard`
  (backoffice) asset entrypoints.
- `app/services/`: domain-specific service objects.
- `spec/`: RSpec test suite.

## Tooling

- Ruby 3.3.6; Rails `~> 7.2`.
- PostgreSQL database configured via `config/database.yml`; uses env
  vars for connection details.
- Always run RuboCop and keep the tree lint-clean.
- Frontend scripts are exposed through npm:
  - `npm run build:watch` for esbuild.
  - `npm run fmt` / `npm run fmt:check` for Prettier.
  - `npm run lint` for ESLint/Stylelint.
- Test suite: `bundle exec rspec`.

## Project Rules

1. Keep RuboCop passing; fix or silence offenses before committing.
2. Preserve public URLs. If a route changes, add a 301/302 redirect from
   the previous path.
