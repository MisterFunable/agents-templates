# AGENTS_PYTHON.md

Instructions for AI models working on Python projects.

## Project Structure

Standard Python project layout:

```
project-name/
├── README.md
├── requirements.txt          # Production dependencies
├── requirements-dev.txt      # Development dependencies (optional)
├── .gitignore
├── src/                      # Source code (or package name)
│   ├── __init__.py
│   ├── main.py
│   └── utils.py
├── tests/                    # Test files mirror src/ structure
│   ├── __init__.py
│   └── test_utils.py
└── examples/                 # Usage examples (optional)
    └── basic_usage.py
```

**For CLI tools:** Add `setup.py` or `pyproject.toml` for installation.

**For libraries:** Use `src/package_name/` structure.

**For scripts:** Single file projects are fine for utilities under 300 lines.

## Code Style

### Imports

Order imports in three groups (PEP 8):

```python
# Standard library
import os
import sys
from pathlib import Path

# Third-party
import requests
import pandas as pd

# Local
from src.utils import helper_function
```

### Type Hints

Use type hints for function signatures:

```python
def fetch_data(url: str, timeout: int = 30) -> dict[str, any]:
    """Fetch JSON data from URL."""
    response = requests.get(url, timeout=timeout)
    return response.json()
```

**Skip type hints for:**
- Simple scripts under 50 lines
- Internal helper functions with obvious types
- When types make code less readable

### Docstrings

Use docstrings at module and public function level only:

```python
"""
Module description: what this file does in one line.
"""

def public_function(param: str) -> bool:
    """One-line description of what it does."""
    pass

def _internal_helper():
    # Comments for complex logic only
    pass
```

**Avoid docstring overkill:**
- Don't document obvious functions
- Don't repeat type hints in docstring
- Don't write essay-length explanations

## Naming Conventions

| Type | Style | Example |
|------|-------|---------|
| Files/Modules | `snake_case` | `data_processor.py` |
| Functions | `snake_case` | `calculate_total()` |
| Variables | `snake_case` | `user_count` |
| Classes | `PascalCase` | `DataParser` |
| Constants | `UPPER_SNAKE` | `MAX_RETRIES` |
| Private | `_leading_underscore` | `_internal_method()` |

## Error Handling

**Be specific with exceptions:**

```python
# Good
try:
    data = json.loads(response.text)
except json.JSONDecodeError as e:
    logger.error(f"Invalid JSON response: {e}")
    return None

# Bad - too broad
try:
    data = json.loads(response.text)
except Exception:
    return None
```

**Don't catch what you can't handle:**
- Let critical errors propagate
- Log before re-raising if needed
- Return `None` or default values for expected failures

## Dependencies

**requirements.txt rules:**
1. Pin major versions only: `requests>=2.28,<3.0`
2. Order alphabetically
3. Add comments for non-obvious packages
4. Test install from scratch before committing

```txt
# requirements.txt
pandas>=2.0,<3.0
requests>=2.28,<3.0
pyyaml>=6.0,<7.0
```

**Use virtual environments:**

```bash
python -m venv venv
source venv/bin/activate  # or `venv\Scripts\activate` on Windows
pip install -r requirements.txt
```

## Configuration

**Order of preference:**
1. Environment variables for secrets
2. Config files for settings
3. Command-line args for overrides

```python
import os

# Good - environment variables for secrets
API_KEY = os.getenv("API_KEY")
if not API_KEY:
    raise ValueError("API_KEY environment variable required")

# Good - config file for settings
with open("config.yaml") as f:
    config = yaml.safe_load(f)
```

**Never commit:**
- API keys or tokens
- Passwords or credentials
- User-specific paths (use relative paths)

## Testing

Use `pytest` for testing:

```python
# tests/test_utils.py
import pytest
from src.utils import calculate_total

def test_calculate_total_with_valid_input():
    assert calculate_total([1, 2, 3]) == 6

def test_calculate_total_with_empty_list():
    assert calculate_total([]) == 0

def test_calculate_total_raises_on_invalid_type():
    with pytest.raises(TypeError):
        calculate_total("not a list")
```

