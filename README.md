# Prompt System Skeleton v3.1.1 — Memory Bank + BMAD + Prompt Contract Edition

> Universal, project-agnostic skeleton for AI-assisted coding (Copilot / Cursor / Cline / Claude Code / Aider).
>
> **v3.1.1 = v3.1 (Cline Memory Bank + BMAD-distilled patterns + ROADMAP + .prompts/ + scripts) + Prompt Contract + prompt optimizer.**
>
> **Template Mode**: Repo này là **master template** để copy sang mọi dự án sau này. Không fill memory-bank bằng facts của một app cụ thể trong repo này; các `<TODO>` trong memory-bank là placeholder có chủ đích.

---

## TL;DR (3 phút đọc)

- **Vấn đề** mà skeleton này giải quyết:
  1. AI quên context giữa các session → mỗi conversation explore lại từ đầu.
  2. Hệ thống lớn → prompt thiếu context → AI làm sai code hiện tại.
  3. Không có gì kiểm chứng output AI đúng/sai.
  4. Mỗi project tạo prompt khác nhau → không đồng nhất.
  5. Khi sửa code không biết phải update memory-bank file nào → memory-bank dần lệch thực tế.
  6. Cần 1 file tổng quát (roadmap) để new dev / AI nhìn vào hiểu luôn rồi vào chi tiết.
  7. Debug = vòng lặp scan → fix → verify → loop. Cần workflow định nghĩa rõ + tận dụng max 1 request.

- **Giải pháp**:
  - **Memory Bank** (6 file core + 4 folder optional) — long-term context AI đọc đầu mọi task.
  - **ROADMAP.md** — single-pane god view, đọc 30s biết tìm gì ở đâu.
  - **`.prompts/`** — canonical prompt library (system / personas / workflows / tasks / snippets).
  - **Prompt Contract + Optimizer** — biến prompt thô thành goal/scope/context/AC/verification rõ ràng trước khi AI thực thi.
  - **Mode 1: One-Shot Max** — tối đa hóa chất lượng trong 1 request bằng multi-lens review + output cô đọng.
  - **Confirmation Gate** — khi bắt buộc hỏi user trong IDE chat, gom mọi xác nhận vào 1 block trả lời bằng `OK` hoặc codes.
  - **`scripts/`** — validation framework (check-memory-bank, check-impact, build-context, verify-prompt, new-adr).
  - **Benchmark + CI gate** — `docs/BENCHMARK-MODE-1.md`, `scripts/check-all.sh`, `.github/workflows/template-ci.yml`.
  - **Template Mode tooling** — `docs/TEMPLATE-MODE.md`, `scripts/check-template.sh`, workflow `apply skeleton to <project>`.
  - **`docs/CHANGE-IMPACT.md`** — lookup table sửa code X → update mb file Y.
  - **`docs/PROMPT-VALIDITY.md`** — checklist trước khi gửi prompt.
  - **5 personas** (Mary 📊, Winston 🏗, Amelia 💻, Casey 🔍, Quinn 🧐) + Party Mode 🎉 — distilled from BMAD-METHOD.

## 3-step Quickstart

```
1. Giữ repo này làm master template sạch.
2. Khi có project thật, copy/apply skeleton vào project root.
3. Trong project thật, gõ: "initialize memory bank"
   → AI quét code, fill 6 file core trong memory-bank/ + ROADMAP.md.

Trong repo master template này, kiểm tra bằng:

```bash
./scripts/check-template.sh
./scripts/check-memory-bank.sh --allow-template
```
```

Sau bước 3:
- Gõ "follow your custom instructions" → AI đọc memory-bank, sẵn sàng task.
- Gõ "deep dive into <module>" / "debug loop <bug>" / "feature end-to-end <name>" — workflows phù hợp.
- Sau mỗi task → gõ "update memory bank" để giữ memory-bank fresh.

## Cấu trúc

```
project-root/
├── ROADMAP.md                       ← god view (đọc TRƯỚC mọi file khác)
├── README.md                        ← bạn đang ở đây
├── AGENTS.md                        ← cross-tool entry
├── CHANGELOG.md                     ← history v2 → v3.0 → v3.1
├── DESIGN-RATIONALE.md              ← đánh giá sâu v3.0 (giữ lại)
├── DESIGN-RATIONALE-v3.1.md         ← đánh giá CỰC SÂU v3.1 (tại sao thêm gì, BMAD compare)
├── GETTING-STARTED.md               ← guide chi tiết
│
├── .github/
│   └── copilot-instructions.md      ← entry cho Copilot
│
├── memory-bank/                     ← long-term project memory
│   ├── projectBrief.md              ★ CORE
│   ├── productContext.md            ★ CORE
│   ├── activeContext.md             ★ CORE
│   ├── systemPatterns.md            ★ CORE
│   ├── techContext.md               ★ CORE
│   ├── progress.md                  ★ CORE
│   ├── glossary.md                  ◇ Optional
│   ├── features/                    ◇ Per-feature
│   ├── integrations/                ◇ Per-integration
│   └── domains/                     ◇ DDD domains
│
├── .prompts/                        ← CANONICAL prompt library
│   ├── system/base.md
│   ├── personas/                    — 5 personas + party-mode
│   ├── workflows/                   — 8 workflows (multi-phase)
│   ├── tasks/                       — 8 tasks (single-prompt)
│   └── snippets/                    — 8 reusable snippets
│
├── scripts/                         ← VALIDATION framework
│   ├── check-memory-bank.sh
│   ├── check-impact.sh
│   ├── build-context.sh
│   ├── verify-prompt.sh
│   ├── new-adr.sh
│   ├── check-template.sh
│   └── check-all.sh
│
├── PRPs/                            ← Feature specs
├── docs/
│   ├── BENCHMARK-MODE-1.md          ← Rubric + benchmark prompts cho Mode 1
│   ├── CHANGE-IMPACT.md             ← Lookup: sửa code X → update mb Y
│   ├── PROMPT-VALIDITY.md           ← Pre-flight checklist
│   ├── REQUEST-MODES.md             ← Mode 1 / Mode 2 / Mode 3
│   ├── TEMPLATE-MODE.md             ← Master template vs applied project
│   ├── adr/                         ← Decision records
│   └── runbooks/                    ← How-to-do guides
├── examples/                        ← Code pattern library
└── _logs/                           ← AI output archive
```

