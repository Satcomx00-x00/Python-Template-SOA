# Contributing to Python Template SOA

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/yourusername/python-template-soa.git
   cd python-template-soa
   ```
3. **Install dependencies**:
   ```bash
   make install
   ```

## Development Workflow

1. **Create a new branch** for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the code style guidelines

3. **Run tests and checks**:
   ```bash
   make check  # Runs all checks: lint, typecheck, security, tests
   ```

4. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Add: description of your changes"
   ```

5. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request** on GitHub

## Code Style

This project uses:
- **ruff** for linting and formatting
- **mypy** for type checking
- **bandit** for security scanning

Run before committing:
```bash
make format  # Auto-format code
make lint    # Check code style
make typecheck  # Check types
```

## Testing

- Write tests for new features in the `tests/` directory
- Follow the existing test structure
- Aim for high test coverage (minimum 80%)
- Run tests with: `make test`

## Commit Messages

Use clear, descriptive commit messages:
- `Add: new feature description`
- `Fix: bug description`
- `Update: modification description`
- `Docs: documentation changes`
- `Test: test-related changes`

## Pull Request Guidelines

- Provide a clear description of the changes
- Reference any related issues
- Ensure all CI checks pass
- Update documentation if needed
- Add tests for new features

## Questions?

Open an issue on GitHub if you have questions or need help!
