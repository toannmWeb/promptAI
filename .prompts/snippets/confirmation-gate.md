---
name: snippet-confirmation-gate
purpose: Chuẩn hóa block hỏi xác nhận trong IDE chat để giảm số request nhưng vẫn an toàn
usage: dùng khi AI cần user input trước khi tiếp tục
version: 1.1
last-updated: 2026-04-30
---

# Snippet: Confirmation Gate

CONFIRMATION GATE — IDE REQUEST ECONOMY.

Mục tiêu: chỉ hỏi user khi thật cần, và khi hỏi thì gom tất cả vào 1 block để user trả lời bằng 1 message ngắn.

## Khi BẮT BUỘC gửi Confirmation Gate (không tự tiếp tục)

1. Task sẽ sửa > 3 file (kể cả prompt-system files / docs / scripts).
2. Task chạy destructive op: xóa file/folder, mass refactor, codemod, migration, schema change, drop/truncate/delete bulk.
3. Task đụng git history: force push, reset --hard, rebase shared branch, branch delete chưa merge.
4. Task sửa production config / secrets / `.env*` / deploy YAML / CI config.
5. Task tạo external side-effect: gửi email/SMS, charge thanh toán, gọi API trả phí lớn.
6. Task phát hiện cần mở scope ngoài `Scope: edit allowed` ban đầu.
7. Reversibility = low (rollback không đơn giản).
8. Conflict với memory-bank / ADR Active.
9. Confidence = low ở decision ảnh hưởng behavior/security/data.
10. Self-verify (`.prompts/snippets/self-verify.md`) báo nhóm Anti-hallucination / Scope lock / Safety fail.

Khi rơi vào nhóm 1–5 hoặc 7, BẮT BUỘC kèm dry-run preview (`.prompts/snippets/dry-run.md`) + rollback plan (`.prompts/snippets/rollback-plan.md`) trong cùng block.

## Khi KHÔNG hỏi

- Có thể suy ra an toàn và reversible.
- Có recommended default rõ ràng và task nằm ngoài danh sách bắt buộc ở trên.
- Chỉ thiếu thông tin nhỏ không ảnh hưởng correctness; ghi vào Assumptions.

## Output format khi cần user input

```text
🛑 INPUT NEEDED — <short reason>

Why blocked:
- <1-3 bullets, cite file:line/instruction nếu có>

Dry-run preview (nếu áp dụng):
| # | Action | Path | Reason | Reversibility |
|---|---|---|---|---|
| 1 | edit | path/a | ... | high |

Rollback plan (nếu áp dụng):
- Backup: `_logs/<task>-<ts>/`
- Undo: `<cmd>`
- Reversibility: <high|medium|low>

Recommended default:
- <D-1=A, D-2=Y> — <reason ngắn>

Reply with one line:
- `OK` → dùng recommended default.
- `D-1=A D-2=N` → chọn cụ thể.
- `OK except #2,#3` → chấp nhận plan trừ dòng 2,3.
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
- Nếu user trả lời `OK except #X,#Y`, loại dòng X,Y khỏi plan, giữ phần còn lại.
- Nếu user trả lời tự do, parse intent; nếu ambiguous, hỏi lại nhưng chỉ 1 câu.
- Không hỏi lại các câu đã được trả lời.
- Nếu trong quá trình execute phát sinh nhánh ngoài plan, DỪNG, in Confirmation Gate thứ hai, không tự mở rộng.

## Task contract của snippet

- Goal: gom mọi user confirmation vào 1 block để giảm round-trip mà vẫn an toàn.
- Scope: IDE chat / agent mode / edit mode / review-only khi cần user input.
- Context refs: `.prompts/system/base.md`, `.prompts/snippets/prompt-contract.md`, `.prompts/snippets/decision-points.md`, `.prompts/snippets/halt-conditions.md`, `.prompts/snippets/dry-run.md`, `.prompts/snippets/rollback-plan.md`, `.prompts/snippets/self-verify.md`.
- Acceptance criteria:
  - AC-1: Mọi câu hỏi blocking gom vào 1 `INPUT NEEDED` block.
  - AC-2: Mỗi decision point có recommended default + trade-off ngắn.
  - AC-3: User có thể trả lời 1 dòng (`OK` / `D-1=A` / `OK except #X` / `STOP`).
  - AC-4: Block giải thích lý do block + cite file:line/instruction.
  - AC-5: Sau khi user trả lời, AI không hỏi lại cùng câu.
  - AC-6: Với task ≥ 4 file hoặc destructive, block kèm dry-run + rollback plan.
- Execution mode: confirmation-only; halt mọi file edit/destructive/external write cho tới khi nhận input.
- Verification: `bash scripts/verify-prompt.sh --allow-template .prompts/snippets/confirmation-gate.md` → Prompt READY hoặc USABLE với 0 failures.
- Language: Trả lời tiếng Việt có dấu đầy đủ; code/path giữ nguyên.
