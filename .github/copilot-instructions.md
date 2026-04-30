# Copilot Instructions — prompt-system-skeleton v3.1+

> GitHub Copilot entrypoint. Nội dung này mirror các rule quan trọng của `AGENTS.md`, rút gọn để Copilot luôn load nhanh.
>
> Repo master này chạy ở **Template Mode**: đây là skeleton dùng chung cho mọi dự án, không phải app cụ thể.

## Bootstrap bắt buộc

Đầu mọi task, đọc theo thứ tự:

1. `ROADMAP.md`
2. `.prompts/system/base.md`
3. `docs/TEMPLATE-MODE.md` nếu tồn tại.
4. `docs/REQUEST-MODES.md` nếu user nói `mode 1`, `one-shot max`, hoặc muốn tối đa hóa 1 request.
5. 6 core memory-bank files:
   - `memory-bank/projectBrief.md`
   - `memory-bank/productContext.md`
   - `memory-bank/activeContext.md`
   - `memory-bank/systemPatterns.md`
   - `memory-bank/techContext.md`
   - `memory-bank/progress.md`

Nếu đang trong repo master template, `<TODO>` trong memory-bank là placeholder có chủ đích. Không fill bằng facts giả. Nếu đang trong project thật đã apply skeleton, core memory-bank còn `<TODO>` thì hỏi user hoặc chạy initialize memory bank.

## Prompt Contract

Trước task substantive, dựng Task Contract:

- Goal: outcome cụ thể.
- Scope: read/edit/no-touch.
- Context: ROADMAP, memory-bank, ADR, PRP, examples, workflow refs.
- Acceptance: AC testable.
- Execution mode: analysis-only | edit-files | review-only | generate-artifact.
- Verification: commands + expected result.
- Output: format cuối cùng.
- Halt: điều kiện phải dừng hỏi user.

Nếu prompt thô mơ hồ, dùng `.prompts/tasks/optimize-prompt.md` trước khi thực thi.

## Rules

> Rút gọn từ 24 rules trong `.prompts/system/base.md`. Khi conflict, `base.md` thắng.

1. An toàn và chính xác ưu tiên tuyệt đối; không đánh đổi để lấy tốc độ, tiết kiệm token, hoặc làm hết trong 1 request.
2. Trả lời tiếng Việt có dấu đầy đủ trừ khi user yêu cầu khác. Code, identifier, command, path, placeholder giữ nguyên.
3. Cite `file:line` cho mọi claim về code thật; áp dụng `.prompts/snippets/force-cite.md`.
4. Tuân thủ memory-bank và ADR Active.
5. Khi sửa file, dùng Edit/Agent mode, không paste diff dài.
6. Không bịa file/function/API; chưa thấy → nói rõ "không thấy trong codebase loaded".
7. Ưu tiên smallest safe change — thay đổi nhỏ, reversible, theo pattern hiện có.
8. Separate fact / inference / guess — facts có cite, inference nói rõ, guess đẩy vào Assumptions hoặc Decision points.
9. Không claim done nếu chưa verify hoặc chưa nói rõ verification chưa chạy.
10. Cuối câu trả lời substantive có cấu trúc Evidence → Inference → Decision → Verification → Next steps + Confidence, Assumptions, Decision points, Files touched, Memory-bank impact, Self-verify.
11. Trong Template Mode, mọi thay đổi phải project-agnostic.
12. Mode 1 → multi-lens (Code/Architecture/Security/Performance/DX + Mary/Winston/Amelia/Casey/Quinn) cô đọc, depth-first 1-3 vấn đề trọng yếu, chỉ sau khi risk preflight đạt.
13. Confirmation Gate khi cần user input: gom mọi câu hỏi vào 1 block, recommended default, reply `OK` / `D-1=A` / `STOP`.
14. **SCOPE LOCK**: chỉ sửa file trong `Scope: edit allowed`; cần mở scope → DỪNG hỏi.
15. **DRY-RUN BEFORE BULK EDIT**: sửa > 3 file, mass refactor, destructive, migration, production config → bắt buộc preview + Confirmation Gate (`.prompts/snippets/dry-run.md`).
16. **ROLLBACK PLAN**: mọi edit-files / migration / refactor phải có plan undo + backup trước khi thực thi (`.prompts/snippets/rollback-plan.md`).
17. **SELF-VERIFY**: trước khi xuất output, đi qua `.prompts/snippets/self-verify.md`; nhóm fail sửa hoặc nêu rõ.
18. **CONTEXT MUST READ**: mọi file khai báo trong `Context to load` phải được đọc thật sự trong phiên, không trả lời từ "trí nhớ".
19. **INLINE INPUT**: cần input → gom mọi câu hỏi vào 1 Confirmation Gate cùng response; KHÔNG nói "hỏi tôi ở request sau".
20. **CONTINUATION HANDOFF**: output không fit 1 response → làm tối đa + lưu progress vào `memory-bank/activeContext.md` + in block `⏩ TIẾP TỤC REQUEST SAU` với prompt copy-paste cho user.

## Commands

| Command | Prompt file |
|---|---|
| `follow your custom instructions` | `.prompts/system/base.md` |
| `initialize memory bank` | `.prompts/workflows/initialize-memory-bank.md` |
| `mode 1 <task>` / `one-shot max <task>` | `.prompts/workflows/mode-1-one-shot-max.md` |
| `apply skeleton to <project path>` | `.prompts/workflows/apply-to-project.md` |
| `overwrite prompt system in <project path>` / `force apply skeleton to <project path>` | `.prompts/workflows/overwrite-prompt-system.md` |
| `update memory bank` | `.prompts/workflows/update-memory-bank.md` |
| `debug loop <bug>` | `.prompts/workflows/debug-loop.md` |
| `deep dive into <module>` | `.prompts/workflows/deep-dive-learn.md` |
| `refactor safely <scope>` | `.prompts/workflows/refactor-safe.md` |
| `feature end-to-end <name>` | `.prompts/workflows/feature-end-to-end.md` |
| `optimize prompt <draft>` | `.prompts/tasks/optimize-prompt.md` |
| `audit template` | `.prompts/tasks/audit-template.md` |
| `verify output` | `.prompts/tasks/verify-output.md` |
| `plan feature <name>` | `.prompts/tasks/plan-feature.md` |
| `trace flow <action>` | `.prompts/tasks/trace-flow.md` |
| `explain module <path>` | `.prompts/tasks/explain-module.md` |
| `extract pattern <name>` | `.prompts/tasks/extract-pattern.md` |
| `document feature <name>` | `.prompts/tasks/document-feature.md` |
| `party mode <topic>` | `.prompts/personas/party-mode.md` |

## Validation

- Template release gate: `bash scripts/check-all.sh`
- Template quick check: `bash scripts/check-template.sh`
- Mode 1 benchmark: read `docs/BENCHMARK-MODE-1.md`
- Confirmation UX: read `.prompts/snippets/confirmation-gate.md`

## Halt

DỪNG hỏi user khi có conflict memory-bank/ADR, risky operation, missing dependency, ambiguous AC, scope quá rộng, hoặc core memory-bank chưa init.

Trong Template Mode, dừng nếu user yêu cầu biến skeleton thành một project app cụ thể.
