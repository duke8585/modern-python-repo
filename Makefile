.PHONY: setup venv install lint format test precommit-install precommit-run activate clean update

VENV_DIR := .venv

setup: venv install precommit-install

venv:
	@echo "Creating virtualenv in $(VENV_DIR)..."
	uv venv --python=python3 $(VENV_DIR)

install:
	uv pip install -e .[dev]

lint:
	$(VENV_DIR)/bin/ruff check src tests

format:
	$(VENV_DIR)/bin/ruff format src tests

test:
	$(VENV_DIR)/bin/pytest tests

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