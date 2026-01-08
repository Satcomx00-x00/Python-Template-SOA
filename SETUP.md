# Quick Setup Guide

This guide will help you get started with the Python Template SOA in minutes.

## Prerequisites

Before you begin, ensure you have:
- **Python 3.13+** installed
- **Git** for version control
- **Make** (usually pre-installed on Linux/Mac)

## Installation Steps

### 1. Install uv (Package Manager)

```bash
# Install uv - fast Python package manager
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add to PATH (if needed)
export PATH="$HOME/.cargo/bin:$PATH"

# Verify installation
uv --version
```

### 2. Clone and Setup Project

```bash
# Clone the repository
git clone https://github.com/yourusername/python-template-soa.git
cd python-template-soa

# Install dependencies
make install

# Verify everything works
make check
```

### 3. Optional Tools

#### Install git-cliff (Changelog Generator)

```bash
# Linux/WSL
curl -LsSf https://github.com/orhun/git-cliff/releases/latest/download/git-cliff-$(uname -m)-unknown-linux-gnu.tar.gz | tar xzf - -C ~/.local/bin

# macOS (Homebrew)
brew install git-cliff

# Verify
git-cliff --version
```

## Quick Commands

```bash
# Development workflow
make install       # Install all dependencies
make format        # Auto-format code
make lint          # Check code quality
make test          # Run tests
make check         # Run all checks

# Run the application
PYTHONPATH=src python -m python_template.main

# Generate changelog
make changelog

# Build container
make container-build
make container-run
```

## IDE Setup

### VS Code with DevContainer

1. Install **DevContainers** extension
2. Open project in VS Code
3. Press `F1` → "Dev Containers: Reopen in Container"
4. Wait for container to build
5. Start coding!

### VS Code without DevContainer

1. Install recommended extensions:
   - Python (ms-python.python)
   - Ruff (charliermarsh.ruff)
   - Even Better TOML (tamasfe.even-better-toml)

2. Configure Python interpreter:
   - Press `F1` → "Python: Select Interpreter"
   - Choose the uv-created virtual environment

## Verify Installation

Run all checks to ensure everything is working:

```bash
# Run comprehensive checks
make check

# Expected output:
# ✅ Python files compiled
# ✅ Code formatted
# ✅ Linting passed
# ✅ Type checking passed
# ✅ Security scan passed
# ✅ Tests passed
```

## Next Steps

1. **Customize the template**:
   - Update project name in `pyproject.toml`
   - Rename `src/python_template/` directory
   - Update README.md with your project details

2. **Add your code**:
   - Write code in `src/python_template/`
   - Add tests in `tests/`

3. **Commit and push**:
   ```bash
   git add .
   git commit -m "feat: initial project setup"
   git push origin main
   ```

4. **Enable GitHub Actions**:
   - CI will automatically run on push
   - Check the "Actions" tab on GitHub

## Troubleshooting

### uv not found
```bash
# Re-run installation
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add to PATH
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Import errors when running tests
```bash
# Ensure dependencies are installed
make install

# Or use uv run
uv run pytest
```

### Permission denied errors
```bash
# Make Makefile executable
chmod +x Makefile

# Or run commands directly
uv sync
uv run pytest
```

## Getting Help

- 📖 Read [EXAMPLES.md](EXAMPLES.md) for detailed usage
- 🤝 See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines
- 📋 Check [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for architecture
- 🐛 Open an issue on GitHub for bugs

## Summary

You're all set! The template includes:
- ✅ Fast dependency management (uv)
- ✅ Code quality tools (ruff, mypy, bandit)
- ✅ Testing framework (pytest)
- ✅ CI/CD pipeline (GitHub Actions)
- ✅ Container support (Containerfile)
- ✅ DevContainer for VS Code
- ✅ Changelog generation (git-cliff)
- ✅ Comprehensive documentation

Happy coding! 🚀
