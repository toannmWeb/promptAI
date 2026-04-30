# Feature: <NAME>

> Status: <Planned / WIP / Done / Deprecated>
> Last updated: <YYYY-MM-DD>

---

## Goal

<TODO — 1-2 câu: feature làm gì, business value.>

## User stories

> Format: As a <role>, I want <goal>, so that <benefit>.

1. <TODO>
2. <TODO>
3. <TODO>

## Acceptance criteria

> Verifiable. Format: Given/When/Then.

- AC-1: Given <precondition>, when <action>, then <result>.
- AC-2: <TODO>
- AC-3: <TODO>

## Architecture

### Modules involved

| Module | Path | Role |
|---|---|---|
| <TODO> | `<path>` | <role> |

### Data flow

```mermaid
sequenceDiagram
    <TODO>
```

## API / Data model

### Endpoints

```
<TODO — vd:
POST /api/v1/photos
  Body: { siteId, file, caption? }
  Response: { id, url, uploadedAt }
>
```

### Schema

```json
<TODO>
```

## Edge cases & error handling

| Case | Handling |
|---|---|
| <TODO — vd "Network timeout"> | <vd "Retry 3x with exponential backoff, then queue offline"> |
| <TODO> | <TODO> |

## Test strategy

| Layer | What to test | Tools |
|---|---|---|
| Unit | <TODO> | <TODO> |
| Integration | <TODO> | <TODO> |
| E2E | <TODO> | <TODO> |

## Implementation notes

<TODO — gotchas, performance considerations, security notes>

## Status

- [ ] Spec approved
- [ ] Architecture decided (link ADR if applicable)
- [ ] Implementation done
- [ ] Tests passing
- [ ] Documentation updated
- [ ] Released to production

## Related

- PRP: <TODO — link to PRPs/<n>-<name>.md>
- ADR: <TODO — link if architecture decision involved>
- Examples: <TODO — link to examples/ if pattern extracted>
