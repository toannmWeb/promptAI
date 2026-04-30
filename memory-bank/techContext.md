# Tech Context

> Tech stack, setup, dependencies, constraints.
> CẬP NHẬT: khi đổi stack/dep major version hoặc add/remove framework.

---

## Stack

| Layer | Technology | Version | Why this choice |
|---|---|---|---|
| Language | <TODO — vd Dart> | <TODO — vd 3.5+> | <TODO> |
| Framework | <TODO — vd Flutter> | <TODO> | <TODO> |
| State management | <TODO — vd flutter_bloc> | <TODO> | <TODO> |
| Routing | <TODO> | <TODO> | <TODO> |
| HTTP client | <TODO> | <TODO> | <TODO> |
| Storage | <TODO> | <TODO> | <TODO> |
| DI | <TODO> | <TODO> | <TODO> |
| Test | <TODO> | <TODO> | <TODO> |
| Lint/format | <TODO> | <TODO> | <TODO> |

## Key dependencies

> Top 5-10 packages quan trọng nhất.

<TODO — vd:
```
flutter_bloc: ^8.1.0       — state management
go_router: ^13.0.0         — routing  
get_it: ^7.6.0             — service locator
dio: ^5.0.0                — HTTP client
hive: ^2.2.0               — local storage
```
>

## Setup commands

```bash
# <TODO — chỉnh cho stack project>

# Install dependencies
<TODO — vd: flutter pub get / npm install / pip install -r requirements.txt>

# Run dev
<TODO — vd: flutter run / npm run dev / python manage.py runserver>

# Test
<TODO — vd: flutter test / npm test / pytest>

# Lint
<TODO — vd: flutter analyze / npm run lint / ruff check .>

# Build production
<TODO — vd: flutter build web / npm run build / ...>
```

## Environment

<TODO — vd:
- Required: Flutter 3.16+, Dart 3.5+
- Optional: Firebase CLI cho deploy
- IDE: VS Code (recommended) hoặc Android Studio
- OS: macOS 12+, Windows 10+, Linux>

## Configuration

> Env variables, config files.

<TODO — vd:
- `.env` — local secrets (gitignored)
- `lib/config/dev.dart` — dev config
- `lib/config/prod.dart` — prod config

Required env vars:
- `API_BASE_URL`
- `SENTRY_DSN`
- `FIREBASE_API_KEY`>

## Constraints

> Giới hạn kỹ thuật phải tuân thủ.

<TODO — vd:
- Browser support: Chrome 90+, Safari 14+, Firefox 88+ (no IE).
- Bundle size: < 2 MB gzip per page.
- Offline: must work without network for read operations.
- Memory: target 60 fps on mid-range Android.>

## Known issues / quirks

> Bugs, workarounds, gotchas đặc thù stack.

<TODO — vd:
- flutter_bloc v8 có breaking change với `BlocListener` — cần `listenWhen`.
- go_router shellRoute hoạt động khác với nested navigation thông thường.
- Hive box phải mở trước khi access, throws error nếu chưa init.>

## Build / Deploy

<TODO — vd:
- CI: GitHub Actions, file `.github/workflows/ci.yml`.
- CD: Firebase Hosting, manual trigger.
- Staging URL: <url>
- Production URL: <url>>

---

**Confidence**: <TODO>
**Last updated**: <YYYY-MM-DD>
