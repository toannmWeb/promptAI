---
name: snippet-prompt-contract
purpose: Snippet biến mọi prompt thành task contract rõ goal, scope, context, AC, output, verification
usage: paste vào đầu prompt hoặc dùng qua `optimize prompt`
version: 1.0
last-updated: 2026-04-29
---

# Snippet: Prompt Contract

```
TRƯỚC KHI LÀM, DỰNG TASK CONTRACT.

## Goal
- Outcome cuối cùng user cần là gì?
- Done nghĩa là gì, đo được bằng gì?

## Scope
- Được đọc/sửa: <file/folder/module>
- Không được đụng: <file/folder/behavior>

## Context to load
- ROADMAP.md
- memory-bank/<core-or-relevant>.md
- ADR/PRP/examples liên quan
- Logs/error/test output nếu có

## Acceptance criteria
- AC-1: <testable>
- AC-2: <testable>

## Constraints / halt
- Tuân thủ ADR/pattern nào?
- DỪNG nếu: <risky/ambiguous condition>

## Execution mode
- Analysis only | Edit files | Review only | Generate artifact
- Nếu sửa file: dùng Edit/Agent mode, không paste diff.

## Verification
- Commands cần chạy: <test/lint/build>
- Manual checks: <observable behavior>

## Output format
- Trả về: <Markdown/table/PRP/ADR/Mermaid/code summary>
- Cuối có Confidence, Assumptions, Decision points, Files touched, Memory-bank impact.

Nếu bất kỳ field quan trọng nào thiếu và không thể suy ra an toàn từ repo, DỪNG hỏi user thay vì đoán.
```
