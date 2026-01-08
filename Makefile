# ============================================================================
# Makefile - Common Development Tasks
# ============================================================================
# This Makefile provides convenient shortcuts for common development tasks
# 
# Usage:
#   make install    - Install dependencies
#   make test       - Run tests
#   make lint       - Run linter
#   make format     - Format code
#   make check      - Run all checks (lint + test + security)
#   make clean      - Clean build artifacts
#
# Make sure uv is installed: curl -LsSf https://astral.sh/uv/install.sh | sh
# ============================================================================

# Default shell
SHELL := /bin/bash

# Colors for terminal output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Python and uv commands
PYTHON := python3
UV := uv
UV_RUN := $(UV) run

# Project directories
SRC_DIR := src
TEST_DIR := tests

# Default target - show help
.PHONY: help
help:
	@echo "$(BLUE)╔══════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║         Python Template SOA - Development Commands          ║$(NC)"
	@echo "$(BLUE)╚══════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(GREEN)Setup:$(NC)"
	@echo "  make install          Install all dependencies"
	@echo "  make install-dev      Install development dependencies only"
	@echo ""
	@echo "$(GREEN)Development:$(NC)"
	@echo "  make format           Format code with ruff"
	@echo "  make lint             Run ruff linter"
	@echo "  make typecheck        Run mypy type checker"
	@echo "  make security         Run bandit security scanner"
	@echo ""
	@echo "$(GREEN)Testing:$(NC)"
	@echo "  make test             Run all tests"
	@echo "  make test-verbose     Run tests with verbose output"
	@echo "  make test-coverage    Run tests and show coverage report"
	@echo "  make test-fast        Run tests without coverage"
	@echo ""
	@echo "$(GREEN)Quality Checks:$(NC)"
	@echo "  make check            Run all checks (format, lint, typecheck, security, test)"
	@echo "  make compile-check    Check Python syntax (py_compile)"
	@echo ""
	@echo "$(GREEN)Cleanup:$(NC)"
	@echo "  make clean            Remove build artifacts and cache"
	@echo "  make clean-all        Remove all generated files including venv"
	@echo ""
	@echo "$(GREEN)Container:$(NC)"
	@echo "  make container-build  Build container image"
	@echo "  make container-run    Run container"
	@echo ""
	@echo "$(GREEN)Changelog:$(NC)"
	@echo "  make changelog        Generate changelog with git-cliff"
	@echo ""

# ============================================================================
# Installation
# ============================================================================

# Install all dependencies (runtime + development)
.PHONY: install
install:
	@echo "$(BLUE)Installing dependencies with uv...$(NC)"
	$(UV) sync
	@echo "$(GREEN)✓ Dependencies installed successfully$(NC)"

# Install only development dependencies
.PHONY: install-dev
install-dev:
	@echo "$(BLUE)Installing development dependencies...$(NC)"
	$(UV) sync --dev
	@echo "$(GREEN)✓ Development dependencies installed$(NC)"

# ============================================================================
# Code Quality
# ============================================================================

# Format code with ruff
.PHONY: format
format:
	@echo "$(BLUE)Formatting code with ruff...$(NC)"
	$(UV_RUN) ruff format $(SRC_DIR) $(TEST_DIR)
	$(UV_RUN) ruff check --fix $(SRC_DIR) $(TEST_DIR)
	@echo "$(GREEN)✓ Code formatted successfully$(NC)"

# Run linter (ruff)
.PHONY: lint
lint:
	@echo "$(BLUE)Running ruff linter...$(NC)"
	$(UV_RUN) ruff check $(SRC_DIR) $(TEST_DIR)
	@echo "$(GREEN)✓ Linting passed$(NC)"

# Run type checker (mypy)
.PHONY: typecheck
typecheck:
	@echo "$(BLUE)Running mypy type checker...$(NC)"
	$(UV_RUN) mypy $(SRC_DIR) $(TEST_DIR)
	@echo "$(GREEN)✓ Type checking passed$(NC)"

# Run security scanner (bandit)
.PHONY: security
security:
	@echo "$(BLUE)Running bandit security scanner...$(NC)"
	$(UV_RUN) bandit -r $(SRC_DIR) -c pyproject.toml
	@echo "$(GREEN)✓ Security scan passed$(NC)"

# Check Python syntax (py_compile) - compiles all .py files
.PHONY: compile-check
compile-check:
	@echo "$(BLUE)Checking Python syntax (py_compile)...$(NC)"
	@$(PYTHON) -m py_compile $(shell find $(SRC_DIR) $(TEST_DIR) -name "*.py")
	@echo "$(GREEN)✓ All Python files compile successfully$(NC)"

# ============================================================================
# Testing
# ============================================================================

