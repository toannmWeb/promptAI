# PRP-<NNN>: <FEATURE_NAME>

> **Status**: Draft / Approved / In Progress / Done / Abandoned
> **Author**: <name>
> **Created**: <YYYY-MM-DD>
> **Last updated**: <YYYY-MM-DD>

---

## 1. Goal

<TODO — 1-2 câu: feature làm gì, business value.>

## 2. User stories

> Format: As a <role>, I want <goal>, so that <benefit>.

1. <TODO>
2. <TODO>

## 3. Acceptance Criteria

> Verifiable. Given/When/Then format. Cover happy + edge + error.

- AC-1 (happy): Given <precondition>, when <action>, then <result>.
- AC-2 (edge): <TODO>
- AC-3 (error): <TODO>

## 4. Affected files

> Liệt kê file sẽ Create / Modify / Delete.

| Action | Path | Description |
|---|---|---|
| Create | `<TODO>` | <reason> |
| Modify | `<TODO>` | <reason> |
| Delete | `<TODO>` | <reason> |

## 5. Architecture / Design

### Approach

<TODO — pick 1 approach. Nếu có alternatives, link đến `docs/adr/<n>.md` (draft).>

### Data model changes

```
<TODO — schema, migration if needed>
```

### Sequence diagram (key flow)

```mermaid
sequenceDiagram
    <TODO>
```

## 6. Implementation plan

> Break thành discrete tasks, ordered by dependency.

- [ ] T-1: <TODO>
- [ ] T-2: <TODO> (depends on T-1)
- [ ] T-3: <TODO>
- [ ] T-4: Update `memory-bank/progress.md` and `activeContext.md`.
- [ ] T-5: Update `memory-bank/features/<name>.md` if feature large.

## 7. Test plan

| Layer | Test case | Coverage |
|---|---|---|
| Unit | <TODO — vd "Validate <method> with valid input"> | AC-1 |
| Unit | <TODO> | AC-2 |
| Integration | <TODO> | AC-1, AC-3 |
| E2E | <TODO> | full flow |

## 8. Validation commands

> Lệnh user/AI chạy để verify implementation pass.

```bash
<TODO — vd:
flutter test test/features/<feature>/
flutter analyze lib/features/<feature>/
flutter run --release  # smoke test manually
>
```

## 9. Edge cases & error handling

| Case | Expected behavior |
|---|---|
| <TODO — vd "Network offline"> | <vd "Queue, retry on reconnect"> |
| <TODO> | <TODO> |

## 10. Risks & mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| <TODO> | <H/M/L> | <H/M/L> | <TODO> |

## 11. Decision points (need user input before AI proceeds)

> Mandatory stops. AI MUST ask user before deciding.

- D-1: <TODO — vd "Choice between IndexedDB vs Hive for offline queue. Pros/cons:?"
- D-2: <TODO>

## 12. Out of scope

> Tránh AI làm quá scope.

<TODO — vd:
- KHÔNG handle conflict resolution (planned PRP-008).
- KHÔNG support batch upload > 50 files.>

## 13. Related

- ADRs: <TODO>
- Other PRPs: <TODO>
- memory-bank/features/<TODO>
- examples/<TODO>

---

## Execution log (filled during/after implementation)

### <YYYY-MM-DD> — kickoff

<notes>

### <YYYY-MM-DD> — done

<notes — what was changed, deviation from plan, lessons learned>
