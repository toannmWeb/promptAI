# Antigravity Setup Guide

> Hướng dẫn setup Antigravity với prompt-system-skeleton v3.2.
>
> Antigravity khác các tool khác: KHÔNG đọc file entry tự động. Phải paste rules vào UI.

---

## 1. Tổng quan

Antigravity dùng 2 loại rules:

| Loại | Phạm vi | Lưu ở đâu | Khi nào dùng |
|---|---|---|---|
| **User rules** | Cross-project (tất cả workspace) | Antigravity user settings | Rules generic: ngôn ngữ, output format, không-bịa |
| **Workspace rules** | Per-project | Workspace settings | Rules cụ thể project: stack, ADR, memory-bank pointers |

→ Recommended: dùng cả hai. User rules cho rule chung (ngôn ngữ, safety), workspace rules cho project-specific.

---

## 2. Setup lần đầu (5 phút)

### Bước 1 — Mở Antigravity rules UI

- Antigravity desktop: `Settings` → `Rules` (hoặc `AI` → `Rules` tùy version).
- Có 2 tab: `User Rules` và `Workspace Rules`.

### Bước 2 — Paste User Rules (cross-project)

Mở User Rules tab, paste nội dung sau:

```
# User Rules — Skeleton v3.2 cross-project

## Ngôn ngữ
- Trả lời tiếng Việt có dấu đầy đủ trừ khi user yêu cầu khác.
- Code, identifier, command, path, placeholder giữ nguyên cú pháp gốc.

## Safety + Accuracy
- An toàn và chính xác ưu tiên tuyệt đối; không đánh đổi để lấy tốc độ, tiết kiệm token, hoặc làm hết trong 1 request.
- Không bịa file/function/API. Nghi ngờ → nói "không thấy trong codebase loaded".
- Mọi claim về code thật phải cite `file:line`.

## Scope + Rollback
- Chỉ sửa file trong `Scope: edit allowed` user khai báo. Cần mở scope → DỪNG hỏi.
- > 3 file edit / migration / destructive op / production config → bắt buộc dry-run preview + Confirmation Gate.
- Mọi edit-files / migration / refactor phải có rollback plan trước khi thực thi.

## Output format
Cuối câu trả lời substantive:
- Confidence: low | medium | high
- Assumptions (nếu có)
- Verification commands (nếu áp dụng)
- Decision points (nếu có)
- Files touched (nếu sửa code)
- Self-verify: <N>/9 nhóm pass

## Decision discipline
- Khi cần user input, gom mọi câu hỏi vào 1 Confirmation Gate có recommended default.
- User reply OK / D-1=A / STOP / OK except #X.
```

→ Save.

### Bước 3 — Paste Workspace Rules (per-project)

Mở Workspace Rules tab cho project đang dùng, paste nội dung sau:

```
# Workspace Rules — <project name>

## Bootstrap (đọc theo thứ tự đầu mọi task)
1. ROADMAP.md — god view.
2. AGENTS.md — full rules + workflow commands.
3. .prompts/system/base.md — 22 rules cốt lõi.
4. 6 file core memory-bank/:
   - memory-bank/projectBrief.md
   - memory-bank/productContext.md
   - memory-bank/activeContext.md
   - memory-bank/systemPatterns.md
   - memory-bank/techContext.md
   - memory-bank/progress.md
5. docs/USAGE-GUIDE.md — bảng tra cứu tình huống → prompt.

## Workflow commands
Khi user gõ command sau, đọc file tương ứng và thực thi:
- "follow your custom instructions" → .prompts/system/base.md
- "initialize memory bank" → .prompts/workflows/initialize-memory-bank.md
- "mode 1 <task>" / "one-shot max <task>" → .prompts/workflows/mode-1-one-shot-max.md
- "update memory bank" → .prompts/workflows/update-memory-bank.md
- "debug loop <bug>" → .prompts/workflows/debug-loop.md
- "deep dive into <module>" → .prompts/workflows/deep-dive-learn.md
- "refactor safely <scope>" → .prompts/workflows/refactor-safe.md
- "feature end-to-end <name>" → .prompts/workflows/feature-end-to-end.md
- "apply skeleton to <project path>" → .prompts/workflows/apply-to-project.md
- "verify output" → .prompts/tasks/verify-output.md
- "optimize prompt <draft>" → .prompts/tasks/optimize-prompt.md
- "audit template" → .prompts/tasks/audit-template.md
- "plan feature <name>" → .prompts/tasks/plan-feature.md
- "trace flow <action>" → .prompts/tasks/trace-flow.md
- "explain module <path>" → .prompts/tasks/explain-module.md
- "extract pattern <name>" → .prompts/tasks/extract-pattern.md
- "document feature <name>" → .prompts/tasks/document-feature.md
- "party mode <topic>" → .prompts/personas/party-mode.md

## Personas (gọi tên trong chat)
- Mary 📊 (Analyst): .prompts/personas/analyst.md
- Winston 🏗 (Architect): .prompts/personas/architect.md
- Amelia 💻 (Dev): .prompts/personas/dev.md
- Casey 🔍 (QA): .prompts/personas/qa.md
- Quinn 🧐 (Reviewer): .prompts/personas/reviewer.md

## Snippets bắt buộc reference
- .prompts/snippets/force-cite.md — cite file:line.
- .prompts/snippets/dry-run.md — preview trước bulk edit.
- .prompts/snippets/rollback-plan.md — backup + undo.
- .prompts/snippets/confirmation-gate.md — gom user input.
- .prompts/snippets/self-verify.md — 9-group checklist trước xuất.
- .prompts/snippets/halt-conditions.md — 23 điều kiện DỪNG.

## Rules cốt lõi (mirror từ .prompts/system/base.md)
1. Safety + accuracy first.
2. Cite file:line cho code thật.
3. Tuân thủ memory-bank + ADR Active.
4. Edit/Agent mode khi sửa file.
5. No hallucination.
6. Smallest safe change.
7. Separate fact / inference / guess.
8. Quality gate trước khi claim done.
9. Scope lock — không sửa ngoài scope.
10. Dry-run trước bulk edit.
11. Rollback plan bắt buộc.
12. Self-verify 9 nhóm trước xuất.
13. Comprehensive single-response + depth-first.
14. Output Evidence → Inference → Decision → Verification → Next steps.
```

