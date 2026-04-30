# Code Pattern Examples

> Reusable patterns extracted from project, with sample code.
> Mục đích: AI và dev mới copy/adapt nhanh thay vì viết lại.

---

## Tại sao có folder này

- AI có context tốt khi có example → output match style codebase.
- Dev mới onboard nhanh khi thấy "do it like this".
- Decisions đã code-ified → không drift theo thời gian.

## Khi nào tạo example

- Pattern xuất hiện ≥ 3 lần trong codebase.
- Pattern non-trivial (> 20 LOC, đặc biệt nếu có async/error handling).
- Pattern liên quan đến ADR hoặc architecture decision.
- Pattern dễ làm sai (gotchas).

→ KHÔNG cần example cho:
- Code straightforward (1 file, 1 function).
- Code dùng 1 lần.
- Code copy-able từ official docs (link tốt hơn).

## Cấu trúc

Mỗi file `<pattern>.md` chứa:

1. **What** — pattern là gì, problem nó solve.
2. **When to use** — tình huống áp dụng.
3. **When NOT to use** — anti-cases.
4. **Code template** — copy-able skeleton.
5. **Real example from codebase** — link `path:line`.
6. **Gotchas** — pitfall thường gặp.
7. **Variations** — biến thể cho case đặc biệt.
8. **Related** — link đến ADR, feature, ...

## Tên file

Format: `<pattern-name>.md` (kebab-case).

Vd:
- `repository-pattern.md`
- `bloc-with-error-handling.md`
- `infinite-scroll-list.md`
- `api-call-with-retry.md`

## Workflow

### Extract pattern from existing code

User gõ AI:
```
extract pattern <name> from <file:line>
```

→ AI:
1. Đọc code thật.
2. Generalize thành template.
3. Tạo `<name>.md` từ `_template.md`.
4. User review.

### Use pattern

Trong AI chat:
```
Implement <feature> following examples/<pattern>.md
```

→ AI áp dụng pattern.

## Anti-patterns

- ❌ Lưu code production thật (sẽ outdated). Lưu **template + link đến code thật**.
- ❌ Copy-paste examples vào nhiều chỗ → maintain song song. Reference duy nhất từ examples.
- ❌ Tạo example cho pattern chưa stable (đang debate trong ADR).
