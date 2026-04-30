# Progress

> Cái gì done, còn lại gì, known issues.
> CẬP NHẬT: khi feature done/start, milestone hit, hoặc issue discovered.

---

## What works

> Liệt kê features đã hoàn thành + verified.

<TODO — vd:
- [x] User authentication (email/password) — verified by manual test + integration test.
- [x] Photo upload (single) — verified.
- [ ] Photo upload (batch) — partial, needs batch endpoint.>

## What's in progress

> Đang làm dở.

<TODO — vd:
- [WIP] Daily log entry form — UI done, BLoC integration in PRP-002.
- [WIP] Offline sync — design phase, ADR-0003 draft.>

## What's left to build

> Backlog có structure (priority).

### High priority

<TODO — vd:
- [ ] Site management (CRUD).
- [ ] Photo annotations.>

### Medium priority

<TODO — vd:
- [ ] Reports export (PDF).
- [ ] Multi-language (JA/VI).>

### Low priority / future

<TODO — vd:
- [ ] Voice memo upload.
- [ ] Push notifications.>

## Current status

| Metric | Status |
|---|---|
| Test coverage | <TODO — vd "Unit: 65%, Integration: 30%, E2E: 0%"> |
| Lint clean | <TODO — vd "✅ pass"> |
| CI passing | <TODO — vd "✅ all green"> |
| Production deployed | <TODO — vd "Yes, v1.2.3 since 2026-04-15"> |

## Known issues

> Bugs đã biết nhưng chưa fix.

<TODO — vd:
- BUG-1: Login button bị disable sai khi back from forgot-password page. Workaround: refresh.
- BUG-2: Image upload fail silently nếu file > 10MB. TODO: thêm size validation.>

## Deferred decisions

> Quyết định cố tình postpone.

<TODO — vd:
- Multi-tenancy: defer Q4 (currently single-org).
- Native mobile app: defer 2027.>

## Recently completed milestones

<TODO — vd:
- 2026-04-15: v1.2.0 released (offline mode).
- 2026-03-30: MVP launched (5 pilot sites).
- 2026-02-15: Architecture decision — switched to flutter_bloc.>

## Blockers (escalated)

> Items escalated to leadership/external.

<TODO — vd:
- Upgrade backend API to v2 — awaiting backend team Q3.>

---

**Confidence**: <TODO>
**Last updated**: <YYYY-MM-DD>
