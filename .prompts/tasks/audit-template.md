---
name: audit-template
purpose: Review master prompt-system template để giữ universal, mạnh, nhất quán và không lẫn project-specific facts
input: <optional focus: personas/workflows/scripts/docs/all>
output: Findings + prioritized upgrade plan + optional patch plan
version: 1.0
last-updated: 2026-04-29
trigger-command: "audit template" / "review skeleton"
---

# Task: Audit Template

> Single-prompt task. Dùng để kiểm tra repo master template trước khi dùng cho nhiều project. Khác `verify output`: task này review toàn skeleton như một product framework.

## Scope mặc định

Đọc:

- `docs/TEMPLATE-MODE.md`
- `README.md`
- `ROADMAP.md`
- `AGENTS.md`
- `.github/copilot-instructions.md`
- `.prompts/system/base.md`
- `.prompts/personas/README.md`
- `.prompts/workflows/*.md`
- `.prompts/tasks/*.md`
- `.prompts/snippets/*.md`
- `docs/PROMPT-VALIDITY.md`
- `scripts/*.sh`

Không fill memory-bank project-specific.

## Task Contract

Goal:
- Đánh giá master template có đủ mạnh, nhất quán, an toàn và project-agnostic để dùng cho mọi dự án sau này.

Scope:
- Read: template docs, prompt library, scripts, command maps.
- Edit allowed: none by default; chỉ đề xuất patch plan trừ khi user yêu cầu sửa trực tiếp.
- Do not touch: facts project-specific trong `memory-bank/*.md`.

Context:
- `docs/TEMPLATE-MODE.md`
- `docs/REQUEST-MODES.md`
- `docs/BENCHMARK-MODE-1.md`
- `.prompts/snippets/prompt-contract.md`
- `docs/PROMPT-VALIDITY.md`
- `README.md`, `ROADMAP.md`, `AGENTS.md`

Acceptance criteria:
- AC-1: Findings cite `file:line`.
- AC-2: Command map consistency table covers README, ROADMAP, AGENTS and prompt file existence.
- AC-3: Script checks include `./scripts/check-template.sh`, `./scripts/check-memory-bank.sh --allow-template`, and `bash -n scripts/*.sh`.
- AC-4: Output separates blockers, majors and minors.
- AC-5: No project-specific memory-bank facts are invented.

Execution mode:
- review-only by default.

Verification:
- Run or propose `./scripts/check-template.sh`.
- Run or propose `./scripts/verify-prompt.sh --allow-template .prompts/tasks/audit-template.md`.

Output:
- Markdown report using the template below.
- End with Confidence, Assumptions, Verification commands, Decision points and Memory-bank impact.

Halt:
- Stop if the user asks to fill project facts inside the master template.
- Stop if audit requires destructive file operations.

Language:
- Trả lời TIẾNG VIỆT CÓ DẤU.
- Mọi từ/câu tiếng Việt phải dùng đầy đủ dấu tiếng Việt; không viết tiếng Việt không dấu.

Memory-bank impact:
- None in Template Mode unless the audit explicitly changes memory-bank templates.

## Review dimensions

| Dimension | Câu hỏi |
|---|---|
| Universality | Có nội dung nào chỉ hợp 1 project cụ thể không? |
| Power | Prompt có đủ Goal/Scope/Context/AC/Verification/Halt không? |
| Consistency | Command map ở README/ROADMAP/AGENTS/.prompts có đồng bộ không? |
| Safety | Có halt conditions cho risky ops, secrets, destructive changes không? |
| Verification | Có script/checklist để kiểm chứng output không? |
| Benchmark | Có rubric và prompt mẫu để chấm Mode 1 không? |
| Token efficiency | Có hướng dẫn max-context mà không ép lộ chain-of-thought không? |
| Apply flow | Có rõ cách copy sang project thật và initialize memory-bank không? |
| Template purity | `<TODO>` có giữ đúng chỗ template và không bị coi là lỗi sai mode không? |

## Output template

```markdown
# Template Audit

## Verdict
- Status: pass | pass-with-warnings | fail
- Biggest risk: <1 sentence>
- Highest leverage upgrade: <1 sentence>

## Findings

[blocker] 1. <finding>. Evidence: <file:line>. Fix: <concrete>.
[major] 2. ...
[minor] 3. ...

## Command map consistency

| Command | README | ROADMAP | AGENTS | Prompt file exists | Status |
|---|---|---|---|---|---|

## Script checks

| Command | Result | Notes |
|---|---|---|
| `./scripts/check-template.sh` | pass/fail/not-run | <notes> |
| `./scripts/check-all.sh` | pass/fail/not-run | <notes> |
| `./scripts/check-memory-bank.sh --allow-template` | pass/fail/not-run | <notes> |
| `bash -n scripts/*.sh` | pass/fail/not-run | <notes> |

## Upgrade plan

| Priority | Change | Files | Expected impact |
|---|---|---|---|

---
**Confidence**: <low|medium|high>
**Assumptions**:
- A-1: Repo is master template, not applied project.
**Decision points needing user input**:
- D-1: <if any>
```

## Halt conditions

DỪNG nếu:

- User yêu cầu fill project facts trong template.
- Audit phát hiện command map thiếu file prompt nhưng không rõ nên create hay remove.
- Audit cần chạy destructive file operations.

## Prompt template

```
@workspace audit template

Task: .prompts/tasks/audit-template.md
Mode: Template Mode, project-agnostic only.
Focus: <all | personas | workflows | scripts | docs>

Output: findings + command map consistency + script checks + prioritized upgrade plan.
```
