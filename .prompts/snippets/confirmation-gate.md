---
name: snippet-confirmation-gate
purpose: Chuẩn hóa block hỏi xác nhận trong IDE chat để giảm số request nhưng vẫn an toàn
usage: dùng khi AI cần user input trước khi tiếp tục
version: 1.0
last-updated: 2026-04-30
---

# Snippet: Confirmation Gate

CONFIRMATION GATE — IDE REQUEST ECONOMY.

Mục tiêu: chỉ hỏi user khi thật cần, và khi hỏi thì gom tất cả vào 1 block để user trả lời bằng 1 message ngắn.

## Task contract

Goal:
- Collect all required user confirmations in one IDE-chat block so AI can continue with fewer request round-trips.

Scope:
- Use for IDE chat, agent mode, edit mode, and review-only work when user input is required before continuing.
- Do not use when a safe, reversible default exists; record those items under Assumptions instead.
- Do not touch unrelated files while waiting for confirmation.

Context:
- Read `ROADMAP.md` first to locate the relevant workflow.
- Follow `.prompts/system/base.md`.
- Follow `.prompts/snippets/prompt-contract.md`.
- Follow `.prompts/snippets/decision-points.md`.
- Follow `.prompts/snippets/halt-conditions.md`.
- Respect `memory-bank/` and Active ADRs; cite file:line when referencing real repo content.

Acceptance criteria:
- AC-1: All blocking questions are batched into one `INPUT NEEDED` block.
- AC-2: Every decision point has a recommended default and a short trade-off.
- AC-3: User can answer with one line: `OK`, explicit decision codes, or `STOP`.
- AC-4: The block states why execution is blocked and cites file:line/instruction when applicable.
- AC-5: After the user answers, AI does not ask the same question again.

Execution mode:
- Mode: confirmation-only.
- Halt file edits, destructive commands, migrations, external writes, and irreversible actions until user input arrives.
- Continue analysis-only work only if it does not change the decision being requested.

Verification plan:
- Verify the snippet with `bash scripts/verify-prompt.sh --allow-template .prompts/snippets/confirmation-gate.md`.
- Expected result: validator returns Prompt READY or Prompt USABLE with 0 failures.

Output:
- Use the `INPUT NEEDED` format below.
- Include `Confidence`, `Assumptions`, `Decision points needing user input`, `Verification commands` when applicable, and `Memory-bank impact` when the confirmation affects memory-bank edits.

Language:
- Trả lời TIẾNG VIỆT trừ khi user yêu cầu khác.

## Khi nào được hỏi
Chỉ hỏi khi:
- Risk cao: destructive ops, data/security/migration, overwrite files.
- Missing context ảnh hưởng behavior/scope.
- Conflict với memory-bank/ADR/user instruction.
- Cần chọn trade-off không reversible.

Không hỏi khi:
- Có thể suy ra an toàn và reversible.
- Có recommended default rõ ràng.
- Chỉ thiếu thông tin nhỏ không ảnh hưởng correctness; ghi vào Assumptions.

## Output format khi cần user input

```text
🛑 INPUT NEEDED — <short reason>

Why blocked:
- <1-3 bullets, cite file:line/instruction nếu có>

Recommended default:
- <D-1=A, D-2=Y> — <reason>

Reply with one line:
- `OK` → dùng recommended default.
- `D-1=A D-2=N` → chọn cụ thể.
- `STOP` → dừng task.

Decision points:
- D-1: <question>
  - A: <option> (recommended) — <trade-off>
  - B: <option> — <trade-off>
- D-2: <question>
  - Y: yes (recommended) — <trade-off>
  - N: no — <trade-off>
```

## Sau khi user trả lời
- Nếu user trả lời `OK`, proceed với recommended default.
- Nếu user trả lời codes, apply đúng codes.
- Nếu user trả lời tự do, parse intent; nếu ambiguous, hỏi lại nhưng chỉ 1 câu.
- Không hỏi lại các câu đã được trả lời.
