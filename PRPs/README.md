# PRPs (Product Requirement Prompts)

> File spec viết TRƯỚC khi code feature mới.
> Khái niệm từ coleam00/context-engineering-intro (13K stars).

---

## Tại sao có PRP

- AI cần FULL CONTEXT để generate code chất lượng.
- "Vibe coding" (chat ad-hoc) → AI thiếu context → output sai/duplicate/anti-pattern.
- PRP = "spec engineer + product manager + tech writer hội tụ vào 1 file" → AI có đủ thông tin để build end-to-end.

## Khi nào viết PRP

- Feature có > 50 LOC.
- Feature touch > 2 module.
- Feature có business rule không trivial.
- Feature cần test strategy rõ ràng.

→ KHÔNG cần PRP cho:
- Bug fix nhỏ.
- Refactor 1 file.
- Add log/instrumentation.

## Workflow

### 1. Tạo PRP

Copy `_template.md` thành `<n>-<feature-name>.md`. Số `<n>` tăng dần (001, 002, ...).

User gõ AI:
```
create PRP for <feature description>
```

→ AI quét code, search example pattern, fill template, đề xuất PRP.

### 2. Review PRP

Check:
- [ ] Goal rõ ràng.
- [ ] AC verifiable (Given/When/Then).
- [ ] Affected files đầy đủ.
- [ ] Test plan covers happy + edge + error.
- [ ] Validation commands (lệnh để verify).
- [ ] Decision points list (chỗ AI cần user input).

### 3. Execute PRP

User gõ AI:
```
execute PRPs/<n>-<feature-name>.md
```

→ AI implement theo plan, tự verify các validation commands.

### 4. Sau khi xong

- Update `memory-bank/progress.md` (mark done).
- Update `memory-bank/activeContext.md` (recent change).
- Tạo `memory-bank/features/<name>.md` nếu feature lớn.
- ADR mới nếu có decision kiến trúc.

## Numbering

- Tăng dần: `001-`, `002-`, `003-`, ...
- KHÔNG tái sử dụng số (kể cả khi PRP bị abandoned).
- Format: `<n>-<short-name>.md` (kebab-case).

Vd:
- `001-add-due-date.md`
- `002-photo-upload-batch.md`
- `003-offline-sync.md`

## Status convention

Trong PRP, ghi status:

- `Draft` — đang viết, chưa execute.
- `Approved` — review xong, sẵn sàng execute.
- `In Progress` — đang implement.
- `Done` — implemented + tested + merged.
- `Abandoned` — không làm nữa, giữ làm reference.
