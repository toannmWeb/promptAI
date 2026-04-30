# `.prompts/` — Canonical Prompt Library

> **Mục đích**: Loại bỏ vấn đề "mỗi project tạo prompt khác nhau, không đồng nhất". Đây là thư viện prompt CHUẨN, copy-paste vào IDE chat (Copilot, Cursor, Cline, Claude Code, Aider).

---

## Cấu trúc

```
.prompts/
├── system/              ← Rules cốt lõi cho AI (đọc đầu mọi conversation)
│   └── base.md
├── personas/            ← Personas chuyên môn (gọi tên trong chat)
│   ├── README.md
│   ├── analyst.md       ← Mary 📊 — Strategic analysis
│   ├── architect.md     ← Winston 🏗 — Tech architecture
│   ├── dev.md           ← Amelia 💻 — Test-first impl
│   ├── qa.md            ← Casey 🔍 — Adversarial QA
│   ├── reviewer.md      ← Quinn 🧐 — Cynical review
│   └── party-mode.md    ← Multi-persona debate
├── workflows/           ← Multi-step workflows (vòng lặp, có state)
│   ├── apply-to-project.md
│   ├── mode-1-one-shot-max.md
│   ├── deep-dive-learn.md
│   ├── debug-loop.md
│   ├── refactor-safe.md
│   ├── feature-end-to-end.md
│   ├── initialize-memory-bank.md
│   └── update-memory-bank.md
├── tasks/               ← Single-step tasks (1 prompt 1 output)
│   ├── explain-module.md
│   ├── extract-pattern.md
│   ├── verify-output.md
│   ├── audit-template.md
│   ├── plan-feature.md
│   ├── document-feature.md
│   ├── trace-flow.md
│   └── optimize-prompt.md
└── snippets/            ← Snippets gắn vào prompt khác (composable)
    ├── force-cite.md
    ├── decision-points.md
    ├── confidence-scale.md
    ├── max-context.md
    ├── one-shot-max.md
    ├── confirmation-gate.md
    ├── halt-conditions.md
    └── prompt-contract.md
```

---

## Cách dùng

### Cách 0: Master template mode

Repo gốc này là **master template**. Khi nâng cấp chính skeleton:

```
audit template
```

Khi áp dụng skeleton sang project thật:

``` 
apply skeleton to <project path>
```

Không chạy `initialize memory bank` trong repo master template này để fill facts của app cụ thể.

Nếu target project đã có prompt/instruction cũ và user muốn thay bằng chuẩn template thay vì merge:

```
overwrite prompt system in <project path>
```

Workflow này dùng `.prompts/workflows/overwrite-prompt-system.md`, backup trước khi ghi đè và phải có confirmation gate.

### Cách 0.5: Mode 1 — One-Shot Max

Khi muốn tận dụng tối đa 1 request:

```
mode 1: <task>
```

AI sẽ dùng `.prompts/workflows/mode-1-one-shot-max.md` + `.prompts/snippets/one-shot-max.md`: nhiều lens kiểm tra, output cô đọng, có verification và decision points.

Khi cần user xác nhận trong IDE chat, AI dùng `.prompts/snippets/confirmation-gate.md` để bạn trả lời một dòng như `OK` hoặc `D-1=A D-2=N`.

### Cách 1: Copy-paste trực tiếp

1. Mở file prompt phù hợp (vd `.prompts/workflows/debug-loop.md`).
2. Đọc section "Prompt template".
3. Copy nội dung trong block ```` ```prompt ```` .
4. Paste vào IDE chat (Copilot Chat, Cursor Chat, ...).
5. Điền các placeholder `<...>` trước khi Enter.

### Cách 2: Tham chiếu

Trong chat AI:
```
@workspace Đọc file .prompts/workflows/debug-loop.md và làm theo workflow này
cho bug: <mô tả bug>.
```

### Cách 3: Composable snippets

Snippets được thiết kế để gắn vào prompt khác:

```
<prompt chính của bạn>

[Đọc thêm: .prompts/snippets/force-cite.md, .prompts/snippets/decision-points.md]
```

### Cách 4: Optimize prompt trước khi chạy

Khi prompt thô còn mơ hồ hoặc task có rủi ro, dùng prompt optimizer:

```
@workspace optimize prompt:

Raw prompt:
<paste prompt thô>

Task: .prompts/tasks/optimize-prompt.md
Apply: .prompts/snippets/prompt-contract.md
```

Output sẽ là prompt đã chuẩn hóa Goal / Scope / Context / Acceptance Criteria / Verification / Halt / Output format.

---

## Ngôn ngữ

Tất cả prompt mặc định **tiếng Việt có dấu**. Nếu cần tiếng Anh:
- Đổi dòng "Trả lời TIẾNG VIỆT CÓ DẤU" → "Reply in ENGLISH".

---

## Khi nào tạo prompt mới

Tạo prompt mới khi:
- Cùng 1 task lặp ≥3 lần với cấu trúc giống nhau.
- Workflow phức tạp >3 step có thể tái sử dụng.

Đặt vào folder phù hợp:
- **system/**: rules áp cho mọi AI session.
- **personas/**: 1 persona/role với value system riêng.
- **workflows/**: multi-step, có vòng lặp / state.
- **tasks/**: single-step, 1 prompt → 1 output.
- **snippets/**: ngắn (≤30 dòng), composable.

---

## Versioning

Mỗi file prompt có header:

```markdown
---
name: <prompt-name>
purpose: <1 dòng>
input: <gì user phải cung cấp>
output: <gì AI sẽ trả>
version: 1.0
last-updated: YYYY-MM-DD
---
```

Khi update prompt, bump version + cập nhật `last-updated`.

---

## Map command → prompt file

Xem `ROADMAP.md` section 6 — bảng đầy đủ.
