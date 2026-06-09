# makigas.es

## Code conventions and rules to follow

1. Rubocop must pass. Always check before finishing the turn. Do not
   consider your solution done if it doesn't pass the cop.

2. Test coverage. Consider running red-light green-light to proof your
   theories as you work. Write the tests if they don't exist. Do not
   write code that you cannot test. Your solution is not correct unless
   there is a test case that asserts that it is correct.

3. Beware of touching the routes.rb. But if you do, always remember to
   add an HTTP 301/302 for the old URL.

4. Unless you are working on the trunk branch, consider feature branches
   as safe areas to rollback. Do not write "workarounds" to keep
   compatibility with code that you just wrote. Just replace the old code
   with the new one.

## Stack Notes

- This project uses a lot of ERB and HAML. ViewComponent is useful, but
  the migration is not finished (and it won't be until genshi-view_component
  exists).

- We use kt-paperclip, but we crave for a migration towards ActiveStorage.

- JavaScript and CSS are bundled via a custom `esbuild` workflow
  (`npm run bundle:watch`). Bundled assets land in `app/assets/builds/`.

- Minimal client-side JavaScript; fully traditional server-side HTML with few
  JavaScript slots for analytics, embeds and simple interactions. Progressive
  enhancement is always required. Site must work without JavaScript enabled.

## Key Paths

- `app/controllers/`, `app/models/`, `app/views/`, `app/helpers/`:
  standard Rails layers.
- `app/components/`: ViewComponent implementations.
- `app/javascript/packs/`: `six` (public site) and `dashboard`
  (backoffice) asset entrypoints.
- `app/services/`: domain-specific service objects.
- `spec/`: RSpec test suite.
