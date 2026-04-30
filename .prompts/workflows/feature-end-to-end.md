---
name: feature-end-to-end
purpose: Workflow đầy đủ feature mới — Plan → PRP → Implement → Verify → Update memory-bank
input: <feature name + 1-2 sentence description>
output: PRP file + code + tests + memory-bank update + ADR (nếu cần)
version: 1.0
last-updated: 2026-04-29
trigger-command: "feature end-to-end <name>"
---

# Workflow: Feature End-to-End

> Đường full lifecycle 1 feature mới: từ idea đến shipped + documented. Sử dụng 4 personas: Mary → Winston → Amelia → Casey.

## Phases (5 phases, multi-iteration)

### Phase 1: Discover (Mary 📊)

Persona: **Mary, Analyst**.

User input: `<feature name + brief>`.

Mary:
1. Read `ROADMAP.md`, memory-bank/, related ADRs.
2. Brainstorm **3-5 approaches** (with anti-bias: shift category every 10 ideas — see BMAD brainstorming).
3. Identify **user persona** affected, **edge case**, **stakeholder voice**.
4. List **dependencies** (existing modules, new libs needed).
5. Output **Discovery doc**:
   ```
   ## Feature: <name>
   - Brief: <1-2 sentences>
   - User persona: <list>
   - Approaches considered: <3-5 with pros/cons>
   - Recommended approach: <choice + reason>
   - Edge cases identified: <list>
   - Dependencies: <list>
   - Open questions: <list>
   ```

User confirm approach + answer open questions.

### Phase 2: Architect (Winston 🏗)

Persona: **Winston, Architect**.

Winston:
1. Convert Discovery → **technical design**.
2. Trade-off analysis (≥2 options) cho mỗi major decision.
3. Vẽ **Mermaid diagram** (sequence + block).
4. Identify **ADR needed** (nếu pattern change / new convention).
5. Output **Architecture brief**:
   ```
   ## Tech Architecture: <name>
   - Components affected: <list>
   - New components: <list>
   - Data flow diagram: <Mermaid>
   - DB schema change (nếu có): <SQL>
   - API contract (nếu có): <OpenAPI / GraphQL snippet>
   - Trade-off decisions: <list with chosen + reason>
   - ADRs needed: <list>
   ```

User confirm + Winston creates ADRs.

### Phase 3: Spec (Amelia 💻)

Persona: **Amelia, Dev**.

Amelia:
1. Convert Architecture → **PRP** (using `PRPs/_template.md`).
2. Break into **tasks** với AC IDs.
3. Define **acceptance criteria** per task (testable).
4. List **examples** to reference (`examples/<pattern>.md`).
5. List **validation commands** (test, lint, run).
6. Save: `PRPs/<NNN>-<feature>.md`.

User confirm PRP complete.

### Phase 4: Implement (Amelia 💻)

Amelia executes PRP tasks **in order**, using `.prompts/workflows/refactor-safe.md` style (test-first):

For each task:
1. Write failing test (RED).
2. Write minimal code (GREEN).
3. Refactor (REFACTOR).
4. Update PRP task status.
5. Cite file:line + AC ID.

After all tasks done → run full test suite → green.

### Phase 5: Verify + Document (Casey 🔍 + Mary 📊)

#### Casey verification
1. Adversarial review code diff (find ≥10 issues).
2. Edge case hunt on changed lines.
3. Run lint + type check.
4. List blockers (must fix), majors (should fix), nits (optional).

User decides which to fix.

#### Mary documentation
1. Update `memory-bank/features/<name>.md` (or create).
2. Update `memory-bank/progress.md` — feature added.
3. Update `memory-bank/activeContext.md` — feature shipped.
4. Update `ROADMAP.md` — section 3 + 5.
5. Save full log: `_logs/<date>-feature-<name>.md`.

## Loop control between phases

After each phase:
- ✅ "OK Phase <N>, next" → continue.
- 🔁 "Loop back, refine Phase <X>" → re-iterate that phase.
- ⏸ "Pause, gather more info" → list missing → user provides → resume.
- ⏹ "Stop, drop feature" → save state to `_logs/`, mark dropped in memory-bank.

## Token efficiency

- Phase 1, 2, 3: 1 prompt-response per phase (full context loaded).
- Phase 4: 1 prompt per task (PRP has N tasks).
- Phase 5: 2 prompts (Casey + Mary).

→ Total ~5-10 prompts cho full feature.

## Halt conditions

DỪNG nếu:
- Phase 1: 0 viable approaches → user revise feature scope.
- Phase 2: Architecture vượt scope (vd phải migrate stack) → escalate.
- Phase 3: PRP > 20 tasks → split feature smaller.
- Phase 4: ≥3 task fail liên tiếp → handoff sang debug-loop workflow.
- Phase 5: Casey find blocker không fixable → revise architecture (loop về Phase 2).

## Prompt template

```
@workspace feature end-to-end: <FEATURE_NAME>

Brief: <BRIEF>

Workflow: .prompts/workflows/feature-end-to-end.md (5 phases, 4 personas).

Bắt đầu Phase 1: Discover (Mary 📊).

Sau Phase 1, đợi tôi confirm "OK Phase 1, Winston" trước khi sang Phase 2.
```
