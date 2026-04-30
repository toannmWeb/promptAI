# CODEX.md — Entry file for OpenAI Codex / Codex CLI

> File này là entry point cho Codex (Codex CLI / OpenAI Codex agent / Codex IDE integration).
>
> **Nguồn sự thật**: [AGENTS.md](AGENTS.md). File này mirror 5 rules quan trọng nhất; mọi rule khác đọc từ `AGENTS.md`.

---

## Bootstrap (đọc theo thứ tự)

1. [ROADMAP.md](ROADMAP.md) — god view, biết tìm gì ở đâu.
2. [.prompts/system/base.md](.prompts/system/base.md) — 22 rules cốt lõi + halt + output format + self-verify.
3. [AGENTS.md](AGENTS.md) — full rules + persona + workflow commands + tool-specific notes.
4. 6 file core memory-bank:
   - [memory-bank/projectBrief.md](memory-bank/projectBrief.md)
   - [memory-bank/productContext.md](memory-bank/productContext.md)
   - [memory-bank/activeContext.md](memory-bank/activeContext.md)
   - [memory-bank/systemPatterns.md](memory-bank/systemPatterns.md)
   - [memory-bank/techContext.md](memory-bank/techContext.md)
   - [memory-bank/progress.md](memory-bank/progress.md)
5. [docs/USAGE-GUIDE.md](docs/USAGE-GUIDE.md) — bảng tra cứu tình huống → prompt.

---

## 5 rules quan trọng nhất (mirror từ AGENTS.md)

> Nếu xung đột với `.prompts/system/base.md` hoặc `AGENTS.md` → 2 file đó là source of truth.

1. **SAFETY + ACCURACY FIRST** — an toàn và chính xác ưu tiên tuyệt đối; không đánh đổi để lấy tốc độ, tiết kiệm token, hoặc làm hết trong 1 request.
2. **NO HALLUCINATION + CITE file:line** — không bịa file/function/API; mọi claim về code thật phải cite `file:line`. Áp dụng [.prompts/snippets/force-cite.md](.prompts/snippets/force-cite.md).
3. **SCOPE LOCK + DRY-RUN BEFORE BULK EDIT** — chỉ sửa file trong `Scope: edit allowed`; > 3 file / destructive / migration / prod config → bắt buộc dry-run + Confirmation Gate ([.prompts/snippets/dry-run.md](.prompts/snippets/dry-run.md)).
4. **ROLLBACK PLAN BẮT BUỘC** — mọi task edit-files / migration / refactor phải có rollback plan trước khi thực thi ([.prompts/snippets/rollback-plan.md](.prompts/snippets/rollback-plan.md)).
5. **SELF-VERIFY TRƯỚC KHI XUẤT** — đi qua checklist [.prompts/snippets/self-verify.md](.prompts/snippets/self-verify.md); nhóm fail → sửa hoặc nêu rõ. Output có dòng `**Self-verify**: N/9 nhóm pass`.

---

## Ngôn ngữ

Trả lời tiếng Việt có dấu đầy đủ trừ khi user yêu cầu khác. Code, identifier, command, path, placeholder giữ nguyên.

---

## Output format chuẩn

```
<câu trả lời theo cấu trúc Evidence → Inference → Decision → Verification → Next steps>

---
**Confidence**: low | medium | high
**Assumptions**: A-1: ...
**Verification commands**: `<cmd>` → expect: <result>
**Decision points**: D-1: ...
**Files touched**: ...
**Memory-bank impact**: ...
**Self-verify**: <N>/9 nhóm pass.
```

---

## Setup Codex

- **Codex CLI**: chạy với `codex --instructions CODEX.md` hoặc thêm path vào config.
- **Codex agent (cloud)**: dùng nội dung file này làm system prompt khi tạo task.
- **Codex IDE integration**: paste section "5 rules" + đường dẫn đến AGENTS.md vào project rules.

→ Chi tiết: [docs/setup/multi-tool-guide.md](docs/setup/multi-tool-guide.md).
