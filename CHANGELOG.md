# Skeleton Changelog

> Track major changes to the skeleton itself (not project using it).

---

## v3.2 — 2026-04-30 — Continuation Protocol + Multi-Tool + Production-Grade

### Major changes

- **Bumped `.prompts/system/base.md` to v1.7** — added 2 rules cốt lõi:
  - Rule 23 **INLINE INPUT**: cần input → gom mọi câu hỏi vào 1 Confirmation Gate cùng response; không bao giờ nói "hỏi tôi ở request sau".
  - Rule 24 **CONTINUATION HANDOFF**: output không fit 1 response → làm tối đa + lưu progress vào `memory-bank/activeContext.md` + in block `⏩ TIẾP TỤC REQUEST SAU` với prompt copy-paste cho user.
- **Added section 8.1 Continuation Handoff block** trong base.md — chuẩn hóa block append cuối response khi rule 24 kích hoạt.
- **Sync rule list** — `AGENTS.md` và `.github/copilot-instructions.md` mirror đủ 24 rules.
- **Added `samples/gather-context.md`** — sample mới cho thu thập context lần đầu vào project: scan tối đa, ghi thẳng `memory-bank/`, hỗ trợ Continuation Handoff khi 1 request không đủ.
- **Production-grade primitives** đã có từ v3.1.3 vẫn áp dụng: `dry-run.md`, `rollback-plan.md`, `self-verify.md`, multi-lens 5×5 trong Mode 1, depth-first rule, halt-conditions 23 điều kiện, multi-tool support (Copilot / Cursor / Cline / Claude Code / Aider / Antigravity / Gemini / Codex).
- **Updated `docs/USAGE-GUIDE.md`** thêm reference samples/gather-context.
- **Updated `samples/README.md`** thêm gather-context vào index.

### Why

Bản v3.2 đóng nốt gap cuối: lifecycle qua nhiều request. Trước đây nếu 1 task quá lớn cho 1 response, AI thường hoặc làm dở rồi ngừng, hoặc bảo "hỏi tôi ở request sau" làm user mất context. Continuation Handoff giúp AI tự lưu state vào `activeContext.md` và đưa prompt sẵn cho user paste tiếp — không cần giải thích lại từ đầu.

---

## v3.1.1 — 2026-04-29 — Prompt Contract + Optimizer Upgrade

### Major changes

- **Added `docs/REQUEST-MODES.md`** — Mode 1 One-Shot Max, Mode 2 Standard, Mode 3 Decision-Gated.
- **Added `.prompts/workflows/mode-1-one-shot-max.md`** — high-density one-request workflow with multi-lens synthesis.
- **Added `.prompts/snippets/one-shot-max.md`** — composable snippet for maximizing output quality per request.
- **Added `.prompts/snippets/confirmation-gate.md`** — IDE-friendly one-block confirmation UX to reduce extra requests.
- **Added `docs/BENCHMARK-MODE-1.md` + `docs/benchmarks/mode-1/*.md`** — scoring rubric and benchmark prompts for Mode 1 quality.
- **Added `scripts/check-all.sh`** — release gate that runs template, prompt, shell and benchmark existence checks.
- **Added `.github/workflows/template-ci.yml`** — GitHub Actions validation for the master template.
- **Added `docs/TEMPLATE-MODE.md`** — explicit distinction between master template and applied project.
- **Added `.prompts/workflows/apply-to-project.md`** — safe workflow for copying/merging the master skeleton into a real project.
- **Added `.prompts/tasks/audit-template.md`** — review task for template purity, command map consistency, scripts and prompt power.
- **Added `scripts/check-template.sh`** — validation script for the master template itself.
- **Added Prompt Contract** to `.prompts/system/base.md` — every substantive task now has Goal, Scope, Context, Acceptance, Constraints, Output, Memory impact before execution.
- **Added `.prompts/snippets/prompt-contract.md`** — composable snippet for turning any prompt into an executable task contract.
- **Added `.prompts/tasks/optimize-prompt.md`** — pre-flight task that rewrites raw prompts into copy-paste-ready prompts with missing context, halt conditions, verification and output format.
- **Strengthened `docs/PROMPT-VALIDITY.md`** — checklist now covers execution mode, memory-bank impact, verification expectations, memory-bank initialization and rollback/reversibility.
- **Strengthened `scripts/verify-prompt.sh`** — now checks task contract fields, execution mode, prompt-contract references, placeholders and expected verification result.
- **Fixed `scripts/build-context.sh` bundle stats** — now writes through a temp bundle and reports included file count, lines, words and rough tokens.
- **Fixed `scripts/check-memory-bank.sh` counter accuracy** and added `--allow-template` for skeleton repos that intentionally contain `<TODO>` placeholders.
- **Added `.github/copilot-instructions.md`** — Copilot-specific entrypoint mirroring the core bootstrap, prompt contract and commands.

### Why

This upgrade targets the user's "mỗi prompt phải tận dụng AI triệt để" requirement: the system now optimizes prompt quality before execution instead of relying only on after-the-fact review. It also locks this repo into Template Mode so it remains reusable across every future project.

---

## v3.1 — 2026-04-29 — Memory Bank + BMAD-distilled Edition

### Major changes

