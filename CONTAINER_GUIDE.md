# Container Guide - Multiple Containerfiles

This project includes **4 different Containerfiles** optimized for different use cases. This guide explains when to use each one and how to customize them.

## 📦 Available Containerfiles

| Containerfile | Purpose | Base Image | Size | Use When |
|--------------|---------|------------|------|----------|
| `Containerfile` | General purpose | python:3.13-slim | ~200MB | Standard Python apps |
| `Containerfile.webapp` | Web applications | python:3.13-slim | ~250MB | Flask, FastAPI, Django apps |
| `Containerfile.algo` | Computational tasks | python:3.13 | ~400MB | Data processing, algorithms |
| `Containerfile.cli` | CLI tools | python:3.13-alpine | ~100MB | Command-line utilities |

## 1️⃣ Containerfile (General Purpose)

**Best for:** Standard Python applications, microservices, background workers

### Features
- ✅ Balanced size and functionality
- ✅ Secure (non-root user)
- ✅ Fast builds with uv
- ✅ Production-ready

### Build and Run
```bash
# Using Make
make container-build
make container-run

# Using Docker directly
docker build -f Containerfile -t my-app .
docker run my-app
```

### Customization
```dockerfile
# Add runtime dependencies (line 33)
dependencies = [
    "requests>=2.31.0",
]

# Change the entry point (line 71)
CMD ["python", "-m", "your_module.main"]
```

## 2️⃣ Containerfile.webapp (Web Applications)

**Best for:** HTTP servers, REST APIs, web dashboards

### Features
- 🌐 Pre-configured for web frameworks
- 🏥 Health check included
- 🔌 Port 8000 exposed by default
- 📈 Gunicorn/Uvicorn included

### Build and Run
```bash
# Using Make
make container-build-webapp
make container-run-webapp  # Runs on http://localhost:8000

# Using Docker directly
docker build -f Containerfile.webapp -t my-webapp .
docker run -p 8000:8000 my-webapp
```

### Customization Examples

#### For FastAPI Application
```dockerfile
# Modify CMD (line 66)
CMD ["uvicorn", "python_template.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
```

#### For Flask Application
```dockerfile
# Modify CMD (line 66)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "python_template.main:app"]
```

#### For Django Application
```dockerfile
# Modify CMD (line 66)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "myproject.wsgi:application"]
```

#### Custom Port
```dockerfile
# Change ENV (line 18)
ENV PORT=3000

# Update EXPOSE (line 48)
EXPOSE 3000

# Update CMD (line 66)
CMD ["uvicorn", "python_template.main:app", "--host", "0.0.0.0", "--port", "3000"]
```

### Production Deployment
```bash
# Run with custom settings
docker run -d \
  -p 80:8000 \
  -e DATABASE_URL=postgres://... \
  -e SECRET_KEY=... \
  --name my-webapp \
  my-webapp:latest

# With Docker Compose
cat > docker-compose.yml << EOF
version: '3.8'
services:
  web:
    build:
      context: .
      dockerfile: Containerfile.webapp
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgres://db:5432/myapp
    depends_on:
      - db
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: myapp
      POSTGRES_PASSWORD: secret
EOF

docker-compose up
```

## 3️⃣ Containerfile.algo (Algorithmic/Computational)

**Best for:** Data processing, machine learning, scientific computing, batch jobs

### Features
- 🧮 Optimized for CPU-intensive tasks
- 📊 Scientific computing libraries support
- 💪 Build tools included (gcc, gfortran)
- 🔢 Reproducible results (PYTHONHASHSEED=0)

### Build and Run
```bash
# Using Make
make container-build-algo
make container-run-algo

# Using Docker directly
docker build -f Containerfile.algo -t my-algo .
docker run my-algo
```

### Customization Examples

#### Add Scientific Libraries
```dockerfile
# Modify RUN command (line 52)
RUN uv pip install --system -r pyproject.toml && \
    uv pip install --system numpy scipy pandas matplotlib scikit-learn
```

#### Process Data Files
```bash
# Mount input/output directories
docker run \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/results:/app/results \
  my-algo python -m python_template.process --input /app/data --output /app/results
```

