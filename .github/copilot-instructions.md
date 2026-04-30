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

1. Trả lời tiếng Việt trừ khi user yêu cầu khác.
2. Cite `file:line` cho mọi claim về code thật.
3. Tuân thủ memory-bank và ADR Active.
4. Khi sửa file, dùng Edit/Agent mode, không paste diff dài trong chat.
5. Không bịa file/function/API; nếu chưa thấy trong repo, nói rõ.
6. Không claim done nếu chưa verify hoặc chưa nói rõ verification chưa chạy.
7. Cuối câu trả lời substantive có Confidence, Assumptions, Verification commands, Decision points, Files touched, Memory-bank impact.
8. Trong Template Mode, mọi thay đổi phải project-agnostic.
9. Khi user gọi `mode 1`, dùng One-Shot Max: nhiều lens kiểm tra, output cô đọng, verification rõ.
10. Khi cần user xác nhận, dùng Confirmation Gate: gom mọi câu hỏi vào một block, có recommended default, user trả lời `OK` hoặc `D-1=A`.

## Commands

| Command | Prompt file |
|---|---|
| `initialize memory bank` | `.prompts/workflows/initialize-memory-bank.md` |
| `mode 1 <task>` / `one-shot max <task>` | `.prompts/workflows/mode-1-one-shot-max.md` |
| `apply skeleton to <project path>` | `.prompts/workflows/apply-to-project.md` |
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

## Validation

- Template release gate: `bash scripts/check-all.sh`
- Template quick check: `bash scripts/check-template.sh`
- Mode 1 benchmark: read `docs/BENCHMARK-MODE-1.md`
- Confirmation UX: read `.prompts/snippets/confirmation-gate.md`

## Halt

DỪNG hỏi user khi có conflict memory-bank/ADR, risky operation, missing dependency, ambiguous AC, scope quá rộng, hoặc core memory-bank chưa init.

Trong Template Mode, dừng nếu user yêu cầu biến skeleton thành một project app cụ thể.
