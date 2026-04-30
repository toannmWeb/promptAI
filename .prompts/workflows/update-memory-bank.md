---
name: update-memory-bank
purpose: Cập nhật memory-bank ĐẦY ĐỦ + CHÍNH XÁC sau task — không miss file nào
input: <task description / commit hash / PR>
output: All affected memory-bank files updated với cite explicit
version: 1.0
last-updated: 2026-04-29
trigger-command: "update memory bank"
---

# Workflow: Update Memory Bank

> User concern (Q1.5): "Cập nhật code phải sửa các file abc đã sửa chưa? Đúng không?". Workflow này đảm bảo: sau task, MỌI memory-bank file affected đều được update CHÍNH XÁC, không miss.

## Pre-conditions

- Đã làm task code (commit / PR / change set rõ ràng).
- `docs/CHANGE-IMPACT.md` exists (lookup table).

## Workflow (1 prompt comprehensive)

AI làm trong 1 Edit-mode session:

### Step 1: Inventory changed files

1. List file code đã sửa (input từ user, hoặc git diff HEAD~N).
2. Categorize file theo type:
   - Source (UI / business / data / config).
   - Test.
   - Docs.
   - Build / CI.
   - Generated.

### Step 2: Lookup impact

Cho mỗi file changed:
1. Check `docs/CHANGE-IMPACT.md` → file memory-bank nào bị affect?
2. Aggregate set: `affected_mb_files = union(all impacts)`.

Output table:
```
| Changed file | Memory-bank impact |
|---|---|
| lib/data/services/user_service.dart | techContext.md (deps), integrations/firebase.md (auth flow) |
| lib/data/repositories/user_repo.dart | systemPatterns.md (repository pattern usage), features/user-mgmt.md |
| pubspec.yaml | techContext.md (versions) |
```

### Step 3: Detect missing or new patterns

1. Detect **new pattern** introduced (vd: code dùng pattern X nhưng pattern X chưa có trong systemPatterns.md hoặc examples/).
   - Action: append vào systemPatterns.md hoặc tạo examples/<X>.md.
2. Detect **new ADR needed** (architectural decision implicit trong code).
   - Action: propose ADR draft, save vào docs/adr/<NNNN>-<title>.md.
3. Detect **new term** không có trong glossary.
   - Action: append vào memory-bank/glossary.md.
4. Detect **new domain/integration/feature** chưa có file.
   - Action: tạo memory-bank/{features|integrations|domains}/<X>.md.

### Step 4: Update each affected file

For each file in `affected_mb_files`:

```markdown
## File: <path>

### Sections to update

- [ ] <section name>: <what changes>

### Diff preview

```diff
- old line
+ new line
```

### Cite source

- Code change: <file:line>
- ADR: <ADR-NNNN if applicable>
- PRP: <PRP-NNN if applicable>
```

### Step 5: Update activeContext.md (always)

Append entry:
```markdown
## YYYY-MM-DD: <task summary>

- Changed: <list files>
- Why: <reason>
- Memory-bank updated: <list updated files>
- New patterns: <list>
- New ADRs: <list>
```

### Step 6: Update progress.md (always)

Move task from "Next" to "Done" / "Recent achievements". Add to "What works" if user-visible.

### Step 7: Verification

Run `./scripts/check-memory-bank.sh` (or describe what it checks):
- Reference integrity (link đến file/ADR exist).
- No conflicting info giữa files.
- All sections required have content (no empty section).
- Date format consistent.

Output:
```
✅ Updated <N> memory-bank files:
- memory-bank/activeContext.md
- memory-bank/progress.md
- memory-bank/features/<X>.md
- ...

✅ Created:
- docs/adr/<NNNN>-<title>.md
- examples/<pattern>.md

✅ Verification: check-memory-bank.sh PASSED.

⚠ Decision points needing user input:
- D-1: Should this pattern be promoted to systemPatterns.md? (Currently only in 1 feature)

Confidence: <high/med/low>
Token usage: <estimate>
```

## Anti-patterns (KHÔNG làm)

- ❌ Update only activeContext.md, skip systemPatterns/features/integrations.
- ❌ Update file mà không cite code change.
- ❌ Tạo new pattern entry mà không add corresponding examples/<X>.md.
- ❌ Tạo new ADR mà không link từ systemPatterns.md.

## Halt conditions

DỪNG, hỏi user nếu:
- `docs/CHANGE-IMPACT.md` không tồn tại / outdated → user update lookup table trước.
- Conflicting info phát hiện (vd new code mâu thuẫn ADR Active) → user decide.
- Phát hiện missing memory-bank file đáng nhẽ phải có (vd integration mới) → user confirm tạo.

## Token efficiency

1 prompt = full update cho task. Không split.

→ User Edit panel sẽ thấy N diff (đa số nhỏ). Accept all sau review.

## Prompt template

```
@workspace update memory bank

Workflow: .prompts/workflows/update-memory-bank.md (7 steps).

Task vừa làm: <DESCRIPTION>
Files changed (hoặc git diff HEAD~N): <LIST>
PRP / ADR / commit: <REF>

Workflow:
1. Inventory changed files.
2. Lookup docs/CHANGE-IMPACT.md → affected memory-bank files.
3. Detect new pattern / ADR / term / domain.
4. Update each affected file (Edit mode).
5. Update activeContext.md.
6. Update progress.md.
7. Run check-memory-bank.sh.

Output cuối: list updated files + created files + decision points + confidence.
```