→ Save.

### Bước 4 — Verify

Mở chat mới trong Antigravity, gõ:

```
follow your custom instructions

Tóm tắt project này dựa trên memory-bank.
```

Antigravity phải:
- Tóm tắt được project (name, mục tiêu, stack, đang làm gì NOW).
- Cite được file:line khi hỏi tiếp.
- Output có Confidence + Self-verify line.

Nếu không pass → kiểm tra workspace rules đã save và đã chọn đúng workspace.

---

## 3. Update rules khi skeleton đổi

Khi `.prompts/system/base.md` hoặc `AGENTS.md` được update (rules mới, snippet mới):
1. Mở Antigravity Workspace Rules.
2. Sync 5-10 dòng thay đổi (không cần paste lại toàn bộ nếu rules cốt lõi không đổi).
3. Save.

→ Mẹo: gắn 1 reminder trong `memory-bank/activeContext.md` ghi "Antigravity rules version: <date>" để biết khi nào cần sync.

---

## 4. Tips dùng Antigravity hiệu quả

### 4.1. Agent autonomous với confirmation gate

Antigravity agent có thể chạy nhiều bước. Để KHÔNG bị runaway:
- Trong workspace rules, nhấn mạnh: "BẮT BUỘC dùng Confirmation Gate khi > 3 file edit, destructive op, migration".
- Bắt đầu task với: `mode 1: <task>` để Agent tự multi-lens review trước khi action.

### 4.2. Memory-bank persistent

Antigravity không tự lưu memory ngoài rules. Để nó "nhớ" project:
- Đảm bảo workspace rules trỏ rõ tới `memory-bank/`.
- Sau mỗi task quan trọng, gõ `update memory bank` để Agent persist context vào file.

### 4.3. Combo Antigravity + Copilot trong cùng project

Antigravity giỏi multi-step autonomous, Copilot giỏi quick edit / single-line completion. Dùng cả 2:
- Quick edit / autocomplete → Copilot.
- Multi-file refactor / scaffold / debug loop → Antigravity.
- Cả 2 đọc cùng `memory-bank/`, không xung đột.

---

## 5. Troubleshooting

| Vấn đề | Nguyên nhân | Fix |
|---|---|---|
| Agent không tóm tắt được project | Workspace rules chưa save / chưa chọn đúng workspace | Mở Settings → Rules, kiểm tra workspace đang active |
| Agent bịa file:line | Rules force-cite chưa được paste | Re-paste workspace rules đầy đủ |
| Agent sửa file ngoài scope | Rule "Scope lock" chưa được paste | Add rule "Scope lock" vào user rules |
| Agent skip Confirmation Gate khi edit > 3 file | Rule "Dry-run before bulk edit" chưa rõ | Nhấn mạnh trong workspace rules |
| Agent không cite file:line | Force-cite snippet chưa reference | Paste lại workspace rules có line "Snippets bắt buộc reference" |

---

## 6. Đọc thêm

- [multi-tool-guide.md](multi-tool-guide.md) — setup các tool khác.
- [../../AGENTS.md](../../AGENTS.md) — full rules.
- [../../.prompts/system/base.md](../../.prompts/system/base.md) — 22 rules source of truth.
- [../USAGE-GUIDE.md](../USAGE-GUIDE.md) — bảng tra cứu tình huống → prompt.
