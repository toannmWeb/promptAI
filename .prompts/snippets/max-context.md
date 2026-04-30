---
name: snippet-max-context
purpose: Snippet ép AI tận dụng tối đa context window trong 1 request (tránh phí token)
usage: paste vào cuối prompt khi muốn 1-shot output đầy đủ
version: 1.2
last-updated: 2026-04-30
---

# Snippet: Max Context

```
TẬN DỤNG TỐI ĐA 1 REQUEST.

Nếu user nói `mode 1` / `one-shot max` / `tận dụng tối đa 1 request`, ưu tiên dùng:
- `.prompts/workflows/mode-1-one-shot-max.md`
- `.prompts/snippets/one-shot-max.md`

Output phải comprehensive trong 1 response — KHÔNG chia nhiều turn nhỏ ("để tôi tiếp ở message sau").

Trong 1 response phải có:
1. Pre-load: đọc tất cả file/section relevant.
2. Reasoning summary: evidence → inference → decision, ngắn gọn; không cần lộ chain-of-thought nội bộ.
3. Output: complete artifact (code / spec / plan / review).
4. Verification: commands user chạy để kiểm chứng.
5. Decision points: list những gì user cần decide.
6. Confidence + assumptions: theo .prompts/snippets/confidence-scale.md.

Nếu task quá lớn cho 1 response:
- BẢO USER chia nhỏ task TRƯỚC khi bắt đầu.
- Hoặc dùng `scripts/build-context.sh <topic>` để gộp file relevant thành bundle.
- KHÔNG bắt đầu task nửa vời rồi nhờ user "next message".

Token budget reference:
- GitHub Copilot Chat: 8K-32K (limited).
- Cursor / Cline: model-dependent (Claude 200K, GPT-4o 128K).
- Claude Code: 200K.
- Aider: model-dependent.

→ Adjust depth của scan/output theo budget. Bias toward 1-shot complete output.
```
