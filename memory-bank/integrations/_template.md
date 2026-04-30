# Integration: <SERVICE_NAME>

> Status: <Active / Deprecated / Planned>
> Last updated: <YYYY-MM-DD>

---

## Overview

**Service**: <TODO — vd "Firebase Authentication">
**URL**: <TODO — vd "https://firebase.google.com/docs/auth">
**Why**: <TODO — vd "Reuse Google account, free tier sufficient for < 50K MAU">
**Status**: <Active / Deprecated>

## Auth method

<TODO — vd:
- Type: API key + OAuth2
- Where stored: Firebase config in `lib/config/firebase_options.dart` (auto-generated, gitignored variant in `.env`)
- Rotation: <TODO>>

## Endpoints / SDK methods used

| Method | When called | File reference |
|---|---|---|
| <TODO — vd "signInWithEmailAndPassword"> | <vd "User login screen"> | <vd "lib/data/services/auth_service.dart:45"> |
| <TODO> | <TODO> | <TODO> |

## Rate limits

<TODO — vd:
- 100 requests/sec per IP
- 10K MAU on free tier
- 1M auth verifications/month free>

## Fallback strategy

> Khi service unavailable / quota exceeded.

<TODO — vd:
- Show cached user data (if logged in already).
- Block new logins, show "Service temporarily unavailable, please retry".
- Log to Sentry.>

## Cost

<TODO — vd:
- Free tier: 10K MAU
- Beyond: $0.01 per MAU
- Current usage: <TODO>>

## Account info

<TODO — vd:
- Sandbox: <project-id>
- Production: <project-id>
- Admin contact: <name@email>
- Console: <url>>

## Common issues / gotchas

<TODO — vd:
- iOS-specific: must enable Apple Sign In separately.
- Token refresh fails silently if user logged out remotely. Workaround: catch and re-prompt login.>

## Code references

<TODO — vd:
- Service: `lib/data/services/auth_service.dart`
- Repository: `lib/data/repositories/user_repository_impl.dart:14-40`
- BLoC: `lib/presentation/blocs/auth/auth_bloc.dart`>

## Related

- ADR: <TODO — vd "../docs/adr/0001-firebase-auth.md">
- Feature: <TODO — vd "../features/user-management.md">
