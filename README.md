<h1 align="center"> Benav Labs FastAPI boilerplate</h1>
<p align="center" markdown=1>
  <i><b>Batteries-included FastAPI starter</b> with production-ready defaults, optional modules, and clear docs.</i>
</p>

<p align="center">
  <a href="https://benavlabs.github.io/FastAPI-boilerplate">
    <img src="docs/assets/FastAPI-boilerplate.png" alt="Purple Rocket with FastAPI Logo as its window." width="25%" height="auto">
  </a>
</p>

<p align="center">
📚 <a href="https://benavlabs.github.io/FastAPI-boilerplate/">Docs</a> · 🧠 <a href="https://deepwiki.com/benavlabs/FastAPI-boilerplate">DeepWiki</a> · 💬 <a href="https://discord.com/invite/TEmPs22gqB">Discord</a>
</p>

<p align="center">
  <a href="https://fastapi.tiangolo.com">
      <img src="https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi" alt="FastAPI">
  </a>
  <a href="https://www.postgresql.org">
      <img src="https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
  </a>
  <a href="https://redis.io">
      <img src="https://img.shields.io/badge/Redis-DC382D?logo=redis&logoColor=fff&style=for-the-badge" alt="Redis">
  </a>
  <a href="https://deepwiki.com/benavlabs/FastAPI-boilerplate">
      <img src="https://img.shields.io/badge/DeepWiki-1F2937?style=for-the-badge&logoColor=white" alt="DeepWiki">
  </a>
</p>

## Features

* ⚡️ Fully async FastAPI + SQLAlchemy 2.0
* 🧱 Pydantic v2 models & validation
* 🔐 JWT auth (access + refresh), cookies for refresh
* 👮 Rate limiter + tiers (free/pro/etc.)
* 🧰 FastCRUD for efficient CRUD & pagination
* 🧑‍💼 **CRUDAdmin**: minimal admin panel (optional)
* 🚦 ARQ background jobs (Redis)
* 🧊 Redis caching (server + client-side headers)
* 🌐 Configurable CORS middleware for frontend integration
* 🐳 One-command Docker Compose
* 🚀 NGINX & Gunicorn recipes for prod

## Why and When to use it

**Perfect if you want:**

* A pragmatic starter with auth, CRUD, jobs, caching and rate-limits
* **Sensible defaults** with the freedom to opt-out of modules
* **Docs over boilerplate** in README - depth lives in the site

