# postmodern-mono

A Python monorepo using [uv Workspaces](https://docs.astral.sh/uv/concepts/projects/workspaces/) and [Nx](https://nx.dev/) for task orchestration.

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
│   └── mycli/                  # CLI app (postmodern.mycli)
│       ├── project.json
│       └── pyproject.toml
└── e2e/
    └── server2-e2e/            # end-to-end tests for server2
        ├── project.json
        └── pyproject.toml
```

- **libs/** — importable packages, never run independently
- **apps/** — runnable applications with entry points
- **e2e/** — end-to-end test suites

## Getting Started

```bash
# Clone the repo
git clone git@github.com:carderne/postmodern-mono.git
cd postmodern-mono

# Install Python dependencies
uv sync --all-packages

# Install Nx
npm install
```

## Commands

All tasks are managed through Nx. Run them across all projects or target a specific one.

### Run across all projects

```bash
npx nx run-many -t fmt        # format code (ruff format)
npx nx run-many -t lint       # lint & fix (ruff check --fix)
npx nx run-many -t check      # type-check (ty check)
npx nx run-many -t test       # run tests (pytest)
```

### Run for a single project

```bash
npx nx run postmodern-server:test
npx nx run postmodern-mycli:lint
npx nx run postmodern-greeter:check
```

### CI targets (no auto-fix)

```bash
NX_TUI=false npx nx run-many -t ci:fmt ci:lint check test e2e
```

### Docker

Build and run the server from the workspace root:

```bash
docker build --tag=postmodern-server -f apps/server/Dockerfile .
docker run --rm -it postmodern-server
```
