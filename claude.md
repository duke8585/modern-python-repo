# Python Development Rules for Claude Code

## Overview
This document defines the strict development standards for Python projects in this repository. These rules prioritize type safety, immutability, validation, and automated enforcement.

## Core Principles

### 1. Type Safety First
- **Every function must have type hints** - no exceptions
- **No `Any` types** - use Union, Generic, or specific types
- **Return types are mandatory** - including `None`
- **Pyright must pass with 0 errors** before any code is committed

### 2. Validation Protocol

**Before EVERY code suggestion, you MUST:**
1. Run `pyright --stats` - must pass with 0 errors
2. Run `ruff check` - must pass all rules
3. Write a test that exercises the types

**On every file save:**
- Auto-run: `ruff format && pyright`
- Fail fast on type errors

### 3. Development Workflow

```bash
# Initial setup
make init

# Before showing any code changes
make check

# Run tests (includes check)
make test
```

## Code Structure Standards

### Use Pydantic for All Data Structures

**YES:**
```python
from pydantic import BaseModel, Field

class Config(BaseModel):
    class Config:
        frozen = True

    api_key: str = Field(..., min_length=1)
    timeout: int = Field(30, gt=0)
```

**NO:**
```python
# Never use raw dicts for structured data
config = {"api_key": key, "timeout": 30}

# Never use untyped dataclasses when validation is needed
@dataclass
class Config:
    api_key: str
    timeout: int
```

### Type All Functions

**YES:**
```python
from beartype import beartype

@beartype
def process_data(items: list[int]) -> tuple[int, float]:
    """Process a list of integers and return count and average."""
    count = len(items)
    average = sum(items) / count if count > 0 else 0.0
    return count, average
```

**NO:**
```python
def process_data(items):  # Missing types
    return len(items), sum(items) / len(items)
```

### Immutability by Default

**YES:**
```python
class UserProfile(BaseModel):
    class Config:
        frozen = True  # Immutable

    username: str
    email: str
    created_at: datetime
```

**NO:**
```python
class UserProfile(BaseModel):
    username: str
    email: str
    # Mutable by default - only use when explicitly needed
```

### Explicit Error Handling

**YES:**
```python
class DatabaseError(Exception):
    """Raised when database operations fail."""
    pass

def fetch_user(user_id: int) -> UserProfile:
    try:
        result = db.query(user_id)
    except ConnectionError as e:
        raise DatabaseError(f"Failed to fetch user {user_id}") from e
    return result
```

**NO:**
```python
def fetch_user(user_id):
    try:
        return db.query(user_id)
    except:  # Bare except
        raise  # Re-raising with no context
```

## Library Preferences

Use these libraries over alternatives:

| Use This | Instead Of | Reason |
|----------|------------|--------|
| `pydantic` | `dataclasses` | Runtime validation + type safety |
| `polars` | `pandas` | Better types, faster, safer |
| `httpx` | `requests` | Async support, better types |
| `msgspec` | `json` | Performance-critical serialization |
| `beartype` | manual checks | Zero-overhead runtime validation |

## Quick Reference Patterns

### Type Validation in Tests

```python
from typing import assert_type

def test_process_data_types() -> None:
    result = process_data([1, 2, 3])
    assert_type(result, tuple[int, float])
    assert result == (3, 2.0)
```

### Exhaustive Pattern Matching

```python
from enum import Enum
from typing import assert_never

class Command(Enum):
    START = "start"
    STOP = "stop"
    RESTART = "restart"

def handle_command(cmd: Command) -> str:
    match cmd:
        case Command.START:
            return "Starting..."
        case Command.STOP:
            return "Stopping..."
        case Command.RESTART:
            return "Restarting..."
        case _:
            assert_never(cmd)  # Ensures all cases handled
```

### Validated Configuration

```python
import os
from pydantic import BaseModel, Field

class Settings(BaseModel):
    class Config:
        frozen = True

    api_url: str = Field(..., regex=r"^https?://")
    api_key: str = Field(..., min_length=32)
    timeout: int = Field(30, gt=0, le=300)

    @classmethod
    def from_env(cls) -> "Settings":
        return cls(
            api_url=os.environ["API_URL"],
            api_key=os.environ["API_KEY"],
            timeout=int(os.getenv("TIMEOUT", "30"))
        )
```

### Result Pattern for Fallible Operations

```python
from typing import Union
from pydantic import BaseModel

class Success(BaseModel):
    class Config:
        frozen = True
    value: str

class Error(BaseModel):
    class Config:
        frozen = True
    message: str

Result = Union[Success, Error]

def parse_config(path: str) -> Result:
    try:
        with open(path) as f:
            data = f.read()
        return Success(value=data)
    except FileNotFoundError as e:
        return Error(message=f"Config not found: {path}")
```

## Enforcement Checklist

Before submitting any code:

- [ ] `make check` passes with 0 errors
- [ ] All functions have type hints
- [ ] All data structures use Pydantic BaseModel
- [ ] Tests exist that exercise the types
- [ ] No `Any` types without explicit justification
- [ ] Beartype decorators on all public functions
- [ ] Immutability (frozen=True) is default

## Editor Integration

Configure your editor to run on save:
```bash
# VS Code: settings.json
{
  "python.linting.enabled": true,
  "python.linting.pyrightEnabled": true,
  "editor.formatOnSave": true,
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff"
  }
}
```

## CI/CD Integration

The pre-commit hooks automatically run:
- `pyright` type checking
- `ruff` linting and formatting
- `pytest` with strict markers

All checks must pass before merge.

---

**Remember: Type safety is not optional. If pyright fails, the code is not ready.**
