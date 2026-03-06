# python-monorepo-experiment

A Python monorepo using [uv Workspaces](https://docs.astral.sh/uv/concepts/projects/workspaces/) and [Nx](https://nx.dev/) for task orchestration.

> **Credit:** This project was bootstrapped from [carderne/postmodern-mono](https://github.com/carderne/postmodern-mono).

## Prerequisites

- [uv](https://docs.astral.sh/uv/) — Python package manager
- [Node.js](https://nodejs.org/) — required for Nx

## Structure

```
.
├── pyproject.toml              # root pyproject (workspace config)
├── nx.json                     # Nx task runner config
├── package.json                # Nx dependencies
├── uv.lock
├── libs/
│   └── greeter/                # shared library (postmodern.greeter)
│       ├── project.json
│       └── pyproject.toml
├── apps/
│   ├── server/                 # web server app (postmodern.server)
│   │   ├── project.json
│   │   ├── pyproject.toml
│   │   └── Dockerfile
│   ├── server2/                # web server app (postmodern.server2)
│   │   ├── project.json
│   │   ├── pyproject.toml
│   │   └── Dockerfile
│   └── mycli/                  # CLI app (postmodern.mycli)
│       ├── project.json
│       └── pyproject.toml
├── tools/
│   └── democli/                # dev demo CLI (postmodern.democli)
│       ├── project.json
│       └── pyproject.toml
└── e2e/
    └── server2-e2e/            # end-to-end tests for server2
        ├── project.json
        └── pyproject.toml
```

- **libs/** — importable packages, never run independently
- **apps/** — runnable applications with entry points
- **tools/** — developer and CI utilities, never deployed to production
- **e2e/** — end-to-end test suites

## Getting Started

```bash
# Clone the repo
git clone https://github.com/Gabswim/python-monorepo-experiment.git
cd python-monorepo-experiment

# Install Python dependencies
uv sync --all-packages

# Install Nx
npm install
```

## Commands

All tasks are managed through Nx. Run them across all projects or target a specific one.

| Command | Description |
| --- | --- |
| `npx nx run-many -t dev` | Start all apps in dev mode with hot-reload |
| `npx nx run postmodern-server:dev` | Start the server in dev mode with hot-reload |
| `npx nx run-many -t fmt` | Format code (ruff format) |
| `npx nx run-many -t lint` | Lint & auto-fix (ruff check --fix) |
| `npx nx run-many -t check` | Type-check (ty check) |
| `npx nx run-many -t test` | Run tests (pytest) |
| `npx nx run <project>:<target>` | Run a specific target for a single project |
| `npx nx run postmodern-server:test` | Example: run tests for the server |
| `npx nx run postmodern-mycli:lint` | Example: lint the CLI app |
| `npx nx run postmodern-greeter:check` | Example: type-check the greeter library |
| `NX_TUI=false npx nx run-many -t ci:fmt ci:lint check test e2e` | CI: run all checks (push/main) |
| `NX_TUI=false npx nx affected -t ci:fmt ci:lint check test e2e` | CI: run checks only for affected projects (PRs) |

## Useful Nx Commands

| Command | Description |
| --- | --- |
| `npx nx graph` | Visualize the project dependency graph in your browser |
| `npx nx graph --affected` | Visualize only projects affected by current changes |
| `npx nx show projects` | List all projects in the workspace |
| `npx nx show project <name>` | Show details and available targets for a project |
| `npx nx affected -t test` | Run tests only for projects affected by current changes |
| `npx nx run-many -t docker:build --dry-run` | Preview the Docker build execution plan without running |
| `npx nx reset` | Clear the Nx cache |
| `npx nx report` | Display installed Nx plugin versions and workspace info |
