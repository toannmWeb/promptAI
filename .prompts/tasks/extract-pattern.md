---
name: extract-pattern
purpose: Tạo examples/<pattern>.md từ code thật (3+ usage)
input: <pattern name + code reference 3+ examples>
output: examples/<pattern>.md với template + sample code
version: 1.1
last-updated: 2026-04-30
trigger-command: "extract pattern <name>"
---

# Task: Extract Pattern

> Single-prompt task. Tạo `examples/<name>.md` từ code thật để re-use future.

## Khi dùng

- Code dùng cùng 1 pattern ≥3 lần.
- Pattern đáng để codify (vd: "add new BLoC", "add new repository", "add new screen").

## Workflow

1. Identify ≥3 instances của pattern trong code.
2. Extract common skeleton (variables → placeholder).
3. Document:
   - Why pattern exists.
   - When to use.
   - How to apply (step-by-step).
   - Sample code (full minimal example).
   - Anti-patterns.

## Output template (file: examples/<name>.md)

```markdown
# Pattern: <name>

## Purpose

<1-2 paragraph: problem solved, when to use>

## When to use

- ✅ <case 1>
- ✅ <case 2>
- ❌ <when NOT to use>

## How to apply (step-by-step)

1. Create <file/class/...>.
2. Implement <interface/contract>.
3. Wire up to <DI / registry / ...>.
4. Test: <test file convention>.

## Skeleton code

> Code dưới đây là pseudocode minh hoạ. Khi áp vào project thật, thay bằng cú pháp ngôn ngữ thực tế và pattern thật của repo.

```pseudo
// minimal complete example với placeholder <NAME>, <FIELD>, <DEP>, <ENDPOINT>
class <NAME>Repository implements I<NAME>Repository {
  private <DEP> client

  constructor(client: <DEP>) {
    this.client = client
  }

  async get<NAME>(id: string): <NAME> {
    response = await this.client.get("/<ENDPOINT>/" + id)
    return <NAME>.fromJson(response.data)
  }
}
```

## Real instances (cite file:line)

- `<path/to/instance-1>:<line>` — <NAME>Repository
- `<path/to/instance-2>:<line>` — <ANOTHER_NAME>Repository
- `<path/to/instance-3>:<line>` — <THIRD_NAME>Repository

## Tests for this pattern

```pseudo
// test skeleton — adapt theo test framework của project
test("<NAME>Repository.get<NAME> returns entity from API") {
  client = mock(<DEP>)
  client.get("/<ENDPOINT>/123").returns({ id: "123", ... })
  repo = new <NAME>Repository(client)
  result = await repo.get<NAME>("123")
  assert(result.id == "123")
}
```

## Anti-patterns

- ❌ <pattern variation 1 to avoid> — reason.
- ❌ <pattern variation 2 to avoid> — reason.

## Related ADRs

- ADR-<NNNN>: <title>

## Glossary

- <term>: <definition>

---
**Pattern type**: structural | behavioral | creational | architectural
**Maturity**: stable | evolving | experimental
**Last verified**: YYYY-MM-DD against <commit hash>
```

## Halt conditions

- < 3 instances → "not yet a pattern, wait for more usage".
- Instances differ significantly → "split into 2 patterns or refactor first".

## Prompt template

```
@workspace extract pattern: <NAME>

Adopt persona Mary 📊 (Analyst).

Task: .prompts/tasks/extract-pattern.md

Pattern instances (≥3): 
- <file:line>
- <file:line>
- <file:line>

Output: tạo examples/<NAME>.md theo template trong task file.

Use Edit mode để tạo file.
```
