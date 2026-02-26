.PHONY: dev test check fmt lint ci-fmt ci-lint

dev:
	uv run uvicorn postmodern.server2.run:app --reload --port 8001

test:
	uv run pytest .

check:
	uv run ty check .

fmt:
	uv run ruff format .

lint:
	uv run ruff check --fix .

ci-fmt:
	uv run ruff format --check .

ci-lint:
	uv run ruff check .
