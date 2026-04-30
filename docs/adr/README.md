# Architecture Decision Records (ADRs)

> Immutable records of architectural decisions.
> Concept by Michael Nygard, 2011.

---

## Tại sao có ADR

- Decisions thường BIẾN MẤT khỏi memory team sau 6 tháng.
- Code thay đổi, nhưng "tại sao chúng ta chọn X thay vì Y" thường không ai nhớ.
- ADR = "git for decisions" — version-controlled, immutable history.

## Khi nào viết ADR

- Quyết định kiến trúc có impact > 1 module.
- Lựa chọn library / framework chính.
- Đổi pattern đang dùng (vd Provider → BLoC).
- Trade-off có ít nhất 1 alternative đáng cân nhắc.
- Constraint mới (security, performance, compliance).

→ KHÔNG cần ADR cho:
- Code style choice (dùng linting config).
- Bug fix.
- Refactor đơn thuần (không đổi public API).

## Quy tắc immutability

- **ADR đã Active KHÔNG sửa nội dung**.
- Muốn đổi quyết định → tạo ADR MỚI với status "Supersedes ADR-XXXX".
- ADR cũ giữ status "Superseded by ADR-YYYY".
- Lý do: lịch sử suy nghĩ phải nguyên vẹn.

## Status

| Status | Meaning |
|---|---|
| `Proposed` | Đang được thảo luận, chưa quyết. |
| `Accepted` | Quyết rồi, đang Active. |
| `Deprecated` | Không còn dùng, nhưng chưa replace. |
| `Superseded by ADR-XXXX` | Bị thay bởi ADR mới. |

## Numbering

- Tăng dần: `0001-`, `0002-`, ... (4 chữ số).
- KHÔNG tái sử dụng số.
- Format: `<n>-<short-title>.md` (kebab-case).

Vd:
- `0001-flutter-bloc-as-state-management.md`
- `0002-go-router-for-routing.md`
- `0003-offline-storage-with-hive.md`

## Workflow

### Tạo ADR

User gõ AI:
```
create ADR for <decision title>
```

→ AI:
1. Hỏi user về context, options, trade-offs.
2. Fill `_template.md` thành `<n>-<title>.md`.
3. Đề xuất status `Proposed`.

### Review

Team review trong PR. Mỗi ADR PR cần ≥ 1 reviewer (tech lead).

### Promote to Accepted

Sau khi PR merged + decision implemented → đổi status `Proposed` → `Accepted`.

### Update memory-bank

Sau khi `Accepted`:
- Cập nhật `memory-bank/systemPatterns.md` để link đến ADR.
- Nếu impact stack → cập nhật `memory-bank/techContext.md`.

## Anti-patterns

- ❌ Sửa ADR đã Accepted → tạo ADR mới supersede.
- ❌ Viết ADR sau khi code đã merged (lost the "why").
- ❌ Bỏ phần "Alternatives considered" → mất 50% giá trị ADR.
- ❌ ADR dài > 2 trang → thường là viết quá chi tiết, không actionable.
