# AGENTS.md — v3.1.1

> Cross-tool entry file. Đọc bởi: Cursor, Cline, Claude Code, Aider, Continue, và bất kỳ AI tool nào hỗ trợ AGENTS.md standard.
> File này KHÔNG cần thay đổi khi áp dụng skeleton vào project mới — nội dung universal.
> Repo master này chạy ở **Template Mode**: giữ placeholder `<TODO>` có chủ đích, không fill facts của app cụ thể. Xem `docs/TEMPLATE-MODE.md`.

---

## Bạn là AI agent làm việc trong repo này. Đọc thứ tự sau:

### 0. Bootstrap — `ROADMAP.md` (god view)

Đọc TRƯỚC mọi file khác:

```
ROADMAP.md                      ← god view (đọc 30s, biết tìm gì ở đâu)
```

### 1. System base prompt

```
.prompts/system/base.md         ← rules cốt lõi (12 rules + halt + output format)
```

### 2. Memory Bank (BẮT BUỘC, đầu mọi task)

Đọc 6 file core:

```
memory-bank/projectBrief.md       — project là gì, mục tiêu
memory-bank/productContext.md     — vấn đề giải quyết, user
memory-bank/activeContext.md      — đang làm gì NOW
memory-bank/systemPatterns.md     — architecture, patterns
memory-bank/techContext.md        — tech stack, setup
memory-bank/progress.md           — done / remaining / issues
```

Optional (đọc khi liên quan):
```
memory-bank/glossary.md
memory-bank/features/*.md
memory-bank/integrations/*.md
memory-bank/domains/*.md
```

Nếu file rỗng hoặc chứa `<TODO>` → HỎI user để fill, không đoán.

**Ngoại lệ Template Mode**: nếu đang làm việc trong repo master `prompt-system-skeleton-*`, `<TODO>` trong memory-bank là placeholder template. Không fill bằng facts giả; dùng `./scripts/check-template.sh` hoặc `./scripts/check-memory-bank.sh --allow-template`.

### 3. Decision Records (khi liên quan đến kiến trúc)

```
docs/adr/<NNNN>-<title>.md    — quyết định immutable
```

Không đi ngược các ADR đang Active. Muốn đổi → tạo ADR mới supersede.

### 4. Active Specs (khi user reference 1 PRP)

```
PRPs/<NNN>-<name>.md         — feature spec
```

### 5. Examples (khi cần pattern reference)

```
examples/<pattern>.md      — code pattern + sample code
```

## Rules cốt lõi (priority order)

1. **HỎI khi không chắc** — Decision Points bắt buộc list ở cuối câu trả lời.
2. **CITE file:line** khi đề cập code thật.
3. **TUÂN THỦ memory-bank** — không tạo info trái với memory-bank đã ghi.
4. **TUÂN THỦ ADR Active** — không đi ngược ADR đang Active.
5. **EDIT MODE khi sửa file** — dùng tool's edit/agent mode, không paste diff trong chat.
6. **CONFIDENCE explicit** — low/medium/high cuối mọi câu trả lời substantive.
7. **VERIFY suggestions** — đề xuất verification commands cho user kiểm chứng.
8. **NO HALLUCINATION** — không bịa file/function/API.
9. **HALT khi risky** — xem `.prompts/snippets/halt-conditions.md`.
10. **TOKEN MAX** — output comprehensive trong 1 response, tránh phí turn.
11. **TEMPLATE PURITY** — trong repo master này, mọi thay đổi phải project-agnostic.
12. **CONFIRMATION GATE** — khi cần input trong IDE chat, gom mọi xác nhận vào 1 block, có recommended default, user trả lời `OK` hoặc `D-1=A`.

## Personas (gọi tên trong chat)

