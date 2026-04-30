# Runbook: Local Development Setup

> ⚠️ STACK-SPECIFIC — sửa theo stack project.
> Mục đích: dev mới setup môi trường trong < 30 phút.

---

## Prerequisites

<TODO — vd:
- OS: macOS 12+, Windows 10+, hoặc Linux
- Tools: Git, <Flutter SDK 3.16+ / Node.js 20+ / Python 3.11+ / ...>
- IDE: VS Code (recommended) hoặc <other>
- Optional: Docker (cho local DB)>

## Setup steps

### 1. Clone repo

```bash
git clone <repo-url>
cd <repo-name>
```

### 2. Install dependencies

```bash
<TODO — vd:
# Flutter
flutter pub get

# Node.js
npm install

# Python (uv)
uv sync

# Go
go mod download
>
```

### 3. Configure environment

```bash
cp .env.example .env
# Edit .env with your local values
```

Required env vars:
<TODO — vd:
- `API_BASE_URL` — vd `http://localhost:8080`
- `DATABASE_URL` — vd `postgres://localhost:5432/myapp`
- `<other>`>

### 4. Initialize database (if applicable)

```bash
<TODO — vd:
# Postgres
docker run -p 5432:5432 -e POSTGRES_PASSWORD=dev postgres:16

# Run migrations
<command>

# Seed data
<command>
>
```

### 5. Run dev server

```bash
<TODO — vd:
flutter run
# or
npm run dev
# or
python manage.py runserver
>
```

→ App chạy tại `<TODO — vd http://localhost:3000>`.

## Common commands

```bash
# Run tests
<TODO>

# Run lint
<TODO>

# Format code
<TODO>

# Build production
<TODO>

# Update dependencies
<TODO>
```

## Troubleshooting

### Issue: <TODO — common error>

<TODO — solution>

### Issue: <TODO>

<TODO>

## IDE setup

### VS Code (recommended)

Install extensions:
<TODO — vd:
- Dart-Code.flutter
- Dart-Code.dart-code
- esbenp.prettier-vscode
- dbaeumer.vscode-eslint>

Settings (`.vscode/settings.json` checked in):
<TODO — link to existing settings.json>

## Next steps

- Read `memory-bank/projectBrief.md` for project overview.
- Read `memory-bank/systemPatterns.md` for architecture.
- Check `memory-bank/activeContext.md` for current focus.
