---
name: mode-1-one-shot-max
purpose: Chế độ tối đa hóa chất lượng, độ chính xác và mật độ thông tin trong 1 request
input: <task description + optional scope/context>
output: One-shot result with evidence, multi-lens synthesis, verification, decision points
version: 1.0
last-updated: 2026-04-30
trigger-command: "mode 1 <task>" / "one-shot max <task>" / "tận dụng tối đa 1 request <task>"
---

# Workflow: Mode 1 — One-Shot Max

> Dùng khi user tính theo request và muốn AI hoạt động xuất sắc nhất trong **một lần hỏi**: nhiều góc nhìn, nhiều kiểm tra, nhưng output vẫn cô đọng và có thể hành động ngay.

## Task Contract

Goal:
- Hoàn thành task trong một response với chất lượng cao nhất có thể trong scope an toàn.

Scope:
- Read: tất cả file/docs liên quan trực tiếp đến task.
- Edit allowed: chỉ khi user yêu cầu sửa file hoặc task mặc định là implementation.
- Do not touch: file ngoài scope, generated/vendor, secrets, facts project-specific trong Template Mode.

Context:
- `docs/REQUEST-MODES.md`
- `.prompts/snippets/one-shot-max.md`
- `.prompts/snippets/prompt-contract.md`
- `.prompts/snippets/confirmation-gate.md`
- `.prompts/snippets/force-cite.md`
- `.prompts/snippets/confidence-scale.md`
- Relevant memory-bank/ADR/PRP/examples.

Acceptance criteria:
- AC-1: Output hoàn chỉnh trong một response, không yêu cầu "hỏi tiếp để tôi làm tiếp" trừ khi halt.
- AC-2: Có evidence hoặc nói rõ phần nào là inference.
- AC-3: Có multi-lens synthesis: Mary/Winston/Amelia/Casey/Quinn, nhưng cô đọng.
- AC-4: Có verification commands với expected result.
- AC-5: Có decision points hoặc ghi `none`.
- AC-6: Không lộ chain-of-thought nội bộ; chỉ reasoning summary.

Execution mode:
- one-shot-max; có thể là analysis-only, edit-files, review-only hoặc generate-artifact tùy task.

Verification:
- Chạy test/lint/build nếu feasible trong môi trường.
- Nếu không chạy được, nêu rõ lý do và lệnh user chạy.

Output:
- Markdown cô đọng, ưu tiên bảng/bullet có mật độ cao.
- Kết thúc bằng Confidence, Assumptions, Verification commands, Decision points, Files touched, Memory-bank impact.

Halt:
- Stop nếu task thiếu scope nghiêm trọng, có risky operation, conflict memory-bank/ADR, hoặc vượt context window.
- Nếu halt cần user input, dùng Confirmation Gate với recommended default và one-line reply format.

Language:
- Trả lời TIẾNG VIỆT.

## Workflow

### Step 1: Frame task

AI tự dựng Task Contract:

- Goal.
- Scope.
- Context.
- AC.
- Risks/halt.
- Output format.

Nếu thiếu thông tin nhưng có thể suy ra an toàn → ghi `Assumptions`.
Nếu thiếu thông tin ảnh hưởng behavior/security/data/scope → HALT.
Khi HALT, gom mọi câu hỏi vào một Confirmation Gate; không hỏi từng câu qua nhiều request.

### Step 2: Load context by priority

Ưu tiên:

1. User-provided prompt/details.
2. `ROADMAP.md`, `.prompts/system/base.md`, `docs/REQUEST-MODES.md`.
3. memory-bank core/relevant.
4. ADR/PRP/examples liên quan.
5. Source/tests trực tiếp liên quan.
6. Broad search chỉ khi cần.

### Step 3: Multi-lens synthesis

AI kiểm nội bộ qua 5 lens:

| Lens | Kiểm gì | Output public |
|---|---|---|
| Mary | goal/scope/user impact/missing context | 1-3 bullets |
| Winston | architecture/trade-offs/reversibility | 1-3 bullets |
| Amelia | implementation/AC/tests | 1-3 bullets |
| Casey | risks/edge cases/failure modes | 1-3 bullets |
| Quinn | validity/completeness/decision points | 1-3 bullets |

Không xuất chain-of-thought; chỉ xuất synthesis nếu nó giúp user quyết định/hành động.

### Step 4: Produce dense output

Output mặc định:

```markdown
# Mode 1 Result: <task>

## Outcome
<answer / result / patch summary>

## Evidence Used
- <file:line> — <fact>

## Multi-Lens Check
| Lens | Key point |
|---|---|

## Main Output
<artifact / plan / implementation summary / review findings>

## Risks
- <risk + mitigation>

## Verification
- `<cmd>` → expect: <result>

## Decision Points
- D-1: <or none>

---
**Confidence**: <low|medium|high>
**Assumptions**:
- A-1: ...
**Files touched**:
- ...
**Memory-bank impact**:
- ...
```

## Prompt template

```
@workspace mode 1:

Task:
<task description>

Scope:
<files/folders/features or "infer safely from repo">

Use:
- .prompts/workflows/mode-1-one-shot-max.md
- .prompts/snippets/one-shot-max.md
- .prompts/snippets/prompt-contract.md
- .prompts/snippets/confirmation-gate.md

Output one complete, dense response in Vietnamese. Cite file:line. Verify or provide commands with expected results.
```
