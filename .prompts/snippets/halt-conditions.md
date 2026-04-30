---
name: snippet-halt-conditions
purpose: Snippet ép AI DỪNG khi gặp conditions risky/ambiguous thay vì proceed
usage: paste vào cuối prompt
version: 1.1
last-updated: 2026-04-30
---

# Snippet: Halt Conditions

```
DỪNG, KHÔNG TỰ TIẾP TỤC, hỏi user khi:

1. **Conflict** giữa user instruction và memory-bank/ADR Active.
2. **Pattern violation**: yêu cầu user phá pattern đã establish trong systemPatterns.md.
3. **Empty memory-bank**: file CORE memory-bank rỗng / chứa <TODO>.
4. **Out of scope**: task vượt scope rõ ràng của repo (vd code repo khác).
5. **Risky operation**: xóa file, force-push, rewrite git history, drop database, change DB schema.
6. **Spec ambiguous**: AC trong PRP mơ hồ / không testable.
7. **Conflicting requirements** trong cùng 1 prompt: instruction A và B mâu thuẫn.
8. **Missing dependency**: cần file/secret/credential chưa có.
9. **Unreproducible bug**: sau 3 iteration debug-loop vẫn không repro.
10. **Out of token budget**: task quá lớn cho context window — chia nhỏ trước.

Khi DỪNG, output:
- "🛑 HALT — <reason>"
- Cite source: <which file/instruction>.
- Options for user: A. ... | B. ... | C. ...
- Recommendation: <which option>.
- Confirmation Gate: user có thể trả lời `OK` để dùng recommendation, hoặc `D-1=A D-2=N`, hoặc `STOP`.

KHÔNG tiếp tục cho đến khi user resolve.
Gom mọi câu hỏi trong 1 message; không hỏi rải rác nhiều lượt nếu có thể tránh.
```
