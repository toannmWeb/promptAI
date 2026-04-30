# Memory Bank

> AI memory persists between sessions through these markdown files.
> Pattern based on Cline Memory Bank (cline.bot, 1K+ stars community).

---

## Tại sao

LLM không nhớ giữa các session. Mỗi conversation = context bị reset. Memory Bank giải quyết bằng cách **lưu context dạng file MD** mà AI đọc đầu mọi task.

→ Sau khi initialize, AI có thể tiếp tục project sau 1 tuần / 1 tháng / 1 năm như chưa từng break.

## Hierarchy

```
projectBrief.md (foundation, 1 lần viết, ít sửa)
    │
    ├─→ productContext.md (why)
    ├─→ systemPatterns.md (how — architecture)
    └─→ techContext.md (what — stack)
            │
            └─→ activeContext.md (now — current focus)
                    │
                    └─→ progress.md (status — done/remaining)
```

→ `projectBrief.md` = nền tảng. Mọi file dưới phải nhất quán với nó.
→ `activeContext.md` = file cập nhật NHIỀU NHẤT (sau mỗi task lớn).
→ `progress.md` = trạng thái tổng (cập nhật khi feature done).

## Core Files (bắt buộc)

| File | Mục đích | Cập nhật |
|---|---|---|
| `projectBrief.md` | Project là gì, mục tiêu, scope | Hiếm (1-2 lần đời project) |
| `productContext.md` | Vấn đề giải quyết, user là ai, UX goals | Hiếm |
| `activeContext.md` | Đang làm gì NOW, recent changes, next steps | **NHIỀU** (sau mỗi task) |
| `systemPatterns.md` | Architecture, design patterns, layers | Khi có quyết định kiến trúc |
| `techContext.md` | Stack, setup, dependencies, constraints | Khi đổi stack/dep |
| `progress.md` | Done / Remaining / Issues | Khi feature done/start |

## Optional Files (tạo khi cần)

| File/Folder | Khi nào tạo |
|---|---|
| `glossary.md` | Project có nhiều thuật ngữ nghiệp vụ (đặc biệt nếu đa ngôn ngữ) |
| `features/<name>.md` | Feature lớn cần doc riêng (>500 LOC, multi-module) |
| `integrations/<name>.md` | Có tích hợp external service (auth, payment, analytics, ...) |
| `domains/<name>.md` | Project DDD, có domain rõ ràng cần modeling |

→ KHÔNG bắt buộc tạo từ đầu. Tạo khi project phát triển đến mức cần.

## Workflow

### Initialize (1 lần / project)

User gõ AI: `initialize memory bank`

→ AI quét code, fill 6 file core, đề xuất content. User review, adjust nếu cần.

### Daily

Đầu conversation mới, user gõ: `follow your custom instructions`

→ AI đọc tất cả memory-bank, tóm tắt context, sẵn sàng task.

### Update

Sau task quan trọng (feature done, decision made, refactor lớn):

User gõ: `update memory bank`

→ AI:
1. Review code thay đổi.
2. Cập nhật `activeContext.md` (current focus mới).
3. Cập nhật `progress.md` (mark done).
4. Cập nhật file liên quan khác (`systemPatterns.md` nếu architecture đổi, `techContext.md` nếu stack đổi).

## Best practices

1. **Concise > verbose**: Mỗi file < 500 dòng. Nếu dài hơn → split sang `features/` hoặc `domains/`.
2. **Latest > history**: `activeContext.md` chỉ chứa state HIỆN TẠI, không log toàn bộ history. History thuộc `_logs/` hoặc git.
3. **Confidence explicit**: AI phải mark Confidence ở cuối mỗi file.
4. **Cite file:line**: Khi reference code → cite path:line, không paraphrase.
5. **TODO placeholders**: Phần chưa biết → giữ `<TODO>`, KHÔNG bịa.
6. **Single source of truth**: Tránh duplicate info giữa các file. Nếu cần reference → link.

## Anti-patterns

- ❌ **Lưu chat history** vào memory-bank — dùng `_logs/` thay.
- ❌ **Lưu code dài** trong memory-bank — chỉ reference path:line.
- ❌ **Cập nhật `projectBrief.md` thường xuyên** — file này gần như immutable.
- ❌ **Bỏ qua `activeContext.md`** — đây là file QUAN TRỌNG NHẤT, AI dựa vào để biết "đang làm gì".
