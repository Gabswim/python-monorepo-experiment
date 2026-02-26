# python-monorepo-experiment
#
# Root Makefile — delegates to per-project Makefiles.
# Use `make -j` to run targets in parallel.

# ── Project directories ──────────────────────────────────────────

APPS      := apps/server apps/server2 apps/mycli
LIBS      := libs/greeter
E2E       := e2e/server2-e2e
ALL       := $(LIBS) $(APPS) $(E2E)
DEV_APPS  := apps/server apps/server2
TEST_DIRS := $(LIBS) $(APPS)

# ── Aggregate targets ────────────────────────────────────────────

.PHONY: setup dev test check fmt lint ci-fmt ci-lint run-e2e ci help

## Install all Python dependencies
setup:
	uv sync --all-packages

## Start all apps in dev mode (hot-reload) — use make -j dev
dev: $(addprefix dev-,$(notdir $(DEV_APPS)))

## Run tests across all projects — use make -j test
test: $(addprefix test-,$(notdir $(TEST_DIRS)))

## Type-check all projects — use make -j check
check: $(addprefix check-,$(notdir $(ALL)))

## Format code across all projects — use make -j fmt
fmt: $(addprefix fmt-,$(notdir $(ALL)))

## Lint & auto-fix across all projects — use make -j lint
lint: $(addprefix lint-,$(notdir $(ALL)))

## Check formatting (CI mode) — use make -j ci-fmt
ci-fmt: $(addprefix ci-fmt-,$(notdir $(ALL)))

## Check linting (CI mode) — use make -j ci-lint
ci-lint: $(addprefix ci-lint-,$(notdir $(ALL)))

## Run e2e tests (runs unit tests first)
run-e2e: test
	$(MAKE) -C $(E2E) e2e

## Run all CI checks
ci: ci-fmt ci-lint check test run-e2e

## Show available targets
help:
	@echo "Usage: make [target]  (add -j for parallel execution)"
	@echo ""
	@echo "Aggregate targets:"
	@echo "  setup      Install all Python dependencies"
	@echo "  dev        Start all apps in dev mode (hot-reload)"
	@echo "  test       Run tests across all projects"
	@echo "  check      Type-check all projects"
	@echo "  fmt        Format code across all projects"
	@echo "  lint       Lint & auto-fix across all projects"
	@echo "  ci-fmt     Check formatting (CI mode)"
	@echo "  ci-lint    Check linting (CI mode)"
	@echo "  run-e2e    Run unit tests then e2e tests"
	@echo "  ci         Run all CI checks"
	@echo ""
	@echo "Per-project targets (examples):"
	@echo "  make -C apps/server dev       Start server with hot-reload"
	@echo "  make -C apps/server test      Run server tests"
	@echo "  make -C libs/greeter check    Type-check the greeter library"
	@echo ""
	@echo "Shorthand per-project targets:"
	@echo "  make server-dev               Start server with hot-reload"
	@echo "  make server-test              Run server tests"
	@echo "  make greeter-check            Type-check the greeter library"

# ── Per-project shorthand targets ────────────────────────────────
# Naming: <project>-<target>  (e.g. server-dev, greeter-test)

# apps/server
.PHONY: server-dev server-test server-check server-fmt server-lint server-ci-fmt server-ci-lint
server-dev:
	$(MAKE) -C apps/server dev
server-test:
	$(MAKE) -C apps/server test
server-check:
	$(MAKE) -C apps/server check
server-fmt:
	$(MAKE) -C apps/server fmt
server-lint:
	$(MAKE) -C apps/server lint
server-ci-fmt:
	$(MAKE) -C apps/server ci-fmt
server-ci-lint:
	$(MAKE) -C apps/server ci-lint

# apps/server2
.PHONY: server2-dev server2-test server2-check server2-fmt server2-lint server2-ci-fmt server2-ci-lint
server2-dev:
	$(MAKE) -C apps/server2 dev
server2-test:
	$(MAKE) -C apps/server2 test
server2-check:
	$(MAKE) -C apps/server2 check
server2-fmt:
	$(MAKE) -C apps/server2 fmt
