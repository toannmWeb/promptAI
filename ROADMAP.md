# ROADMAP — `<PROJECT_NAME>`

> **Đây là god view của project.** Đọc TRƯỚC khi đọc bất kỳ file nào khác. Nhìn vào file này → biết hiểu cấu trúc, tìm gì ở đâu, đang làm gì, tiếp theo gì.
>
> **Version**: 1.0 · **Cập nhật cuối**: `<YYYY-MM-DD>` · **Skeleton**: prompt-system-skeleton v3.2
>
> **Template Mode**: Repo này là master template prompt-system dùng chung cho mọi dự án. Không fill memory-bank bằng facts project cụ thể trong repo này; xem `docs/TEMPLATE-MODE.md`.

---

## 1. Project là gì (30 giây đọc)

`<TODO 1-2 câu>` — ví dụ: "Hệ thống quản lý log vận hành công trường, FE Flutter web."

- **Stage**: `<idea | poc | mvp | growth | mature | legacy>`
- **Primary stack**: `<TODO>` (vd: Flutter 3.x · Dart · Firebase · go_router · flutter_bloc)
- **Repository type**: `<single-app | monorepo | multi-part>` (BE + FE + mobile, ...)
- **Owners**: `<TODO>` (1-3 người chính + email/handle)
- **Liên hệ trợ giúp**: `<TODO>` (Slack channel, doc page, ...)

---

## 2. Quick Navigation (đọc 30 giây tìm gì ở đâu)

| Câu hỏi | Đọc file |
|---|---|
| Project là gì, mục tiêu? | `memory-bank/projectBrief.md` |
| Tại sao project tồn tại? | `memory-bank/productContext.md` |
| Đang làm gì NOW? | `memory-bank/activeContext.md` |
| Architecture, design pattern? | `memory-bank/systemPatterns.md` |
| Tech stack, setup, constraints? | `memory-bank/techContext.md` |
| Done / Remaining / Issues? | `memory-bank/progress.md` |
| Glossary thuật ngữ? | `memory-bank/glossary.md` |
| Setup local dev? | `docs/runbooks/local-dev.md` |
| Debug khi gặp bug? | `docs/runbooks/debug.md` |
| Quyết định kiến trúc nào đã làm? | `docs/adr/` (mỗi file 1 quyết định) |
| Code pattern X làm sao? | `examples/<pattern>.md` |
| Spec feature đang làm? | `PRPs/<n>-<name>.md` |
| Output AI cần lưu? | `_logs/<date>-<task>.md` |
| Khi sửa code X cần update gì? | `docs/CHANGE-IMPACT.md` |
| Trước khi gửi prompt cần check gì? | `docs/PROMPT-VALIDITY.md` |
| Đây là template hay project thật? | `docs/TEMPLATE-MODE.md` |
| Muốn tối đa hóa 1 request? | `docs/REQUEST-MODES.md`, `.prompts/workflows/mode-1-one-shot-max.md` |
| Muốn AI hỏi xác nhận ít request nhất trong IDE? | `.prompts/snippets/confirmation-gate.md` |
| Muốn biết Mode 1 có đạt chất lượng không? | `docs/BENCHMARK-MODE-1.md`, `docs/benchmarks/mode-1/*.md` |
| Prompt mẫu cho task X? | `.prompts/` (phân theo workflows / tasks / snippets) |

---

## 3. Map by topic (mở rộng theo project)

> Hàng loạt domain/feature/integration trong project này. Khi cần làm việc với 1 mảng → tới đây trước.

| Topic / Domain | Where to look | Status |
|---|---|---|
| `<user-auth>` | `memory-bank/features/auth.md`, `memory-bank/integrations/<auth-provider>.md`, `docs/adr/0002-auth-strategy.md` | active |
| `<data-layer>` | `memory-bank/features/<data-feature>.md`, `docs/adr/0003-<data-decision>.md` | active |
| `<reporting>` | `memory-bank/features/<report-feature>.md`, `examples/<report-pattern>.md` | planned |
| ... | ... | ... |

> Khi tạo feature/domain/integration mới: thêm 1 row vào bảng này + tạo file tương ứng dưới `memory-bank/features/` hoặc `memory-bank/domains/`.

---

## 4. Folder structure tổng quan

