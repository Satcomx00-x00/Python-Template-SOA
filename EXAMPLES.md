# Examples and Usage Guide

This document provides examples of how to use the Python Template SOA.

## Table of Contents
- [Basic Usage](#basic-usage)
- [Development Commands](#development-commands)
- [Container Usage](#container-usage)
- [Testing Examples](#testing-examples)
- [Adding New Features](#adding-new-features)

## Basic Usage

### Running the Application

```bash
# Using uv
uv run python -m python_template.main

# Or after installing
python -m python_template.main
```

### Using the Module in Your Code

```python
from python_template.main import greet, calculate

# Greet a user
message = greet("Alice")
print(message)  # Hello, Alice! Welcome to Python Template SOA.

# Perform calculations
result = calculate(10, 5, "add")
print(result)  # 15.0

result = calculate(10, 5, "multiply")
print(result)  # 50.0
```

## Development Commands

### Installation

```bash
# Install all dependencies
make install

# Install only dev dependencies
make install-dev
```

### Code Quality

```bash
# Format code automatically
make format

# Run linter
make lint

# Run type checker
make typecheck

# Run security scan
make security

# Run all checks at once
make check
```

### Testing

```bash
# Run tests with coverage
make test

# Run tests verbosely
make test-verbose

# Run tests without coverage (faster)
make test-fast

# Run tests and generate HTML coverage report
make test-coverage
# Then open htmlcov/index.html in your browser
```

### Cleanup

```bash
# Clean build artifacts and cache
make clean

# Clean everything including virtual environment
make clean-all
```

## Container Usage

### Building the Container

```bash
# Using make
make container-build

# Or using docker directly
docker build -f Containerfile -t python-template-soa:latest .
```

### Running the Container

```bash
# Using make
make container-run

# Or using docker directly
docker run --rm python-template-soa:latest

# Run interactively
docker run --rm -it python-template-soa:latest /bin/bash
```

### Using with Docker Compose (Example)

Create a `docker-compose.yml`:

```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Containerfile
    volumes:
      - ./src:/app/src
    environment:
      - DEBUG=true
```

Then run:
```bash
docker-compose up
```

## Testing Examples

### Writing a Simple Test

```python
# tests/test_example.py
from python_template.main import greet

def test_greet():
    """Test the greet function."""
    result = greet("Test User")
    assert "Test User" in result
    assert "Welcome" in result
```

### Using Fixtures

```python
import pytest

@pytest.fixture
def calculator_inputs():
    """Provide inputs for calculator tests."""
    return (10, 5)

def test_addition(calculator_inputs):
    """Test addition using fixture."""
    x, y = calculator_inputs
    result = calculate(x, y, "add")
    assert result == 15.0
```

### Testing Exceptions

```python
def test_divide_by_zero():
    """Test that division by zero raises an error."""
    with pytest.raises(ZeroDivisionError):
        calculate(10, 0, "divide")
```

### Parametrized Tests

```python
@pytest.mark.parametrize("x,y,expected", [
    (10, 5, 15),
    (0, 0, 0),
    (-5, 3, -2),
])
def test_addition_parametrized(x, y, expected):
    """Test addition with multiple inputs."""
    result = calculate(x, y, "add")
    assert result == expected
```

## Adding New Features

### 1. Create a New Module

```python
# src/python_template/utils.py
"""Utility functions for the application."""

def format_number(number: float, decimals: int = 2) -> str:
    """Format a number with specified decimal places."""
    return f"{number:.{decimals}f}"
```

### 2. Write Tests

```python
# tests/test_utils.py
"""Tests for utility functions."""

from python_template.utils import format_number

def test_format_number():
    """Test number formatting."""
    assert format_number(3.14159) == "3.14"
    assert format_number(3.14159, 3) == "3.142"
```

### 3. Update Package Exports

```python
# src/python_template/__init__.py
from python_template.utils import format_number

__all__ = ["greet", "calculate", "format_number"]
```

### 4. Run Tests

```bash
make test
```

## CI/CD Pipeline

The GitHub Actions CI pipeline automatically:

1. **Syntax Check**: Compiles all Python files
2. **Security Scan**: Runs Bandit to find security issues
3. **Linting**: Runs ruff to check code style
4. **Type Checking**: Runs mypy to verify types
5. **Tests**: Runs pytest on multiple Python versions

View results in the "Actions" tab on GitHub.

## Environment Variables

You can configure the application using environment variables:

```bash
# Example: Enable debug mode
export DEBUG=true
python -m python_template.main

# Example: Set custom configuration
export CONFIG_FILE=/path/to/config.json
python -m python_template.main
```

## Troubleshooting

### Common Issues

**Issue**: `uv: command not found`
```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Issue**: Tests fail with import errors
```bash
# Ensure dependencies are installed
make install

# Or use uv run
uv run pytest
```

**Issue**: Type checking fails
```bash
# Run mypy to see specific errors
make typecheck

# Add type hints to resolve issues
```

## Best Practices

1. **Always run checks before committing**:
   ```bash
   make check
   ```

2. **Keep dependencies updated**:
   ```bash
   make update
   ```

3. **Write tests for new features**:
   - Aim for 80%+ coverage
   - Test edge cases and error conditions

4. **Use type hints**:
   ```python
   def my_function(param: str) -> int:
       return len(param)
   ```

5. **Document your code**:
   - Add docstrings to functions and classes
   - Update README when adding features

## Additional Resources

- [uv documentation](https://github.com/astral-sh/uv)
- [pytest documentation](https://docs.pytest.org/)
- [ruff documentation](https://docs.astral.sh/ruff/)
- [mypy documentation](https://mypy.readthedocs.io/)
- [Bandit documentation](https://bandit.readthedocs.io/)
