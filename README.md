# python-monorepo-experiment

A Python monorepo using [uv Workspaces](https://docs.astral.sh/uv/concepts/projects/workspaces/) and [Just](https://just.systems/) for task orchestration.

> **Credit:** This project was bootstrapped from [carderne/postmodern-mono](https://github.com/carderne/postmodern-mono).

## Prerequisites

- [uv](https://docs.astral.sh/uv/) — Python package manager
- [just](https://just.systems/) — command runner

## Structure

```
.
├── pyproject.toml              # root pyproject (workspace config)
├── justfile                    # root task runner (aggregates modules)
├── uv.lock
├── libs/
│   └── greeter/                # shared library (postmodern.greeter)
│       ├── justfile
│       └── pyproject.toml
├── apps/
│   ├── server/                 # web server app (postmodern.server)
│   │   ├── justfile
│   │   ├── pyproject.toml
│   │   └── Dockerfile
│   ├── server2/                # web server app (postmodern.server2)
│   │   ├── justfile
│   │   ├── pyproject.toml
│   │   └── Dockerfile
│   └── mycli/                  # CLI app (postmodern.mycli)
│       ├── justfile
│       └── pyproject.toml
└── e2e/
    └── server2-e2e/            # end-to-end tests for server2
        ├── justfile
        └── pyproject.toml
```

- **libs/** — importable packages, never run independently
- **apps/** — runnable applications with entry points
- **e2e/** — end-to-end test suites

## Getting Started

```bash
# Clone the repo
git clone https://github.com/Gabswim/python-monorepo-experiment.git
cd python-monorepo-experiment

# Install Python dependencies
uv sync --all-packages
```

## Commands

All tasks are managed through Just. Run them across all projects or target a specific one.

| Command | Description |
| --- | --- |
| `just dev` | Start all apps in dev mode with hot-reload |
| `just server::dev` | Start the server in dev mode with hot-reload |
| `just fmt` | Format code (ruff format) |
| `just lint` | Lint & auto-fix (ruff check --fix) |
| `just check` | Type-check (ty check) |
| `just test` | Run tests (pytest) |
| `just <module>::<recipe>` | Run a specific recipe for a single project |
| `just server::test` | Example: run tests for the server |
| `just mycli::lint` | Example: lint the CLI app |
| `just greeter::check` | Example: type-check the greeter library |
| `just ci` | CI: run all checks (format, lint, type-check, test, e2e) |
| `just run-e2e` | Run unit tests then e2e tests |

## Useful Commands

| Command | Description |
| --- | --- |
| `just --list` | List all available recipes |
| `just --list <module>` | List recipes for a specific module (e.g. `just --list server`) |
| `just setup` | Install all Python dependencies (`uv sync --all-packages`) |