```
<PROJECT>/
├── ROADMAP.md                       ← BẠN ĐANG Ở ĐÂY (god view)
├── README.md                        ← Project README
├── AGENTS.md                        ← Cross-tool AI entry
├── .github/copilot-instructions.md  ← Copilot-specific entry
│
├── memory-bank/                     ← Long-term project memory (đọc TRƯỚC mọi task)
│   ├── projectBrief.md              ★ CORE
│   ├── productContext.md            ★ CORE
│   ├── activeContext.md             ★ CORE (cập nhật nhiều nhất)
│   ├── systemPatterns.md            ★ CORE
│   ├── techContext.md               ★ CORE
│   ├── progress.md                  ★ CORE
│   ├── glossary.md                  ◇ Optional
│   ├── features/<name>.md           ◇ Optional (per-feature)
│   ├── integrations/<name>.md       ◇ Optional (per-integration)
│   └── domains/<name>.md            ◇ Optional (DDD domains)
│
├── .prompts/                        ← Canonical prompt library (copy-paste vào IDE chat)
│   ├── system/                      — Rules cốt lõi cho AI
│   ├── personas/                    — Personas chuyên môn (Analyst/Architect/Dev/QA/Reviewer)
│   ├── workflows/                   — Multi-step workflows (debug-loop, deep-dive, ...)
│   ├── tasks/                       — Single-step tasks (explain-module, plan-feature, ...)
│   └── snippets/                    — Reusable snippets (cite, decision-points, ...)
│
├── scripts/                         ← Validation framework (chạy thủ công)
│   ├── check-memory-bank.sh         — Verify memory-bank consistency
│   ├── check-template.sh            — Verify master template purity
│   ├── check-all.sh                 — Run full template validation gate
│   ├── check-impact.sh              — Khi sửa code X → file nào cần update
│   ├── build-context.sh             — Tạo "context bundle" cho prompt lớn
│   ├── verify-prompt.sh             — Check prompt đủ context refs
│   └── new-adr.sh                   — Scaffold ADR mới
│
├── PRPs/                            ← Feature specs (write before code)
│   ├── README.md
│   ├── _template.md
│   └── <NNN>-<feature>.md
│
├── docs/
│   ├── CHANGE-IMPACT.md             ← Lookup: sửa code X → update file Y
│   ├── PROMPT-VALIDITY.md           ← Checklist trước khi gửi prompt
│   ├── REQUEST-MODES.md             ← Request modes (Mode 1/2/3)
│   ├── TEMPLATE-MODE.md             ← Master template vs applied project
│   ├── BENCHMARK-MODE-1.md          ← Rubric đo chất lượng Mode 1
│   ├── adr/                         ← Decision records (immutable)
│   │   ├── README.md
│   │   ├── _template.md
│   │   └── <NNNN>-<title>.md
│   └── runbooks/                    ← How-to-do guides
│       ├── local-dev.md
│       └── debug.md
│
├── examples/                        ← Code pattern library
│   ├── README.md
│   ├── _template.md
│   └── <pattern>.md
│
└── _logs/                           ← AI output archive (selective)
    ├── README.md
    └── <YYYY-MM-DD>-<task-slug>.md
```

---

## 5. Current sprint / focus

> Pulled từ `memory-bank/activeContext.md`. Cập nhật mỗi khi đổi sprint/focus.

**Sprint hiện tại**: `<TODO sprint name | YYYY-MM-DD → YYYY-MM-DD>`

**Mục tiêu chính**:
- `<TODO>`
- `<TODO>`

**Đang làm**:
- `<feature/task #1>` — owner: `<name>` — status: `<in-progress | review | blocked>`
- `<feature/task #2>` — owner: `<name>` — status: `<in-progress | review | blocked>`

**Đã làm gần đây** (3-5 mục):
- `<task>` (`<date>`)

**Tiếp theo**:
- `<task>`
- `<task>`

**Blocker / risk**:
- `<TODO>` — owner: `<name>` — ETA: `<date>`

---

## 6. Workflow commands AI hỗ trợ

> Bạn (user) gõ vào AI chat để trigger workflow. AI sẽ đọc file `.prompts/...` tương ứng và thực hiện.

