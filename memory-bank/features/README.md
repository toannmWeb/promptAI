# Features

> Optional folder. Tạo khi project có feature lớn cần doc riêng.

---

## Khi nào tạo `features/<name>.md`

- Feature có > 500 LOC across multi-module.
- Feature có business rule phức tạp (validation, workflow state machine).
- Feature cần handoff cho team member mới (onboarding aid).
- Feature có integration với external service.

## Cấu trúc

Copy từ `_template.md`. File chứa:

1. **Goal** — feature làm gì.
2. **User stories** — ai sử dụng, làm gì, để được gì.
3. **Acceptance criteria** — verifiable, Given/When/Then.
4. **Architecture** — module liên quan, data flow.
5. **API / Data model** — schema, endpoint.
6. **Edge cases** — corner case + error handling.
7. **Test strategy** — unit/integration/e2e coverage.
8. **Status** — Done / WIP / Planned.
9. **Related** — link đến PRPs, ADRs.

## Tên file

Format: `<feature-name>.md` (kebab-case).

Vd:
- `user-management.md`
- `photo-upload.md`
- `daily-log-entry.md`
- `offline-sync.md`
