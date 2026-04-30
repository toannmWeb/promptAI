# Active Context

> File CẬP NHẬT NHIỀU NHẤT trong memory-bank.
> CẬP NHẬT: sau mỗi task có ý nghĩa (PR merged, feature done, decision made).
> Mục đích: AI biết NGAY "đang làm gì" mà không phải đọc git log.

---

## Current focus

<TODO — vd "Implementing user-management feature (PRP-003)" / "Refactoring 5 BLoCs to use new event pattern" / "Memory bank just initialized, awaiting first task".>

## Recent changes (last 7 days)

> Liệt kê 3-7 thay đổi gần nhất, mới nhất ở trên.

<TODO — vd:
- 2026-04-29: Initialized memory bank, mapped 5-tier architecture.
- 2026-04-28: Added go_router for navigation (ADR-0002).
- 2026-04-27: Migrated state management from Provider to flutter_bloc (ADR-0001).>

## Next steps (planned)

> 3-5 next actions. Specific, actionable.

<TODO — vd:
1. Create PRP-001 for "Photo upload with offline queue".
2. Add ADR for offline storage (IndexedDB vs Hive).
3. Document feature/photo-upload.md once spec ready.>

## Active decisions in progress

> Decisions chưa quyết, đang weighing options.

<TODO — vd:
- D-1: IndexedDB vs Hive cho offline storage. Pros/cons in `docs/adr/draft-0003-offline-storage.md`. Awaiting team input.
- D-2: Whether to support landscape mode on tablets. Product team to decide.>

## Open questions

> Câu hỏi chưa có câu trả lời.

<TODO — vd:
- Q-1: Maximum offline queue size?
- Q-2: Sync conflict resolution strategy (LWW vs CRDT)?>

## Blocked items

> Việc đang block, chờ external action.

<TODO — vd:
- B-1: Awaiting design mockups for v2 dashboard (UX team).
- B-2: API endpoint /api/v2/sites not deployed yet (backend team).>

## Key insights / learnings

> Điều quan trọng nhận ra gần đây mà các session sau cần biết.

<TODO — vd:
- BLoC events should be past-tense (UserCreated) not imperative (CreateUser) — chuẩn Cline community.
- Repository layer KHÔNG nên catch exception, để bubble lên usecase. Chỉ usecase decide retry/fallback.>

---

**Confidence**: <TODO>
**Last updated**: <YYYY-MM-DD>
