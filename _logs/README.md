# Logs

> Lưu output AI quan trọng để tham khảo sau.

---

## Tại sao có folder này

- AI chat panel = ephemeral. Đóng IDE = mất chat.
- Output dài, khó copy lại sau.
- Reference history khi cần.

→ Lưu output AI quan trọng vào file `<YYYY-MM-DD>-<task>.md`.

## Khi nào lưu

- AI quét code và explain architecture (long output).
- AI đề xuất plan / approach mà bạn muốn reference.
- AI tổng hợp research mà mất thời gian re-generate.
- AI debug session với root cause đáng nhớ.

→ KHÔNG cần lưu:
- Câu trả lời ngắn 1-2 câu.
- Code đã accept (đã merge → có git).
- Q&A trivial.

## Cấu trúc

Mỗi file:

```markdown
# <task name>

> Date: <YYYY-MM-DD>
> AI tool: <Copilot / Cursor / Claude Code / ...>
> Mode: <Chat / Edit / Agent>

---

## Prompt

<paste prompt user gửi>

## Output

<paste AI response>

## Notes (optional)

<comments của user nếu có>
```

## Tên file

Format: `<YYYY-MM-DD>-<short-task>.md` (kebab-case).

Vd:
- `2026-04-29-explain-fe-architecture.md`
- `2026-05-02-debug-bloc-state-leak.md`
- `2026-05-10-research-offline-storage.md`

## Anti-patterns

- ❌ Lưu mọi chat → trash. Selective only.
- ❌ Lưu code dài → lỗi thời. Reference path:line từ git thay.
- ❌ Lưu thông tin secret/PII.

## Related folders

- Insight quan trọng từ logs → cập nhật `memory-bank/activeContext.md` hoặc `systemPatterns.md`.
- Pattern phát hiện → tạo `examples/<pattern>.md`.
- Decision → tạo `docs/adr/<n>.md`.
