# Domains

> Optional folder. Tạo khi project áp dụng DDD (Domain-Driven Design) hoặc có domain rõ ràng cần modeling.

---

## Khi nào tạo `domains/<name>.md`

- Project có > 3 bounded contexts rõ ràng.
- Có domain expert ngoài tech (cần ngôn ngữ chung).
- Code organize theo domain (vd `lib/domains/<name>/`).
- Có rule nghiệp vụ phức tạp (state machine, validation, derived value).

## Cấu trúc

Copy từ `_template.md`. File chứa:

1. **Bounded context** — ranh giới, ngôn ngữ chung (ubiquitous language).
2. **Entities** — đối tượng có ID, lifecycle.
3. **Value objects** — đối tượng immutable, không có ID.
4. **Aggregates** — root entity + children.
5. **Domain events** — sự kiện business-significant.
6. **Domain services** — logic không thuộc entity nào.
7. **Invariants** — rule luôn đúng, không vi phạm.
8. **State transitions** — state machine nếu có.

## Tên file

Format: `<domain-name>.md` (kebab-case, singular).

Vd:
- `user.md`
- `site.md`
- `order.md`
- `inventory.md`
