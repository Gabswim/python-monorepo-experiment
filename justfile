# python-monorepo-experiment

# ── Modules (per-project justfiles) ──────────────────────────────

mod server 'apps/server/justfile'
mod server2 'apps/server2/justfile'
mod mycli 'apps/mycli/justfile'
mod greeter 'libs/greeter/justfile'
mod e2e 'e2e/server2-e2e/justfile'

# ── Aggregate recipes ────────────────────────────────────────────

# Install all Python dependencies
setup:
    uv sync --all-packages

# Start all apps in dev mode (hot-reload)
[parallel]
dev: server::dev server2::dev

# Run tests across all projects
[parallel]
test: server::test server2::test mycli::test greeter::test

# Type-check all projects
[parallel]
check: server::check server2::check mycli::check greeter::check e2e::check

# Format code across all projects
[parallel]
fmt: server::fmt server2::fmt mycli::fmt greeter::fmt e2e::fmt

# Lint & auto-fix across all projects
[parallel]
lint: server::lint server2::lint mycli::lint greeter::lint e2e::lint

# Check formatting (CI mode, fails on unformatted code)
[parallel]
ci-fmt: server::ci-fmt server2::ci-fmt mycli::ci-fmt greeter::ci-fmt e2e::ci-fmt

# Check linting (CI mode, no auto-fix)
[parallel]
ci-lint: server::ci-lint server2::ci-lint mycli::ci-lint greeter::ci-lint e2e::ci-lint

# Run e2e tests (runs unit tests first)
run-e2e: test e2e::e2e

# Run all CI checks
ci: ci-fmt ci-lint check test run-e2e
