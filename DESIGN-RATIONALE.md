# Design Rationale — Skeleton v3.0

> Đánh giá sâu (deep evaluation): tại sao chọn structure này, so sánh với alternatives, trade-offs.

---

## TL;DR đánh giá

Skeleton v3.0 = **Cline Memory Bank** (1K+ stars, proven) làm CORE + **PRP** (từ coleam00, 13K stars) cho specs + **ADR** (universal pattern) cho decisions + **Examples** + **Logs**.

**Tại sao combo này thắng**:
1. Memory Bank giải quyết "AI quên giữa session" — vấn đề #1 của AI coding.
2. PRP giải quyết "vibe coding output rác" — feature spec trước khi code.
3. ADR giải quyết "decisions bị forget" — immutable history.
4. Examples giải quyết "AI không biết style codebase" — copy-able templates.
5. Logs giải quyết "output AI bị mất" — selective archive.

**Tại sao bỏ skeleton v2.x**:
- v2 over-engineered: 12 task templates + 4-tier verification + 10 root MD = học curve dốc, đa số không dùng đến.
- v2 duplicate purpose: `MAP.md` + `AGENTS.md` + `GLOSSARY.md` overlap.
- v2 thiếu Memory Bank → AI vẫn quên context giữa session.

---

## 1. Vấn đề chúng ta giải quyết

### Vấn đề #1: AI mất context giữa session

LLM stateless. Mỗi conversation = blank slate. Hậu quả:

- Mỗi lần làm task → re-explore code 5-10 phút.
- AI bịa info nếu không re-explore.
- Output không nhất quán (bữa nay style A, mai style B).

**Skeleton v3.0 solution**: Memory Bank — AI đọc 6 file MD ở đầu mọi conversation → re-load context tức thì.

### Vấn đề #2: "Vibe coding" output rác

User chat ad-hoc với AI → AI thiếu spec → output:
- Sai requirement.
- Duplicate code có sẵn.
- Vi phạm convention codebase.
- Test coverage 0%.

**Skeleton v3.0 solution**: PRP (Product Requirement Prompt) — feature spec viết trước, AI implement đúng spec, có test plan.

### Vấn đề #3: Decisions bị forget

Quyết định "vì sao chọn X thay vì Y" thường biến mất sau 6 tháng. Hậu quả:
- Team mới hỏi → không ai trả lời được.
- Có người revert decision không biết, gây regression.

**Skeleton v3.0 solution**: ADR — immutable record per decision, version-controlled.

### Vấn đề #4: AI không biết style codebase

AI default = generate generic code. Codebase có convention riêng → output trông lạ.

**Skeleton v3.0 solution**: Examples folder — pattern templates copy-able.

### Vấn đề #5: Output AI mất khi đóng IDE

Long output (research, debug, explain) → đóng IDE = mất.

**Skeleton v3.0 solution**: `_logs/` folder — selective archive output quan trọng.

---

## 2. So sánh frameworks

### 2.1. Cline Memory Bank (✅ adopted as core)

**Source**: cline.bot, GitHub `cline/prompts` (1K+ stars), được Cline community adopt.

**Pattern**:
```
memory-bank/
├── projectBrief.md
├── productContext.md
├── activeContext.md
├── systemPatterns.md
├── techContext.md
└── progress.md
```

**Lý do chọn**:
- ✅ Đơn giản (6 file).
- ✅ Mỗi file mục đích rõ, không overlap.
- ✅ Hierarchy rõ (projectBrief → ... → progress).
- ✅ Battle-tested (Cline community dùng hằng ngày).
- ✅ Tool-agnostic (work với mọi AI).
- ✅ activeContext.md = file CRITICAL (state hiện tại).

**Trade-off**:
- ⚠ Chưa có concept "feature spec" tách riêng (gộp PRP từ coleam00 để bù).
- ⚠ Chưa có "decision log" tách riêng (gộp ADR để bù).

**Verdict**: Best fit for "context persistence" goal. Adopted as core.

### 2.2. coleam00 Context Engineering (✅ adopted PRP pattern)

**Source**: github.com/coleam00/context-engineering-intro (13K stars).

