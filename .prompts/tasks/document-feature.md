---
name: document-feature
purpose: Tạo memory-bank/features/<name>.md sau khi feature đã ship
input: <feature name + reference (PRP / commits)>
output: memory-bank/features/<name>.md đầy đủ
version: 1.0
last-updated: 2026-04-29
trigger-command: "document feature <name>"
---

# Task: Document Feature

> Single-prompt. Sau khi feature ship → tạo doc canonical cho memory-bank.

## Output template (file: memory-bank/features/<name>.md)

```markdown
# Feature: <name>

## Status

- **State**: shipped | beta | deprecated
- **Owners**: <list>
- **PRP**: PRPs/<NNN>-<feature>.md
- **ADRs**: <list>

## What it does

<1 paragraph for non-tech>

## How it works

<2-3 paragraphs technical>

## Architecture

```mermaid
sequenceDiagram
    ...
```

## Files

| Layer | File | Purpose |
|---|---|---|
| UI | <path> | <purpose> |
| BLoC | <path> | <purpose> |
| Repository | <path> | <purpose> |
| Service | <path> | <purpose> |

## Public API

- `<function/endpoint>` — <description>

## Data model

```<lang>
class <Name> {
  ...
}
```

## Edge cases handled

- <case 1> → <how>

## Edge cases NOT handled

- <case 1> → <potential issue>

## Tests

- Unit: `<test file>`
- Integration: `<test file>`
- E2E: `<test file>` (nếu có)

## Known issues / tech debt

- <issue 1>

## How to extend

- Add new <thing> by: <instruction>
- See pattern: `examples/<X>.md`

## Glossary (feature-specific)

- <term>: <definition>

---
**Last updated**: YYYY-MM-DD against commit <hash>
**Coverage of feature behavior**: <high/med/low>
```

## Prompt template

```
@workspace document feature: <NAME>

Adopt Mary 📊 (Analyst).

Task: .prompts/tasks/document-feature.md

Reference: PRP <NNN> + commits <hash range>.

Output: tạo memory-bank/features/<NAME>.md theo template.
Use Edit mode.
```
