---
name: update-dependencies
description: Review, update and verify application dependencies across Ruby, NodeJS, mise, Docker and CI. Use for dependency maintenance in this repository.
disable-model-invocation: true
---

Run commands and resolve project paths from the repository root.

# Stage 1: Inventory

Review these dependency sources:

- `mise.toml`: Ruby, NodeJS, pnpm and PostgreSQL versions.
- `Gemfile`: Direct gems and Ruby version.
- `Gemfile.lock`: Resolved gems, platforms, Ruby and Bundler versions.
- `package.json`: Direct NodeJS dependencies and pnpm version.
- `pnpm-lock.yaml`: Resolved NodeJS dependencies.
- `pnpm-workspace.yaml`: Release cooldown and allowed build scripts.
- `Dockerfile`: Base images, pnpm, system packages and Dockerfile frontend.
- `compose.yaml`: PostgreSQL, Meilisearch and both Garage container images.
- `.github/workflows/{ci,cd}.yml`: Actions, runners, service images and system
  packages.

Use `bundle outdated` and `pnpm outdated` to identify updates. Preserve
configured cooldowns and verify release eligibility separately; outdated
reports may include releases still within their cooldown.

# Stage 2: Plan

- Target the latest eligible stable releases, including majors, unless the user
  narrows the scope. Exclude prereleases by default.
- Review direct dependency changelogs before updating and identify required
  adaptations. Transitive dependency changelog review is intentionally omitted.
- Review majors and 0.x minor updates closely: esbuild updates have previously
  required rollback after breaking the build.

# Stage 3: Update

- Update each blank-line-separated block of gems in `Gemfile` together.
  `package.json` has no required grouping.
- Adapt build and lint configuration where required by package changes.
- Keep repeated versions synchronized; Ruby appears in `mise.toml`, `Gemfile`,
  `Gemfile.lock` and `Dockerfile`.
- Then update remaining eligible transitive dependencies and review the diff.

# Stage 4: Verify

Run using the project's configured tools:

- `bundle exec rspec`
- `bundle exec rubocop`
- `pnpm run lint`
- `pnpm run fmt:check`
- `pnpm run build`
- `RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 NODE_ENV=production bundle exec rails assets:precompile`

Always build and boot the production image with Docker Compose or
podman-compose, even when container files are unchanged. This catches missing
production build dependencies and production-only initializer failures.

Apply these regression checks when the relevant dependencies change:

- **Search:** Test Meilisearch server, Ruby client and jobs together: indexing,
  deletion, filtering and pagination. Server health alone is insufficient.
- **Frontend:** Test compilation and watch-mode rebuilding after an asset edit;
  check PostCSS ESM plugin loading when adapting configuration.
- **Native libraries:** Check build headers and final-image shared libraries
  after Ruby/native-gem updates; exercise image processing for libvips updates.
- **Linters:** Verify nested-file glob coverage and RuboCop's default exclusions.
- **Migrations:** Test changed migrations on a disposable database with
  pre-upgrade data. Schema loading missed a deployment failure where attachment
  cleanup referenced a removed model.

Fix upgrade-related failures and rerun affected checks. An upgrade is verified
only when its checks pass; report blocked checks as unverified.

# Stage 5: Summary

Report old → new versions, deferred updates with reasons, and checks that
passed, failed or could not run.
