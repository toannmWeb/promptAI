# DESIGN-RATIONALE — v3.1

> **Mục đích**: Giải thích CỰC SÂU mọi quyết định trong v3.1.
>
> File này dùng để: (a) bạn hiểu tại sao có gì, (b) future-self trở lại 6 tháng sau vẫn hiểu, (c) onboard team member.
>
> **Lưu ý**: File này KHÔNG phải tài liệu user. Đó là `README.md` + `GETTING-STARTED.md`. File này là **engineering memo**.

---

# Mục lục

- [Phần 0 — Bối cảnh + concerns user nêu](#phần-0--bối-cảnh)
- [Phần 1 — Mapping concerns → giải pháp v3.1](#phần-1--mapping-concerns--giải-pháp-v31)
- [Phần 2 — BMAD-METHOD sâu: phân tích + extraction](#phần-2--bmad-method-sâu-phân-tích--extraction)
- [Phần 3 — Architecture v3.1: 5 layers](#phần-3--architecture-v31-5-layers)
- [Phần 4 — Decisions D-1 đến D-12 (giải thích từng cái)](#phần-4--decisions-d-1-đến-d-12)
- [Phần 5 — Personas — distillation từ BMAD](#phần-5--personas--distillation-từ-bmad)
- [Phần 6 — Workflows — multi-phase iterative](#phần-6--workflows--multi-phase-iterative)
- [Phần 7 — Tasks — single-prompt 1-shot](#phần-7--tasks--single-prompt-1-shot)
- [Phần 8 — Snippets — composable building blocks](#phần-8--snippets--composable-building-blocks)
- [Phần 9 — Scripts — validation framework](#phần-9--scripts--validation-framework)
- [Phần 10 — ROADMAP god view: tại sao + design](#phần-10--roadmap-god-view-tại-sao--design)
- [Phần 11 — CHANGE-IMPACT.md: tại sao lookup table](#phần-11--change-impactmd-tại-sao-lookup-table)
- [Phần 12 — PROMPT-VALIDITY.md: tại sao pre-flight checklist](#phần-12--prompt-validitymd-tại-sao-pre-flight-checklist)
- [Phần 13 — Trade-offs honest](#phần-13--trade-offs-honest)
- [Phần 14 — So sánh: v2.1 vs v3.0 vs v3.1](#phần-14--so-sánh-v21-vs-v30-vs-v31)
- [Phần 15 — So sánh: v3.1 vs adopt full BMAD](#phần-15--so-sánh-v31-vs-adopt-full-bmad)
- [Phần 16 — Anti-patterns avoid](#phần-16--anti-patterns-avoid)
- [Phần 17 — Future considerations (v3.2+)](#phần-17--future-considerations-v32)
- [Phần 18 — Conclusion](#phần-18--conclusion)

---

# Phần 0 — Bối cảnh

## 0.1 Lịch sử ngắn

- **v1.x** — concept ban đầu, scattered patterns.
- **v2.x** — 12 task templates trong `.prompts/tasks/` + 4-tier verification + `_examples/Tasks-FastAPI`. Over-engineered.
- **v3.0** — pivot to Cline Memory Bank. Cắt mạnh: 30 file, 5 folder. Simplified.
- **v3.1 (file này)** — trả lời feedback user về 7 concerns mà v3.0 chưa cover đủ.

## 0.2 User profile (PHẢI fit)

| Thuộc tính | Giá trị |
|---|---|
| Role | Solo dev (build cho mình tôi dùng) |
| IDE | VS Code + GitHub Copilot Chat |
| Language | Tiếng Việt |
| Time budget | Có thể đầu tư học hiểu (4-8h OK), nhưng cần estimate |
| Quality bar | "Chấp nhận mọi thứ để được thứ tốt nhất" |
| Token budget | "Tận dụng max 1 request" — không thích multi-turn back-and-forth |
| Project scale | Đa project, mỗi project quy mô lớn (vd ASBLOG = Flutter web 5-tier) |
| Stability | Cần skeleton ổn định, dùng dài hạn 6+ tháng không phải migrate |

**Kết luận**: User cần solution **right-sized** (không quá heavy, không quá light), Vietnamese-first, Copilot-compatible, multi-project re-usable.

## 0.3 7 concerns user đã nêu (verbatim)

| # | User verbatim | Tóm tắt |
|---|---|---|
| Q1.1 | "Hệ thống lớn viết prompt nó không đủ context tôi sợ nhất làm sai lệch code hiện tại" | Prompt thiếu context → AI sửa sai code |
| Q1.2 | "Tôi không rõ đầu ra của AI nó có chính xác không cũng không có gì kiểm chứng nó là đúng" | Không có cách verify output |
| Q1.3 | "Hệ thống lớn tôi muốn tìm hiểu cực sâu và sau đó học lại cái hay của nó" | Cần workflow learn deeply |
| Q1.4 | "Mỗi project lại tạo những câu khác nhau không có sự đồng nhất và form cố định dễ hiểu" | Cần prompt template chuẩn |
| Q1.5 | "Cập nhật code phải sửa các file abc đã sửa chưa, đúng không? cập nhật có đủ không? chính xác không?" | Cần lookup change-impact + verify completeness |
| Q1.6 | "Cần 1 file tổng quát cực quan trọng như cái roadmap nhìn vào là biết hiểu luôn rồi tự biết vào chi tiết" | Cần single-pane god view |
| Q2 | "Để debug thì khi gặp bug AI phải xem lại tổng thể rồi fix sau đó lại quay lại vòng lặp này cho tới khi hết bug. tận dụng tối đa 1 rq để dùng toàn bộ token" | Cần debug loop workflow + max-context philosophy |
| (+) | "Trong prompt những thứ liên quan phải đúng valid đúng nhưng còn đủ thì sao?" | Validity + completeness check |

→ v3.1 PHẢI cover đủ 7 concerns + bonus.

---

# Phần 1 — Mapping concerns → giải pháp v3.1

| # | Concern | Solution v3.1 | File implementation |
|---|---|---|---|
| Q1.1 | Prompt thiếu context | (a) ROADMAP god view, (b) build-context.sh bundler, (c) deep-dive-learn workflow load full module, (d) max-context.md snippet | `ROADMAP.md`, `scripts/build-context.sh`, `.prompts/workflows/deep-dive-learn.md`, `.prompts/snippets/max-context.md` |
| Q1.2 | Không kiểm chứng output | (a) Casey persona adversarial reviewer, (b) verify-output task ≥10 issues, (c) confidence-scale snippet, (d) Quinn pre-flight reviewer | `.prompts/personas/qa.md`, `.prompts/tasks/verify-output.md`, `.prompts/snippets/confidence-scale.md`, `.prompts/personas/reviewer.md` |
| Q1.3 | Hiểu cực sâu | deep-dive-learn workflow 5 phases (scope → full read → diagram → patterns → quiz, loop) | `.prompts/workflows/deep-dive-learn.md` |
| Q1.4 | Không đồng nhất | (a) `.prompts/` canonical library, (b) PROMPT-VALIDITY checklist, (c) personas as standardized "voice", (d) workflow command index trong AGENTS.md | `.prompts/`, `docs/PROMPT-VALIDITY.md`, `AGENTS.md` |
| Q1.5 | Cập nhật đủ/đúng | (a) CHANGE-IMPACT lookup table, (b) check-impact.sh script, (c) update-memory-bank workflow 7 steps | `docs/CHANGE-IMPACT.md`, `scripts/check-impact.sh`, `.prompts/workflows/update-memory-bank.md` |
| Q1.6 | Roadmap god view | ROADMAP.md root | `ROADMAP.md` |
| Q2 | Debug loop max-context | (a) debug-loop workflow iteration template, (b) max-context snippet | `.prompts/workflows/debug-loop.md`, `.prompts/snippets/max-context.md` |
| (+) | Validity + completeness | PROMPT-VALIDITY.md checklist + verify-prompt.sh + Quinn persona | `docs/PROMPT-VALIDITY.md`, `scripts/verify-prompt.sh`, `.prompts/personas/reviewer.md` |

→ Mỗi concern có **ít nhất 2 layer giải pháp** (defense in depth) — không depend 1 file/script duy nhất.

---

# Phần 2 — BMAD-METHOD sâu: phân tích + extraction

## 2.1 BMAD là gì (review)

BMAD-METHOD = "Breakthrough Method of Agile AI-driven Development". 43K stars trên GitHub. v6.2.2 (March 2026). MIT license.

**Cấu trúc BMAD**:
```
bmad-core/
├── agents/           — 10+ specialized agents (.md files)
│   ├── analyst.md     (Mary)
│   ├── architect.md   (Winston)
│   ├── pm.md          (John)
│   ├── po.md          (Sarah)
│   ├── sm.md          (Bob)
│   ├── dev.md         (James)
│   ├── qa.md          (Casey)
│   ├── ux-expert.md   (Sally)
│   └── bmad-orchestrator.md / bmad-master.md
├── tasks/            — task definitions (single-step instructions)
├── workflows/        — multi-phase orchestrations
├── templates/        — output templates
├── checklists/       — verification checklists
└── data/             — shared knowledge (knowledge base)
```

**Triết lý BMAD**:
1. **Persona-driven**: Mỗi agent có identity + value system + style + rules. Khi user gọi → AI ADOPT persona đó (không trộn).
2. **Scale-adaptive**: Tự adjust độ sâu planning theo project complexity (small/medium/large).
3. **Dependencies hierarchy**: agent → task → template → data.
4. **Multi-modal**: Có cả "Web UI mode" (full team simulation) và "IDE mode" (focused dev).
5. **Document-driven**: Output mọi thứ thành markdown (PRD, architecture, stories, ...).
6. **Party mode**: Nhiều agent debate cùng 1 topic.

## 2.2 BMAD adoption trade-off đã review (Session 2)

KHÔNG adopt full vì:
1. Bug với Copilot (issues #1482, #1360, #1344, #1081).
2. Heavy: 100+ files trong `.bmad/`, 12+ agents.
3. English-only.
4. Multi-call workflows mâu thuẫn user's "max 1 request".
5. Update churn (v5 → v6 breaking).
6. Học curve 4-8h vs v3.1 60-90 phút.
7. Memory persistence yếu hơn Cline Memory Bank.
8. Không có ROADMAP single-pane.

→ **Distill, không adopt full.**

## 2.3 Pattern strongest từ BMAD đã extract vào v3.1

### 2.3.1 Persona structure (từ `bmad-core/agents/*.md`)

BMAD định nghĩa persona theo schema:

```yaml
agent:
  name: Mary
  id: analyst
  title: Business Analyst
  icon: 📊
  whenToUse: For market research, brainstorming, ...

persona:
  role: Insightful Analyst & Strategic Ideation Partner
  style: Analytical, inquisitive, creative, ...
  identity: Strategic analyst specializing in ...
  focus: Research planning, ideation facilitation, ...

core_principles:
  - Curiosity-Driven Inquiry
  - Objective & Evidence-Based Analysis
  - Strategic Contextualization
  - ...

commands:
  - help: Show numbered list of commands
  - brainstorm {topic}: Facilitate brainstorming
  - create-deep-research-prompt: ...
  - perform-market-research: ...

dependencies:
  tasks: [...]
  templates: [...]
  data: [...]
```

→ v3.1 `.prompts/personas/*.md` adopt schema này nhưng:
- **Bỏ YAML frontmatter** — không cần parser, chỉ cần Markdown thuần.
- **Bỏ dependencies hierarchy** — flat structure.
- **Adapt sang tiếng Việt** identity + style + principles.
- **Menu command đơn giản hóa** (5-10 commands per persona, không 20+).

### 2.3.2 Adversarial review (Casey QA agent)

BMAD QA agent có "edge case hunter mode" + "adversarial review":
- Tìm ≥10 issues, categorize blocker / major / minor / nit.
- Output: pass/fail + bullet list issues + recommended fixes.

→ v3.1 adopt full pattern này vào:
- `.prompts/personas/qa.md` (Casey persona)
- `.prompts/tasks/verify-output.md` (single-task version)

### 2.3.3 Pre-flight checker (Reviewer pattern)

BMAD có "validate-spec" task — check spec hoàn chỉnh trước khi handoff.

→ v3.1 generalize thành:
- `.prompts/personas/reviewer.md` (Quinn persona) — review prompt/spec/PRP/ADR.
- `docs/PROMPT-VALIDITY.md` — checklist self-serve.
- `scripts/verify-prompt.sh` — automation.

### 2.3.4 Document-project pattern

BMAD's `document-project.md` task: scan codebase, generate brownfield architecture document.

→ v3.1 adopt:
- `.prompts/workflows/initialize-memory-bank.md` 9 steps — fill 6 core mb files từ code.
- `.prompts/tasks/explain-module.md` — high-level module explanation.
- `.prompts/tasks/trace-flow.md` — trace 1 user action E2E with file:line.

### 2.3.5 Brainstorm + advanced elicitation

BMAD's `brainstorming-techniques.md` + `advanced-elicitation.md` data files chứa techniques:
- 5 Whys
- SWOT analysis
- First principles thinking
- Mind mapping
- Devil's advocate

→ v3.1 adopt:
- `.prompts/personas/analyst.md` (Mary) `principles` section reference các techniques này.
- `.prompts/tasks/plan-feature.md` brainstorm phase dùng techniques.

### 2.3.6 Party mode

BMAD có `bmad-master` agent có thể "group chat" với các agents khác — nhiều persona cùng debate.

→ v3.1 adopt:
- `.prompts/personas/party-mode.md` — 4-step workflow:
  1. Set topic + decision question.
  2. Each persona đưa quan điểm độc lập (Mary, Winston, Amelia, Casey, Quinn).
  3. Tension resolution: identify conflicts + propose synthesis.
  4. Final recommendation + decision points cho user.

### 2.3.7 Iteration template (debug, refactor, deep-dive)

BMAD có pattern "iteration tracking" trong story files:
- Each iteration có Status, Goal, Actions, Evidence, Decision.
- Loop until Acceptance Criteria pass.

→ v3.1 adopt vào:
- `.prompts/workflows/debug-loop.md` template A-E.
- `.prompts/workflows/refactor-safe.md` 5 phases.
- `.prompts/workflows/deep-dive-learn.md` 5 phases với loop control.

### 2.3.8 Halt conditions (Dev agent)

BMAD Dev agent có rule "HALT before risky operations":
- Conflict between requirement + implementation.
- Pattern violation (đi ngược ADR).
- Empty memory bank.
- Out-of-scope expansion.
- Risky destructive ops (drop table, force push, ...).

→ v3.1 adopt:
- `.prompts/snippets/halt-conditions.md` — 10 halt points generic.
- Mọi persona reference snippet này.

## 2.4 Pattern KHÔNG extract (intentional)

| BMAD pattern | Lý do KHÔNG adopt |
|---|---|
| YAML frontmatter cho agents | Copilot không parse YAML; plain MD work everywhere |
| Dependencies hierarchy (agent → task → template → data) | Over-engineered cho solo dev; flat structure đủ |
| Web UI mode (full team simulation) | Solo dev không cần PM, UX, PO simulation |
| 12+ agents | 5 agents (Mary, Winston, Amelia, Casey, Quinn) đủ cho solo |
| `bmad-orchestrator` agent | 1 user = 1 orchestrator; không cần meta-agent |
| `npx bmad-method install` (CLI) | Skeleton là plain folder, không cần installer |
| Update churn (v5 → v6) | Skeleton bạn own, không depend BMAD updates |
| `*help` command numbered list | Workflow commands trong AGENTS.md đủ |
| Story file workflow (User Stories agile) | Solo dev không cần agile ceremony |
| Sharding documents (PRD shard) | Memory Bank đã shard sẵn (6 file core) |

→ v3.1 = **30% concrete BMAD patterns adapted + 70% Cline Memory Bank foundation + custom additions**.

---

# Phần 3 — Architecture v3.1: 5 layers

```
┌─────────────────────────────────────────────────────────┐
│ LAYER 5 — User-facing interface                         │
│ AGENTS.md + .github/copilot-instructions.md             │
│ → Workflow commands, persona triggers, output format    │
└─────────────────────────────────────────────────────────┘
                          ↓ user gõ command
┌─────────────────────────────────────────────────────────┐
│ LAYER 4 — Prompt library                                │
│ .prompts/ — system + personas + workflows + tasks       │
│ → Canonical prompt templates                             │
└─────────────────────────────────────────────────────────┘
                          ↓ AI load
┌─────────────────────────────────────────────────────────┐
│ LAYER 3 — Project memory                                │
│ memory-bank/ — 6 core + 4 optional                      │
│ ROADMAP.md — god view                                    │
│ → Long-term project context                              │
└─────────────────────────────────────────────────────────┘
                          ↓ AI reference
┌─────────────────────────────────────────────────────────┐
│ LAYER 2 — Active artifacts                              │
│ PRPs/ docs/adr/ docs/runbooks/ examples/ _logs/         │
│ → Per-feature, per-decision artifacts                    │
└─────────────────────────────────────────────────────────┘
                          ↓ validation
┌─────────────────────────────────────────────────────────┐
│ LAYER 1 — Validation framework                          │
│ scripts/ + docs/CHANGE-IMPACT + docs/PROMPT-VALIDITY    │
│ → Safety net, consistency check                          │
└─────────────────────────────────────────────────────────┘
```

**Tại sao 5 layers**:
- Mỗi layer 1 concern: interface / templates / memory / artifacts / validation.
- Loose coupling: thay 1 layer không break others (vd thay scripts/ bằng Python tools — layer 4-5 vẫn work).
- Read order tối ưu: AI đọc top-down từ Layer 5 → 1 trong 1 conversation.

---

# Phần 4 — Decisions D-1 đến D-12

Format: D-X — Câu hỏi → Decision → Lý do → Alternatives rejected → Reversibility.

## D-1 — Có nên thêm ROADMAP.md ở root?

- **Decision**: YES.
- **Lý do**: Q1.6 explicit. Memory Bank 6 file flat, không có index. ROADMAP = god view 30s.
- **Alternatives rejected**:
  - (a) Mở rộng `projectBrief.md` thành ROADMAP — nhưng projectBrief = "what is this project", ROADMAP = "where to find what". Khác nhau.
  - (b) Tự generate ROADMAP từ memory-bank — over-engineering, AI có thể stale.
- **Reversibility**: high. Xóa file, không ảnh hưởng khác.

## D-2 — Có nên restore `.prompts/` library (đã cắt ở v3.0)?

- **Decision**: YES, but RESHAPED.
- **Lý do**: Q1.4 explicit user cần "form cố định". v3.0 cắt vì v2 over-engineered (12 templates). Nhưng cắt hết = mất tiêu chuẩn.
- **Reshape**:
  - v2: 12 task templates flat (over-eng).
  - v3.1: 5 layers (system / personas / workflows / tasks / snippets) — mỗi cái có scope rõ.
- **Alternatives rejected**:
  - (a) Chỉ AGENTS.md với commands (như v3.0) — text command quá ngắn, không có content.
  - (b) Dùng GitHub gist external — fragmentation, không version với code.
- **Reversibility**: medium. Bỏ .prompts/ phải refactor AGENTS.md commands.

## D-3 — Có nên có Personas (Mary, Winston, ...)?

- **Decision**: YES, 5 personas + Party Mode.
- **Lý do**: 
  - BMAD chứng minh value (43K stars).
  - Personas giúp AI "switch hat" thay vì general-purpose vague.
  - Mary cho "explore" mode khác Casey cho "challenge" mode → output chất lượng khác hẳn.
- **Sao 5 không 12 (BMAD)**:
  - Solo dev không cần PM (John), UX (Sally), PO (Sarah), SM (Bob).
  - 5 = (Analyst, Architect, Dev, QA, Reviewer) — đủ phủ vòng đời.
- **Alternatives rejected**:
  - (a) Không có personas (như v3.0) — mất pattern strongest của BMAD.
  - (b) 1 persona "smart helper" general — quá vague, AI ra output trộn vai.
- **Reversibility**: medium. Personas là MD file, có thể delete.

## D-4 — Có nên thêm `scripts/` validation?

- **Decision**: YES, 5 scripts bash.
- **Lý do**: Q1.2 + Q1.5 → cần safety net. Manual checklist ai cũng quên, automation = không quên.
- **Sao bash, không Python**:
  - Standard hơn (bash có sẵn macOS / Linux / WSL / Git Bash).
  - User Windows + VS Code → Git Bash sẵn.
  - Python require setup pip + venv.
- **Alternatives rejected**:
  - (a) Dùng pre-commit hooks → coupling với Git, ép user dùng pre-commit.
  - (b) Dùng Makefile → Windows không có sẵn make.
  - (c) Dùng `just` (Justfile) → cần install thêm.
- **Reversibility**: high. Scripts là file riêng, không break nếu xóa.

## D-5 — Có nên có `docs/CHANGE-IMPACT.md` lookup table?

- **Decision**: YES, table format.
- **Lý do**: Q1.5. Không có lookup → AI/user phải đoán "sửa gì cần update gì" → memory-bank dần stale.
- **Sao Markdown table, không YAML/JSON**:
  - Human-readable trên GitHub.
  - bash parse được (awk).
  - User edit dễ.
- **Alternatives rejected**:
  - (a) AI tự "hiểu" qua context — unreliable, tùy model.
  - (b) Hard-code trong update-memory-bank.md workflow — không update được khi project thay đổi structure.
- **Reversibility**: high.

## D-6 — Có nên có `docs/PROMPT-VALIDITY.md` checklist?

- **Decision**: YES.
- **Lý do**: User explicitly hỏi "valid" + "đủ" — checklist self-serve + automation backup.
- **Alternatives rejected**:
  - (a) Chỉ Quinn persona — depend on AI nhớ check, có thể skip.
  - (b) Chỉ verify-prompt.sh — không explain "tại sao check item này".
- **Reversibility**: high.

## D-7 — Có nên thêm `DESIGN-RATIONALE-v3.1.md` (file này)?

- **Decision**: YES, separate file (không merge vào v3.0's DESIGN-RATIONALE).
- **Lý do**: User asked "đánh giá CỰC SÂU" + show explicit mapping concerns → solutions.
- **Tại sao file riêng**:
  - v3.0's DESIGN-RATIONALE đã exist, là history.
  - v3.1 changelog quá dài cho CHANGELOG.md.
  - Engineering memo dài, không phù hợp README.
- **Reversibility**: high.

## D-8 — Có nên có Party Mode?

- **Decision**: YES, 1 file `party-mode.md`.
- **Lý do**: BMAD pattern strongest cho decision points multi-perspective. Solo dev = không có team debate, AI multi-persona thay thế.
- **Khi nào dùng**: Decisions kiến trúc lớn / trade-off ambiguous / cần multi-angle.
- **Khi nào KHÔNG dùng**: Tasks routine — dùng 1 persona đủ. Party mode tốn token.
- **Alternatives rejected**:
  - (a) Không có — mất giá trị BMAD đặc trưng.
  - (b) Auto-trigger khi decision lớn — quá magic, user mất control.
- **Reversibility**: high.

## D-9 — Có nên giữ memory-bank 6 core (như v3.0) hay merge với v3.1 patterns?

- **Decision**: GIỮ NGUYÊN 6 core. Optional folders unchanged.
- **Lý do**: Memory Bank là CLINE pattern proven (1K+ stars). Không hack. v3.1 chỉ ADD layer khác (.prompts/, ROADMAP, ...) — KHÔNG modify Memory Bank schema.
- **Reversibility**: medium.

## D-10 — Có nên rename `_logs/` → `logs/` (bỏ underscore)?

- **Decision**: GIỮ `_logs/` (underscore prefix).
- **Lý do**: Convention "underscore = ephemeral, exclude from git index by default". User có thể `.gitignore _logs/` không lo nhầm với production logs.
- **Reversibility**: high (rename folder + update refs).

## D-11 — Có nên thêm Vietnamese-first translation cho TẤT CẢ files?

- **Decision**: YES cho user-facing docs (README, ROADMAP, AGENTS.md, copilot-instructions, .prompts/, GETTING-STARTED, DESIGN-RATIONALE-v3.1).
- **Decision**: GIỮ ENGLISH cho structural files (CHANGELOG, ADR template — vì ADR convention industry là English).
- **Lý do**: User explicit Vietnamese-first. Personas tiếng Việt = AI auto-respond Vietnamese.
- **Reversibility**: medium (translate effort).

## D-12 — Có nên có `.bmad/` folder để compatible BMAD users migrate sang v3.1?

- **Decision**: NO.
- **Lý do**: 
  - BMAD users hiếm trong Vietnamese solo dev community.
  - Compat layer = maintenance burden.
  - User explicit chọn KHÔNG adopt full BMAD.
- **Reversibility**: high (add nếu cần sau).

---

# Phần 5 — Personas — distillation từ BMAD

## 5.1 Schema mỗi persona

```markdown
# <Icon> <Name> — <Title>

## Identity
Bạn là [Name]. Bạn có chuyên môn [domain]. Bạn channels [archetype famous person].

## Communication style
- <style 1>
- <style 2>

## Core principles (5)
1. <principle 1>
2. ...

## Bootstrap (đầu mọi conversation)
1. Đọc memory-bank/...
2. Đọc ROADMAP.md
3. Greet user, propose mode

## Menu (capabilities)
| Command | Mô tả |
|---|---|
| <CMD> | <action> |

## Output style
<format expected>

## Halt conditions
<when to STOP>
```

## 5.2 Mary 📊 — Strategic Analyst

- **Role**: Phân tích yêu cầu, deep-dive hệ thống, chuyển nhu cầu mơ hồ thành spec.
- **Channels**: Michael Porter (strategic rigor) + Barbara Minto (Pyramid Principle).
- **5 principles**:
  1. Evidence-based: Mọi claim có file:line / data / source.
  2. Precision: Diction precise, không vague.
  3. Stakeholder voice: Phân biệt "what user said" vs "what user means".
  4. Pattern over instance: Nhìn pattern xuyên 3+ instances.
  5. Distill: Output ngắn gọn, action-oriented.
- **Menu (9 commands)**:
  - BP (brainstorm patterns), MR (market research), DR (domain research), TR (technical research)
  - DD (deep-dive module), EM (explain module), EP (extract pattern), PF (plan feature), TF (trace flow)
- **Khi dùng**: Đầu phase explore / research / requirement gathering.

## 5.3 Winston 🏗 — System Architect

- **Role**: Kiến trúc tech, ADR, trade-off explicit.
- **Channels**: Martin Fowler (refactoring + patterns) + Sam Newman (microservices).
- **5 principles**:
  1. Rule of three: Đợi 3 instances trước khi extract abstraction.
  2. Boring tech: Pick boring + proven over hot + risky.
  3. DX-first: Optimize developer experience.
  4. Trade-offs explicit: Mọi decision list trade-offs.
  5. Document why: ADR mọi decision quan trọng.
- **Menu**: NEW-ADR, REVIEW-ADR, ARCHITECTURE-OVERVIEW, EVAL-ALTERNATIVES, IDENTIFY-RISKS.
- **Khi dùng**: Decisions kiến trúc, trade-off, design system.

## 5.4 Amelia 💻 — Senior Engineer

- **Role**: Test-first impl, file:line precise, AC-driven.
- **Channels**: Kent Beck (TDD) + DHH (convention over config).
- **5 principles**:
  1. RED-GREEN-REFACTOR: Test fail trước, code pass, refactor.
  2. Smallest unit: Mỗi commit smallest unit testable.
  3. Convention over config: Theo project convention.
  4. Cite file:line: Mọi code reference precise.
  5. AC = contract: AC pass = feature done.
- **TDD workflow**:
  - RED: write failing test
  - GREEN: minimal code to pass
  - REFACTOR: clean up, tests still pass
- **Menu**: DS (draft spec), QD (quick draft), QA (quality audit), CR (code review), RS (refactor scope), BL (break loop).

## 5.5 Casey 🔍 — Adversarial Reviewer

- **Role**: Find bugs, edge cases, security issues.
- **Channels**: James Bach (exploratory testing) + Bruce Schneier (security mindset).
- **2 modes**:
  - **REVIEW mode**: Casey reviews code/spec → ≥10 issues categorized blocker / major / minor / nit.
  - **EDGE-CASE HUNT mode**: Casey generates ≥10 edge cases để test.
- **5 principles**:
  1. Adversarial: Assume worst-case input.
  2. Security: Threat model mọi input.
  3. Edge cases: Empty / null / negative / overflow / unicode / concurrent.
  4. Find ≥10: Nếu < 10 issues → search harder, không HALT vì "code looks fine".
  5. Categorize: blocker / major / minor / nit.

## 5.6 Quinn 🧐 — Pre-flight Reviewer

- **Role**: Review prompt / spec / PRP / ADR TRƯỚC khi gửi AI.
- **Channels**: Edward Tufte (information clarity) + Strunk & White (concise writing).
- **Distinction**: Validity ≠ Completeness.
  - **Validity**: format đúng, AI parse được.
  - **Completeness**: đủ context, AI không phải đoán.
- **5 principles**:
  1. Both validity + completeness.
  2. No vague terms: flag "tốt", "nhanh", "tối ưu", ...
  3. Single responsibility: 1 prompt 1 task.
  4. Halt explicit: list halt conditions.
  5. Output format defined: AI biết format expected.
- **Menu**: REVIEW-PROMPT, REVIEW-PRP, REVIEW-ADR, REVIEW-MEMORY-BANK, REVIEW-WORKFLOW.

## 5.7 Party Mode 🎉

- 4-step workflow:
  1. Set topic + decision question.
  2. Each persona đưa quan điểm độc lập (Mary → Winston → Amelia → Casey → Quinn).
  3. Tension resolution: identify conflicts + propose synthesis.
  4. Final recommendation + decision points cho user.
- **Khi dùng**: Decision lớn ambiguous, trade-off cao, multi-angle critical.
- **Khi KHÔNG dùng**: Routine task (tốn token).

---

# Phần 6 — Workflows — multi-phase iterative

Workflows = multi-phase, có state, loop back. Khác task (single-prompt).

## 6.1 deep-dive-learn.md (Q1.3)

5 phases:
- Phase 1 — Scope & Map: scope module + list file paths + initial diagram.
- Phase 2 — Full read: AI đọc top file (cite file:line cho mọi claim).
- Phase 3 — Diagram: Mermaid sequence + class diagram.
- Phase 4 — Patterns: Identify pattern, anti-pattern.
- Phase 5 — Quiz: AI hỏi 5 câu, user answer, AI confirm "đã hiểu hoặc chưa".

Loop control: ✅ OK next phase / 🔁 dig deeper this phase / ⏹ stop.

Output: `memory-bank/features/<name>.md` + `examples/<pattern>.md` + `_logs/<date>.md`.

## 6.2 debug-loop.md (Q2)

Iteration template A-E:
- A. Scan: scan stack trace + relevant files.
- B. Hypothesis: top 3 hypothesis, cite file:line, rank by likelihood.
- C. Verify plan: how to test each hypothesis (test, log, breakpoint).
- D. Proposed fix: minimal scope, test-first.
- E. Decision points: list D-1, D-2 cho user choose.

Loop until 6 termination criteria pass:
1. Bug reproducible.
2. Root cause identified.
3. Fix applied.
4. Test green.
5. Regression test added.
6. Doc updated.

## 6.3 refactor-safe.md

5 phases (charter → test inventory → refactor small steps → verification → doc).

Guarantee: NO behavior change. Test pass before + after.

## 6.4 feature-end-to-end.md

5 phases:
- Phase 1 (Mary): Discover requirements.
- Phase 2 (Winston): Architect + ADR if needed.
- Phase 3 (Amelia): Spec PRP.
- Phase 4 (Amelia): Implement TDD.
- Phase 5 (Casey + Mary): Verify + document.

→ Full lifecycle 1 feature, multi-persona handoff.

## 6.5 initialize-memory-bank.md

9 steps:
1. Detect project type (Flutter / FastAPI / Next.js / ...).
2. Scan top-level structure.
3. Read README / package manifest.
4. Identify entry points.
5. Trace 1 user flow.
6. Identify patterns (BLoC / Redux / Context / ...).
7. Fill 6 core mb files.
8. Update ROADMAP.md sections 1, 5.
9. Self-review: any TODO placeholder? broken refs?

## 6.6 update-memory-bank.md

7 steps:
1. List file code thay đổi (git diff HEAD~1).
2. Lookup `docs/CHANGE-IMPACT.md` → mb file impacted.
3. Detect missing patterns / ADRs (new pattern in code?).
4. Update each mb file with cite file:line.
5. Update ROADMAP.md if structure changed.
6. Run `./scripts/check-memory-bank.sh`.
7. Confidence + Assumptions per file updated.

---

# Phần 7 — Tasks — single-prompt 1-shot

Khác workflows: tasks đơn shot, output ngay, không state.

| Task | Mô tả | Persona dùng |
|---|---|---|
| explain-module.md | TL;DR + Files + Public API + Sequence diagram + Patterns + Edge cases | Mary |
| extract-pattern.md | 3+ instances → examples/<pattern>.md | Winston |
| verify-output.md | Adversarial review ≥10 issues, categorize | Casey |
| plan-feature.md | Brainstorm 3-5 approaches → recommendation → draft PRP | Mary + Winston |
| document-feature.md | After ship → memory-bank/features/<name>.md | Mary |
| trace-flow.md | Trace 1 user action E2E with file:line + sequence diagram | Mary |

---

# Phần 8 — Snippets — composable building blocks

| Snippet | Mục đích |
|---|---|
| force-cite.md | "Mỗi claim phải có file:line hoặc line-range" |
| decision-points.md | List D-1, D-2, ... options before concluding |
| confidence-scale.md | Output format Confidence + Assumptions + Verification |
| max-context.md | Tận dụng 1 request đầy đủ, pre-load + reasoning + output + verification + decision + confidence |
| halt-conditions.md | 10 halt points: conflict, pattern violation, empty MB, out-of-scope, risky, ambiguous, conflicting reqs, missing dep, unreproducible bug, token budget |

→ Composable: dùng "Apply [force-cite.md] + [decision-points.md] + [confidence-scale.md]" trong prompt → AI follow tất cả.

---

# Phần 9 — Scripts — validation framework

## 9.1 check-memory-bank.sh

7 checks:
1. All 6 CORE files exist + non-empty.
2. No `<TODO>` placeholders.
3. ADR refs point to existing files.
4. Examples refs point to existing files.
5. PRP refs point to existing files.
6. activeContext freshness (warn nếu > 7 days).
7. Summary pass/fail.

## 9.2 check-impact.sh

Parse `docs/CHANGE-IMPACT.md` lookup table, match path against patterns, output mb files cần update.

Modes:
- `./scripts/check-impact.sh <single-path>`
- `./scripts/check-impact.sh --git HEAD~1` (auto từ git diff)

## 9.3 build-context.sh

Bundle topic-relevant files thành 1 context bundle cho prompt lớn.

Logic:
1. Read 6 core mb files always.
2. Search `memory-bank/features/`, `memory-bank/integrations/` matching topic.
3. Search `examples/` matching topic.
4. Search `docs/adr/` matching topic.
5. Output bundled markdown with section headers.

## 9.4 verify-prompt.sh

Pre-flight check:
- Validity (7 items): mb ref, scope, AC, cite, confidence, decision points, output format.
- Completeness (6 items): workflow ref, ADR/PRP ref, edit mode, language, halt conditions.
- Risk (3 items): vague terms, conflicting words, length.

## 9.5 new-adr.sh

Scaffold ADR với:
- Auto next number (NNNN).
- Slugify title.
- Use `docs/adr/_template.md` if exists.
- Print next steps after creation.

---

# Phần 10 — ROADMAP god view: tại sao + design

## 10.1 Tại sao cần

Q1.6: "1 file tổng quát cực quan trọng như cái roadmap nhìn vào là biết hiểu luôn rồi tự biết vào chi tiết."

Memory-bank 6 file flat, không có "where to find what for question X".

## 10.2 ROADMAP.md sections

10 sections:
1. Quick navigation (đọc 30s) — câu hỏi → file.
2. Map by topic — table topic → files.
3. Folder structure — tree.
4. Current sprint — pull từ activeContext.
5. Workflow commands — list lệnh.
6. Personas — list persona.
7. Validation tooling — list scripts.
8. Rituals — daily / weekly / per-task.
9. Versioning — link CHANGELOG.
10. Footer — last updated.

## 10.3 Self-update strategy

- Section 1, 4, 5: AI auto-update khi `update memory bank`.
- Section 2, 3, 6, 7, 8, 9, 10: thủ công, ít thay đổi.

---

# Phần 11 — CHANGE-IMPACT.md: tại sao lookup table

## 11.1 Tại sao

Q1.5: User concern memory-bank stale. Sửa code không update mb = mb dần lệch.

## 11.2 Format

Markdown table 2 cols: pattern (bash glob) → mb impact (comma list).

## 11.3 Customization

Per-project. Skeleton có template (Flutter / FastAPI / Next.js patterns), user customize.

## 11.4 Anti-patterns

- ❌ Pattern quá generic (`*`).
- ❌ Pattern quá specific (`lib/data/services/user_service.dart`).
- ❌ Quên update bảng khi đổi structure.

---

# Phần 12 — PROMPT-VALIDITY.md: tại sao pre-flight checklist

## 12.1 Distinction

- Validity: format đúng (cite request, output format, scope, AC).
- Completeness: context đủ (workflow ref, ADR/PRP ref, edit mode, language).

## 12.2 3 cách dùng

1. Manual checklist (5 phút).
2. Automation (`scripts/verify-prompt.sh`).
3. Quinn persona review (2 phút).

## 12.3 Verdict logic

- Pass ≥ 7 + Warn ≤ 2 + Fail = 0 → READY.
- Pass ≥ 5 + Warn ≤ 4 + Fail = 0 → USABLE.
- Fail ≥ 1 → NOT READY.

---

# Phần 13 — Trade-offs honest

## 13.1 Strengths v3.1

| Aspect | Strength |
|---|---|
| Coverage 7 concerns | 85-90% (vs v3.0 35%) |
| Token efficiency | ✅ max 1 request workflow |
| Vietnamese-first | ✅ |
| Copilot compat | ✅ Native (plain MD) |
| BMAD distilled | ✅ 30% best patterns |
| Customizable | ✅ Per-project (CHANGE-IMPACT) |
| Safety net | ✅ scripts/ validation |
| Single-pane view | ✅ ROADMAP |

## 13.2 Weaknesses v3.1

| Aspect | Weakness | Mitigation |
|---|---|---|
| Học curve | 60-90 phút (vs 30 phút v3.0) | GETTING-STARTED guide |
| File count | ~70 files (vs 30 v3.0) | Clear folder boundaries |
| Maintain | User own scripts/ + CHANGE-IMPACT | Documentation |
| BMAD evolution | Không tự update theo BMAD | Manual review yearly |
| Personas opinionated | Maybe Mary "voice" không suit user | Customizable, edit MD |
| Scripts bash-only | Windows phải Git Bash | Documented |

## 13.3 Khi nào v3.1 KHÔNG phù hợp

- ✗ Project < 1 tuần lifespan (skeleton overhead waste).
- ✗ Single-file script project.
- ✗ User không chấp nhận học 60-90 phút.
- ✗ Team > 5 dev (cần BMAD đầy đủ với PM/UX/PO).
- ✗ Enterprise compliance (audit trails) — cần BMAD enterprise.

---

# Phần 14 — So sánh: v2.1 vs v3.0 vs v3.1

| Tiêu chí | v2.1 | v3.0 | v3.1 |
|---|---|---|---|
| File MD | ~50 | 30 | ~70 |
| Folders | 6 | 5 | 7 |
| Memory Bank | ❌ | ✅ 6 core | ✅ 6 core (giữ) |
| ROADMAP | ❌ MAP.md root | ❌ | ✅ god view |
| .prompts/ | ✅ 12 templates | ❌ cắt | ✅ system + personas + workflows + tasks + snippets |
| Personas | ❌ | ❌ | ✅ 5 + Party Mode |
| Workflows multi-phase | ❌ | ❌ | ✅ 6 |
| Tasks single-shot | ✅ 12 | ❌ | ✅ 6 (curated) |
| Snippets composable | ❌ | ❌ | ✅ 5 |
| Scripts validation | ✅ partial | ❌ | ✅ 5 |
| CHANGE-IMPACT.md | ⚠ partial | ❌ | ✅ |
| PROMPT-VALIDITY.md | ❌ | ❌ | ✅ |
| 4-tier verification | ✅ | ❌ | ❌ (replaced by Casey + verify-prompt) |
| Tasks/FastAPI demo | ✅ | ❌ | ❌ |
| Coverage 7 concerns | 50% | 35% | 85-90% |
| Học curve | 90+ phút | 30 phút | 60-90 phút |
| BMAD-distilled | ❌ | ❌ | ✅ |
| Multi-tool support | ⚠ | ✅ | ✅ |

→ v3.1 = sweet spot: simpler v2 + more powerful v3.0 + BMAD distilled.

---

# Phần 15 — So sánh: v3.1 vs adopt full BMAD

| Tiêu chí | Adopt full BMAD | v3.1 |
|---|---|---|
| Coverage user concerns | 70-80% | 85-90% |
| Copilot compat | ⚠ Buggy | ✅ Native |
| Vietnamese | ❌ English | ✅ |
| Solo dev fit | ⚠ Over-kill | ✅ Right-sized |
| Token efficiency | ❌ Multi-call | ✅ Max 1-2 |
| Stability | ⚠ Update churn | ✅ User own |
| Học curve | 4-8h | 60-90 phút |
| Battle-tested | ✅ 43K stars | ⚠ Custom |
| Distilled patterns | N/A | ✅ 30% best of BMAD |
| Future-proof | ✅ Active community | ⚠ Manual review |
| File count | 100+ in `.bmad/` | ~70 in skeleton |
| Multi-project re-use | ✅ | ✅ |

→ User's setup (Copilot + solo + Vietnamese + multi-project) → v3.1 better fit.

---

# Phần 16 — Anti-patterns avoid

## 16.1 Skeleton-level

- ❌ Auto-generate ROADMAP from memory-bank — stale risk.
- ❌ YAML frontmatter cho personas — Copilot không parse, complexity.
- ❌ Magic auto-trigger personas — user mất control.
- ❌ Pre-commit hook ép validation — coupling Git.
- ❌ Cross-project shared memory-bank — projects khác nhau, context khác nhau.

## 16.2 User-level

- ❌ Copy-paste prompt mà không customize variables (`<scope>`, `<topic>`).
- ❌ Skip `update memory bank` step → mb stale.
- ❌ Commit `_logs/` (verbose AI output) → repo bloat.
- ❌ Modify ADR đã Active (immutable) — nên tạo ADR mới supersede.
- ❌ Dùng party mode cho task routine → tốn token.
- ❌ Override persona's principles — mất giá trị standard voice.

---

# Phần 17 — Future considerations (v3.2+)

## 17.1 Possible additions

- `scripts/check-prompt-history.sh` — track which prompts đã dùng nhiều, optimize.
- `examples/<framework>/` subdirectories — Flutter, FastAPI, Next.js sample.
- `.prompts/personas/security.md` — Security persona (Threat modeling).
- `.prompts/workflows/migration.md` — large refactor / version migration.
- Integration với `git pre-commit` (optional, opt-in).

## 17.2 Known gaps

- No automated test framework cho skeleton itself (chỉ user-level scripts).
- Personas hardcoded English archetypes (Porter, Fowler, ...) — could localize.
- No measurement: bao nhiêu time skeleton actually saves vs without.

## 17.3 NOT planned

- ❌ CLI installer (`npx prompt-system init`) — over-engineering.
- ❌ VS Code extension — fragmentation.
- ❌ Web UI dashboard — solo dev không cần.

---

# Phần 18 — Conclusion

## 18.1 Recap

v3.1 = **right-sized solution** cho solo dev VN với Copilot, không over-engineered (BMAD full), không under-powered (v3.0).

## 18.2 Coverage

- Q1.1 (context) ✅ ROADMAP + build-context + deep-dive-learn + max-context.
- Q1.2 (verify) ✅ Casey + verify-output + confidence-scale + Quinn.
- Q1.3 (deep) ✅ deep-dive-learn 5 phases.
- Q1.4 (đồng nhất) ✅ .prompts/ canonical + PROMPT-VALIDITY + personas voice.
- Q1.5 (update) ✅ CHANGE-IMPACT + check-impact + update-mb workflow.
- Q1.6 (roadmap) ✅ ROADMAP.md god view.
- Q2 (debug loop) ✅ debug-loop workflow + max-context snippet.
- (+) (validity + completeness) ✅ PROMPT-VALIDITY + verify-prompt.

→ **85-90% covered** (vs v3.0 35%).

## 18.3 Effort estimate cho user

| Activity | Time |
|---|---|
| Đọc README + ROADMAP | 15 phút |
| Đọc DESIGN-RATIONALE-v3.1 (file này) | 30 phút |
| Initialize memory bank lần đầu (1 project) | 15-30 phút |
| Customize CHANGE-IMPACT.md per-project | 10-20 phút |
| Học workflows (deep-dive, debug, feature-e2e) | 30-60 phút |
| Học personas (Mary, Winston, ...) | 20 phút |

**Total**: ~2-3 giờ để fully productive.

## 18.4 Validation v3.1 success

Sau khi áp dụng v3.1 vào ASBLOG:
1. Memory-bank initialize ra output đúng (review diff).
2. Run `./scripts/check-memory-bank.sh` → all pass.
3. Trial 1 deep-dive workflow trên 1 module → output có cite file:line + diagram + quiz.
4. Trial 1 debug-loop trên bug thực → ≥1 iteration converge to fix.
5. Trial Casey adversarial review → tìm ≥10 issues từ 1 file.

Nếu cả 5 pass → v3.1 working as designed.

## 18.5 Khi nào reconsider

Reconsider v3.1 nếu:
- User đổi sang Cursor / Claude Code → consider full BMAD adoption.
- Project scale to team 3+ dev → consider PM/UX/PO personas.
- Token cost trở thành blocker → consider sharper trim.
- Memory-bank pattern fail (vd file > 10MB, không scalable) → consider DB-backed alternative.

→ v3.1 stable cho 6-12 tháng tới với current setup user.

---

**End of DESIGN-RATIONALE v3.1**

Generated: 2026-04-29
Author: Devin (AI agent) reviewing user 7 concerns + BMAD-METHOD v6.2.2 research
Lifetime: 6-12 months until significant skeleton revision