**Pattern**:
```
CLAUDE.md (rules)
INITIAL.md (initial feature request)
PRPs/
├── templates/prp_base.md
└── <feature>.md
examples/ (code patterns)
.claude/commands/ (slash commands)
```

**Lý do chọn PRP**:
- ✅ Concept "PRP" elegant: spec engineer + PM + tech writer hội tụ vào 1 file.
- ✅ Force AI có FULL context trước khi code → output chất lượng cao.
- ✅ 13K stars = pattern chứng minh ở cộng đồng lớn.

**Lý do KHÔNG adopt full**:
- ⚠ Slash commands `/generate-prp`, `/execute-prp` chỉ work với Claude Code.
- ⚠ INITIAL.md → PRP pipeline có thể manual cho Copilot user.
- ⚠ examples/ folder concept đã có sẵn trong skeleton v3.0.

**Verdict**: Adopt PRP concept + template. Bỏ slash command pipeline (replace bằng AI prompt thủ công).

### 2.3. ADR by Michael Nygard (✅ adopted)

**Source**: Pattern từ 2011, blog post "Documenting Architecture Decisions" (Michael Nygard).

**Pattern**:
```
docs/adr/
├── 0001-<title>.md
├── 0002-<title>.md
└── ...
```

Mỗi ADR có:
- Status: Proposed/Accepted/Deprecated/Superseded.
- Context.
- Decision.
- Consequences (positive/negative/neutral).
- Alternatives considered.

**Lý do chọn**:
- ✅ Universal — mọi industry dùng.
- ✅ Immutability rule rõ (KHÔNG sửa, tạo mới supersede).
- ✅ "Alternatives considered" force suy nghĩ kỹ.
- ✅ Format simple, không tool-specific.

**Trade-off**:
- ⚠ Cần discipline để viết (dev hay skip).

**Verdict**: Adopted. Universal pattern, low cost, high value.

### 2.4. BMAD-METHOD (❌ rejected)

**Source**: github.com/bmad-code-org/BMAD-METHOD (44K stars).

**Pattern**:
```
_bmad/
├── core/
├── bmm/
│   ├── agents/
│   ├── workflows/
│   └── ...
└── ...
```

Có 10+ specialized agents (analyst, architect, dev, QA, refactor) với workflow phức tạp.

**Lý do KHÔNG chọn**:
- ❌ Quá phức tạp (30+ file phải hiểu để start).
- ❌ Cài qua `npx bmad-method install` — thêm Node.js dependency.
- ❌ Workflow tied to Cursor/Claude Code agent invocation — không native cho Copilot.
- ❌ Steep learning curve cho user mới.
- ❌ Over-engineered cho project < 50K LOC.

**Trade-off accepted**:
- Mất features nâng cao (multi-agent collaboration, structured workflows).
- Ngược lại: skeleton v3.0 đủ cho 95% project, học curve thấp.

**Verdict**: Rejected. Stars cao không đồng nghĩa fit cho mọi case. Solo dev + small team không cần BMAD overhead.

### 2.5. Cursor Rules (`.cursor/rules/`) (❌ tool-specific, không adopt)

**Pattern**:
```
.cursor/rules/
├── react-patterns.mdc
├── api-guidelines.mdc
└── ...
```

`.mdc` files với YAML frontmatter (description, globs, alwaysApply).

**Lý do KHÔNG adopt**:
- ❌ Tool-specific (Cursor only).
- ❌ Skeleton v3.0 cần work với mọi AI tool.

**Trade-off**:
- Cursor user vẫn dùng được skeleton v3.0 (Cursor đọc AGENTS.md).
- Optional: user tạo `.cursor/rules/` riêng nếu muốn rules path-specific.

**Verdict**: Bỏ. AGENTS.md cross-tool đủ.

### 2.6. Kiro Specs (❌ IDE-specific)

**Pattern**:
```
specs/<feature>/
├── requirements.md
├── design.md
└── tasks.md
```

3 file per spec.

**Lý do KHÔNG adopt**:
- ❌ Cần Kiro IDE (Amazon proprietary).
- ❌ 3 file per spec overkill cho feature nhỏ-vừa.