★ = Core (luôn có)
◇ = Optional (tạo khi cần)

## Workflow phổ biến

### Khởi tạo project mới

1. Từ repo master template, gõ AI: `apply skeleton to <project path>` hoặc copy thủ công theo `docs/TEMPLATE-MODE.md`.
2. Trong project thật, gõ AI: `initialize memory bank`.
3. AI quét code → fill 6 file core + ROADMAP.md sections 1, 5.
4. Bạn review diff → Accept.

### Daily work

```
[mỗi conversation mới]
follow your custom instructions

[tối đa hóa 1 request]
mode 1: <task>

[apply template sang project thật]
apply skeleton to <project path>

[deep-dive 1 module]
deep dive into lib/data/repositories/

[debug 1 bug]
debug loop: <bug description>

[làm feature mới]
feature end-to-end: <name>
   ↓ Phase 1 (Mary)  → Phase 2 (Winston) → Phase 3+4 (Amelia) → Phase 5 (Casey + Mary)

[refactor an toàn]
refactor safely <scope>

[verify output]
verify output

[tối ưu prompt trước khi chạy task lớn]
optimize prompt: <draft prompt>

[audit master template]
audit template

[sau task]
update memory bank
```

### Validation tooling

```bash
# Hàng tuần: check memory-bank consistency
./scripts/check-memory-bank.sh

# Trong repo master template: check template purity
./scripts/check-template.sh

# Release gate: chạy toàn bộ validation quan trọng
./scripts/check-all.sh

# Sau commit: list mb file cần update
./scripts/check-impact.sh --git HEAD~1

# Trước khi gửi prompt lớn: bundle context
./scripts/build-context.sh auth > /tmp/auth-context.md

# Trước khi gửi prompt: validity check
./scripts/verify-prompt.sh /tmp/draft-prompt.md

# Khi quyết định kiến trúc: scaffold ADR
./scripts/new-adr.sh "Use Riverpod instead of Provider"
```

## Tương thích AI tool

| Tool | Entry file đọc | Personas hoạt động? | Memory Bank? |
|---|---|---|---|
| GitHub Copilot Chat | `.github/copilot-instructions.md` | ✅ | ✅ |
| Cursor | `.cursor/rules/*.mdc` hoặc `AGENTS.md` | ✅ | ✅ |
| Cline | `.clinerules/` hoặc Memory Bank instructions | ✅ | ✅ Native |
| Claude Code (CLI) | `CLAUDE.md` (symlink → AGENTS.md) | ✅ | ✅ |
| Aider | `--read AGENTS.md` | ✅ | ✅ |
| Continue, Codeium, ... | `AGENTS.md` | ⚠ Tùy version | ✅ |

→ Skeleton thiết kế work với MỌI tool. Personas pattern (Mary, Winston, ...) là plain Markdown, không cần plugin.

## Đọc thêm

- **`ROADMAP.md`** — god view của project (sau khi initialize).
- **`docs/BENCHMARK-MODE-1.md`** — rubric để đo Mode 1 bằng score thay vì cảm giác.
- **`GETTING-STARTED.md`** — guide chi tiết cho người mới.
- **`DESIGN-RATIONALE-v3.1.md`** — đánh giá CỰC SÂU: tại sao thêm gì so với v3.0, BMAD compare, decisions D-1 đến D-12, trade-offs.
- **`CHANGELOG.md`** — history v2.1 → v3.0 → v3.1.
- **`memory-bank/README.md`** — chi tiết Memory Bank pattern.
- **`.prompts/README.md`** — chi tiết Prompt library.

## Credits

- **Cline Memory Bank pattern** (cline.bot, 1K+ stars) — base pattern cho `memory-bank/`.
- **BMAD-METHOD** (43K stars) — distilled patterns: personas (Mary/Winston/Amelia/Casey), document-project workflow, party mode, adversarial review, edge case hunter, advanced elicitation.
- **coleam00 Context Engineering** (13K stars) — PRP concept.
- **GitHub Copilot custom instructions** — Copilot integration approach.

→ v3.1 KHÔNG fork BMAD-METHOD framework. Chỉ distill các pattern strongest và adapt để work với mọi tool + tiếng Việt + solo dev. Xem `DESIGN-RATIONALE-v3.1.md` chi tiết.

## License

MIT (free để fork và adapt).

## Versioning

- v2.1 (deprecated) — over-engineered, 12 task templates + 4-tier verification.
- v3.0 — simplified to Memory Bank + PRPs + ADR.
- **v3.1.1 (current)** — v3.1 + Prompt Contract + Mode 1 One-Shot Max + benchmark/check-all/CI.

→ v3.1.1 là canonical version. Mọi project tương lai đều dùng v3.1.1.
