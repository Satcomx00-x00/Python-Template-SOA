# ============================================================================
# Containerfile - General Purpose Python Application
# ============================================================================
# This is the default Containerfile for general-purpose Python applications
# For specific use cases, see:
#   - Containerfile.webapp - Web applications with HTTP servers
#   - Containerfile.algo - CPU-intensive algorithmic/computational tasks
#
# Build: docker build -f Containerfile -t python-template .
# Run:   docker run python-template
# ============================================================================

# Use official Python slim image as base
# Slim variant is smaller and contains only essential packages
FROM python:3.13-slim

# Set environment variables
# PYTHONUNBUFFERED: Prevents Python from buffering stdout/stderr (better for container logs)
# PYTHONDONTWRITEBYTECODE: Prevents Python from writing .pyc files
# UV_SYSTEM_PYTHON: Allow uv to use system Python in container
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_SYSTEM_PYTHON=1

# Set working directory inside container
WORKDIR /app

# Install uv - fast Python package installer
# Using the official installation script from astral.sh
# The script installs uv to /root/.cargo/bin/uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Copy dependency files first (for layer caching)
# Docker caches layers, so if dependencies don't change, this layer is reused
COPY pyproject.toml ./

# Install dependencies using uv
# --no-dev: Don't install development dependencies (smaller image)
# --frozen: Use exact versions from uv.lock (if it exists)
# Note: For production, you may want to generate uv.lock first
RUN uv pip install --system -r pyproject.toml

# Copy the application source code
# This is done after dependency installation to leverage Docker layer caching
COPY src/ ./src/

# Copy any additional files needed at runtime
# COPY config/ ./config/

# Create a non-root user for security
# Running as non-root is a security best practice
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port if your application serves HTTP traffic
# EXPOSE 8000

# Health check (optional) - adjust the command for your application
# HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
#   CMD python -c "import sys; sys.exit(0)"

# Default command to run when container starts
# Adjust this to your application's entry point
CMD ["python", "-m", "python_template.main"]

# ============================================================================
# Multi-stage Build Example (Optional)
# ============================================================================
# For production, you may want a multi-stage build to have smaller images:
#
# # Stage 1: Builder
# FROM python:3.11-slim AS builder
# COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
# WORKDIR /app
# COPY pyproject.toml ./
# RUN uv pip install --system -r pyproject.toml
#
# # Stage 2: Runtime
# FROM python:3.11-slim
# WORKDIR /app
# COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
# COPY src/ ./src/
# RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
# USER appuser
# CMD ["python", "-m", "python_template.main"]
# ============================================================================
