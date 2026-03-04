# this Dockerfile should be built from the repo root:
#   docker build -f apps/server/Dockerfile -t postmodern-server .

# ---------------------------------------------------------------------------
# Stage 1: builder – install deps + project with uv
# ---------------------------------------------------------------------------
FROM python:3.14-slim-bookworm AS builder

COPY --from=ghcr.io/astral-sh/uv:0.9.18 /uv /uvx /bin/

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_NO_DEV=1

WORKDIR /app
COPY . /app

# Copy full source and sync to install workspace packages.
# --locked validates the lockfile is up-to-date now that all members are present.
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-editable --package=postmodern-server

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

CMD ["postmodern-server"]