#### Optimize for Performance
```bash
# Set CPU and memory limits
docker run \
  --cpus="8.0" \
  --memory="16g" \
  -e OMP_NUM_THREADS=8 \
  -e OPENBLAS_NUM_THREADS=8 \
  my-algo
```

#### Run with GPU Support (NVIDIA)
```bash
# Build with GPU support
docker run --gpus all my-algo

# Or in Dockerfile, use nvidia/cuda base image
FROM nvidia/cuda:11.8.0-base-ubuntu22.04
```

## 4️⃣ Containerfile.cli (Command-Line Tool)

**Best for:** CLI utilities, one-off scripts, minimal deployments

### Features
- 🪶 Smallest image size (~100MB)
- ⚡ Fast startup time
- 🎯 ENTRYPOINT configured for easy CLI usage
- 🐧 Alpine Linux based

### Build and Run
```bash
# Using Make
make container-build-cli

# Run with arguments
docker run python-template-soa:cli greet "Alice"
docker run python-template-soa:cli add 10 5
```

### Customization Examples

#### Create Shell Alias
```bash
# Add to ~/.bashrc or ~/.zshrc
alias python-cli='docker run --rm python-template-soa:cli'

# Usage
python-cli greet "World"
python-cli --help
```

#### Pass Files
```bash
# Read from file
docker run -v $(pwd)/input.txt:/app/input.txt \
  python-template-soa:cli process --input /app/input.txt

# Write to file
docker run -v $(pwd)/output:/app/output \
  python-template-soa:cli generate --output /app/output/result.txt
```

#### Interactive Mode
```bash
# Run bash shell inside container
docker run -it python-template-soa:cli /bin/sh
```

## 🔧 Common Customizations

### Change Python Version
```dockerfile
# Replace line 13 in any Containerfile
FROM python:3.12-slim  # or 3.11-slim, 3.10-slim, etc.
```

### Add System Dependencies
```dockerfile
# For Debian/Ubuntu based (general, webapp, algo)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# For Alpine based (cli)
RUN apk add --no-cache git curl
```

### Use Multi-Stage Build (Reduce Size)
```dockerfile
# Stage 1: Builder
FROM python:3.13-slim AS builder
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
WORKDIR /app
COPY pyproject.toml ./
RUN uv pip install --system -r pyproject.toml

# Stage 2: Runtime
FROM python:3.13-slim
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.13/site-packages /usr/local/lib/python3.13/site-packages
COPY src/ ./src/
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser
CMD ["python", "-m", "python_template.main"]
```

## 🚀 Best Practices

### 1. Layer Caching
Copy dependency files before source code to maximize cache hits:
```dockerfile
COPY pyproject.toml ./
RUN uv pip install --system -r pyproject.toml
COPY src/ ./src/  # This layer changes frequently
```

### 2. Security
Always run as non-root user:
```dockerfile
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser
```

### 3. Image Size
- Use `.dockerignore` to exclude unnecessary files
- Clean up after package installation
- Use multi-stage builds for production

### 4. Environment Variables
```dockerfile
# Development
ENV DEBUG=True LOG_LEVEL=DEBUG

# Production
ENV DEBUG=False LOG_LEVEL=WARNING WORKERS=4
```

## 📊 Size Comparison

After building all variants:
```bash
make container-build-all
docker images | grep python-template-soa

# Typical sizes:
# cli     ~100MB (smallest)
# latest  ~200MB
# webapp  ~250MB
# algo    ~400MB (largest, includes scientific libs)
```

## 🎯 Quick Decision Guide

Choose your Containerfile based on:

```
┌─────────────────────────────────────────────┐
│ Need smallest image?                        │
│ → Use Containerfile.cli                     │
├─────────────────────────────────────────────┤
│ Building a web app/API?                     │
│ → Use Containerfile.webapp                  │
├─────────────────────────────────────────────┤
│ Doing data processing/ML?                   │
│ → Use Containerfile.algo                    │
├─────────────────────────────────────────────┤
│ General Python application?                 │
│ → Use Containerfile (default)               │
└─────────────────────────────────────────────┘
```

## 📚 Additional Resources

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [uv Documentation](https://github.com/astral-sh/uv)
- [Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [Docker Compose](https://docs.docker.com/compose/)
