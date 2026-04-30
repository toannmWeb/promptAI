---
name: overwrite-prompt-system
purpose: Ghi đè prompt/instruction cũ trong target project bằng chuẩn template hiện tại, có backup và confirmation gate
input: <target project path + overwrite scope>
output: Prompt-system artifacts trong target được thay bằng bản template, các file cũ được backup trước khi ghi đè
version: 1.0
last-updated: 2026-04-30
trigger-command: "overwrite prompt system in <project path>"
aliases:
  - "force apply skeleton to <project path>"
  - "reset prompts to template in <project path>"
---

# Workflow: Overwrite Prompt System

> Workflow này dùng khi target project đã có prompt/instruction cũ, lệch chuẩn, hoặc lộn xộn, và user muốn thay bằng chuẩn từ master template.
> Đây là workflow ghi đè có kiểm soát, không phải merge nhẹ như `apply skeleton to <project path>`.

## Khi nào dùng

Dùng workflow này khi:

- Target project đã có `AGENTS.md`, `.github/copilot-instructions.md`, `.prompts/` cũ nhưng không chuẩn.
- User muốn lấy prompt system từ master template làm nguồn sự thật duy nhất.
- Việc merge thủ công dễ tạo xung đột hoặc giữ lại rule cũ sai.

Không dùng workflow này khi:

- User chỉ muốn thêm skeleton lần đầu vào project sạch. Dùng `apply skeleton to <project path>`.
- User chưa chắc muốn mất nội dung prompt/instruction cũ.
- Target project đang có memory-bank đã điền facts thật và user không cho phép reset memory-bank.

## Task Contract

Goal:
- Backup rồi ghi đè prompt-system artifacts trong target bằng bản từ master template hiện tại.

Scope:
- Source đọc từ repo template hiện tại.
- Target được sửa trong project path user cung cấp.
- Không sửa app code.
- Không xóa file ngoài scope.
- Không ghi đè target `README.md`.

Default overwrite scope:
- `AGENTS.md`
- `.github/copilot-instructions.md`
- `.prompts/`
- `docs/REQUEST-MODES.md`
- `docs/PROMPT-VALIDITY.md`
- `docs/BENCHMARK-MODE-1.md`
- `docs/benchmarks/`
- `scripts/check-all.sh`
- `scripts/check-template.sh`
- `scripts/check-memory-bank.sh`
- `scripts/check-impact.sh`
- `scripts/build-context.sh`
- `scripts/verify-prompt.sh`
- `scripts/new-adr.sh`

Default preserve scope:
- `README.md`
- app source code
- `.git/`
- `memory-bank/` đã initialize
- `ROADMAP.md` đã customize cho project thật
- `docs/CHANGE-IMPACT.md` đã customize theo project thật
- `docs/adr/`
- `PRPs/`
- `examples/`
- `_logs/`

Legacy/tool-specific instruction files to scan:
- `.github/instructions/`
- `.cursor/rules/`
- `.clinerules/`
- `GEMINI.md`
- `CLAUDE.md`
- `.windsurfrules`
- `.aider.conf.yml`
- `.continue/`
- `.roo/`

These files can conflict with the template even if `AGENTS.md` and `.github/copilot-instructions.md` are overwritten. Do not delete them silently; inventory them, back them up, and ask user whether to preserve, disable, or overwrite.

Context:
- `docs/TEMPLATE-MODE.md`
- `.prompts/workflows/apply-to-project.md`
- `.prompts/snippets/confirmation-gate.md`
- Target existing prompt/instruction files.

Acceptance criteria:
- AC-1: Source template path và target project path được xác nhận, không trùng nhau.
- AC-2: Target existing prompt/instruction files được inventory trước khi ghi đè.
- AC-3: AI tạo backup trong target trước khi overwrite.
- AC-4: AI in overwrite plan và chờ confirmation gate trước khi sửa.
- AC-5: Không ghi đè `README.md`, app code, `.git/`, hoặc memory-bank facts nếu user không chọn reset.
- AC-6: Sau khi overwrite, chạy hoặc đề xuất validation phù hợp.

