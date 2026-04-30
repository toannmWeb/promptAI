---
name: snippet-prompt-contract
purpose: Snippet biến mọi prompt thành task contract rõ goal, scope, context, AC, rollback, output, verification
usage: paste vào đầu prompt hoặc dùng qua `optimize prompt`
version: 1.1
last-updated: 2026-04-30
---

# Snippet: Prompt Contract

```
TRƯỚC KHI LÀM, DỰNG TASK CONTRACT.

## Goal
- Outcome cuối cùng user cần là gì?
- Done nghĩa là gì, đo được bằng metric/AC nào?

## Scope
- Được đọc: <file/folder/module>
- Được sửa (edit allowed): <file/folder — explicit list>
- Không được đụng: <file/folder/behavior>
- SCOPE LOCK: AI chỉ được sửa file trong `edit allowed`. Cần mở scope → DỪNG hỏi user, không tự mở rộng.

## Context to load (BẮT BUỘC đọc hết trước khi trả lời)
- ROADMAP.md
- memory-bank/<core-or-relevant>.md (liệt kê cụ thể file nào)
- ADR/PRP/examples/runbook liên quan (liệt kê đường dẫn)
- Logs/error/test output nếu có
- Source/test file trực tiếp ảnh hưởng

> Quy tắc: mọi file ở đây PHẢI được đọc thật sự trong phiên, không trả lời dựa trên trí nhớ / pattern đoán. Nếu file không đọc được → ghi vào Assumptions hoặc HALT.

## Acceptance criteria (testable)
- AC-1: <hành động / metric / output cụ thể>; verify bằng `<cmd / manual check>`.
- AC-2: ...

> Mỗi AC phải trả lời: đo bằng cách nào, expected pass condition là gì.

## Constraints / halt
- Tuân thủ ADR/pattern nào?
- DỪNG nếu: <risky / ambiguous / scope drift / >3 file không dry-run / destructive op>.
- Tham chiếu `.prompts/snippets/halt-conditions.md`.

## Execution mode
- Analysis only | Edit files | Review only | Generate artifact | Debug loop
- Nếu sửa file: dùng Edit/Agent mode, không paste diff.
- Nếu sửa > 3 file hoặc destructive: BẮT BUỘC dry-run preview + Confirmation Gate (`.prompts/snippets/dry-run.md`).

## Rollback plan (bắt buộc với edit-files / migration / refactor)
- Cách undo: <git revert / restore backup / migration ngược>.
- Backup path: `_logs/<task>-<timestamp>/`.
- Reversibility: high | medium | low.
- Reversibility = low → không tự thực thi, bắt buộc Confirmation Gate.
- Tham chiếu `.prompts/snippets/rollback-plan.md`.

## Verification
- Commands cần chạy: `<test/lint/build>` → expect: <result>.
- Manual checks: <observable behavior>.
- Phân biệt rõ "đã chạy" vs "đề xuất user chạy".

## Self-verify
- Sau khi dựng output, AI đi qua `.prompts/snippets/self-verify.md` và ghi `Self-verify: N/9 nhóm pass`.

## Output format
- Trả về: <Markdown/table/PRP/ADR/Mermaid/code summary>.
- Cấu trúc: Evidence → Inference → Decision → Verification → Next steps.
- Cuối có Confidence, Assumptions, Decision points, Files touched, Memory-bank impact, Self-verify.

Nếu bất kỳ field quan trọng nào thiếu và không thể suy ra an toàn từ repo, DỪNG hỏi user thay vì đoán.
```
