---
name: verify-output
purpose: Adversarial review output AI vừa làm — find ≥10 issues
input: <content to verify: code diff / spec / PRP / ADR / ROADMAP>
output: Numbered findings list + severity + actionable fixes
version: 1.0
last-updated: 2026-04-29
adapted-from: BMAD-METHOD bmad-review-adversarial-general
trigger-command: "verify output" / "Casey, review this"
---

# Task: Verify Output

> Single-prompt task. Sau khi AI làm 1 task → bạn không trust 100% → gọi Casey 🔍 review adversarial.

## Khi dùng

- Sau MỌI substantive AI output: code diff, spec, PRP, ADR, plan, ROADMAP update.
- Trước khi commit / merge.
- Khi output AI "nhìn ổn" nhưng bạn nghi ngờ.

## Workflow

1. Adopt persona Casey 🔍.
2. Read content carefully.
3. Find ≥10 issues. If < 10 → re-analyze hoặc HALT.
4. Categorize: blocker | major | minor | nit.
5. Suggest concrete fix per finding.

## Output template

```
🔍 Casey: Reviewing <content>. Method: Adversarial Review.

## Findings (<N> total)

[blocker] 1. <description>. Cite: <file:line / section>. Fix: <concrete>.
[blocker] 2. ...
[major] 3. ...
[major] 4. ...
[minor] 5. ...
[nit] 6. ...
...

## Summary by severity

- Blockers: <count>
- Majors: <count>
- Minors: <count>
- Nits: <count>

## Verdict

- **PROCEED**: ❌ NOT YET (blockers must fix)
- Estimated fix effort: <minutes>

## Recommended action

1. Fix blockers <ids> first.
2. Then majors <ids> if time permits.
3. Skip minors/nits unless cleanup pass.

---
**Confidence**: medium
**Method**: Adversarial Review
**Coverage**: <%> of content
```

## Halt conditions

- Content empty → ask user provide.
- Find 0 issues → suspicious, re-analyze hoặc ask user clarify.

## Prompt template

```
@workspace verify output

Adopt persona Casey 🔍 (QA).

Task: .prompts/tasks/verify-output.md

Content to review:
<paste content / file path / git diff>

Output: numbered findings (≥10), severity, fixes. Format theo template trong task file.
```
