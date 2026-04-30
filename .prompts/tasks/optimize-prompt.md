---
name: optimize-prompt
purpose: Biến prompt thô / ý tưởng mơ hồ thành prompt contract executable, đủ context và kiểm chứng được
input: <raw prompt / goal / task idea>
output: Improved prompt ready to send + missing context + risk review
version: 1.0
last-updated: 2026-04-29
trigger-command: "optimize prompt <draft>" / "Quinn, optimize this prompt"
---

# Task: Optimize Prompt

> Single-prompt task. Dùng trước khi đưa AI làm việc quan trọng. Mục tiêu: tăng xác suất AI làm đúng ngay lần đầu bằng cách chuẩn hóa goal, scope, context, AC, halt conditions, verification và output format.

## Khi dùng

- Prompt đang có từ mơ hồ: "tối ưu", "làm tốt hơn", "fix hết", "powerful", "clean", "robust".
- Task có thể sửa code, kiến trúc, dữ liệu, security, hoặc nhiều file.
- Cần tận dụng tối đa 1 request nhưng vẫn muốn AI không đoán.
- Cần chuyển ý tưởng thành prompt copy-paste cho Copilot/Cursor/Cline/Claude Code/Aider.

## Workflow

1. Adopt persona Quinn (Reviewer) cho pre-flight, rồi Mary (Analyst) để làm rõ goal.
2. Đọc `docs/PROMPT-VALIDITY.md` và `.prompts/snippets/prompt-contract.md`.
3. Nếu prompt liên quan repo hiện tại, đọc `ROADMAP.md` và 6 file memory-bank core. Nếu core còn `<TODO>`, không fill thay user; chỉ ghi missing context.
4. Phân loại task:
   - `analysis-only`
   - `edit-files`
   - `debug-loop`
   - `feature-plan`
   - `feature-implementation`
   - `review`
   - `documentation`
5. Chuyển prompt thô thành **Task Contract**.
6. Liệt kê missing context và decision points.
7. Xuất prompt cuối cùng đã tối ưu, có thể copy-paste.

## Output template

````markdown
# Optimized Prompt: <short name>

## Diagnosis

| Area | Status | Finding | Fix |
|---|---|---|---|
| Goal | pass/warn/fail | <finding> | <fix> |
| Scope | pass/warn/fail | <finding> | <fix> |
| Context | pass/warn/fail | <finding> | <fix> |
| Acceptance | pass/warn/fail | <finding> | <fix> |
| Verification | pass/warn/fail | <finding> | <fix> |
| Output | pass/warn/fail | <finding> | <fix> |
| Halt | pass/warn/fail | <finding> | <fix> |

## Missing context

- M-1: <file/info/user answer needed>
- M-2: ...

## Optimized prompt

```prompt
@workspace <command or task summary>

Goal:
- <specific outcome>

Scope:
- Read: <files/folders>
- Edit allowed: <files/folders or "none">
- Do not touch: <boundaries>

Context to load:
- ROADMAP.md
- memory-bank/<file>.md
- <ADR/PRP/examples/workflow refs>

Acceptance criteria:
- AC-1: <testable>
- AC-2: <testable>

Workflow:
- Use <.prompts/workflows/... or .prompts/tasks/...>.
- Apply .prompts/snippets/prompt-contract.md.
- Apply .prompts/snippets/force-cite.md.
- Apply .prompts/snippets/confidence-scale.md.
- Apply .prompts/snippets/halt-conditions.md.

Execution:
- Mode: <analysis-only | edit-files | review-only | generate-artifact>
- Use Edit/Agent mode for file changes.
- Cite file:line for claims about real code.

Verification:
- Run or propose: `<cmd>`
- Expected result: <observable pass condition>

Output format:
- <exact Markdown structure>
- End with Confidence, Assumptions, Verification commands, Decision points, Files touched, Memory-bank impact.

Halt if:
- <condition 1>
- <condition 2>
```

## Decision points needing user input

- D-1: <decision>

---
**Confidence**: <low|medium|high>
**Assumptions**:
- A-1: <assumption>
**Verification commands**:
- `./scripts/verify-prompt.sh <draft.md>` → expect: Prompt READY hoặc warnings rõ ràng.
````

## Quality bar

Prompt optimized xong phải đạt:
- Goal cụ thể, không còn từ mơ hồ không đo được.
- Scope chỉ rõ read/edit/no-touch.
- Có context refs: `ROADMAP.md`, memory-bank, ADR/PRP/examples nếu liên quan.
- Có AC testable.
- Có halt conditions.
- Có verification commands.
- Có output format.
- Có instruction cite `file:line` cho code claims.

## Halt conditions

DỪNG, hỏi user nếu:
- Raw prompt thiếu mục tiêu đến mức không thể dựng AC.
- Task yêu cầu sửa code nhưng không có scope hoặc repo context.
- Core memory-bank còn `<TODO>` và task đòi hỏi project-specific facts.
- Prompt có yêu cầu nguy hiểm: xóa dữ liệu, rewrite history, bypass security, leak secret.

## Prompt template

```
@workspace optimize prompt:

Raw prompt:
<paste raw prompt>

Task: .prompts/tasks/optimize-prompt.md

Output: diagnosis + optimized prompt copy-paste ready + missing context + decision points.
Trả lời TIẾNG VIỆT CÓ DẤU. Mọi từ/câu tiếng Việt phải dùng đầy đủ dấu tiếng Việt; không viết tiếng Việt không dấu. Cite file:line nếu nói về file thật trong repo.
```
