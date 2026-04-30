---
name: refactor-safe
purpose: Refactor không phá behavior — test-first, scope-bounded, reversible
input: <scope: file/folder/feature>
output: Refactored code + same tests pass + ADR if pattern change
version: 1.0
last-updated: 2026-04-29
trigger-command: "refactor safely <scope>" / "Winston, refactor strategy"
---

# Workflow: Refactor Safely

> Refactor **không đổi behavior**. Bắt buộc test-first. Scope-bounded. Reversible (nếu xấu, revert dễ).

## Phases

### Phase 1: Charter (5-10 phút)

User input: `<scope>`.

AI làm:
1. Đọc `ROADMAP.md`, `systemPatterns.md`, ADRs liên quan.
2. List **goals** của refactor (vd: "giảm coupling", "tách 1 god class thành 3 class", "đổi pattern A → B").
3. List **non-goals** (NOT touch behavior, NOT change public API, NOT introduce new lib).
4. Define **scope boundary**: file/folder cụ thể được phép edit.
5. Output Charter:
   ```
   ## Refactor Charter: <name>
   - Scope: <files>
   - Goals: <list>
   - Non-goals: <list>
   - Behavior contract (unchanged): <list>
   - Public API (unchanged): <list>
   - Reversibility plan: <how to revert if bad>
   ```

User confirm Charter.

### Phase 2: Test inventory (10-15 phút)

AI làm:
1. List all existing tests covering scope (cite test file:line).
2. Identify **coverage gaps** — behavior chưa có test.
3. Write **characterization tests** (golden master) cho gap → cover behavior CURRENT trước khi refactor.
4. Run all tests → confirm green BASELINE.

User confirm: tests green, ready to refactor.

### Phase 3: Refactor (small steps)

Mỗi step:
1. **Small change** (≤50 LOC, 1 concept).
2. **Run tests** → green.
3. **Commit** với message clear (`refactor: extract X from Y`).
4. **Repeat**.

AI tracks progression trong table:
```
Step | Change | Files | Tests | Commit
1 | Extract validateEmail() from UserService | user_service.dart | green | abc1234
2 | Move isAdult() to User model | user.dart, user_service.dart | green | def5678
...
```

### Phase 4: Verification

1. All tests green.
2. **Behavior diff** — compare before/after on:
   - Public API signatures.
   - DB schema (nếu touched).
   - Network calls (nếu touched).
   - File output / artifacts.
3. **Performance check** — benchmark trước/sau (nếu refactor liên quan perf).
4. Manual smoke test (nếu UI).

### Phase 5: Document

1. Update `memory-bank/systemPatterns.md` với pattern mới.
2. Nếu pattern change đáng kể → tạo ADR (`docs/adr/<NNNN>-<title>.md`).
3. Update `memory-bank/progress.md`.
4. Save log vào `_logs/<date>-refactor-<scope>.md`.

## Halt conditions

DỪNG nếu:
- Test fail và không phải do refactor (preexisting flake) → fix flake trước.
- Phải đổi public API → STOP, ask user (đây không còn là "safe refactor").
- Phải đổi DB schema → STOP, treat as migration (workflow khác).
- Step >50 LOC → split nhỏ hơn.

## Anti-patterns

- ❌ Refactor + add feature trong cùng commit.
- ❌ Big-bang refactor (>500 LOC trong 1 commit).
- ❌ Refactor mà không có test baseline.
- ❌ Skip characterization test cho behavior chưa cover.

## Prompt template

```
@workspace refactor safely: <SCOPE>

Adopt persona Winston 🏗 (Architect) cho Charter, sau đó handoff sang Amelia 💻 (Dev) cho execution.

Workflow: .prompts/workflows/refactor-safe.md (5 phases).

Bắt đầu Phase 1: Charter.
- Scope: <SCOPE>
- Goals (user input): <GOALS>

Sau Phase 1, đợi tôi confirm Charter trước khi sang Phase 2.
```
