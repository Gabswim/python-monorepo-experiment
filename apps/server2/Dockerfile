# this Dockerfile should be built from the repo root:
#   docker build -f apps/server2/Dockerfile -t postmodern-server2 .

# ---------------------------------------------------------------------------
# Stage 1: builder – install deps + project with uv
# ---------------------------------------------------------------------------
FROM python:3.14-slim-bookworm AS builder

COPY --from=ghcr.io/astral-sh/uv:0.9.18 /uv /uvx /bin/

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_NO_DEV=1

WORKDIR /app

# 1) Install third-party dependencies only (workspace members not available yet).
#    --frozen skips lockfile validation since member pyproject.tomls aren't copied.
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    uv sync --frozen --no-install-workspace --no-editable --package=postmodern-server2

# 2) Copy full source and sync again to install workspace packages.
#    --locked validates the lockfile is up-to-date now that all members are present.
COPY . /app
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-editable --package=postmodern-server2

# ---------------------------------------------------------------------------
# Stage 2: runtime – minimal image with only the venv
# ---------------------------------------------------------------------------
FROM python:3.14-slim-bookworm

# Create non-root user
RUN addgroup --system app && adduser --system --ingroup app app

# Copy the self-contained venv from the builder (includes all installed packages)
COPY --from=builder --chown=app:app /app/.venv /app/.venv

ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1

USER app

CMD ["uvicorn", "postmodern.server2.run:app", "--host", "0.0.0.0", "--port", "8000"]
