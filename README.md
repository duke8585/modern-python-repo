# 🧱 Python Project Template

A modern Python project scaffold with strict type safety and validation:

- `uv` for environment and dependency management
- `pyproject.toml` as the single source of truth
- `pyright` for strict type checking
- `ruff` for linting and formatting
- `pytest` for testing
- `pydantic` for data validation
- `beartype` for runtime type checking
- `pre-commit` hooks for enforcement
- `Makefile` for reproducible workflows  


## 🚀 Quickstart

Clone or fork the repo, then choose your workflow:

### Standard Setup
```bash
make setup
```

This will:
- Create a `.venv` virtual environment using `uv`
- Install all dependencies (including dev tools like `ruff`, `pytest`, `pre-commit`)
- Install pre-commit Git hooks

### Strict Type-Safe Setup (Recommended)
```bash
make venv
make init
make precommit-install
```

This additionally installs:
- `pyright` for strict type checking
- `pydantic` for data validation
- `beartype` for runtime type checking

You're now ready to develop with full type safety.


## 🧪 Development Workflow

| Task              | Command              | Description                                |
|-------------------|----------------------|--------------------------------------------|
| Setup project     | `make setup`         | Create env + install everything            |
| Strict setup      | `make init`          | Install with type checking tools           |
| Type check & lint | `make check`         | Run pyright + ruff (strict validation)     |
| Run tests         | `make test`          | Run pyright + ruff + pytest                |
| Lint code         | `make lint`          | Run `ruff check` only                      |
| Format code       | `make format`        | Auto-format with `ruff format`             |
| Run all hooks     | `make precommit-run` | Run pre-commit hooks manually              |
| Activate env      | `make activate`      | Print the `source` command                 |
| Clean venv        | `make clean`         | Remove `.venv`                             |
| Update deps       | `make update`        | Upgrade and reinstall all dependencies     |


## 🧹 Pre-commit Hooks

Pre-commit is used to enforce:

- Code linting (`ruff check`)
- Code formatting (`ruff format`)
- Unit test execution (`pytest`, defined as a local hook)

**Note:** Type checking with `pyright` runs as part of `make test` (via the local pytest hook), ensuring type safety before commits.

You don't need to run these manually — they will trigger on `git commit`.

To run them explicitly:

```bash
make precommit-run
```


## 📂 Project Structure

```text
my_project/
├── pyproject.toml             ← single source of config
├── .pre-commit-config.yaml    ← defines all hooks
├── Makefile                   ← reproducible automation
├── claude.md                  ← Python development rules
├── agents.md                  ← AI agent guidelines
├── src/
│   └── my_project/
│       └── example.py         ← your core code goes here
├── tests/
│   └── test_example.py        ← write unit tests here
```

## 📚 Development Documentation

- **`claude.md`** - Comprehensive Python development rules covering type safety, validation protocols, and code structure standards
- **`agents.md`** - Guidelines for AI coding assistants working in this repository, including workflows and quality standards


## ✏️ Fill In The Blanks

Before you start using this repo for real work, update:

- `pyproject.toml`:
  - `[project]` section: set `name`, `version`, `description`, `authors`
  - `[project.dependencies]`: add your actual runtime dependencies
  - `[project.optional-dependencies].dev`: add dev-only tools if needed

- `src/my_project/`:
  - Rename `my_project` to your actual package/module name
  - Replace `example.py` with your real code

- `tests/`:
  - Replace `test_example.py` with your real test cases
  - Add fixtures, mocks, integration tests as needed


## ✅ Requirements

- Python 3.11+ installed  
- `uv` installed (`pip install uv`)  
- GNU Make installed (built into macOS/Linux; for Windows use WSL or `make.exe`)  
- Git  


## 🧠 Tips

### Type Safety Workflow
- **Always run `make check` before committing** - ensures type safety and code quality
- Use `make test` to run full validation (type checking + linting + tests)
- If pyright fails, fix type errors immediately - they block commits

### General
- Use `make update` to upgrade all dependencies and re-install
- If something breaks, start over with:

```bash
make clean && make setup && make init
```

### Strict Development Mode
For maximum safety, configure your editor to run `pyright` on save:
- VS Code: Install the Pylance extension and enable type checking
- Other editors: Configure to run `.venv/bin/pyright` on file save


## 📦 Want to Publish?

This blueprint is designed for local dev and team collaboration. If you want to publish this as a PyPI package or internal library, you’ll need to:

- Add `build-system` section to `pyproject.toml`
- Choose a backend (e.g. Hatchling, Flit)
- Add versioning and packaging metadata

Check [https://packaging.python.org/](https://packaging.python.org/) for guidance.
