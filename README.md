# python-monorepo-experiment

A Python monorepo using [uv Workspaces](https://docs.astral.sh/uv/concepts/projects/workspaces/) and [Make](https://www.gnu.org/software/make/) for task orchestration.

> **Credit:** This project was bootstrapped from [carderne/postmodern-mono](https://github.com/carderne/postmodern-mono).

## Prerequisites

- [uv](https://docs.astral.sh/uv/) — Python package manager
- `make` — pre-installed on macOS and Linux

## Structure

```
.
├── pyproject.toml              # root pyproject (workspace config)
├── Makefile                    # root task runner (delegates to sub-Makefiles)
├── uv.lock
├── libs/
│   └── greeter/                # shared library (postmodern.greeter)
│       ├── Makefile
│       └── pyproject.toml
├── apps/
│   ├── server/                 # web server app (postmodern.server)
│   │   ├── Makefile
│   │   ├── pyproject.toml
│   │   └── Dockerfile
│   ├── server2/                # web server app (postmodern.server2)
│   │   ├── Makefile
│   │   ├── pyproject.toml
│   │   └── Dockerfile
│   └── mycli/                  # CLI app (postmodern.mycli)
│       ├── Makefile
│       └── pyproject.toml
└── e2e/
    └── server2-e2e/            # end-to-end tests for server2
        ├── Makefile
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

All tasks are managed through Make. Run them across all projects or target a specific one.
Add `-j` for parallel execution (e.g. `make -j test`).

| Command | Description |
| --- | --- |
| `make dev` | Start all apps in dev mode with hot-reload |
| `make server-dev` | Start the server in dev mode with hot-reload |
| `make fmt` | Format code (ruff format) |
| `make lint` | Lint & auto-fix (ruff check --fix) |
| `make check` | Type-check (ty check) |
| `make test` | Run tests (pytest) |
| `make <project>-<target>` | Run a specific target for a single project |
| `make server-test` | Example: run tests for the server |
| `make mycli-lint` | Example: lint the CLI app |
| `make greeter-check` | Example: type-check the greeter library |
| `make ci` | CI: run all checks (format, lint, type-check, test, e2e) |
| `make run-e2e` | Run unit tests then e2e tests |
| `make -C apps/server test` | Alternative: run a target directly in a project directory |

## Useful Commands

| Command | Description |
| --- | --- |
| `make help` | List all available targets with descriptions |
| `make setup` | Install all Python dependencies (`uv sync --all-packages`) |
