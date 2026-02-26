.PHONY: test check fmt lint ci-fmt ci-lint

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
