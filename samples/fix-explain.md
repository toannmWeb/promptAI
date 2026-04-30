---
name: sample-fix-explain
purpose: Fix bug với giải thích rõ bối cảnh để user hiểu, không chỉ thấy patch
input: mô tả bug + steps to reproduce + expected vs actual
output: 4-section Markdown (bối cảnh, bug ở đâu, cách sửa, sửa+verify) + diff
version: 1.0
last-updated: 2026-04-30
---

# Sample: Fix + Explain

## Khi nào dùng

- Bug khó hiểu, muốn AI giải thích trước khi sửa.
- Mentor mode: muốn HỌC từ bug, không chỉ fix.
- Onboarding dev mới: hiểu code qua bug thật.

## Reference

- Workflow: [.prompts/workflows/debug-loop.md](../.prompts/workflows/debug-loop.md)
- Snippet bắt buộc: [.prompts/snippets/force-cite.md](../.prompts/snippets/force-cite.md), [.prompts/snippets/rollback-plan.md](../.prompts/snippets/rollback-plan.md), [.prompts/snippets/self-verify.md](../.prompts/snippets/self-verify.md)

## Prompt

```
follow your custom instructions

Task: fix bug + explain.

## Mô tả bug
- Bug: <mô tả ngắn>.
- Steps to reproduce:
  1. <step 1>
  2. <step 2>
  3. <step 3>
- Expected: <hành vi mong đợi>
- Actual: <hành vi hiện tại>
- Logs / error message (nếu có): <paste>
- Tần suất: <luôn xảy ra | thỉnh thoảng | chỉ trên prod>

## Output BẮT BUỘC theo cấu trúc 4 phần

### Phần 1 — Bối cảnh
Giải thích cho người KHÔNG biết module này:
- Module này làm gì trong project (1-2 câu).
- Code đang chạy gì khi bug xuất hiện (đi qua file nào, gọi function nào). Cite file:line.
- Concept / pattern liên quan (ví dụ: "đây là async race condition", "đây là off-by-one", "đây là leak listener").
- Sequence diagram Mermaid ngắn (3-7 step) mô tả flow lúc bug xảy ra.

### Phần 2 — Bug ở đâu, tại sao
- Chỗ bug: cite file:line CHÍNH XÁC.
- Code đoạn bug (paste 5-15 dòng có context).
- Tại sao bug: 
  - Logic sai: chỉ ra điều kiện / nhánh / order sai.
  - State sai: chỉ ra biến nào sai giá trị, ở thời điểm nào.
  - Side effect: chỉ ra side effect chưa lường.
- Ai trigger: input nào, state nào → kích hoạt bug.
- Tại sao test cũ không bắt: test coverage gap ở đâu.

### Phần 3 — Cách sửa
- Đề xuất ≥ 2 giải pháp:
  - Option A: <mô tả ngắn>. Trade-off: <pros/cons>.
  - Option B: <mô tả ngắn>. Trade-off: <pros/cons>.
- Recommendation: chọn option nào, TẠI SAO chọn option đó (smallest safe change? phù hợp pattern hiện có? reversibility cao?).
- Tác động phụ: thay đổi này có làm gì khác bị ảnh hưởng không? Cite file:line liên quan.

### Phần 4 — Sửa + Verify
- Dry-run preview: file sẽ sửa, hành động gì (theo `.prompts/snippets/dry-run.md`).
- Rollback plan: backup + undo command + reversibility (theo `.prompts/snippets/rollback-plan.md`).
- Confirmation Gate: tôi reply OK / sửa option khác / STOP.
- Sau khi tôi OK, AI sửa code (Edit mode).
- Verification:
  - Test command để verify fix: `<cmd>` → expect: <result>.
  - Test bổ sung để cover bug này (test case mới): cite file test sẽ tạo / sửa.
  - Manual reproduce steps để tự kiểm.
- Memory-bank impact: cần update `progress.md` / `activeContext.md` không?

---
**Confidence**: <low|medium|high>
**Assumptions**:
- A-1: ...
**Decision points**:
- D-1: ...
**Files touched**:
- ...
**Self-verify**: <N>/9 nhóm pass theo `.prompts/snippets/self-verify.md`.

## Constraints

- Mỗi claim về code phải cite file:line. Áp dụng `.prompts/snippets/force-cite.md`.
- KHÔNG sửa code trước khi tôi OK Confirmation Gate ở Phần 4.
- Nếu nguyên nhân chưa rõ ràng → đẩy vào "Hypothesis" + đề xuất verification command để xác nhận trước khi đề xuất fix.
- Mục tiêu chính: tôi HIỂU được context + cách sửa, không chỉ thấy patch.

Mode: analysis-only ở Phần 1-3, edit-files ở Phần 4 (sau Confirmation Gate).
Scope: edit allowed = [<list file dự kiến sửa>; AI có thể đề xuất bổ sung sau Phần 2].
```

## Variants

- **Quick-fix mode** (bug hiển nhiên, không cần học): rút gọn Phần 1 còn 2 dòng, tập trung Phần 2-4.
- **Educational mode** (mentor học trò): mở rộng Phần 1, thêm "Concept reference" link đến example/ADR/doc liên quan.
- **Production-incident mode**: thêm Phần 0 "Mitigation tạm thời" trước Phần 1 (rollback feature flag, scale up, restart).

## Verification

- Test command pass với fix.
- Test mới (bug case) pass.
- Manual reproduce theo step → bug không còn.
- `git diff` → smallest safe change, không sửa file ngoài scope.
