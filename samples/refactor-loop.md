---
name: sample-refactor-loop
purpose: Refactor + tính năng mới với vòng lặp Plan→Implement→Test→Verify, mỗi iteration confirm user
input: scope + mục tiêu refactor + tính năng mới (nếu có)
output: code đã sửa, test pass, build pass, mỗi iteration có Confirmation Gate
version: 1.0
last-updated: 2026-04-30
---

# Sample: Refactor Loop

## Khi nào dùng

- Refactor module có rủi ro (đổi structure, tách class, gộp function).
- Refactor + thêm tính năng mới cùng lúc.
- Cần kiểm soát chặt từng bước, không muốn AI sửa ồ ạt.

## Reference

- Workflow: [.prompts/workflows/refactor-safe.md](../.prompts/workflows/refactor-safe.md), [.prompts/workflows/feature-end-to-end.md](../.prompts/workflows/feature-end-to-end.md)
- Snippet bắt buộc: [.prompts/snippets/dry-run.md](../.prompts/snippets/dry-run.md), [.prompts/snippets/rollback-plan.md](../.prompts/snippets/rollback-plan.md), [.prompts/snippets/confirmation-gate.md](../.prompts/snippets/confirmation-gate.md), [.prompts/snippets/self-verify.md](../.prompts/snippets/self-verify.md)

## Prompt

```
follow your custom instructions

Task: refactor + feature loop.

Refactor goal: <mô tả refactor, ví dụ: tách OrderService thành 3 service: Pricing, Inventory, Notification>
Feature goal (nếu có): <mô tả feature mới, ví dụ: thêm discount code khi tính giá>

Scope: edit allowed = [<list file/folder>]
Out of scope: <list file KHÔNG được sửa>

Acceptance criteria:
- AC-1: Behavior cũ KHÔNG đổi (test hiện có pass nguyên xi, không sửa test).
- AC-2: Feature mới có test happy + sad path.
- AC-3: Build pass: `<build command>`.
- AC-4: Test pass: `<test command>`.
- AC-5: Lint pass: `<lint command>`.
- AC-6: Self-verify 9/9 nhóm pass.

## Vòng lặp bắt buộc

### Iteration N (lặp đến khi AC pass + tôi confirm STOP)

#### Phase 1 — Plan
- Liệt kê task bước này (smallest safe change).
- Dependencies giữa các bước.
- Dry-run preview: file nào sẽ sửa, hành động gì.
- Rollback plan: backup + undo command + reversibility (high/medium/low).
- Risk + mitigation.
- Confirmation Gate: tôi reply OK / `D-1=A` / STOP / `Skip step X`.

#### Phase 2 — Implement (chỉ sau khi tôi OK)
- Sửa file trong scope edit allowed.
- KHÔNG sửa file ngoài scope. Phát hiện cần mở scope → DỪNG hỏi.
- Bulk edit > 3 file → bắt buộc dry-run lại.

#### Phase 3 — Test
- Chạy test command. Paste output.
- Nếu fail → Phase 4 quyết định.

#### Phase 4 — Verify
- Pass: 
  - Tôi review diff.
  - Tôi reply CONTINUE (sang iteration tiếp) hoặc STOP (kết thúc).
- Fail: 
  - AI phân tích nguyên nhân fail (cite file:line).
  - Quay lại Phase 1 — Plan refined.
  - Iteration tối đa: 5. Vượt 5 mà vẫn fail → DỪNG, đề xuất rollback toàn bộ.

## End condition

Kết thúc khi TẤT CẢ điều kiện sau đúng:
- [ ] AC-1 đến AC-6 pass.
- [ ] Build + test + lint pass.
- [ ] Tôi reply STOP (hoặc CONFIRM DONE).
- [ ] AI xuất "Final report":
  - Files touched (full list).
  - Memory-bank impact (theo `docs/CHANGE-IMPACT.md`).
  - Verification commands đã chạy + output.
  - Self-verify 9/9 pass.
  - Rollback plan tổng (nếu cần undo toàn bộ).

## Constraints chung

- Áp dụng `.prompts/snippets/dry-run.md` mọi lần edit > 3 file.
- Áp dụng `.prompts/snippets/rollback-plan.md` mọi iteration có edit-files.
- Áp dụng `.prompts/snippets/confirmation-gate.md` đầu mỗi iteration.
- Áp dụng `.prompts/snippets/self-verify.md` trước Final report.
- Cite file:line cho mọi claim về code thật.
- Không bịa file/function. Confidence + Assumptions cuối mỗi iteration report.

## Halt conditions

DỪNG hỏi tôi nếu:
- Cần mở scope (edit file ngoài scope edit allowed).
- Migration / DB schema / production config.
- Test fail > 5 iterations liên tiếp.
- Conflict giữa refactor goal và memory-bank/ADR.
- Rollback plan reversibility = low.

Mode: edit-files (sau khi tôi OK).
```

## Variants

- **Refactor-only (no feature)**: bỏ "Feature goal", giữ AC-1 (behavior không đổi) làm chính.
- **Feature-only (no refactor)**: bỏ "Refactor goal", thêm AC mới về behavior expected.
- **Migration mode**: thêm AC "data integrity check" + Phase 5 "rollback dry-run" sau mỗi iteration.

## Verification (sau khi loop kết thúc)

- `<build command>` → exit 0.
- `<test command>` → all pass.
- `<lint command>` → exit 0.
- `git diff --stat <branch trước>` → review tổng quan.
- Self-verify report: `**Self-verify**: 9/9 nhóm pass`.
