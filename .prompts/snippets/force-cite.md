---
name: snippet-force-cite
purpose: Snippet ép AI cite file:line cho mọi claim về code
usage: paste vào cuối prompt
version: 1.0
---

# Snippet: Force Cite

```
CITE EVERY CLAIM:
- Khi nói về code, BẮT BUỘC cite `file:line` (vd: `lib/data/services/user_service.dart:42`).
- Khi nói về convention, cite ≥2 instance (vd: dùng pattern X tại file_a.dart:10 và file_b.dart:25).
- Khi nói về decision, cite ADR (vd: ADR-0003).
- Khi nói về requirement, cite PRP + AC ID (vd: PRP-007 AC-2).
- Khi nói về memory-bank, cite section (vd: memory-bank/systemPatterns.md "Repository pattern").

Nếu KHÔNG có evidence → nói "không thấy trong codebase loaded" thay vì đoán.
```