**Test coverage:**
- Write tests for public functions
- Skip tests for trivial getters/setters
- Focus on edge cases and error conditions

## Logging

Use standard `logging` module:

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

logger.info("Processing started")
logger.warning("Rate limit approaching")
logger.error("Failed to fetch data", exc_info=True)
```

**Log levels:**
- `DEBUG`: Detailed diagnostic info
- `INFO`: Confirmation things are working
- `WARNING`: Something unexpected but handled
- `ERROR`: Function failed but app continues
- `CRITICAL`: App cannot continue

## File I/O

Use `pathlib` for paths:

```python
from pathlib import Path

# Good
output_dir = Path("exports")
output_dir.mkdir(exist_ok=True)
output_file = output_dir / "result.json"

with output_file.open("w") as f:
    json.dump(data, f, indent=2)

# Bad - string concatenation
output_file = "exports/" + "result.json"
```

**Context managers for files:**
- Always use `with` statements
- Files close automatically on error
- No need for manual cleanup

## Async/Await

Use `asyncio` for I/O-bound concurrent operations:

```python
import asyncio
import aiohttp

async def fetch_url(session: aiohttp.ClientSession, url: str) -> dict:
    async with session.get(url) as response:
        return await response.json()

async def fetch_all(urls: list[str]) -> list[dict]:
    async with aiohttp.ClientSession() as session:
        tasks = [fetch_url(session, url) for url in urls]
        return await asyncio.gather(*tasks)

# Run async code
results = asyncio.run(fetch_all(["https://api.example.com/1", "https://api.example.com/2"]))
```

**When to use async:**
- Multiple HTTP requests
- Database queries with async driver
- File I/O with `aiofiles`

**When NOT to use async:**
- CPU-bound operations (use `multiprocessing`)
- Simple scripts with sequential logic
- When sync code is clearer

## Dataclasses and Pydantic

**Use dataclasses for simple data containers:**

```python
from dataclasses import dataclass, field
from datetime import datetime

@dataclass
class User:
    name: str
    email: str
    created_at: datetime = field(default_factory=datetime.now)
    tags: list[str] = field(default_factory=list)

user = User(name="Alice", email="alice@example.com")
```

**Use Pydantic for validation and serialization:**

```python
from pydantic import BaseModel, EmailStr, Field

class UserCreate(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    email: EmailStr
    age: int = Field(ge=0, le=150)

# Validates on creation
user = UserCreate(name="Alice", email="alice@example.com", age=30)

# Serialize to dict/JSON
user.model_dump()
user.model_dump_json()
```

**When to use which:**

| Use Case | Choice |
|----------|--------|
| Internal data structures | dataclass |
| API request/response models | Pydantic |
| Config file parsing | Pydantic |
| Simple DTOs | dataclass |
| Data with complex validation | Pydantic |

## Type Checking

**Run mypy for static type checking:**

```bash
pip install mypy
mypy src/ --strict
```

**Common type patterns:**

```python
from typing import Optional, Union
from collections.abc import Callable, Iterator

# Optional (can be None)
def find_user(id: int) -> Optional[User]:
    return users.get(id)

# Union types
def process(value: int | str) -> str:  # Python 3.10+
    return str(value)

# Callable types
def retry(func: Callable[[], bool], attempts: int = 3) -> bool:
    for _ in range(attempts):
        if func():
            return True
    return False

# Generic containers
def first(items: list[T]) -> T | None:
    return items[0] if items else None
```

**Type narrowing:**

```python
def process_response(data: dict | None) -> str:
    if data is None:
        return "No data"
    # mypy knows data is dict here
    return data.get("result", "")
```

## Security

**Dependency scanning:**

```bash
pip install pip-audit
pip-audit  # Check for known vulnerabilities
```

**Input validation:**

```python
import re
from pathlib import Path

# Validate file paths (prevent path traversal)
def safe_path(user_input: str, base_dir: Path) -> Path:
    resolved = (base_dir / user_input).resolve()
    if not resolved.is_relative_to(base_dir):
        raise ValueError("Path traversal detected")
    return resolved

# Validate and sanitize strings
def sanitize_filename(name: str) -> str:
    return re.sub(r'[^\w\-.]', '_', name)
```

**Secrets handling:**

```python
import secrets
from hashlib import sha256

# Generate secure tokens
token = secrets.token_urlsafe(32)

# Compare secrets safely (timing-attack resistant)
secrets.compare_digest(user_token, stored_token)

# Never log secrets
logger.info(f"User authenticated")  # Good
logger.info(f"Token: {token}")      # Bad
```

**SQL injection prevention:**

```python
# Bad - string formatting
cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")

# Good - parameterized queries
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))
```

## Edge Cases

**Handle encoding issues:**

```python
# Explicit encoding for file I/O
with open(filepath, "r", encoding="utf-8") as f:
    content = f.read()

