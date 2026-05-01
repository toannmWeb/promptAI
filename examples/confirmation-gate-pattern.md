# Pattern: Confirmation Gate

> Last updated: 2026-04-30

---

## What

Pattern gom TẤT CẢ câu hỏi cần user xác nhận vào **1 block duy nhất** cuối response, kèm recommended default và reply format tối giản. Giảm số lượt chat trong IDE từ N câu hỏi → 1 lượt reply.

## When to use

- Task có ≥ 2 decision points cần user input.
- Bulk edit > 3 file (bắt buộc theo Rule 18).
- Destructive operation cần explicit consent.
- Ambiguous spec có nhiều cách interpret.

## When NOT to use

- Task trivial không có decision point (vd: fix typo).
- User đã chỉ rõ 100% spec — không còn gì phải hỏi.
- Analysis-only mode — chỉ output, không sửa.

## Code template

```markdown
## Confirmation Gate

Trước khi proceed, xin xác nhận:

| # | Decision | Options | Recommended |
|---|---|---|---|
| D-1 | <quyết định 1> | A: <option A> / B: <option B> | **A** — <lý do> |
| D-2 | <quyết định 2> | A: <option A> / B: <option B> / C: <option C> | **B** — <lý do> |
| D-3 | <quyết định 3> | A: <option A> / B: <option B> | **A** — <lý do> |

**Reply format**:
- `OK` → dùng tất cả recommended defaults.
- `D-1=B D-3=B` → override chỉ D-1 và D-3, còn lại dùng default.
- `OK except #2` → OK trừ D-2, giữ recommended cho D-1 và D-3.
- `STOP` → hủy toàn bộ, không proceed.
```

## Real example from codebase

- `.prompts/snippets/confirmation-gate.md` — snippet definition gốc, paste vào cuối prompt.
- `.prompts/snippets/dry-run.md:25-30` — dry-run output kết thúc bằng Confirmation Gate.
- `.prompts/workflows/refactor-safe.md:37` — Phase 1 Charter kết thúc bằng "User confirm Charter".
- `.prompts/workflows/feature-end-to-end.md:40` — mỗi phase kết thúc bằng user confirm.

## Gotchas

- **Đừng gom quá 5 decisions** trong 1 gate — user sẽ overwhelm. Nếu > 5, chia thành 2 phases.
- **Luôn có recommended default** — user không nên phải research mới trả lời được.
- **STOP phải là option hợp lệ** — user luôn có quyền hủy.
- **Nếu thuộc nhóm Destructive (Rule 18-19)**: sau OK vẫn cần rollback plan trước khi thực thi.

## Variations

### Variation 1: Inline Confirmation (cho 1 decision point)

Khi chỉ có 1 quyết định, không cần table:

```markdown
**Decision point**: <mô tả>
- Option A: <...> (recommended — <lý do>)
- Option B: <...>

Reply `OK` hoặc `D-1=B`.
```

### Variation 2: Progressive Confirmation (cho multi-phase workflow)

Mỗi phase kết thúc bằng mini-gate:

```markdown
Phase 1 done. Reply:
- ✅ "OK Phase 1, next" → continue Phase 2.
- 🔁 "Wait, refine <X>" → loop lại Phase 1.
- ⏹ "Stop" → save state, dừng.
```

## Related

- ADR: [0001-prompt-library-architecture.md](../docs/adr/0001-prompt-library-architecture.md) — architecture decision cho composable prompt system.
- Snippet source: [.prompts/snippets/confirmation-gate.md](../.prompts/snippets/confirmation-gate.md)
- Rule references: Rule 16 (Confirmation Gate), Rule 18 (Dry-run before bulk edit), Rule 19 (Rollback plan bắt buộc) trong `.prompts/system/base.md`.