Execution mode:
- Decision-gated overwrite. Không sửa file cho tới khi user xác nhận bằng `OK` hoặc decision codes.

Verification:
- Source template: `bash scripts/check-template.sh`
- Target after overwrite: `bash scripts/check-memory-bank.sh --allow-template` nếu target chưa initialize, hoặc `bash scripts/check-memory-bank.sh` nếu target đã initialize.
- Prompt file sanity: `bash scripts/verify-prompt.sh .prompts/system/base.md`

Language:
- Trả lời TIẾNG VIỆT CÓ DẤU.
- Mọi từ/câu tiếng Việt phải dùng đầy đủ dấu tiếng Việt; không viết tiếng Việt không dấu.

## Phase 1: Safety check

AI làm:

1. Xác nhận source là master template:
   - Có `docs/TEMPLATE-MODE.md`.
   - Có `.prompts/system/base.md`.
   - Chạy hoặc đề xuất `bash scripts/check-template.sh`.
2. Xác nhận target:
   - Path tồn tại.
   - Target không trùng source template path.
   - Target không nằm bên trong source template path.
3. Inventory target:
   - `AGENTS.md`
   - `.github/copilot-instructions.md`
   - `.prompts/`
   - `memory-bank/`
   - `ROADMAP.md`
   - `docs/CHANGE-IMPACT.md`
   - `docs/adr/`
   - `PRPs/`
   - `examples/`
   - `_logs/`
   - legacy/tool-specific instruction files:
     - `.github/instructions/`
     - `.cursor/rules/`
     - `.clinerules/`
     - `GEMINI.md`
     - `CLAUDE.md`
     - `.windsurfrules`
     - `.aider.conf.yml`
     - `.continue/`
     - `.roo/`

HALT nếu target path không rõ, source trùng target, hoặc user yêu cầu xóa app code.

## Phase 2: Overwrite plan

AI phải in bảng trước khi sửa:

| Artifact | Action | Reason |
|---|---|---|
| `AGENTS.md` | overwrite after backup | Entry chung cần theo template chuẩn |
| `.github/copilot-instructions.md` | overwrite after backup | Copilot entry cần mirror rule mới |
| `.prompts/` | replace after backup | Prompt library cần dùng chuẩn template |
| `scripts/*.sh` | overwrite after backup | Validation tooling cần đồng bộ |
| `docs/REQUEST-MODES.md` | overwrite after backup | Request mode là prompt-system rule |
| `docs/PROMPT-VALIDITY.md` | overwrite after backup | Prompt validity là rule chung |
| `docs/BENCHMARK-MODE-1.md` + `docs/benchmarks/` | overwrite after backup | Benchmark là artifact template |
| `README.md` | preserve | README thuộc project thật |
| `memory-bank/` | preserve by default | Có thể chứa facts thật của project |
| `ROADMAP.md` | preserve by default | Có thể đã customize cho project thật |
| `docs/CHANGE-IMPACT.md` | preserve by default | Thường là per-project |
| `docs/adr/`, `PRPs/`, `examples/`, `_logs/` | preserve by default | Có thể chứa artifacts thật |

## Phase 3: Confirmation Gate

AI phải hỏi một lần duy nhất:

```text
INPUT NEEDED — Ghi đè prompt system trong target project

Why blocked:
- Đây là thao tác overwrite, có thể thay thế instruction/prompt cũ của target.
- Workflow sẽ backup trước, nhưng user vẫn cần chọn scope.

Recommended default:
- D-1=A, D-2=Y, D-3=P, D-4=I — overwrite prompt-only, backup bắt buộc, preserve memory-bank/ROADMAP, chỉ inventory legacy instructions.

Reply with one line:
- OK → dùng recommended default.
- D-1=A D-2=Y D-3=P D-4=I → chọn cụ thể.
- STOP → dừng task.

Decision points:
- D-1: Overwrite scope?
  - A: Prompt-only (recommended) — overwrite entry/prompt/scripts/docs prompt-system, preserve project facts.
  - B: Full skeleton reset — overwrite toàn bộ skeleton artifacts trừ README/app code/.git; rủi ro cao hơn.
- D-2: Backup before overwrite?
  - Y: Yes (required) — tạo backup trong `_logs/overwrite-backups/<timestamp>/`.
  - N: No — không được khuyến nghị; AI phải HALT nếu user chọn N.
- D-3: Memory-bank và ROADMAP?
  - P: Preserve (recommended) — giữ facts thật của project.
  - R: Reset to template — chỉ dùng khi user muốn bỏ toàn bộ context cũ và initialize lại.
- D-4: Legacy/tool-specific instruction files?
  - I: Inventory only (recommended) — liệt kê file cũ, không sửa nếu chưa có quyết định riêng.
  - B: Backup and disable — backup rồi đổi tên file/folder cũ sang `.disabled` để tránh conflict.
  - O: Overwrite/delete after backup — rủi ro cao; chỉ dùng khi user chắc chắn không cần rule cũ.
```