# Handle mixed encodings
def safe_read(filepath: Path) -> str:
    try:
        return filepath.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return filepath.read_text(encoding="latin-1")
```

**Handle circular imports:**

```python
# Use TYPE_CHECKING for type-only imports
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .models import User  # Only imported during type checking

def get_user() -> "User":  # Forward reference as string
    from .models import User
    return User()
```

**Handle large files:**

```python
def process_large_file(filepath: Path) -> Iterator[str]:
    with filepath.open() as f:
        for line in f:  # Iterate line by line, not load all
            yield line.strip()
```

## Anti-Patterns

Avoid these common mistakes:

| Don't | Do |
|-------|-----|
| `from module import *` | `from module import specific_function` |
| Bare `except:` clauses | `except SpecificError:` |
| `requirements.txt` with `==` pins | Use `>=X.Y,<X+1.0` ranges |
| Global mutable state | Pass config as parameters |
| `print()` for logging | Use `logging` module |
| String path concatenation | Use `pathlib.Path` |
| Commit secrets in code | Use environment variables |
| `async def` for CPU-bound work | Use `multiprocessing` |
| Mutable default arguments | Use `field(default_factory=list)` |
| Ignore type checker errors | Fix or add `# type: ignore` with reason |
| Format SQL with f-strings | Use parameterized queries |
| Load entire file into memory | Stream with iterators |

## Version Support

Unless specified otherwise:
- Target Python 3.9+ (released 2020)
- Avoid deprecated features
- Document if requiring latest Python features

## Package Distribution

For installable packages, use modern `pyproject.toml`:

```toml
[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"

[project]
name = "your-package"
version = "0.1.0"
description = "One-line description"
requires-python = ">=3.9"
dependencies = [
    "requests>=2.28,<3.0",
]

[project.scripts]
your-command = "your_package.main:main"
```

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Indentation | 4 spaces |
| Line length | 88 characters (Black default) |
| Quotes | Double quotes for docstrings, either for code |
| Blank lines | 2 between top-level, 1 between methods |
| Main guard | `if __name__ == "__main__":` |
| Shebang | `#!/usr/bin/env python3` (executable scripts) |
| Type checking | mypy with `--strict` |
| Data classes | `dataclasses` (simple) or Pydantic (validation) |
| Async HTTP | `aiohttp` or `httpx` |
| Security scanning | `pip-audit` |

## When Working on Python Projects

1. Create virtual environment first
2. Pin dependencies in requirements.txt
3. Use type hints for non-trivial functions
4. Run `mypy` before committing
5. Run `pip-audit` to check for vulnerabilities
6. Use dataclasses or Pydantic for structured data
7. Handle encoding explicitly in file I/O
8. Test with fresh environment before committing

## See Also

- AGENTS_CLI.md for command-line tool patterns
- AGENTS_WEBAPP.md for web application backends

