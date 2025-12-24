# Docker Configuration Guide

This project uses Docker Compose with environment-specific override files following Docker best practices.

## File Structure

```
docker-compose.yml           # Base configuration (shared across all environments)
docker-compose.dev.yml       # Development overrides (hot-reload, debugging)
docker-compose.staging.yml   # Staging overrides (production-like testing)
docker-compose.prod.yml      # Production overrides (NGINX, optimized)
Dockerfile                   # Multi-stage build for all environments
.env.example                # Environment variables template
Makefile                    # Convenience commands
```

## Quick Start

### 1. Setup Environment

```bash
# Copy environment configuration
cp .env.example src/.env

# Edit src/.env with your settings
```

### 2. Choose Your Environment

```bash
# Development (recommended for local work)
make dev

# Staging (for testing before production)
make staging

# Production (with NGINX)
make prod
```

## Available Commands

| Command | Description |
|---------|-------------|
| `make dev` | Start development environment (hot-reload) |
| `make staging` | Start staging environment (production-like) |
| `make prod` | Start production environment (with NGINX) |
| `make down` | Stop all containers |
| `make clean` | Remove all containers, volumes, and images |
| `make init` | Initialize database (create superuser & tier) |
| `make test` | Run test suite |
| `make logs` | View container logs |
| `make db-shell` | Connect to PostgreSQL |
| `make redis-cli` | Connect to Redis |

## Environment Details

### Development (`docker-compose.dev.yml`)

**Purpose:** Local development with maximum convenience

**Features:**
- Uvicorn with auto-reload
- Source code mounted for hot-reload
- Debug-friendly settings
- Runs on port 8000
- Optional test and init services (via profiles)

**Usage:**
```bash
make dev
# Access: http://127.0.0.1:8000/docs
```

**Optional services:**
```bash
# Run with initialization (superuser + tier)
docker compose -f docker-compose.yml -f docker-compose.dev.yml --profile init up

# Run tests
docker compose -f docker-compose.yml -f docker-compose.dev.yml --profile test up pytest
```

### Staging (`docker-compose.staging.yml`)

**Purpose:** Pre-production testing and performance testing

**Features:**
- Gunicorn managing 4 Uvicorn workers
- Source code NOT mounted (uses image code)
- Production-like performance
- Runs on port 8000

**Usage:**
```bash
make staging
# Access: http://127.0.0.1:8000
```

**Important:**
- Change `SECRET_KEY` in `src/.env`
- Use production-like passwords

### Production (`docker-compose.prod.yml`)

**Purpose:** Production deployment

**Features:**
- NGINX reverse proxy
- Gunicorn + Uvicorn workers
- No source code volumes
- Automatic restart policies
- Runs on port 80
- HTTPS ready (uncomment SSL volumes)

**Usage:**
```bash
make prod
# Access: http://localhost
```

**Security Checklist:**
- [ ] Generate new `SECRET_KEY`: `openssl rand -hex 32`
- [ ] Change all passwords in `src/.env`
- [ ] Update `CORS_ORIGINS` to specific domains
- [ ] Set `ENVIRONMENT=production`
- [ ] Configure SSL certificates (optional)
- [ ] Review `CRUD_ADMIN_ALLOWED_IPS_LIST`

## Manual Docker Compose Usage

If you prefer not to use Makefile:

```bash
# Development
docker compose -f docker-compose.yml -f docker-compose.dev.yml up

# Staging
docker compose -f docker-compose.yml -f docker-compose.staging.yml up

# Production
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Stop
docker compose down
```

## Docker Profiles

Some services are optional and use Docker profiles:

```bash
# Initialize database (create superuser and tier)
docker compose -f docker-compose.yml -f docker-compose.dev.yml --profile init up

# Run tests
docker compose -f docker-compose.yml -f docker-compose.dev.yml --profile test up pytest --abort-on-container-exit
```

## Architecture

### Services

1. **web** - FastAPI application
   - Development: Uvicorn with reload
   - Production: Gunicorn + Uvicorn workers

2. **worker** - ARQ background task worker
   - Processes async jobs via Redis

3. **db** - PostgreSQL 13
   - Persistent data storage

4. **redis** - Redis Alpine
   - Cache, queue, and rate limiting

5. **nginx** (production only)
   - Reverse proxy
   - SSL/TLS termination

### Dockerfile

Multi-stage build:
1. **Builder stage**: Install dependencies with `uv`
2. **Final stage**: Minimal runtime with Python 3.11

Benefits:
- Small image size
- Fast builds (layer caching)
- Non-root user for security

## Migration from Old Structure

If you're upgrading from the old `scripts/` + `setup.py` structure:

**Old:**
```
scripts/local_with_uvicorn/
scripts/gunicorn_managing_uvicorn_workers/
scripts/production_with_nginx/
setup.py
```

**New:**
```
docker-compose.yml
docker-compose.dev.yml
docker-compose.staging.yml
docker-compose.prod.yml
Makefile
```

**Benefits:**
- Standard Docker Compose practices
- Configuration inheritance (DRY)
- No need to copy files
- Easier to maintain
- Better for CI/CD

## Troubleshooting

### Port already in use
```bash
# Find process using port 8000
lsof -ti:8000 | xargs kill -9

# Or change port in docker-compose.dev.yml
ports:
  - "8001:8000"
```

### Permission denied
```bash
# Fix file permissions
chmod +x Makefile

# Or run docker with sudo
sudo make dev
```

### Database connection error
```bash
# Check database is running
docker compose ps

# View database logs
docker compose logs db

# Reset database
make clean && make dev
```

### Hot-reload not working
```bash
# Ensure volumes are mounted correctly
docker compose -f docker-compose.yml -f docker-compose.dev.yml config | grep volumes
```

## Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Project Documentation](https://benavlabs.github.io/FastAPI-boilerplate/)
