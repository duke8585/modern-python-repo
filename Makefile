.PHONY: setup venv install init check lint format test test-verbose precommit-install precommit-run activate clean update

VENV_DIR := .venv

# Default setup (backward compatible)
setup: venv install precommit-install

venv:
	@echo "Creating virtualenv in $(VENV_DIR)..."
	uv venv --python=python3 $(VENV_DIR)

install:
	uv pip install -e .[dev]

# New strict development workflow
init:
	@echo "Installing project with strict type checking tools..."
	uv pip install -e ".[dev]"
	uv pip install pyright ruff pytest beartype pydantic

check:
	@echo "Running strict type checking and linting..."
	$(VENV_DIR)/bin/pyright --stats
	$(VENV_DIR)/bin/ruff check --fix
	$(VENV_DIR)/bin/ruff format

lint:
	$(VENV_DIR)/bin/ruff check src tests

format:
	$(VENV_DIR)/bin/ruff format src tests

test: check
	@echo "Running tests with strict validation..."
	$(VENV_DIR)/bin/pytest --tb=short --strict-markers

test-verbose:
	$(VENV_DIR)/bin/pytest -v -s tests

precommit-install:
	$(VENV_DIR)/bin/pre-commit install

precommit-run:
	$(VENV_DIR)/bin/pre-commit run --all-files

activate:
	@echo "Run: source $(VENV_DIR)/bin/activate"

clean:
	rm -rf $(VENV_DIR)

update:
	uv pip compile --upgrade
	uv pip install -e .[dev]