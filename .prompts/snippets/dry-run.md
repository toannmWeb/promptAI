---
name: snippet-dry-run
purpose: Ép AI in change preview (dry-run) trước khi thực thi bulk edit / destructive op
usage: paste vào prompt khi task có thể sửa >3 file hoặc chạy lệnh có side effect lớn
version: 1.0
last-updated: 2026-04-30
---

# Snippet: Dry-Run Mode

```
DRY-RUN BẮT BUỘC TRƯỚC BULK EDIT / DESTRUCTIVE OP.

Khi task thuộc 1 trong các nhóm sau, AI PHẢI in change preview trước, KHÔNG được thực thi ngay:

- Sửa > 3 file trong cùng 1 task.
- Tạo / xóa / rename file hoặc folder.
- Chạy migration, schema change, seed/reset DB, drop/truncate/delete bulk.
- Force push, rewrite git history, reset hard, branch delete.
- Sửa file production config / secrets / `.env*` / CI deploy config.
- Mass refactor, codemod, regex replace toàn repo.
- Sửa prompt-system, hooks, scripts/* trong target project.

## Format dry-run

```text
🟡 DRY-RUN — sẽ chưa thực thi cho tới khi user xác nhận.

Plan summary:
- Goal: <outcome>
- Scope locked: <files/folders sẽ touch — explicit list>
- Files outside scope (NOT touch): <khẳng định>

Planned changes (preview):
| # | Action | Path | Reason | Reversibility |
|---|---|---|---|---|
| 1 | edit | path/a.md | … | high (git revert) |
| 2 | create | path/b.md | … | high (rm) |
| 3 | delete | path/c.md | … | medium (cần backup trước) |

Side-effect commands sẽ chạy:
- `<cmd>` — expected: <result>

Rollback plan:
- Bước 1: …
- Bước 2: …
- Backup location: `_logs/<...>/` hoặc git stash / branch.

Risks:
- <risk + mitigation>

Confirmation gate:
- Reply `OK` để proceed nguyên plan.
- Reply `OK except #2,#3` để loại 1 phần.
- Reply `STOP` để hủy.
```

## Sau khi user OK
- Áp dụng đúng plan, không thêm file ngoài plan.
- Nếu phát hiện nhánh phụ cần sửa, DỪNG, in dry-run thứ 2, không tự mở rộng scope.
- Sau khi thực thi, cite từng file:line đã sửa.

## Khi không cần dry-run
- Sửa ≤ 3 file, mỗi file < 30 dòng diff, reversible bằng git revert đơn giản.
- Analysis-only / review-only output.
- Sửa duy nhất 1 file user vừa nhắc rõ tên trong cùng câu.

Trong các trường hợp này vẫn phải cite file:line + verification, nhưng có thể bỏ bảng plan.
```
