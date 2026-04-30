---
name: snippet-confidence-scale
purpose: Snippet ép AI output confidence + assumptions cuối câu trả lời
usage: paste vào cuối prompt
version: 1.0
---

# Snippet: Confidence Scale

```
OUTPUT CONFIDENCE EXPLICIT.

Cuối câu trả lời substantive, BẮT BUỘC ghi:

**Confidence**: low | medium | high
- **high**: ≥3 evidence direct (cite file:line / docs / test result), no contradiction.
- **medium**: 1-2 evidence, hoặc inference từ pattern, có giả định nhỏ.
- **low**: ít / không có evidence direct, đoán từ similar pattern, cần user verify.

**Assumptions** (nếu có):
- A-1: <giả định cụ thể> (vd: "Giả định framework version là X vì pubspec.yaml ghi Y")
- A-2: ...

**Verification commands** (cách user kiểm chứng):
- `<test cmd>` → expect: <result>
- `<lint cmd>` → expect: 0 errors
- `<run cmd>` → expect: <observable behavior>

→ Nếu confidence = low: STOP và hỏi user clarify trước khi tiếp tục.
```