| Command | AI làm gì | Prompt file |
|---|---|---|
| `initialize memory bank` | Lần đầu fill 6 file core từ codebase | `.prompts/workflows/initialize-memory-bank.md` |
| `mode 1 <task>` | One-Shot Max: nhiều lens kiểm tra, output cô đọng, tối đa hóa 1 request | `.prompts/workflows/mode-1-one-shot-max.md` |
| `apply skeleton to <project path>` | Copy/merge master template vào project thật | `.prompts/workflows/apply-to-project.md` |
| `overwrite prompt system in <project path>` | Ghi đè prompt/instruction cũ bằng chuẩn template, có backup + confirmation gate | `.prompts/workflows/overwrite-prompt-system.md` |
| `update memory bank` | Cập nhật memory-bank sau task | `.prompts/workflows/update-memory-bank.md` |
| `follow your custom instructions` | Đọc memory-bank, tóm tắt, sẵn sàng | `.prompts/system/base.md` |
| `deep dive into <module>` | Học cực sâu 1 module + lưu doc | `.prompts/workflows/deep-dive-learn.md` |
| `debug loop <bug>` | Vòng lặp scan → hypothesis → fix → verify → loop | `.prompts/workflows/debug-loop.md` |
| `refactor safely <scope>` | Refactor không phá code (test-first) | `.prompts/workflows/refactor-safe.md` |
| `feature end-to-end <name>` | Plan → PRP → impl → verify → update mb | `.prompts/workflows/feature-end-to-end.md` |
| `verify output` | Adversarial review output AI vừa làm | `.prompts/tasks/verify-output.md` |
| `optimize prompt <draft>` | Biến prompt thô thành task contract đủ context + AC + verification | `.prompts/tasks/optimize-prompt.md` |
| `audit template` | Review master template: universality, consistency, scripts, command map | `.prompts/tasks/audit-template.md` |
| `extract pattern <name>` | Tạo `examples/<name>.md` từ code thật | `.prompts/tasks/extract-pattern.md` |
| `explain module <path>` | Giải thích module + sequence diagram | `.prompts/tasks/explain-module.md` |
| `plan feature <name>` | Brainstorm + tạo PRP draft | `.prompts/tasks/plan-feature.md` |
| `document feature <name>` | Tạo `memory-bank/features/<name>.md` sau khi feature ship | `.prompts/tasks/document-feature.md` |
| `trace flow <action>` | Trace 1 user action qua các tầng | `.prompts/tasks/trace-flow.md` |
| `party mode <topic>` | Multi-perspective: Analyst + Architect + Dev + QA cùng debate | `.prompts/personas/party-mode.md` |

> Xem chi tiết các persona: `.prompts/personas/README.md`.

---

## 7. Active personas (gọi tên trong chat)

| Persona | Icon | Vai trò | File |
|---|---|---|---|
| **Analyst** | 📊 | Strategic analysis, requirements, deep-dive existing system | `.prompts/personas/analyst.md` |
| **Architect** | 🏗 | Tech architecture, trade-offs, ADR | `.prompts/personas/architect.md` |
| **Dev** | 💻 | Test-first impl, file:line citation, AC-driven | `.prompts/personas/dev.md` |
| **QA** | 🔍 | Adversarial review, edge case, find ≥10 issues | `.prompts/personas/qa.md` |
| **Reviewer** | 🧐 | Cynical review, validity + completeness check | `.prompts/personas/reviewer.md` |

User trigger: "hey Analyst, ...", "Winston, ...", hoặc gõ command "party mode <topic>".

---

## 8. Validation tooling

```bash
# Check memory-bank consistency (run weekly)
./scripts/check-memory-bank.sh

# Check master template purity (run trong repo skeleton gốc)
./scripts/check-template.sh

# Release gate: chạy toàn bộ validation
./scripts/check-all.sh

# Khi sửa code in <path>, list file memory-bank cần update
./scripts/check-impact.sh <path>

# Build context bundle (gộp file relevant cho prompt lớn)
./scripts/build-context.sh <topic> > /tmp/context-bundle.md

# Verify prompt drafted có đủ context refs không
./scripts/verify-prompt.sh /path/to/draft-prompt.md

# Scaffold ADR mới
./scripts/new-adr.sh "Title of decision"
```

---

## 9. Maintenance rituals

| Ritual | Khi nào | Làm gì |
|---|---|---|
| Update activeContext | Sau MỌI task không trivial | Edit `memory-bank/activeContext.md` (5 phút) |
| Update progress | Hàng tuần (cuối sprint) | Edit `memory-bank/progress.md` (10 phút) |
| Update ROADMAP | Hàng tháng (hoặc đổi sprint) | Edit file này, đặc biệt section 5 (5 phút) |
| Run check-template.sh | Sau khi sửa skeleton master | Fix template inconsistency script báo |
| Run check-all.sh | Trước khi coi template release-ready | Full validation gate |
| Run check-memory-bank.sh | Hàng tuần trong applied project | Fix mismatches script báo |
| Add ADR | Khi quyết định kiến trúc | `./scripts/new-adr.sh "..."` (15-30 phút) |
| Extract pattern | Khi gặp pattern dùng ≥3 lần | `extract pattern <name>` (10 phút) |

---

## 10. Versioning của ROADMAP & memory-bank

- **ROADMAP.md**: bump version khi thay đổi structure (vd thêm section, đổi folder layout).
- **memory-bank/**: KHÔNG version explicit, nhưng commit messages nên ghi rõ "memory-bank: update activeContext" / "memory-bank: add feature/auth.md".
- **ADR**: số tăng dần, immutable. Nếu quyết định cũ thay đổi → ADR mới ghi `Supersedes ADR-<N>`.

---

## Footer

Skeleton: [prompt-system-skeleton v3.2](https://github.com/<your-org>/prompt-system-skeleton)
Generated: `<YYYY-MM-DD>`
