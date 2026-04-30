# PROMPT-VALIDITY.md — Pre-flight checklist

> **Mục đích**: Trước khi gửi prompt cho AI, check 2 thứ:
> 1. **Valid** — format đúng, AI hiểu được.
> 2. **Complete** — đủ context, AI không phải đoán.
>
> User concern (Q1.4): "Mỗi project tạo prompt khác nhau, không đồng nhất, không có form cố định dễ hiểu."
>
> File này = **form chuẩn**. Áp cho mọi prompt trong mọi project.

---

## Cách dùng

### 3 cách

**Cách 1 — Manual checklist** (5 phút):
1. Mở file này song song với prompt draft.
2. Đi qua từng item, check ✅ / ✗.
3. Fix các ✗ trước khi gửi.

**Cách 2 — Tự động bằng script** (30 giây):
```bash
./scripts/verify-prompt.sh /path/to/draft-prompt.md

# Khi kiểm tra file prompt template có placeholder <...> cố ý:
./scripts/verify-prompt.sh --allow-template .prompts/tasks/<task>.md
```
Script báo pass/fail per check.

**Cách 3 — Quinn 🧐 review** (2 phút):
```
@workspace Quinn, review prompt sau:
[paste prompt draft]
```
Quinn (persona) sẽ apply checklist và đề xuất revised prompt.

---

## Prompt Contract tối thiểu

Prompt tốt không chỉ "hợp lệ"; nó phải là một **task contract** đủ để AI thực thi mà không đoán:

```markdown
Goal: <outcome cụ thể>
Scope: read <files/folders>; edit <files/folders>; do not touch <boundaries>
Context: ROADMAP.md + memory-bank refs + ADR/PRP/examples/workflow refs
Acceptance criteria: AC-1, AC-2, ... testable
Execution mode: analysis-only | edit-files | review-only | generate-artifact
Verification: commands + expected result
Output format: Markdown/table/PRP/ADR/Mermaid/code summary
Halt if: conflict, risky operation, missing context, ambiguous AC
```

Nếu prompt thô chưa đạt contract này, dùng:

```bash
optimize prompt <draft>
```

Hoặc reference trực tiếp `.prompts/tasks/optimize-prompt.md` + `.prompts/snippets/prompt-contract.md`.

---

## Checklist

### A. Validity (format)

| # | Check | Pass criteria |
|---|---|---|
| A0 | **Task contract present** | Prompt có Goal, Scope, Context, Acceptance criteria, Execution mode, Verification, Output format, Halt. |
| A1 | **Memory-bank reference** | Prompt mention ít nhất 1 file `memory-bank/*.md` HOẶC bảo AI "đọc memory-bank trước". |
| A2 | **Scope rõ ràng** | Prompt chỉ rõ: file/folder/feature/module nào sẽ touch. KHÔNG: "fix tất cả bug". |
| A3 | **Acceptance criteria** | Prompt có ít nhất 1 AC testable (vd: "test pass", "lint 0 errors", "endpoint return 200"). |
| A4 | **Cite request** | Prompt yêu cầu AI cite `file:line` cho mọi claim về code. |
| A5 | **Confidence + Assumptions** | Prompt yêu cầu output cuối có Confidence + Assumptions (theo `.prompts/snippets/confidence-scale.md`). |
| A6 | **Decision points** | Prompt yêu cầu AI list Decision Points thay vì tự decide thay user. |
| A7 | **Output format** | Prompt chỉ rõ output expected: markdown / code diff / table / mermaid? |
| A8 | **Execution mode** | Prompt nói rõ AI chỉ phân tích, review, tạo artifact, hay được sửa file bằng Edit/Agent mode. |
| A9 | **Confirmation gate** | Nếu task có thể cần user input, prompt yêu cầu gom questions vào 1 block với recommended default + reply format. |

### B. Completeness (context)

| # | Check | Pass criteria |
|---|---|---|
| B1 | **Workflow / task reference** | Prompt link `.prompts/workflows/*.md` hoặc `.prompts/tasks/*.md` phù hợp. |
| B2 | **ADR / PRP refs** | Nếu task liên quan kiến trúc → cite ADR. Nếu task có PRP → cite PRP. |
| B3 | **Examples ref** | Nếu task dùng pattern → cite `examples/<X>.md` để AI follow. |
| B4 | **Edit mode directive** | Nếu task sửa file → bảo AI dùng Edit mode (không paste diff text). |
| B5 | **Language directive** | Specify "Trả lời TIẾNG VIỆT" hoặc "Reply in ENGLISH". |
| B6 | **Halt conditions** | List tình huống AI phải DỪNG hỏi user thay vì proceed. |
| B7 | **Memory-bank impact** | Nếu task sửa code/docs → yêu cầu tra `docs/CHANGE-IMPACT.md` và nêu file memory-bank cần update. |
| B8 | **Verification expectation** | Mỗi command có expected result, không chỉ list command trống. |
| B9 | **IDE request economy** | Prompt tránh hỏi rải rác nhiều lượt; dùng `OK` / `D-1=A` reply format khi cần xác nhận. |