Nếu user chọn `D-2=N`, AI phải dừng và giải thích rằng overwrite không backup là không được phép trong workflow này.

## Phase 4: Backup

Trước khi overwrite, AI tạo backup trong target:

```text
_logs/overwrite-backups/<YYYYMMDD-HHMMSS>/
```

Backup các file/folder sắp bị ghi đè. Nếu folder `_logs/` chưa có, tạo `_logs/overwrite-backups/...`.

Backup manifest:

```text
_logs/overwrite-backups/<YYYYMMDD-HHMMSS>/MANIFEST.md
```

Manifest cần ghi:

- Source template path.
- Target project path.
- Timestamp.
- Decision codes user đã chọn.
- Danh sách file/folder backup.
- Danh sách file/folder overwrite.

## Phase 5: Overwrite

AI chỉ overwrite các artifact đúng scope đã xác nhận.

Quy tắc:

- Copy từ source template sang target.
- Không xóa app code.
- Không overwrite `README.md`.
- Không overwrite `memory-bank/` nếu `D-3=P`.
- Không overwrite `ROADMAP.md` nếu `D-3=P`.
- Không overwrite `docs/CHANGE-IMPACT.md` nếu preserve project facts.
- Nếu cần thay folder `.prompts/`, backup folder cũ trước rồi replace.
- Với legacy/tool-specific instruction files, chỉ làm đúng lựa chọn D-4:
  - `I`: chỉ report trong output.
  - `B`: backup rồi disable bằng cách đổi tên có hậu tố `.disabled`.
  - `O`: backup rồi overwrite/delete theo plan đã xác nhận.

## Phase 6: Verify

Trong target project, chạy hoặc đề xuất:

```bash
bash scripts/check-memory-bank.sh
```

Nếu target vừa reset memory-bank hoặc là project mới chưa initialize:

```bash
bash scripts/check-memory-bank.sh --allow-template
```

Nếu shell không chạy được, AI phải nói rõ chưa verify bằng script.

## Output template

```markdown
# Overwrite Prompt System Result

## Source
- Template path: <path>
- Template validation: pass/warn/fail/not run

## Target
- Target path: <path>
- Scope: Prompt-only | Full skeleton reset
- Backup path: `_logs/overwrite-backups/<timestamp>/`

## Files overwritten
| Path | Action |
|---|---|

## Files preserved
| Path | Reason |
|---|---|

## Verification
- `<command>` — pass/fail/not run

---
**Confidence**: low | medium | high
**Assumptions**:
- A-1: ...
**Verification commands**:
- `<cmd>`
**Decision points needing user input**:
- none
**Files touched**:
- `<target path>` — overwritten prompt-system artifacts
**Memory-bank impact**:
- `memory-bank/activeContext.md` — update recommended nếu target là project thật và overwrite prompt system là thay đổi đáng ghi nhớ
```

## Prompt template

```text
overwrite prompt system in <PROJECT_PATH>

Use workflow: .prompts/workflows/overwrite-prompt-system.md

Goal:
- Replace old/non-standard prompt instructions in target with this template's prompt system.

Safety:
- Backup before overwrite.
- Print overwrite plan first.
- Do not overwrite README, app code, .git, memory-bank, ROADMAP, or project-specific docs unless I explicitly choose reset.
- Wait for confirmation gate before editing.
```
