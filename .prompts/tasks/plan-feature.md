---
name: plan-feature
purpose: Brainstorm + draft PRP cho feature mới (single prompt)
input: <feature name + 1-2 sentence description>
output: PRPs/<NNN>-<feature>.md draft + decision points
version: 1.0
last-updated: 2026-04-29
trigger-command: "plan feature <name>"
---

# Task: Plan Feature

> Single-prompt task. Quick brainstorm + draft PRP. Khác với `feature-end-to-end` (full lifecycle 5 phases).

## Khi dùng

- Có idea feature, cần spec ra để decide có làm không.
- Trước khi commit thời gian implement.

## Workflow

1. Adopt persona Mary 📊 (Analyst) for brainstorm + Winston 🏗 (Architect) for tech feasibility.
2. Brainstorm 3-5 approaches.
3. Recommend 1 + reason.
4. Draft PRP file (use `PRPs/_template.md`).
5. List open questions for user.

## Output template

```markdown
# Plan: <feature name>

## Problem statement

<1 paragraph: who, what, why>

## Approaches considered

| # | Approach | Pros | Cons | Effort | Risk |
|---|---|---|---|---|---|
| A | <name> | <pros> | <cons> | <S/M/L/XL> | <low/med/high> |
| B | ... | ... | ... | ... | ... |

## Recommendation

**Approach <X>** because <reason>.

## PRP draft

### File: PRPs/<NNN>-<feature>.md

```markdown
# PRP: <feature>

## Goal
<1 sentence>

## Why
<1 paragraph>

## What (acceptance criteria)
- AC-1: <testable criterion>
- AC-2: ...

## Context
- Memory-bank refs: <list>
- Examples to follow: <list>
- ADRs to respect: <list>

## Implementation tasks
- Task 1: <description> (covers AC-1)
- Task 2: <description> (covers AC-2)

## Validation commands
- Test: `<cmd>`
- Lint: `<cmd>`
- Run: `<cmd>`

## Out of scope
- <list>

## Open questions
- Q-1: ...
```

## Decision points needing user input

- D-1: Approve approach <X> or pick another?
- D-2: Priority: P0/P1/P2?
- D-3: Timeline: this sprint / next / icebox?

## Open questions to research

- Q-1: <technical>
- Q-2: <product>

---
**Confidence**: <low/med/high>
**Estimated effort**: <S/M/L/XL>
**Estimated risk**: <low/med/high>
```

## Halt conditions

- Feature description quá vague → ask user clarify.
- Feature conflict với memory-bank/projectBrief.md scope → flag conflict.

## Prompt template

```
@workspace plan feature: <FEATURE_NAME>

Brief: <BRIEF>

Adopt Mary 📊 + Winston 🏗 (handoff).

Task: .prompts/tasks/plan-feature.md

Output đầy đủ trong 1 response: 3-5 approaches + recommendation + PRP draft + decision points.
```
