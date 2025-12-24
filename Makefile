# FastAPI Boilerplate - Development Shortcuts
# ============================================================================
# Usage: make <target>
# ============================================================================

.PHONY: help dev staging prod down clean test init logs

# Default target
help:
	@echo "FastAPI Boilerplate - Available Commands"
	@echo "========================================"
	@echo ""
	@echo "Development:"
	@echo "  make dev          - Start in development mode (hot-reload enabled)"
	@echo "  make staging      - Start in staging mode (production-like)"
	@echo "  make prod         - Start in production mode (with NGINX)"
	@echo ""
	@echo "Management:"
	@echo "  make down         - Stop all containers"
	@echo "  make clean        - Stop and remove all containers, volumes, images"
	@echo "  make logs         - View logs from all containers"
	@echo ""
	@echo "Database:"
	@echo "  make init         - Initialize database (create superuser, tier)"
	@echo ""
	@echo "Testing:"
	@echo "  make test         - Run tests in isolated container"
	@echo ""

# Development environment (default)

dev:
	@echo "Starting development environment..."
	docker compose -f docker-compose.yml -f docker-compose.dev.yml up

# Staging environment

staging:
	@echo "Starting staging environment..."
	docker compose -f docker-compose.yml -f docker-compose.staging.yml up

# Production environment

prod:
	@echo "Starting production environment..."
	docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
	@echo "Production services started in background"
	@echo "   Access at: http://localhost"

# Stop all containers

down:
	@echo "Stopping all containers..."
	docker compose down

# Clean up everything

clean:
	@echo "Cleaning up all containers, volumes, and images..."
	docker compose -f docker-compose.yml -f docker-compose.dev.yml down -v --rmi local
	docker compose -f docker-compose.yml -f docker-compose.staging.yml down -v --rmi local
	docker compose -f docker-compose.yml -f docker-compose.prod.yml down -v --rmi local

# Initialize database (create superuser and tier)

init:
	@echo "Initializing database..."
	docker compose -f docker-compose.yml -f docker-compose.dev.yml --profile init up create_superuser create_tier
	@echo "Database initialized"

# Run tests

test:
	@echo "Running tests..."
	docker compose -f docker-compose.yml -f docker-compose.dev.yml --profile test up pytest --abort-on-container-exit
	@echo "Tests completed"

# View logs

logs:
	@echo "Viewing logs (Ctrl+C to exit)..."
	docker compose logs -f

# Development with detached mode

dev-d:
	@echo "Starting development environment (detached)..."
	docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
	@echo "Development services started in background"
	@echo "   Access at: http://127.0.0.1:8000/docs"

# Rebuild containers

rebuild:
	@echo "Rebuilding containers..."
	docker compose -f docker-compose.yml -f docker-compose.dev.yml build --no-cache

# Database shell

db-shell:
	@echo "Connecting to PostgreSQL..."
	docker compose exec db psql -U postgres -d postgres

# Redis CLI

redis-cli:
	@echo "Connecting to Redis..."
	docker compose exec redis redis-cli