# Run all tests with coverage (default pytest config)
.PHONY: test
test:
	@echo "$(BLUE)Running tests with coverage...$(NC)"
	$(UV_RUN) pytest
	@echo "$(GREEN)✓ Tests passed$(NC)"

# Run tests with verbose output
.PHONY: test-verbose
test-verbose:
	@echo "$(BLUE)Running tests (verbose)...$(NC)"
	$(UV_RUN) pytest -vv
	@echo "$(GREEN)✓ Tests passed$(NC)"

# Run tests and display coverage report
.PHONY: test-coverage
test-coverage:
	@echo "$(BLUE)Running tests with coverage report...$(NC)"
	$(UV_RUN) pytest --cov=$(SRC_DIR) --cov-report=term-missing --cov-report=html
	@echo "$(GREEN)✓ Coverage report generated in htmlcov/$(NC)"
	@echo "$(YELLOW)  Open htmlcov/index.html in a browser to view$(NC)"

# Run tests quickly without coverage
.PHONY: test-fast
test-fast:
	@echo "$(BLUE)Running tests (no coverage)...$(NC)"
	$(UV_RUN) pytest --no-cov
	@echo "$(GREEN)✓ Tests passed$(NC)"

# ============================================================================
# Combined Checks
# ============================================================================

# Run all quality checks
.PHONY: check
check: compile-check lint typecheck security test
	@echo ""
	@echo "$(GREEN)╔══════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(GREEN)║            ✓ All checks passed successfully!                 ║$(NC)"
	@echo "$(GREEN)╚══════════════════════════════════════════════════════════════╝$(NC)"

# ============================================================================
# Cleanup
# ============================================================================

# Clean build artifacts, cache, and coverage files
.PHONY: clean
clean:
	@echo "$(BLUE)Cleaning build artifacts and cache...$(NC)"
	rm -rf __pycache__
	rm -rf .pytest_cache
	rm -rf .ruff_cache
	rm -rf .mypy_cache
	rm -rf htmlcov
	rm -rf .coverage
	rm -rf dist
	rm -rf build
	rm -rf *.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	@echo "$(GREEN)✓ Cleanup complete$(NC)"

# Clean everything including virtual environment
.PHONY: clean-all
clean-all: clean
	@echo "$(BLUE)Removing virtual environment...$(NC)"
	rm -rf .venv venv
	rm -rf .uv
	@echo "$(GREEN)✓ Full cleanup complete$(NC)"

# ============================================================================
# Container Operations
# ============================================================================

# Build container image
.PHONY: container-build
container-build:
	@echo "$(BLUE)Building container image...$(NC)"
	docker build -f Containerfile -t python-template-soa:latest .
	@echo "$(GREEN)✓ Container image built: python-template-soa:latest$(NC)"

# Run container
.PHONY: container-run
container-run:
	@echo "$(BLUE)Running container...$(NC)"
	docker run --rm python-template-soa:latest

# ============================================================================
# Utility Targets
# ============================================================================

# Show project information
.PHONY: info
info:
	@echo "$(BLUE)Project Information:$(NC)"
	@echo "  Python version: $$($(PYTHON) --version)"
	@echo "  uv version: $$($(UV) --version)"
	@echo "  Project directory: $$(pwd)"
	@echo "  Source directory: $(SRC_DIR)"
	@echo "  Test directory: $(TEST_DIR)"

# Update dependencies to latest versions
.PHONY: update
update:
	@echo "$(BLUE)Updating dependencies...$(NC)"
	$(UV) lock --upgrade
	@echo "$(GREEN)✓ Dependencies updated$(NC)"

# Show outdated dependencies
.PHONY: outdated
outdated:
	@echo "$(BLUE)Checking for outdated dependencies...$(NC)"
	$(UV) pip list --outdated

# ============================================================================
# Changelog
# ============================================================================

# Generate changelog with git-cliff
.PHONY: changelog
changelog:
	@echo "$(BLUE)Generating changelog with git-cliff...$(NC)"
	@if command -v git-cliff >/dev/null 2>&1; then \
		git-cliff --output CHANGELOG.md; \
		echo "$(GREEN)✓ Changelog generated: CHANGELOG.md$(NC)"; \
	else \
		echo "$(RED)✗ git-cliff is not installed$(NC)"; \
		echo "$(YELLOW)  Install it from: https://github.com/orhun/git-cliff$(NC)"; \
		exit 1; \
	fi

# ============================================================================
# Notes
# ============================================================================
# - Targets marked with .PHONY don't correspond to actual files
# - Use 'make -n <target>' to see what commands would be run without executing
# - Customize colors and messages as needed for your team
# ============================================================================