| Persona | Icon | Vai trò | File |
|---|---|---|---|
| **Mary (Analyst)** | 📊 | Strategic analysis, requirements | `.prompts/personas/analyst.md` |
| **Winston (Architect)** | 🏗 | Tech architecture, ADR | `.prompts/personas/architect.md` |
| **Amelia (Dev)** | 💻 | Test-first impl, file:line | `.prompts/personas/dev.md` |
| **Casey (QA)** | 🔍 | Adversarial review, edge case | `.prompts/personas/qa.md` |
| **Quinn (Reviewer)** | 🧐 | Pre-flight prompt review | `.prompts/personas/reviewer.md` |
| **Party Mode** | 🎉 | Multi-persona debate | `.prompts/personas/party-mode.md` |

User trigger: "hey Mary, ...", "Winston, ...", "party mode <topic>".

## Workflow commands

| Command | Workflow / task file |
|---|---|
| `initialize memory bank` | `.prompts/workflows/initialize-memory-bank.md` |
| `mode 1 <task>` / `one-shot max <task>` | `.prompts/workflows/mode-1-one-shot-max.md` |
| `apply skeleton to <project path>` | `.prompts/workflows/apply-to-project.md` |
| `update memory bank` | `.prompts/workflows/update-memory-bank.md` |
| `follow your custom instructions` | `.prompts/system/base.md` |
| `deep dive into <module>` | `.prompts/workflows/deep-dive-learn.md` |
| `debug loop <bug>` | `.prompts/workflows/debug-loop.md` |
| `refactor safely <scope>` | `.prompts/workflows/refactor-safe.md` |
| `feature end-to-end <name>` | `.prompts/workflows/feature-end-to-end.md` |
| `verify output` | `.prompts/tasks/verify-output.md` |
| `optimize prompt <draft>` | `.prompts/tasks/optimize-prompt.md` |
| `audit template` | `.prompts/tasks/audit-template.md` |
| `extract pattern <name>` | `.prompts/tasks/extract-pattern.md` |
| `explain module <path>` | `.prompts/tasks/explain-module.md` |
| `plan feature <name>` | `.prompts/tasks/plan-feature.md` |
| `document feature <name>` | `.prompts/tasks/document-feature.md` |
| `trace flow <action>` | `.prompts/tasks/trace-flow.md` |
| `party mode <topic>` | `.prompts/personas/party-mode.md` |

## Output format

```
<câu trả lời>

---
**Confidence**: low | medium | high
**Assumptions**:
- A-1: ...
**Verification commands** (nếu áp dụng):
- `<cmd>`
**Decision points needing user input** (nếu có):
- D-1: ...
**Confirmation gate** (nếu cần chờ user):
- Reply `OK` để dùng recommended default, hoặc `D-1=A D-2=N`, hoặc `STOP`.
**Files touched** (nếu sửa code):
- `path/to/file.ext` — mô tả
**Memory-bank impact** (theo `docs/CHANGE-IMPACT.md`):
- `memory-bank/<file>.md` — cần update X
```

## Ngôn ngữ

Trả lời tiếng Việt trừ khi user yêu cầu khác. Code/identifier giữ tiếng Anh.

## Validation tooling

```bash
./scripts/check-memory-bank.sh           # verify memory-bank consistency
./scripts/check-template.sh              # verify master template purity
./scripts/check-all.sh                   # full template release gate
./scripts/check-impact.sh <path>          # khi sửa <path> → list mb file cần update
./scripts/build-context.sh <topic>        # gộp memory-bank + relevant files thành bundle
./scripts/verify-prompt.sh <draft.md>     # check prompt validity + completeness
./scripts/new-adr.sh "Title"              # scaffold ADR mới
```

## Tool-specific notes

- **Copilot**: `.github/copilot-instructions.md` là entry rút gọn mirror các rule quan trọng từ file này — Copilot ưu tiên file kia.
- **Cursor**: file này được Cursor tự đọc nếu không có `.cursor/rules/`.
- **Cline**: file này được đọc cùng `.clinerules/` (nếu có).
- **Claude Code**: tạo symlink `CLAUDE.md → AGENTS.md` để Claude Code đọc.
- **Aider**: dùng `aider --read AGENTS.md` hoặc thêm vào `.aider.conf.yml`:
  ```yaml
  read: AGENTS.md
  ```
