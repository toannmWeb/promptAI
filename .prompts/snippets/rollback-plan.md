---
name: snippet-rollback-plan
purpose: Ép AI khai báo rollback plan trước khi sửa file / chạy migration / refactor
usage: paste vào prompt cho mọi workflow edit-files hoặc destructive-op
version: 1.0
last-updated: 2026-04-30
---

# Snippet: Rollback Plan

```
ROLLBACK PLAN BẮT BUỘC.

Mọi task sửa file, refactor, migration, hoặc thao tác có side-effect lớn PHẢI khai báo rollback plan TRƯỚC KHI thực thi.

## Format rollback plan

```text
## Rollback plan
- Trigger để rollback: <test fail / regression / user reject / smoke fail>
- Bước rollback (in order):
  1. <vd: `git checkout <sha>` hoặc `git revert <sha>`>
  2. <vd: restore backup từ `_logs/overwrite-backups/<ts>/`>
  3. <vd: chạy `npm install` để đồng bộ deps>
- Reversibility: high | medium | low
  - high: 1 lệnh git revert là xong.
  - medium: cần restore backup + re-run setup.
  - low: thay đổi không revert dễ (vd schema migration đã chạy production); cần migration ngược.
- Data safety:
  - DB change: có backup trước? snapshot/dump path?
  - File delete: file đã backup vào `_logs/<ts>/`?
  - Secret/config rotate: có ghi log thay đổi để rotate ngược?
- Time-to-rollback estimate: <phút>
- Người verify rollback: user / AI / CI.
```

## Quy tắc

1. Reversibility = low → BẮT BUỘC Confirmation Gate, không tự thực thi.
2. Mọi thao tác xóa file / overwrite ≥ 1 file phải có backup vào `_logs/<task>-<YYYYMMDD-HHMMSS>/` trước khi sửa.
3. Mọi thao tác trên git (rebase, reset --hard, force push, branch delete) phải có ghi `before-sha` để revert.
4. Mọi thao tác DB (migration, drop, truncate, mass update) phải có dry-run hoặc transaction nếu engine hỗ trợ.
5. Sau task, nếu rollback đã chạy, phải log vào `_logs/<task>-rollback.md` với lý do.

## Nếu không có rollback khả thi

- DỪNG.
- In Confirmation Gate giải thích lý do không rollback được.
- Đề xuất phương án: chia nhỏ task, tạo branch riêng, hoặc cancel.
```
