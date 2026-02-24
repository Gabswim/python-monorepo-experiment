# this Dockerfile should be built from the repo root
FROM python:3.14-slim-bookworm

ENV PYTHONUNBUFFERED=True
WORKDIR /workspace

COPY --from=ghcr.io/astral-sh/uv:0.9.18 /uv /bin/

COPY pyproject.toml uv.lock /workspace/
RUN uv sync --frozen --no-install-workspace --package=postmodern-server

COPY . /workspace
RUN uv sync --frozen --package=postmodern-server

CMD ["/workspace/.venv/bin/uvicorn", "postmodern.server.run:app", "--host", "0.0.0.0", "--port", "8000"]