### C. Risk (ambiguity)

| # | Check | Pass criteria |
|---|---|---|
| C1 | **No vague terms** | Tránh từ mơ hồ: "tốt", "nhanh", "tối ưu", "user-friendly", "robust", "scalable", "clean". Số hóa nếu có thể. |
| C2 | **No conflicting instructions** | Section A không mâu thuẫn section B trong cùng prompt. |
| C3 | **No assumed knowledge** | Mọi term/abbreviation domain-specific phải define hoặc link glossary. |
| C4 | **Token budget** | Estimate tokens prompt + expected response < context window của model. |
| C5 | **Single responsibility** | 1 prompt = 1 main task. KHÔNG: "fix bug A và refactor B và document C". |
| C6 | **Memory-bank initialized** | Nếu task cần facts của project, 6 core files không còn `<TODO>` hoặc prompt yêu cầu initialize trước. |
| C7 | **Reversibility / rollback** | Với edit/refactor/migration, prompt nói rõ cách rollback hoặc boundary để revert an toàn. |

---

## Verdict logic

| Pass | Warn | Fail | Verdict |
|---|---|---|---|
| ≥ 9 | ≤ 2 | 0 | ✅ READY — gửi đi. |
| ≥ 7 | ≤ 4 | 0 | ⚠ USABLE — cân nhắc fix warnings. |
| any | any | ≥ 1 | ❌ NOT READY — fix failures trước. |

---

## Example: Bad prompt → Good prompt

### ❌ Bad

```
Sửa bug auth giúp tôi.
```

Why bad:
- A1 ✗ no memory-bank ref
- A2 ✗ scope mơ hồ ("auth" — UI? backend? all?)
- A3 ✗ no AC
- A4 ✗ no cite request
- A5 ✗ no Confidence
- A6 ✗ AI sẽ tự decide cách fix
- A7 ✗ no output format
- C1 ✗ "bug auth" mơ hồ

→ AI sẽ đoán → output sai → bạn không biết tại sao sai.

### ✅ Good

```
@workspace debug loop: bug user không login được khi password có ký tự `\`

Đọc trước:
- memory-bank/systemPatterns.md (auth flow section)
- memory-bank/integrations/firebase-auth.md
- ADR-0002 (auth strategy)

Workflow: .prompts/workflows/debug-loop.md (iteration template).

Bug:
- Repro: nhập password "abc\def" → submit form → 0 error message hiện.
- Console log: "TypeError: undefined is not iterable at AuthService.login:42"
- Failing test: chưa có (cần add).

Bắt đầu Iteration 1:
- A. Scan: read AuthService, AuthBloc, login_screen.
- B. Hypothesis: top 3, cite file:line.
- C. Verify plan.
- D. Proposed fix: minimal scope, test-first.
- E. Decision points.

Output đầy đủ trong 1 response. Đợi tôi decide D-1 trước khi proceed.

Trả lời TIẾNG VIỆT. Cite file:line. Confidence + Assumptions cuối câu.

DỪNG nếu:
- Test framework chưa setup.
- Fix vượt 5 file.
- Bug có security implication (cần disclosure).
```

→ AI có context đủ → output có thể trust → bạn verify được.

---

## Common pitfalls (red flags)

| Pitfall | Fix |
|---|---|
| "Fix tất cả bug trong module X" | Scope nhỏ: 1 bug 1 prompt. |
| "Refactor toàn bộ codebase" | Phase by phase, dùng `refactor-safe.md` workflow. |
| "Implement feature Y" mà không có PRP | Tạo PRP trước (dùng `plan-feature.md` task). |
| "Fix performance" | Số hóa: từ X ms → < Y ms. |
| "Make it cleaner" | Clean theo metric: cyclomatic complexity < N, LOC per func < M. |
| "Use best practice" | Cite specific best practice: ADR-X / pattern-Y / docs-link. |

---

## Maintenance

- Update file này khi:
  - Tìm thêm prompt failure mode mới (add to checklist).
  - Tìm thêm vague term phổ biến (add to C1).
  - Có pattern prompt mới prove value (add to "Common pitfalls").

- Khi update, bump version trong `scripts/verify-prompt.sh` nếu logic check thay đổi.
