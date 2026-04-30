# Pattern: <NAME>

> Last updated: <YYYY-MM-DD>

---

## What

<TODO — 1-2 câu: pattern là gì, problem solve.>

## When to use

<TODO — bullet 2-4 cases:
- vd "API call cần retry on network error."
- vd "Form submission có optimistic UI update.">

## When NOT to use

<TODO — anti-cases:
- vd "Simple synchronous logic — overkill."
- vd "Performance-critical path — overhead too high.">

## Code template

```<lang>
<TODO — paste skeleton, comment các phần adapt:

// 1. <thay tên class>
class MyPattern {
  // 2. <thay logic>
  void doSomething() {
    // ...
  }
}
>
```

## Real example from codebase

<TODO — link path:line:
- `lib/data/repositories/user_repository_impl.dart:14-40` — implements pattern for User.
- `lib/data/repositories/site_repository_impl.dart:22-58` — implements pattern for Site.>

## Gotchas

<TODO — pitfall:
- vd "Don't catch in repository layer — let exception bubble to usecase."
- vd "Mock service must throw same error type for test isolation.">

## Variations

### Variation 1: <name>

<TODO — when to use this variation>

```<lang>
<TODO — code>
```

### Variation 2: <name>

<TODO>

## Related

- ADR: <TODO — vd "../docs/adr/0003-repository-pattern.md">
- Features using this: <TODO>
- Tests: <TODO — vd "test/data/repositories/user_repository_test.dart">
