---
name: snippet-one-shot-max
purpose: Ép AI tối đa hóa chất lượng trong 1 request bằng multi-lens review + output cô đọng
usage: paste vào prompt hoặc trigger bằng "mode 1" / "one-shot max"
version: 1.0
last-updated: 2026-04-30
---

# Snippet: One-Shot Max

```
MODE 1: ONE-SHOT MAX.

Mục tiêu: tối đa hóa giá trị trong 1 request, không tối đa hóa độ dài.

## Context loading
- Đọc `ROADMAP.md`, `.prompts/system/base.md`, `docs/REQUEST-MODES.md`.
- Đọc memory-bank/ADR/PRP/examples liên quan theo Task Contract.
- Nếu context quá lớn, ưu tiên: files trực tiếp ảnh hưởng behavior > tests > docs > examples > broad scan.

## Task contract minimum
- Goal: hoàn thành task với giá trị cao nhất trong 1 response.
- Scope: dùng scope user đưa; nếu thiếu scope nhưng suy ra an toàn được thì ghi Assumptions; nếu không thì HALT.
- Acceptance criteria:
  - AC-1: output có thể hành động ngay.
  - AC-2: có evidence hoặc inference summary.
  - AC-3: có verification commands + expected result.
  - AC-4: có decision points hoặc `none`.
- Execution mode: one-shot-max; analysis-only/edit-files/review-only/generate-artifact tùy task.
- Confirmation: nếu cần user input, dùng `.prompts/snippets/confirmation-gate.md` và cho phép reply `OK`.

## Multi-lens pass
Trong cùng 1 response, tự kiểm qua 5 lens và chỉ xuất phần synthesis cô đọng:
- Mary: goal, scope, missing context, user impact.
- Winston: architecture, trade-off, reversibility.
- Amelia: implementation path, AC coverage, tests.
- Casey: risks, edge cases, failure modes.
- Quinn: validity, completeness, halt/decision points.

Không lộ chain-of-thought nội bộ. Chỉ xuất: evidence, inference summary, recommendation.

## Output density
- Không filler.
- Không lặp lại context dài.
- Dùng bảng khi so sánh, bullet khi liệt kê, code block khi cần artifact.
- Mỗi claim về code/docs thật phải cite `file:line`.
- Nêu rõ verification đã chạy hay chưa chạy.

## Required sections
1. Outcome / answer.
2. Evidence used.
3. Main output / patch / plan / review.
4. Risks and edge cases.
5. Verification commands with expected result.
6. Decision points needing user input.
7. Confidence + assumptions.

## Output format
```markdown
# Mode 1 Result: <task>

## Outcome
<dense answer>

## Evidence Used
- <file:line> — <fact>

## Main Output
<artifact / plan / implementation summary / review>

## Verification
- `<cmd>` → expect: <result>

## Decision Points
- D-1: <or none>

---
**Confidence**: <low|medium|high>
**Assumptions**:
- A-1: ...
**Memory-bank impact**:
- <if any>
```

## Halt override
Nếu task quá lớn, thiếu scope, hoặc risky:
- DỪNG sớm.
- Trả 1 plan chia nhỏ có thứ tự ưu tiên.
- Nếu cần user chọn, gom mọi lựa chọn vào 1 Confirmation Gate.
- Không làm nửa vời.
```