> **Not a fit** if you need a monorepo microservices scaffold - [see the docs](https://benavlabs.github.io/FastAPI-boilerplate/user-guide/project-structure/) for pointers.

**What you get:**

* **App**: FastAPI app factory, [env-aware docs](https://benavlabs.github.io/FastAPI-boilerplate/user-guide/development/) exposure
* **Auth**: [JWT access/refresh](https://benavlabs.github.io/FastAPI-boilerplate/user-guide/authentication/), logout via token blacklist
* **DB**: Postgres + SQLAlchemy 2.0, [Alembic migrations](https://benavlabs.github.io/FastAPI-boilerplate/user-guide/database/)
* **CRUD**: [FastCRUD generics](https://benavlabs.github.io/FastAPI-boilerplate/user-guide/database/crud/) (get, get_multi, create, update, delete, joins)
* **Caching**: [decorator-based endpoints cache](https://benavlabs.github.io/FastAPI-boilerplate/user-guide/caching/); client cache headers
* **Queues**: [ARQ worker](https://benavlabs.github.io/FastAPI-boilerplate/user-guide/background-tasks/) (async jobs), Redis connection helpers
* **Rate limits**: [per-tier + per-path rules](https://benavlabs.github.io/FastAPI-boilerplate/user-guide/rate-limiting/)
* **Admin**: [CRUDAdmin views](https://benavlabs.github.io/FastAPI-boilerplate/user-guide/admin-panel/) for common models (optional)

This is what we've been using in production apps. Several applications running in production started from this boilerplate as their foundation - from SaaS platforms to internal tools. It's proven, stable technology that works together reliably. Use this as the foundation for whatever you want to build on top.

> **Building an AI SaaS?** Skip even more setup with [**FastroAI**](https://fastro.ai) - our production-ready template with AI integration, payments, and frontend included.

## TL;DR - Quickstart

Use the template on GitHub, create your repo, then:

```bash
git clone https://github.com/<you>/FastAPI-boilerplate
cd FastAPI-boilerplate
```

### 🚀 Quick Start (Development)

```bash
# Copy environment configuration
cp .env.example src/.env

# Start development environment with hot-reload
make dev
```

**Access your app:**
- API: http://127.0.0.1:8000
- API Docs: http://127.0.0.1:8000/docs
- Admin Panel: http://127.0.0.1:8000/admin

### 🧑‍💻 Develop with VS Code DevContainer

You can open this project in a VS Code DevContainer to get a reproducible developer environment with the app and services started automatically.

1. Install the "Remote - Containers" extension in VS Code.
2. Open the repository in VS Code and choose "Reopen in Container" when prompted.

What the DevContainer does:
- Uses the project's development compose (`docker-compose.dev.yml`) and attaches to the `web` service
- Copies `.env.example` to `src/.env` on creation (no secrets are provided)
- Installs project dependencies via `uv sync` if available
- Forwards ports 8000 (web), 5432 (Postgres), and 6379 (Redis)

You can then run `make dev` (inside or outside the container) or use the Docker Compose commands described above.

### 📋 Available Commands

```bash
make dev       # Development mode (Uvicorn with hot-reload)
make staging   # Staging mode (Gunicorn + Uvicorn workers)
make prod      # Production mode (with NGINX reverse proxy)
make down      # Stop all containers
make test      # Run tests
make init      # Initialize database (create superuser & tier)
make logs      # View container logs
```

### 🔧 Environment-Specific Setup

#### Development (Default)
**Best for:** Local development and testing

```bash
make dev
# or
docker compose -f docker-compose.yml -f docker-compose.dev.yml up
```

**Features:**
- Uvicorn with auto-reload
- Source code mounted for hot-reload
- Runs on port 8000

#### Staging
**Best for:** Pre-production testing and load testing

```bash
make staging
# or
docker compose -f docker-compose.yml -f docker-compose.staging.yml up
```

**Features:**
- Gunicorn managing multiple Uvicorn workers
- Production-like performance
- Source code not mounted (uses image code)

> [!WARNING]
> Change `SECRET_KEY` and passwords in `src/.env` for staging environments.

#### Production
**Best for:** Production deployments

```bash
make prod
# or
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

**Features:**
- NGINX reverse proxy
- Gunicorn + Uvicorn workers
- Runs on port 80
- Automatic restart policies

> [!CAUTION]
> You MUST change `SECRET_KEY`, all passwords, and sensitive values in `src/.env` before deploying!
> Generate new secret key: `openssl rand -hex 32`


### 🎯 Next Steps

**Initialize database with superuser and tier:**
```bash
make init
```

**Run tests:**
```bash
make test
```

**Run database migrations** (when you add/modify models):
```bash
cd src && uv run alembic revision --autogenerate && uv run alembic upgrade head
```

**Test background jobs:**
```bash
curl -X POST 'http://127.0.0.1:8000/api/v1/tasks/task?message=hello'
```

**Run locally without Docker:**
```bash
uv sync && uv run uvicorn src.app.main:app --reload
```

> Full documentation: [https://benavlabs.github.io/FastAPI-boilerplate/](https://benavlabs.github.io/FastAPI-boilerplate/)

---

## Configuration

The boilerplate uses environment variables for configuration. See `.env.example` for all available options.

**Key settings to configure:**

```bash
# Application
APP_NAME="My FastAPI App"
ENVIRONMENT="local"  # local, staging, production

# Database
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="changeme123"
POSTGRES_DB="postgres"

# Security (REQUIRED for production)
SECRET_KEY="generate-with-openssl-rand-hex-32"
ACCESS_TOKEN_EXPIRE_MINUTES=60

# Admin
ADMIN_USERNAME="admin"
ADMIN_PASSWORD="!Ch4ng3Th1sP4ssW0rd!"
```

Full configuration guide: [https://benavlabs.github.io/FastAPI-boilerplate/getting-started/configuration/](https://benavlabs.github.io/FastAPI-boilerplate/getting-started/configuration/)

---

## Project Structure

```
FastAPI-boilerplate/
├── docker-compose.yml          # Base configuration
├── docker-compose.dev.yml      # Development overrides
├── docker-compose.staging.yml  # Staging overrides
├── docker-compose.prod.yml     # Production overrides
├── Dockerfile                  # Multi-stage build
├── Makefile                    # Convenience commands
├── .env.example               # Environment variables template
├── src/
│   ├── app/
│   │   ├── main.py            # FastAPI application
│   │   ├── api/               # API routes
│   │   ├── core/              # Config, security, DB
│   │   ├── crud/              # Database operations
│   │   ├── models/            # SQLAlchemy models
│   │   ├── schemas/           # Pydantic schemas
│   │   └── admin/             # Admin panel (optional)
│   └── migrations/            # Alembic migrations
└── tests/                     # Test suite
```

More details: [https://benavlabs.github.io/FastAPI-boilerplate/user-guide/project-structure/](https://benavlabs.github.io/FastAPI-boilerplate/user-guide/project-structure/)

---

## Common Tasks

```bash
# Development
make dev              # Start dev environment
make logs             # View logs
make down             # Stop containers

# Database
make init             # Create superuser and tier
make db-shell         # PostgreSQL shell
cd src && uv run alembic revision --autogenerate  # Create migration
cd src && uv run alembic upgrade head              # Apply migrations

# Testing
make test             # Run test suite

# Production
make prod             # Deploy with NGINX
```

More examples: [https://benavlabs.github.io/FastAPI-boilerplate/getting-started/first-run/](https://benavlabs.github.io/FastAPI-boilerplate/getting-started/first-run/)

## Contributing

Read [contributing](CONTRIBUTING.md).

## References

This project was inspired by a few projects, it's based on them with things changed to the way I like (and pydantic, sqlalchemy updated)

- [`Full Stack FastAPI and PostgreSQL`](https://github.com/tiangolo/full-stack-fastapi-postgresql) by @tiangolo himself
- [`FastAPI Microservices`](https://github.com/Kludex/fastapi-microservices) by @kludex which heavily inspired this boilerplate
- [`Async Web API with FastAPI + SQLAlchemy 2.0`](https://github.com/rhoboro/async-fastapi-sqlalchemy) for sqlalchemy 2.0 ORM examples
- [`FastaAPI Rocket Boilerplate`](https://github.com/asacristani/fastapi-rocket-boilerplate/tree/main) for docker compose

## License

[`MIT`](LICENSE.md)

## Contact

Benav Labs – [benav.io](https://benav.io), [discord server](https://discord.com/invite/TEmPs22gqB)

<hr>
<a href="https://benav.io">
  <img src="https://github.com/benavlabs/fastcrud/raw/main/docs/assets/benav_labs_banner.png" alt="Powered by Benav Labs - benav.io"/>
</a>