server2-lint:
	$(MAKE) -C apps/server2 lint
server2-ci-fmt:
	$(MAKE) -C apps/server2 ci-fmt
server2-ci-lint:
	$(MAKE) -C apps/server2 ci-lint

# apps/mycli
.PHONY: mycli-test mycli-check mycli-fmt mycli-lint mycli-ci-fmt mycli-ci-lint
mycli-test:
	$(MAKE) -C apps/mycli test
mycli-check:
	$(MAKE) -C apps/mycli check
mycli-fmt:
	$(MAKE) -C apps/mycli fmt
mycli-lint:
	$(MAKE) -C apps/mycli lint
mycli-ci-fmt:
	$(MAKE) -C apps/mycli ci-fmt
mycli-ci-lint:
	$(MAKE) -C apps/mycli ci-lint

# libs/greeter
.PHONY: greeter-test greeter-check greeter-fmt greeter-lint greeter-ci-fmt greeter-ci-lint
greeter-test:
	$(MAKE) -C libs/greeter test
greeter-check:
	$(MAKE) -C libs/greeter check
greeter-fmt:
	$(MAKE) -C libs/greeter fmt
greeter-lint:
	$(MAKE) -C libs/greeter lint
greeter-ci-fmt:
	$(MAKE) -C libs/greeter ci-fmt
greeter-ci-lint:
	$(MAKE) -C libs/greeter ci-lint

# e2e/server2-e2e
.PHONY: e2e-e2e e2e-check e2e-fmt e2e-lint e2e-ci-fmt e2e-ci-lint
e2e-e2e:
	$(MAKE) -C e2e/server2-e2e e2e
e2e-check:
	$(MAKE) -C e2e/server2-e2e check
e2e-fmt:
	$(MAKE) -C e2e/server2-e2e fmt
e2e-lint:
	$(MAKE) -C e2e/server2-e2e lint
e2e-ci-fmt:
	$(MAKE) -C e2e/server2-e2e ci-fmt
e2e-ci-lint:
	$(MAKE) -C e2e/server2-e2e ci-lint

# ── Aliases used by aggregate targets ────────────────────────────
# These map the $(addprefix ...) expansions to the shorthand targets.

.PHONY: dev-server dev-server2
dev-server: server-dev
dev-server2: server2-dev

.PHONY: test-server test-server2 test-mycli test-greeter
test-server: server-test
test-server2: server2-test
test-mycli: mycli-test
test-greeter: greeter-test

.PHONY: check-server check-server2 check-mycli check-greeter check-server2-e2e
check-server: server-check
check-server2: server2-check
check-mycli: mycli-check
check-greeter: greeter-check
check-server2-e2e: e2e-check

.PHONY: fmt-server fmt-server2 fmt-mycli fmt-greeter fmt-server2-e2e
fmt-server: server-fmt
fmt-server2: server2-fmt
fmt-mycli: mycli-fmt
fmt-greeter: greeter-fmt
fmt-server2-e2e: e2e-fmt

.PHONY: lint-server lint-server2 lint-mycli lint-greeter lint-server2-e2e
lint-server: server-lint
lint-server2: server2-lint
lint-mycli: mycli-lint
lint-greeter: greeter-lint
lint-server2-e2e: e2e-lint

.PHONY: ci-fmt-server ci-fmt-server2 ci-fmt-mycli ci-fmt-greeter ci-fmt-server2-e2e
ci-fmt-server: server-ci-fmt
ci-fmt-server2: server2-ci-fmt
ci-fmt-mycli: mycli-ci-fmt
ci-fmt-greeter: greeter-ci-fmt
ci-fmt-server2-e2e: e2e-ci-fmt

.PHONY: ci-lint-server ci-lint-server2 ci-lint-mycli ci-lint-greeter ci-lint-server2-e2e
ci-lint-server: server-ci-lint
ci-lint-server2: server2-ci-lint
ci-lint-mycli: mycli-ci-lint
ci-lint-greeter: greeter-ci-lint
ci-lint-server2-e2e: e2e-ci-lint
