---
name: sample-quick-install
purpose: Copy toàn bộ prompt-system skeleton vào project có sẵn code, rồi initialize memory-bank — chỉ cần 2 prompt copy-paste
input: source-skeleton=<skeleton path> + target-project=<project path>
output: Skeleton files installed + memory-bank initialized với facts từ code thật
version: 1.0
last-updated: 2026-04-30
---

# Sample: Quick Install

> 2 prompt, không giải thích dài. Copy → sửa path → paste → chạy.

## Khi nào dùng

- Project đã có code, muốn áp dụng hệ thống prompt skeleton vào.
- Muốn làm nhanh, không cần đọc workflow dài.

## Khi KHÔNG dùng

- Project đã có skeleton cũ lệch chuẩn → dùng `overwrite prompt system in <project path>`.
- Chỉ muốn khám phá project, không muốn cài skeleton → dùng `samples/explore-project.md`.

---

## Bước 1 — Install skeleton vào project

Copy prompt dưới đây, **sửa 2 dòng trong `USER INPUT`**, paste vào AI chat.

```
follow your custom instructions

Task: install prompt-system skeleton vào project có sẵn code.

USER INPUT — CHỈ SỬA 2 DÒNG NÀY:
[[USER_EDIT_BLOCK]]
- Source skeleton: <absolute-path-to-skeleton-repo>
- Target project: <absolute-path-to-target-project>
END USER INPUT

Goal:
- Copy prompt-system artifacts từ source skeleton sang target project.
- Không ghi đè README, app code, .git.
- Nếu target đã có file cùng tên (AGENTS.md, .github/copilot-instructions.md, ...) → backup vào `_logs/install-backup/<timestamp>/` trước khi ghi đè.

Scope — copy từ source sang target:
- AGENTS.md
- GEMINI.md
- CODEX.md
- .github/copilot-instructions.md
- .prompts/ (toàn bộ folder)
- memory-bank/ (toàn bộ folder — giữ template placeholder)
- scripts/ (toàn bộ folder)
- samples/ (toàn bộ folder)
- docs/CHANGE-IMPACT.md
- docs/PROMPT-VALIDITY.md
- docs/REQUEST-MODES.md
- docs/BENCHMARK-MODE-1.md
- docs/TEMPLATE-MODE.md
- docs/USAGE-GUIDE.md
- docs/benchmarks/ (toàn bộ folder)
- docs/adr/README.md + docs/adr/_template.md
- docs/runbooks/ (toàn bộ folder)
- docs/setup/ (toàn bộ folder nếu có)
- PRPs/README.md + PRPs/_template.md
- examples/README.md + examples/_template.md
- _logs/README.md
- ROADMAP.md

Scope — KHÔNG copy:
- README.md (thuộc project thật)
- .git/
- CHANGELOG.md, DESIGN-RATIONALE*.md, GETTING-STARTED.md (thuộc skeleton repo)
- docs/TEMPLATE-MODE.md → copy nhưng thêm note "Đây là applied project, không phải master template"

Execution:
1. Verify source path có `.prompts/system/base.md` (chứng tỏ là skeleton repo).
2. Verify target path tồn tại và ≠ source path.
3. Nếu target đã có file trong scope → backup trước.
4. Copy files/folders.
5. In danh sách files đã copy và files đã backup.

Output format:
- Bảng: File/Folder | Action (created / overwritten+backup / skipped) | Notes
- Nếu có lỗi: dừng, giải thích.

Sau khi xong, in dòng: "✅ Skeleton installed. Chạy Bước 2 để initialize memory-bank."

Language: tiếng Việt có dấu. Code/path/command giữ nguyên.
```

---

## Bước 2 — Initialize memory-bank từ code thật

Sau khi Bước 1 xong, copy prompt dưới đây, **sửa 1 dòng**, paste vào AI chat.

```
follow your custom instructions

Task: initialize memory bank

USER INPUT — CHỈ SỬA 1 DÒNG NÀY:
[[USER_EDIT_BLOCK]]
- Project root: <absolute-path-to-target-project>
END USER INPUT

Workflow: .prompts/workflows/initialize-memory-bank.md (9 steps).

Scan code thật trong project root, infer answers, fill 6 file memory-bank/*.md + ROADMAP.md sections 1, 5.

Dùng Edit mode để TỰ SỬA file. Cite assumption explicitly. Confidence per file.

Output cuối: list <TODO> chỗ user cần fill.

Language: tiếng Việt có dấu. Code/path/command giữ nguyên.
```

---

## Tóm tắt

| Bước | Prompt | Kết quả |
|---|---|---|
| 1 | Install skeleton | Files skeleton copied vào project |
| 2 | Initialize memory-bank | 6 file memory-bank + ROADMAP filled từ code thật |

Sau 2 bước, project đã sẵn sàng dùng mọi workflow/task/persona trong hệ thống prompt.
