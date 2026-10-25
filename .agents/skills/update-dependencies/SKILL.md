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

Record the NodeJS major and Ruby `X.Y` branch configured at the start of the
task. Check the official [NodeJS release schedule](https://nodejs.org/en/about/previous-releases)
and [Ruby maintenance branches](https://www.ruby-lang.org/en/downloads/branches/)
for support status and available releases. Distinguish updates within these
starting runtime lines from upgrades that require user involvement.

Use `bundle outdated` and `pnpm outdated` to identify updates. Preserve
configured cooldowns and verify release eligibility separately; outdated
reports may include releases still within their cooldown.

# Stage 2: Plan

- For NodeJS, allow stable minor and patch updates only within the major
  configured at the start of the task, and only on a supported LTS line.
  For example, `24.2.0` may move to `24.2.1` or `24.3.0`, but not to `25.0.0`
  or `26.0.0`, even if the newer major is LTS.
- For Ruby, allow stable patch updates only within the supported `X.Y` branch
  configured at the start of the task. For example, `3.7.0` may move to
  `3.7.1`, but `3.6` to `3.7` and `3.7` to `4.0` require user involvement.
- NodeJS major upgrades and Ruby `X.Y` branch upgrades are report-only and
  require separate planning and user validation. This also applies when the
  starting runtime line is unsupported or NodeJS is not LTS; report that status
  without automatically switching lines.
- If a dependency or tooling update requires a runtime outside these limits,
  choose the latest eligible release compatible with the allowed runtimes or
  defer it and report the requirement. Do not change runtime lines to unblock it.
- For all other dependencies and tooling, target the latest eligible stable
  releases, including majors, unless the user narrows the scope. Exclude
  prereleases by default.
- Review direct dependency changelogs and runtime release notes before updating
  and identify required adaptations. Transitive dependency changelog review is
  intentionally omitted.
- Review majors and 0.x minor updates closely: esbuild updates have previously
  required rollback after breaking the build.

# Stage 3: Update

- Update each blank-line-separated block of gems in `Gemfile` together.
  `package.json` has no required grouping.
- Adapt build and lint configuration where required by package changes.
- Keep repeated versions synchronized; Ruby appears in `mise.toml`, `Gemfile`,
  `Gemfile.lock` and `Dockerfile`. Keep NodeJS pins synchronized wherever present.
  Check the selected runtimes against dependency and tooling requirements.
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
passed, failed or could not run. Include runtime support status and newer
runtime lines that need separate planning and user validation.
