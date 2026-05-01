---
name: debug-loop
purpose: Vòng lặp debug — scan → hypothesis → verify → fix → re-test → loop đến khi hết bug
input: <bug description / error log / failing test>
output: Bug fixed + root cause documented in _logs/ + memory-bank update
version: 1.0
last-updated: 2026-04-29
adapted-from: BMAD-METHOD bmad-correct-course (sprint change management)
trigger-command: "debug loop <bug>" / "Amelia, debug loop"
---

# Workflow: Debug Loop

> Vòng lặp **scan → hypothesis → verify → fix → re-test → loop**. Tận dụng max 1 request mỗi iteration. Chấm dứt chỉ khi bug REPRODUCIBLE → FIXED → VERIFIED → DOCUMENTED.
>
> **Pre-check**: Workflow này yêu cầu test framework đã setup. Nếu chưa có → setup trước khi bắt đầu loop (vd: `npm init jest`, `pytest --co`, `flutter test`).

## Tại sao cần workflow này

User concern (Q2): "Với hệ thống lớn, bug xảy ra → AI phải xem lại tổng thể rồi fix → quay lại vòng lặp này cho tới hết bug. Hoặc tận dụng tối đa 1 request để dùng toàn bộ token."

→ Workflow này định nghĩa rõ:
- 1 iteration = 1 request đầy đủ (scan + hypothesis + propose fix).
- User decide: accept fix → next iteration verify, hoặc reject → re-iterate hypothesis.
- Loop break: reproducible fix + green test + memory-bank updated.

## Iteration template (mỗi vòng = 1 prompt-response)

```
Iteration <N>:

## A. Scan (whole context)
- Read: ROADMAP.md, memory-bank/activeContext.md, related memory-bank/features/<X>.md
- Read: code path liên quan (cite file:line)
- Read: stack trace / log / failing test
- Read: docs/runbooks/debug.md

## B. Hypothesis
- Top 3 hypotheses (ranked by likelihood):
  - H-1: <root cause candidate> — evidence: <file:line> — likelihood: <%>
  - H-2: ...
  - H-3: ...

## C. Verification plan
- For H-1: <how to confirm>: cmd / test / log assert
- For H-2: ...
- For H-3: ...

## D. Proposed fix (for top hypothesis)
- File(s) to change: <list>
- Change strategy: <description>
- Risk: <list>
- Test to add: <description>

## E. Decision points
- D-1: User confirm proceed với H-1, hoặc thử H-2/H-3 trước?
- D-2: Add test before fix (TDD), hay fix trước rồi add test?

---
**Iteration <N> output**:
- Confidence: <low/med/high>
- Next: User decide D-1, D-2 → AI proceed với chosen path.
```

## Loop control

Sau mỗi iteration:
- ✅ **"Proceed H-<X>, fix"**: AI implements fix → Iteration N+1 = verify (run test, check log).
- 🔁 **"Reject, try H-<Y>"**: AI re-iterate với new top hypothesis.
- ⏸ **"Pause, gather more info"**: AI list info needed (additional log, repro steps) → user provide → resume.
- ⏹ **"Stop, escalate"**: AI summarize state vào `_logs/` → handoff.

## Termination criteria (loop break)

ALL must be true:
1. ✅ Bug **reproducible** (có repro steps clear).
2. ✅ Root cause **identified** (cite file:line).
3. ✅ Fix **applied** (diff committed).
4. ✅ Test **green** (test reproduce bug giờ pass).
5. ✅ **Regression test** added.
6. ✅ Doc updated:
   - `memory-bank/activeContext.md` — log bug + fix.
   - `_logs/<YYYY-MM-DD>-bug-<short>.md` — full transcript + root cause + lesson learned.
   - `docs/runbooks/debug.md` — nếu pattern reusable, add vào "Common bugs" section.

## Token efficiency strategy (max 1 request/iteration)

Mỗi iteration tận dụng full context window:
- **Pre-load context** trong A (scan): read all files relevant 1 lần.
- **All 5 sections (A-E)** trong 1 response, không split.
- **No back-and-forth small Q** giữa iteration (trừ when user need decide).

→ Token budget mỗi iteration:
- Copilot: 8K-32K (limited) → focus narrow scope.
- Cursor / Claude Code: 200K → full repo scan possible.
- Adjust scan depth theo IDE.

## Halt conditions

DỪNG, hỏi user nếu:
- Bug không reproducible after 3 iterations → escalate.
- Fix require >10 file changes → ask Winston (Architect) review.
- Test framework chưa setup → setup TRƯỚC khi loop.
- Bug có security implication → ask user về disclosure policy.

## Anti-patterns (KHÔNG làm)

- ❌ Apply fix mà không có test reproduce.
- ❌ Loop mà không cite file:line.
- ❌ Gọi nhiều prompt nhỏ "thử cái này, thử cái kia" — phí token.
- ❌ Skip Section B (Hypothesis) → fix mò mẫm.
- ❌ Skip update memory-bank / _logs sau fix.

## Prompt template

```
@workspace debug loop: <bug description>

Adopt persona Amelia 💻 (Dev). Đọc .prompts/personas/dev.md trước.

Workflow: .prompts/workflows/debug-loop.md (iteration template).

Bug: <bug>
Repro: <steps>
Error log: <paste>
Failing test (nếu có): <path:line>

Bắt đầu Iteration 1: A. Scan → B. Hypothesis → C. Verify plan → D. Proposed fix → E. Decision.

Output đầy đủ trong 1 response. Sau đó đợi tôi decide D-1, D-2.
```