- **Added ROADMAP.md** at root — single-pane god view (Q1.6 user concern).
- **Added `.prompts/` library** — canonical prompt library:
  - `system/base.md` — 12 rules cốt lõi.
  - `personas/` — 5 personas distilled from BMAD-METHOD: Mary 📊 (Analyst), Winston 🏗 (Architect), Amelia 💻 (Dev), Casey 🔍 (QA), Quinn 🧐 (Reviewer) + Party Mode 🎉.
  - `workflows/` — 6 multi-phase workflows: deep-dive-learn, debug-loop, refactor-safe, feature-end-to-end, initialize-memory-bank, update-memory-bank.
  - `tasks/` — 6 single-prompt tasks: explain-module, extract-pattern, verify-output, plan-feature, document-feature, trace-flow.
  - `snippets/` — 5 reusable: force-cite, decision-points, confidence-scale, max-context, halt-conditions.
- **Added `scripts/` validation framework**:
  - `check-memory-bank.sh` — verify consistency, broken refs, TODOs.
  - `check-impact.sh` — sửa code X → list mb file cần update (parse CHANGE-IMPACT.md).
  - `build-context.sh` — bundle memory-bank + topic-relevant files cho prompt lớn.
  - `verify-prompt.sh` — pre-flight check prompt validity + completeness.
  - `new-adr.sh` — scaffold ADR mới với template.
- **Added `docs/CHANGE-IMPACT.md`** — lookup table sửa code X → update mb file Y (Q1.5).
- **Added `docs/PROMPT-VALIDITY.md`** — pre-flight checklist trước khi gửi prompt (Q1.4).
- **Added `DESIGN-RATIONALE-v3.1.md`** — đánh giá cực sâu (50+ sections), giải thích từng quyết định, BMAD comparison, decisions D-1 đến D-12.
- **Updated AGENTS.md + .github/copilot-instructions.md** — point to ROADMAP + .prompts/ + personas + workflow commands.
- **Updated README.md** — reflect v3.1 structure + 7 user concerns.

### Tại sao thêm so với v3.0

User feedback (Q1-Q2):
- Q1.1: Prompt không đủ context → ROADMAP + build-context.sh + deep-dive-learn workflow.
- Q1.2: AI output không có gì kiểm chứng → Casey persona + verify-output task + adversarial review.
- Q1.3: Muốn hiểu CỰC SÂU module → deep-dive-learn workflow (5 phases).
- Q1.4: Mỗi project prompt khác nhau, không đồng nhất → .prompts/ library + PROMPT-VALIDITY.md.
- Q1.5: Cập nhật memory-bank đủ/đúng không → CHANGE-IMPACT.md + check-impact.sh + update-memory-bank workflow.
- Q1.6: Cần file tổng quát kiểu roadmap → ROADMAP.md.
- Q2: Debug loop = scan → fix → verify → loop, max 1 request → debug-loop workflow + max-context snippet.

### Files

```
v3.0: 30 files
v3.1: ~70 files (+ ROADMAP, .prompts/ library, scripts/, docs/CHANGE-IMPACT.md, PROMPT-VALIDITY.md)
```

### Migration v3.0 → v3.1

1. Copy file mới từ v3.1 vào v3.0:
   - `ROADMAP.md` (root)
   - `.prompts/` (entire folder)
   - `scripts/` (entire folder)
   - `docs/CHANGE-IMPACT.md`, `docs/PROMPT-VALIDITY.md`
   - `DESIGN-RATIONALE-v3.1.md`
2. Replace `AGENTS.md` + `.github/copilot-instructions.md` với v3.1 versions.
3. Update `README.md` + `CHANGELOG.md`.
4. Customize `docs/CHANGE-IMPACT.md` patterns theo project structure.
5. `chmod +x scripts/*.sh`.

→ Memory-bank của bạn KHÔNG bị ảnh hưởng. Personas + workflows là additive.

---

## v3.0 — 2026-04-29 — Memory Bank Edition

### Major changes

- **Adopted Cline Memory Bank** as core context persistence pattern.
- **Removed `.prompts/tasks/` (12 templates)** from v2.x — over-engineered, replaced by AGENTS.md workflow commands.
- **Removed root MAP.md, GLOSSARY.md** — consolidated into `memory-bank/`.
- **Removed `_examples/` (Tasks/FastAPI demo)** — not generic.
- **Added `memory-bank/`** with 6 core files + 4 optional folders.
- **Added `_logs/`** for selective archive of AI output.
- **Simplified AGENTS.md** to 7 priority rules + workflow commands.
- **New DESIGN-RATIONALE.md** with deep evaluation of alternatives.

### Migration from v2.x

See `DESIGN-RATIONALE.md` § 6 "Migration paths".

### Files

```
Root MD count: v2 = 10 → v3 = 4
Total folders: v2 = 6 → v3 = 5 (.github, memory-bank, PRPs, docs, examples, _logs)
Files in memory-bank: 6 core + 4 optional folders
```

---

## v2.1 — Earlier — Clean Template Edition

- Cleaned Tasks-specific content from templates.
- Added `<TODO>` placeholders.
- Stack-specific markers in AGENTS.md.

## v2.0 — Earlier — 12-Template Edition

- 12 task templates in `.prompts/tasks/`.
- 4-tier verification.
- Tasks/FastAPI example app.

## v1.x — Earlier

Initial skeleton concept.