**Trade-off accepted**:
- PRP của coleam00 là 1 file unified, đơn giản hơn.

**Verdict**: Rejected. PRP pattern (1 file) thắng về simplicity.

### 2.7. Aider Conventions (❌ minimal, không đủ)

**Pattern**:
- `CONVENTIONS.md` (single file)
- `.aider.conf.yml` (config)
- `.aider/chat.history.md` (auto-saved)

**Lý do KHÔNG adopt**:
- ❌ Quá minimal (chỉ 1 file conventions).
- ❌ Thiếu context structure (memory bank concept).
- ❌ Tied to Aider tool.

**Trade-off accepted**:
- Aider user có thể `aider --read AGENTS.md` để dùng skeleton v3.0.
- Chat history Aider auto-save vẫn work, KHÔNG conflict với `_logs/`.

**Verdict**: Rejected as core. Aider compat via AGENTS.md.

### 2.8. GitHub Copilot Native (`.github/copilot-instructions.md`) (✅ used as entry)

**Pattern**:
- Repository-wide: `.github/copilot-instructions.md`.
- Path-specific: `.github/instructions/<name>.instructions.md` với `applyTo`.
- Cross-tool: `AGENTS.md`.

**Lý do adopt**:
- ✅ Native cho Copilot (đa số user dùng).
- ✅ Combo với AGENTS.md đủ cover Cursor/Cline/Aider/Claude Code.

**Verdict**: Adopted as entry layer. Skeleton v3.0 có cả `.github/copilot-instructions.md` + `AGENTS.md`.

---

## 3. Trade-offs của skeleton v3.0

### Strengths

1. **Tool-agnostic**: Work với Copilot, Cursor, Cline, Claude Code, Aider. Không vendor lock-in.
2. **Low learning curve**: 6 file core + 4 file optional. Tổng < 15 file phải hiểu.
3. **Battle-tested patterns**: Memory Bank (1K+ stars) + PRP (13K+ stars) + ADR (universal).
4. **Extensible**: Optional folders (features/, integrations/, domains/) tạo khi cần.
5. **Single source of truth**: Mỗi info chỉ ở 1 chỗ (no duplication).

### Weaknesses (honest)

1. **Không có multi-agent workflow**: BMAD có 10+ agents collaborate. Skeleton v3.0 = single AI, single context. → OK cho < 50K LOC.
2. **Manual updates**: AI không tự động update memory-bank sau mỗi commit. User phải gõ `update memory bank`. → Có thể tự động hóa qua git hook nếu cần.
3. **Memory bank size**: Project lớn có thể vượt 6 file core. → Tạo optional folders (features/, domains/).
4. **Conflict trong team**: `activeContext.md` thường conflict khi multi-dev. → Suggest dùng branch-specific hoặc team-level only.
5. **Không có structured workflow**: BMAD/Kiro có quy trình step-by-step (analyst → architect → dev → QA). Skeleton v3.0 = freeform với templates. → Trade-off cho flexibility.

### When to NOT use skeleton v3.0

- Project > 100K LOC với > 10 devs đồng thời → consider BMAD-METHOD (multi-agent).
- Team có quy trình phê duyệt nghiêm ngặt cho mọi change → cần workflow tool, không phải markdown.
- AI tool primary là proprietary (vd Kiro, Devin standalone) → dùng convention native.

---

## 4. Decisions inside skeleton

### D-1: Tại sao 6 file core, không phải 5 hay 7?

- **Tại sao không 5**: Bỏ bất kỳ 1 trong 6 đều mất info quan trọng:
  - Bỏ `projectBrief` → mất foundation.
  - Bỏ `productContext` → AI không biết "why".
  - Bỏ `activeContext` → AI quên "now".
  - Bỏ `systemPatterns` → AI không biết "how".
  - Bỏ `techContext` → AI không biết "what stack".
  - Bỏ `progress` → AI không biết "status".
- **Tại sao không 7**: Mọi info bổ sung đều cover được bằng optional folders. Không cần thêm core file.

→ 6 = sweet spot.

