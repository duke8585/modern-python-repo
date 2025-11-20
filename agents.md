# AI Agent Guidelines for Python Development

## Purpose
This document provides specific guidance for AI coding assistants (like Claude Code) working in this repository. It defines the workflow, validation steps, and quality standards that must be followed.

## Mandatory Pre-Flight Checks

Before suggesting ANY code changes, you MUST:

1. **Read `claude.md`** - Understand the development rules
2. **Verify tooling is available** - Ensure pyright, ruff, pytest are installed
3. **Check current state** - Run `make check` to see the baseline

## Code Change Workflow

### Step 1: Understand Requirements
- Ask clarifying questions if requirements are ambiguous
- Identify which files need changes
- Consider type implications and data flow

### Step 2: Plan the Changes
- Identify required types and data structures
- Plan Pydantic models before writing business logic
- Consider error cases and edge conditions

### Step 3: Implement with Types
```python
# ALWAYS start with types and validation
from pydantic import BaseModel, Field
from beartype import beartype

class InputData(BaseModel):
    class Config:
        frozen = True

    value: int = Field(..., gt=0)
    label: str = Field(..., min_length=1)

@beartype
def process_input(data: InputData) -> str:
    return f"{data.label}: {data.value}"
```

### Step 4: Validate Immediately
```bash
# Run this BEFORE showing code to user
make check

# If it fails, fix the issues
# Never show failing code
```

### Step 5: Write Tests
```python
from typing import assert_type

def test_process_input() -> None:
    data = InputData(value=42, label="count")
    result = process_input(data)

    # Type assertion
    assert_type(result, str)

    # Value assertion
    assert result == "count: 42"
```

### Step 6: Run Full Test Suite
```bash
make test  # Runs check + pytest
```

## Common Patterns

### Adding a New Feature

1. **Define data models first:**
```python
from pydantic import BaseModel

class FeatureInput(BaseModel):
    class Config:
        frozen = True

    param1: str
    param2: int

class FeatureOutput(BaseModel):
    class Config:
        frozen = True

    result: str
    metadata: dict[str, str]
```

2. **Implement typed function:**
```python
from beartype import beartype

@beartype
def new_feature(input_data: FeatureInput) -> FeatureOutput:
    # Implementation
    return FeatureOutput(
        result="processed",
        metadata={"status": "success"}
    )
```

3. **Write test:**
```python
def test_new_feature() -> None:
    input_data = FeatureInput(param1="test", param2=42)
    output = new_feature(input_data)
    assert output.result == "processed"
```

4. **Validate:**
```bash
make check && make test
```

### Refactoring Existing Code

When refactoring untyped code:

1. **Add types incrementally:**
```python
# Before
def process(data):
    return data["value"] * 2

# After
from pydantic import BaseModel

class ProcessInput(BaseModel):
    value: int

def process(data: ProcessInput) -> int:
    return data.value * 2
```

2. **Update all call sites:**
```python
# Before
result = process({"value": 10})

# After
result = process(ProcessInput(value=10))
```

3. **Run validation:**
```bash
make check
```

### Handling External Data

Always validate external data at boundaries:

```python
from pydantic import BaseModel, ValidationError

class APIResponse(BaseModel):
    status: str
    data: dict[str, str]

def fetch_data(url: str) -> APIResponse:
    import httpx

    response = httpx.get(url)

    try:
        return APIResponse.model_validate(response.json())
    except ValidationError as e:
        raise ValueError(f"Invalid API response: {e}") from e
```

## Error Handling Standards

### Define Specific Exceptions

```python
class ValidationError(Exception):
    """Raised when input validation fails."""
    pass

class ProcessingError(Exception):
    """Raised when data processing fails."""
    pass
```

### Use Result Types for Fallible Operations

```python
from typing import Union
from pydantic import BaseModel

class Success(BaseModel):
    class Config:
        frozen = True
    value: str

class Failure(BaseModel):
    class Config:
        frozen = True
    error: str

Result = Union[Success, Failure]

def risky_operation(input_val: str) -> Result:
    if not input_val:
        return Failure(error="Input cannot be empty")
    return Success(value=input_val.upper())
```

## Integration with Existing Code

### When Adding to Existing Modules

1. **Read the existing code first:**
```bash
# Use Read tool to understand context
```

2. **Match existing patterns:**
   - Use the same import style
   - Follow existing naming conventions
   - Maintain consistent error handling

