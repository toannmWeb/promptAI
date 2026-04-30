---
name: apply-to-project
purpose: Áp dụng master prompt-system skeleton vào một project thật mà không làm bẩn template gốc
input: <target project path + optional stack/domain hints>
output: Skeleton files copied/merged into target project + memory-bank initialized there
version: 1.0
last-updated: 2026-04-29
trigger-command: "apply skeleton to <project path>"
---

# Workflow: Apply Skeleton To Project

> Workflow này dùng khi repo master template đã ổn và bạn muốn áp dụng nó sang một project thật. Không chạy workflow này để fill memory-bank trong repo template gốc.

## Preconditions

- Source repo hiện tại đang ở **Template Mode** (`docs/TEMPLATE-MODE.md` exists).
- User cung cấp target project path rõ ràng.
- Target project là project thật có code/docs hoặc sẽ là project mới.

## Task Contract

Goal:
- Copy/merge master prompt-system skeleton vào một target project mà không làm bẩn repo template gốc và không phá instruction/docs hiện có của target.

Scope:
- Read source: `README.md`, `ROADMAP.md`, `AGENTS.md`, `.github/copilot-instructions.md`, `.prompts/`, `memory-bank/`, `docs/`, `scripts/`, `PRPs/`, `examples/`, `_logs/`.
- Read target: root docs/instruction files trước khi merge.
- Edit allowed: target project only, sau khi safety check và merge plan rõ ràng.
- Do not touch: source template files, target app code, target README nếu chưa có explicit confirmation.

Context:
- `docs/TEMPLATE-MODE.md`
- `.prompts/snippets/prompt-contract.md`
- `docs/PROMPT-VALIDITY.md`
- Target existing instruction files, cited by `file:line` where possible.

Acceptance criteria:
- AC-1: Source template validation is run or explicitly proposed: `./scripts/check-template.sh`.
- AC-2: Target path is confirmed and not equal to source path.
- AC-3: Existing target instruction/docs are read before merge and cited as `file:line`.
- AC-4: Merge plan lists create/merge/skip for every skeleton artifact.
- AC-5: Target README is not overwritten without explicit user confirmation.
- AC-6: Final output lists target files touched and next verification commands.

Execution mode:
- edit-files in target only after user approves merge plan.

Verification:
- Source: `./scripts/check-template.sh`
- Target after apply: `./scripts/check-memory-bank.sh` or `./scripts/check-memory-bank.sh --allow-template`

Output:
- Markdown safety check + merge plan + apply result.
- End with Confidence, Assumptions, Verification commands, Decision points, Files touched and Memory-bank impact.

Halt:
- Stop if target path is unclear, source equals target, or target files would be overwritten without confirmation.

Language:
- Trả lời TIẾNG VIỆT.

## Phase 1: Safety check

AI làm:

1. Xác nhận source là template:
   - `docs/TEMPLATE-MODE.md` exists.
   - `./scripts/check-template.sh` pass hoặc warnings đã hiểu.
2. Xác nhận target path:
   - Path tồn tại hoặc user muốn tạo mới.
   - Không trùng source template path.
3. Inventory target:
   - Có `AGENTS.md` chưa?
   - Có `.github/copilot-instructions.md` chưa?
   - Có `memory-bank/`, `docs/adr/`, `PRPs/`, `examples/`, `_logs/` chưa?
   - Có README project thật chưa?

HALT nếu target path không rõ hoặc source == target.

## Phase 2: Copy / merge plan

Output merge plan trước khi sửa target:

| Artifact | Action | Rule |
|---|---|---|
| `AGENTS.md` | create hoặc merge | Không overwrite instruction hiện có nếu chưa đọc |
| `.github/copilot-instructions.md` | create hoặc merge | Preserve existing Copilot rules |
| `.prompts/` | copy/update | Prompt library canonical từ template |
| `memory-bank/` | create if missing | Giữ template placeholders để initialize trong target |
| `docs/CHANGE-IMPACT.md` | create/customize | Sau đó chỉnh theo target stack |
| `docs/TEMPLATE-MODE.md` | usually do not copy | Target dùng Applied Project Mode; nếu copy thì đổi thành applied note |
| `scripts/` | copy/update | Preserve executable bits if possible |
| `README.md` | do not overwrite | Project README thuộc target |

## Phase 3: Apply files

AI dùng Edit/Agent mode hoặc file operations an toàn:

1. Copy prompt-system artifacts sang target.
2. Merge entry files nếu target đã có.
3. Không đè README project thật.
4. Không copy `_logs/` content cũ; chỉ tạo `_logs/README.md` nếu thiếu.
5. Nếu target đã có ADR/PRP/examples, merge folder không overwrite file cùng tên.

## Phase 4: Initialize target memory-bank

Trong target project, chạy workflow:

1. `initialize memory bank`
2. AI đọc code thật target.
3. Fill 6 core memory-bank bằng facts target.
4. Update target `ROADMAP.md` sections 1, 3, 5.
5. Customize target `docs/CHANGE-IMPACT.md` theo folder structure thật.

Không dùng facts của template repo.

## Phase 5: Verify target

Trong target:

```bash
./scripts/check-memory-bank.sh
./scripts/verify-prompt.sh <sample-prompt.md>
```

Nếu target là project mới chưa có code, dùng:

```bash
./scripts/check-memory-bank.sh --allow-template
```

và ghi rõ memory-bank chưa initialized.

## Output template

```markdown
# Apply Skeleton Result

## Source
- Template path: <path>
- Template check: pass/warn/fail

## Target
- Target path: <path>
- Target mode: Applied Project Mode | New Project Template Mode

## Files created / merged
| File/folder | Action | Notes |
|---|---|---|

## Next required actions
- Run `initialize memory bank` in target.
- Customize `docs/CHANGE-IMPACT.md`.
- Run `./scripts/check-memory-bank.sh`.

## Decision points needing user input
- D-1: <merge conflict / overwrite decision>

---
**Confidence**: <low|medium|high>
**Files touched**:
- <target files only>
```

## Halt conditions

DỪNG nếu:

- Target path chưa rõ.
- Target path trùng source template path.
- Existing target instruction files conflict và cần user chọn merge policy.
- User yêu cầu xóa project files để copy skeleton.
- Target chứa secrets hoặc generated/vendor folder mà workflow đang định copy/scan quá rộng.

## Prompt template

```
@workspace apply skeleton to project

Source template: <current repo path>
Target project: <absolute path>
Target stack/domain hints: <optional>

Workflow: .prompts/workflows/apply-to-project.md
Mode: source is Template Mode, target becomes Applied Project Mode.

Output: safety check + merge plan first. Do not overwrite target README or existing instructions without explicit confirmation.
```