### D-2: Tại sao Memory Bank ở `memory-bank/` (kebab-case), không phải `MemoryBank/`?

- ✅ kebab-case hợp với conventions phổ biến (docs, examples, scripts).
- ✅ Không conflict case-sensitivity giữa OS (Windows/Mac/Linux).
- ✅ Match Cline pattern.

### D-3: Tại sao PRP/ADR là root folder, không nest trong `docs/`?

- **PRPs/**: feature specs cần cho cả dev và AI tool — bằng vai với `memory-bank/` về importance. Nest sâu trong `docs/` làm AI khó tìm.
- **docs/adr/**: ADR thuộc "documentation" hơn → nest trong `docs/` hợp lý.

→ Folder layout phản ánh access pattern, không hierarchy semantic.

### D-4: Tại sao có `_logs/` thay vì rely on git history?

- Git history record code, không record AI conversations.
- AI explain output không phải code → không vào git.
- `_logs/` selective (chỉ archive output quan trọng), không spam.

### D-5: Tại sao không có `.prompts/tasks/` (12 templates) như v2.x?

Honest: v2.x over-engineered. 12 task templates (explain, plan, refactor, test, debug, document, enumerate, learn, compare, verify, extract, extract-pattern):

- Đa số ít dùng (`enumerate`, `compare`, `learn-concept`).
- AI tool hiện đại (Copilot/Cursor/Cline) đã handle các task type này natively.
- User chỉ cần PROMPT TỐT, không cần TEMPLATE prompt.

→ v3 thay bằng: workflow commands trong AGENTS.md (`initialize memory bank`, `update memory bank`, `create PRP`, `create ADR`, `extract pattern`, `save chat to log`). Đủ cover.

### D-6: Tại sao bỏ MAP.md, GLOSSARY.md ở root v2.x?

- **MAP.md** v2 → split thành `memory-bank/projectBrief.md` (foundation) + `memory-bank/productContext.md` (why). Cleaner separation.
- **GLOSSARY.md** v2 → move vào `memory-bank/glossary.md` (optional). Giảm root MD.

→ Root MD count: v2 = 10, v3 = 4 (`README`, `GETTING-STARTED`, `DESIGN-RATIONALE`, `AGENTS`). 60% giảm.

### D-7: Tại sao có cả `.github/copilot-instructions.md` VÀ `AGENTS.md`?

- Copilot có path đặc biệt (`.github/copilot-instructions.md`) → file native.
- AGENTS.md = cross-tool fallback.
- Cả 2 có nội dung gần giống → minor duplication acceptable for compat.

→ Trade-off: 1 file duplicate ≪ 1 tool không work.

---

## 5. Validation: Đã ai dùng pattern này thành công chưa?

### Memory Bank → ✅ Cline community

- Cline có official memory-bank workflow.
- Hàng trăm dev share success stories trên Discord/Reddit.
- Pattern proven cho project up to 50K LOC.

### PRP → ✅ coleam00 community

- 13K stars trên GitHub.
- Pattern dùng bởi nhiều agency build LLM apps.
- Proven cho feature dev với Claude Code/Cursor.

### ADR → ✅ Industry-standard

- ThoughtWorks Tech Radar.
- AWS Architecture Center.
- Microsoft Azure docs.
- Spotify, Shopify, Atlassian dùng pattern này.

### Skeleton v3.0 (combo) → ⏳ New synthesis

Skeleton v3.0 = synthesis. Không có project lớn nào dùng EXACT combo này (chưa). Nhưng:
- Mỗi component đã proven độc lập.
- Combo có overlap thấp, fit tốt.
- Risk thấp vì có thể adopt từng phần.

---

## 6. Migration paths

### From skeleton v2.x → v3

1. Copy v3 vào project.
2. Migrate content:
   - `MAP.md` → `memory-bank/projectBrief.md` (foundation) + `productContext.md` (why).
   - `AGENTS.md` v2 → merge với v3 AGENTS.md (giữ project-specific rules).
   - `GLOSSARY.md` → `memory-bank/glossary.md`.
   - `docs/architecture/00-overview.md` → `memory-bank/systemPatterns.md`.
3. Xóa: `.prompts/`, `_examples/` (Tasks/FastAPI), `scripts/` (trừ khi project cần).
4. Giữ: `PRPs/`, `docs/adr/`, `docs/runbooks/`, `examples/`.

### From naked project (no skeleton) → v3

1. Copy v3.
2. Gõ AI: `initialize memory bank`.
3. Review + accept 6 file core.
4. Done.

### From BMAD-METHOD → v3

- Không khuyến nghị migrate xuôi (BMAD có features v3 không có).
- Nếu project quá phức tạp với v3 → upgrade lên BMAD (ngược lại).

### From Cursor `.cursor/rules/` → v3

- Giữ `.cursor/rules/` (tool-specific, không conflict v3).
- Thêm v3 structure.
- AGENTS.md sẽ là cross-tool fallback nếu user dùng Cursor + tool khác.

---

## 7. Anti-patterns to avoid

### Trong skeleton v3.0

- ❌ **Bịa info trong memory-bank**: AI bịa = corrupt foundation. Force AI HỎI khi không chắc.
- ❌ **Cập nhật `projectBrief.md` thường xuyên**: file này near-immutable. Đổi nhiều = mâu thuẫn cấu trúc.
- ❌ **Lưu code dài trong memory-bank**: chỉ cite path:line.
- ❌ **Nest deep memory-bank**: max 2 cấp (memory-bank/ → features/<file>.md). Sâu hơn = khó navigate.
- ❌ **Sửa ADR đã Accepted**: tạo ADR mới supersede.
- ❌ **Skip review PRP trước execute**: AI có thể miss edge case.

### Khi setup skeleton

- ❌ **Đè nội dung memory-bank của team**: merge thay vì overwrite.
- ❌ **Dùng template từ ASBLOG/example cho project mới**: skeleton template phải `<TODO>` placeholders, content riêng cho mỗi project.
- ❌ **Không gõ `initialize memory bank` sau setup**: skeleton có file empty → AI không có context.

---

## 8. Future considerations (v3.1+)

Items đang weigh để add vào v3.1:

- **Auto-update memory bank via git hook**: post-commit hook cập nhật `progress.md` từ commit messages.
- **AI agent integration với CI**: PR check verify memory-bank consistency.
- **Visual map**: tool generate Mermaid diagram từ memory-bank/systemPatterns.md.
- **Multi-tenant support**: memory-bank riêng per workspace/team.
- **Localization**: skeleton support EN + VI + JA + ZH out-of-box (hiện tại VI primary).

Items rejected:

- ❌ Multi-agent workflows (BMAD-style) — quá phức tạp cho 95% project.
- ❌ Auto-extracted patterns (AI tự tạo `examples/`) — chất lượng inconsistent.
- ❌ Real-time sync giữa memory-bank và code — over-engineering.

---

## 9. Conclusion

Skeleton v3.0 là **honest synthesis** của 3 patterns proven (Memory Bank + PRP + ADR), tinh giản từ v2.x, tool-agnostic.

**Adopted**:
- Cline Memory Bank (core).
- coleam00 PRP (specs).
- Michael Nygard ADR (decisions).
- Examples folder (patterns).
- Logs folder (archive).

**Rejected**:
- BMAD-METHOD (over-engineered cho < 50K LOC).
- Tool-specific (Cursor rules, Kiro specs, Aider conventions).
- v2.x complexity (12 task templates, 4-tier verification).

**Trade-offs accepted**:
- Manual update memory-bank (vs auto).
- No multi-agent workflows (vs BMAD).
- Single conventional structure (vs flexibility for niche cases).

**Best for**:
- Solo dev + small team (1-5 dev).
- Project size < 50K LOC.
- AI-augmented workflow (Copilot/Cursor/Cline/Claude Code).
- Nhu cầu "context persistence" cao (project lâu dài).

**Not best for**:
- Team > 10 dev với workflow nghiêm ngặt → BMAD.
- Project < 1K LOC throwaway → overkill, dùng AGENTS.md alone.
- Pure agent automation (no human review) → cần workflow tool.
