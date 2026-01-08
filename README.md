# Python Template - State of the Art

A modern Python project template with best practices, security scanning, and containerization.

## Features

- 🚀 **Fast dependency management** with [uv](https://github.com/astral-sh/uv)
- 🐳 **Containerized** development and deployment with Containerfile
- 🛠️ **DevContainer** support for consistent development environments
- ✅ **Comprehensive testing** with pytest
- 🔒 **Security scanning** with Bandit
- 🤖 **GitHub Actions CI/CD** pipeline with ruff format/lint checks
- 📝 **Code quality** with ruff (linting & formatting)
- 📋 **Automated changelog** generation with git-cliff
- 🎯 **Makefile** for common development tasks

## Quick Start

### Prerequisites

- Python 3.11+
- [uv](https://github.com/astral-sh/uv) installed (`curl -LsSf https://astral.sh/uv/install.sh | sh`)

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd Python-Template-SOA

# Install dependencies with uv
make install

# Or manually:
uv sync
```

### Development

```bash
# Run tests
make test

# Run linting
make lint

# Run security checks
make security

# Format code
make format

# Run all checks (test + lint + security)
make check

# Generate changelog
make changelog
```

## Project Structure

```
.
├── src/                    # Source code
│   └── python_template/    # Main package
│       ├── __init__.py
│       └── main.py
├── tests/                  # Test files
│   ├── __init__.py
│   └── test_main.py
├── .devcontainer/          # VS Code devcontainer configuration
├── .github/                # GitHub Actions workflows
│   └── workflows/
│       └── ci.yml
├── Containerfile           # Container image definition
├── Makefile               # Development tasks
├── pyproject.toml         # Project configuration and dependencies
└── README.md              # This file
```

## Using uv

This project uses [uv](https://github.com/astral-sh/uv) for fast and reliable dependency management:

```bash
# Install dependencies (includes dev dependencies)
uv sync

# Add a new dependency
uv add <package-name>

# Add a development dependency (to dev group)
uv add --group dev <package-name>

# Run Python with project dependencies
uv run python src/python_template/main.py

# Run tests
uv run pytest
```

## Container Usage

```bash
# Build the container
docker build -f Containerfile -t python-template .

# Run the container
docker run python-template
```

## DevContainer

Open this project in VS Code with the DevContainers extension installed. VS Code will prompt you to reopen in a container, providing a consistent development environment.

## CI/CD

The GitHub Actions workflow automatically:
- 🧹 Runs make clean to ensure clean environment
- ✅ Compiles all Python files to check for syntax errors
- 📐 Checks code formatting with ruff
- 🧹 Runs ruff linter
- 🔒 Runs Bandit security scanner
- 🔍 Runs mypy type checker
- 🧪 Executes the test suite on multiple Python versions
- 📋 Generates changelog with git-cliff
- 📊 Reports coverage

## Customization

### Editing Project Name

1. Update `name` in [pyproject.toml](pyproject.toml)
2. Rename `src/python_template/` directory to match your project
3. Update import statements in tests
4. Update README.md

### Adding Dependencies

```bash
# Runtime dependency
uv add requests

# Development dependency (added to dev group)
uv add --group dev black
```

### Modifying CI/CD

Edit [.github/workflows/ci.yml](.github/workflows/ci.yml) to customize the pipeline.

## License

See [LICENSE](LICENSE) for details.
