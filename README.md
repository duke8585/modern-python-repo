# 🧱 Python Project Template

A modern Python project scaffold with:

- `uv` for environment and dependency management  
- `pyproject.toml` as the single source of truth  
- `ruff` for linting and formatting  
- `pytest` for testing  
- `pre-commit` hooks for enforcement  
- `Makefile` for reproducible workflows  


## 🚀 Quickstart

Clone or fork the repo, then:

```bash
make setup
```

This will:

- Create a `.venv` virtual environment using `uv`
- Install all dependencies (including dev tools like `ruff`, `pytest`, `pre-commit`)
- Install pre-commit Git hooks

You’re now ready to develop and commit safely.


## 🧪 Development Workflow

| Task            | Command              | Description                        |
|-----------------|----------------------|------------------------------------|
| Setup project   | `make setup`         | Create env + install everything    |
| Activate env    | `make activate`      | Print the `source` command         |
| Run tests       | `make test`          | Run the test suite with `pytest`   |
| Run doctests    | `make doctest`       | Run doctest-enabled examples       |
| Lint code       | `make lint`          | Run `ruff check`                   |
| Format code     | `make format`        | Auto-format with `ruff format`     |
| Run all hooks   | `make precommit-run` | Run pre-commit hooks manually      |
| Clean venv      | `make clean`         | Remove `.venv`                     |


## 🧹 Pre-commit Hooks

Pre-commit is used to enforce:

- Code linting (`ruff`)
- Code formatting (`ruff format`)
- Unit test execution (`make test`, defined as a local hook)

You don’t need to run these manually — they will trigger on `git commit`.

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
├── src/
│   └── my_project/
│       └── example.py         ← your core code goes here
├── tests/
│   └── test_example.py        ← write unit tests here
```


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

- Use `make update` to upgrade all dependencies and re-install
- Use `make doctest` if you use `doctest`-style inline examples
- If something breaks, start over with:

```bash
make clean && make setup
```


## 📦 Want to Publish?

This blueprint is designed for local dev and team collaboration. If you want to publish this as a PyPI package or internal library, you’ll need to:

- Add `build-system` section to `pyproject.toml`
- Choose a backend (e.g. Hatchling, Flit)
- Add versioning and packaging metadata

Check [https://packaging.python.org/](https://packaging.python.org/) for guidance.
