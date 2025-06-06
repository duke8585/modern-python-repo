# TODOs

## gh actions automation for PRs

- [ ] gh action and README update

## README

```md

## 🔒 Enforcing PR Checks with GitHub Actions

This project uses GitHub Actions to enforce pre-commit hooks and tests before pull requests can be merged.

Once you've pushed this repository to GitHub, follow these steps to enable enforcement:

1. Navigate to your repository’s **Settings** → **Branches**
2. Click **"Add branch protection rule"**
3. For **Branch name pattern**, enter: `main`
4. Under **Rule settings**, enable the following:
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Require pull request reviews before merging (optional)

5. Under **Status checks that are required**, select:
- `pre-commit & test checks / lint-and-test`

This ensures that:
- All pre-commit hooks pass (linting, formatting, local checks)
- All tests pass
- The branch is in sync with `main` before merge

With this setup, your CI and local standards are aligned, and nothing unclean hits `main`.
```

## code prototype

- [ ] should determine file scope of PR automagically

```yaml

name: pre-commit & test checks

on:
  pull_request:
  push:
    branches:
      - main

jobs:
  lint-and-test:
    name: Run pre-commit and tests
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Install uv
        run: |
          pip install uv

      - name: Set up virtualenv and install deps
        run: |
          make install

      - name: Run pre-commit hooks
        run: |
          pip install pre-commit
          pre-commit run --all-files

      - name: Run tests
        run: |
          make test

```
