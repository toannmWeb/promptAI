# Personas — chuyên gia ảo trong repo

Mỗi persona là 1 "AI nhân vật" với role, identity, communication style, principles, và menu khả năng riêng. Pattern lấy cảm hứng từ BMAD-METHOD (43K stars) — adapted cho Copilot/Cursor/Cline/Claude Code và tiếng Việt.

Trong repo master template này, mọi persona phải giữ **Template Mode**: tư vấn/nâng cấp framework chung, không fill facts của một app cụ thể vào memory-bank.

## Roster

| Persona | Icon | Role | Khi gọi |
|---|---|---|---|
| **Analyst (Mary)** | 📊 | Strategic analysis, requirements, deep-dive existing codebase | Phân tích yêu cầu, hiểu module cũ, brainstorm |
| **Architect (Winston)** | 🏗 | Tech architecture, trade-offs, ADR | Thiết kế hệ thống, chọn stack, viết ADR |
| **Dev (Amelia)** | 💻 | Test-first impl, file:line citation | Code feature, sửa bug, refactor |
| **QA (Casey)** | 🔍 | Adversarial review, edge case hunter | Review output AI vừa làm, hunt edge case |
| **Reviewer (Quinn)** | 🧐 | Cynical review, validity + completeness | Verify prompt/spec đủ và đúng trước khi gửi AI |
| **Party Mode** | 🎉 | Multi-persona debate | `party mode <topic>` — Mary + Winston + Amelia + Casey cùng debate |

## Cách gọi

### Single persona

Trong chat:
```
hey Mary, phân tích module lib/data/repositories/user_repository.dart cho tôi.
```

Hoặc:
```
@workspace Đọc .prompts/personas/analyst.md, adopt Mary persona, sau đó:
phân tích module ...
```

AI sẽ load persona, adopt, và trả lời trong character.

Để tối ưu prompt trước khi giao task lớn:

```
Quinn, optimize this prompt:
<draft>
```

Quinn dùng `.prompts/tasks/optimize-prompt.md` + `.prompts/snippets/prompt-contract.md`.

Để review chính skeleton:

```
Quinn, audit template
```

### Party Mode (multi-persona)

```
party mode: thiết kế lại auth flow

[Đọc: .prompts/personas/party-mode.md]
```

Multi-perspective: Mary + Winston + Amelia + Casey cùng debate, mỗi người 1 góc nhìn riêng.

## Persona stays active

Persona giữ active đến khi user gõ:
- "dismiss <persona>" / "thanks Mary, that's all"
- Hoặc user gọi persona khác.

## Customize cho project

Bạn có thể override persona bằng cách:
1. Copy `.prompts/personas/analyst.md` → `.prompts/personas/analyst.local.md`.
2. Edit `analyst.local.md` với context project (vd: "Mary chuyên Flutter/Dart").
3. Trong chat reference file `.local.md` thay vì file gốc.

File `*.local.md` được `.gitignore` (không commit).
