# Use the official UV image as base
FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy UV project files first for better caching
COPY pyproject.toml uv.lock ./

# Install dependencies using UV
RUN uv sync --frozen --no-cache

# Copy the source code
COPY src/ ./src/

# Create a non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Create and set permissions for UV cache directory
RUN mkdir -p /home/appuser/.cache/uv && \
    chown -R appuser:appuser /home/appuser && \
    chown -R appuser:appuser /app

USER appuser

# Expose the port that FastAPI will run on
EXPOSE 8000

# Health check to ensure the app is running
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Use UV to run the FastAPI application
CMD ["uv", "run", "uvicorn", "src.api:app", "--host", "0.0.0.0", "--port", "8000"]
