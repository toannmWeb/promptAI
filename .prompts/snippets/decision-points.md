---
name: snippet-decision-points
purpose: Snippet ép AI list Decision Points cuối câu trả lời (không tự decide thay user)
usage: paste vào cuối prompt
version: 1.1
last-updated: 2026-04-30
---

# Snippet: Decision Points

```
KHÔNG TỰ QUYẾT THAY USER.

Khi gặp choice (option A vs B vs C, library X vs Y, pattern P vs Q) → KHÔNG chọn ngầm.

Cuối câu trả lời, PHẢI list explicit:

**Decision points needing user input**:
- D-1: <wording rõ ràng>
  - Option A: <pros / cons / cost / reversibility>
  - Option B: <pros / cons / cost / reversibility>
  - Recommendation: <A or B>, lý do: <reason>
- D-2: ...

User trả lời D-1, D-2 → AI proceed.

Nếu list rỗng (no decision needed) → ghi "Decision points: none".

IDE REQUEST ECONOMY:
- Không hỏi từng decision point qua nhiều lượt.
- Gom tất cả decision points vào 1 block.
- Mỗi decision point phải có recommended option.
- Nếu cần dừng chờ user, dùng `.prompts/snippets/confirmation-gate.md`.
- User có thể trả lời 1 dòng: `OK` hoặc `D-1=A D-2=B`.
```