3. **Add types to everything you touch:**
```python
# If you modify a function, add full type hints
def existing_function(x: int, y: str) -> bool:
    # Even if original had no types
    ...
```

### When Creating New Modules

1. **Start with a type-safe template:**
```python
"""Module docstring describing purpose."""

from beartype import beartype
from pydantic import BaseModel, Field

class ModuleConfig(BaseModel):
    """Configuration for this module."""
    class Config:
        frozen = True

    # Config fields here

@beartype
def main_function(input_data: InputType) -> OutputType:
    """Function docstring."""
    # Implementation
```

2. **Add `__init__.py` exports:**
```python
"""Package exports."""

from .module import main_function, ModuleConfig

__all__ = ["main_function", "ModuleConfig"]
```

## Testing Requirements

### Every Change Must Include Tests

```python
def test_feature_happy_path() -> None:
    """Test the expected behavior."""
    result = feature_function(valid_input)
    assert result == expected_output

def test_feature_error_case() -> None:
    """Test error handling."""
    with pytest.raises(SpecificError):
        feature_function(invalid_input)

def test_feature_types() -> None:
    """Verify type correctness."""
    from typing import assert_type
    result = feature_function(valid_input)
    assert_type(result, ExpectedType)
```

### Test Coverage Standards

- **Happy path** - Expected behavior with valid input
- **Error cases** - How failures are handled
- **Edge cases** - Boundary conditions
- **Type validation** - Using `assert_type`

## Debugging Type Errors

### Using reveal_type

```python
from typing import reveal_type

def debug_function(data: list[int]) -> None:
    result = process(data)
    reveal_type(result)  # Pyright will show the inferred type
```

Run pyright to see the revealed type:
```bash
pyright src/module.py
```

### Common Type Issues

**Issue: Type is too broad**
```python
# Bad
def process(data: dict) -> Any:
    ...

# Good
def process(data: dict[str, int]) -> list[int]:
    ...
```

**Issue: Missing Optional**
```python
# Bad
def find_user(user_id: int) -> User:
    # Might return None!
    ...

# Good
def find_user(user_id: int) -> User | None:
    ...
```

**Issue: Mutable default argument**
```python
# Bad
def add_item(items: list[str] = []) -> list[str]:
    ...

# Good
def add_item(items: list[str] | None = None) -> list[str]:
    if items is None:
        items = []
    ...
```

## Pre-Commit Hook Integration

The pre-commit hooks will automatically run:
- `pyright` - Type checking
- `ruff` - Linting and formatting
- `pytest` - Full test suite

If pre-commit fails:
1. **Read the error message carefully**
2. **Fix the specific issue**
3. **Re-run `make check`**
4. **Try commit again**

Do not bypass pre-commit hooks with `--no-verify` unless absolutely necessary.

## Communication with Users

### When Showing Code

1. **Always run validation first:**
```bash
make check && make test
```

2. **Show the validated code:**
```python
# This code has been validated with pyright and ruff
```

3. **Explain type choices:**
"I'm using a Pydantic BaseModel here to ensure runtime validation..."

### When Changes Fail Validation

1. **Don't show failing code** - Fix it first
2. **Explain what you're fixing:**
"I need to adjust the return type because pyright detected a mismatch..."

3. **Show the corrected version**

### When Suggesting Improvements

1. **Show specific type improvements:**
```python
# Current (less safe)
def process(data: dict) -> dict:
    ...

# Improved (type-safe)
class ProcessInput(BaseModel):
    value: int

class ProcessOutput(BaseModel):
    result: str

def process(data: ProcessInput) -> ProcessOutput:
    ...
```

2. **Explain the benefits:**
"Using Pydantic models provides runtime validation and catches errors at the boundary..."

## Quick Reference Commands

```bash
# Setup project
make init

# Validate code quality
make check

# Run tests (includes check)
make test

# Fix formatting issues
make format

# Run pre-commit manually
make precommit-run

# Clean and restart
make clean && make setup
```

## Summary Checklist

Before completing any task:

- [ ] All code has complete type hints
- [ ] Pydantic models for all data structures
- [ ] Beartype decorators on public functions
- [ ] Tests written and passing
- [ ] `make check` passes with 0 errors
- [ ] `make test` passes completely
- [ ] Pre-commit hooks would pass
- [ ] Code is formatted with ruff
- [ ] No `Any` types without justification
- [ ] Error handling is explicit

---

**Remember: You are not just writing code, you are maintaining a type-safe, validated, production-ready codebase.**
