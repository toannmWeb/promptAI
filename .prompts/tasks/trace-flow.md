---
name: trace-flow
purpose: Trace 1 user/system action qua các tầng với evidence, happy path, branches, data/state, side effects, risk và tests
input: <action description> + optional entrypoint hint + optional output folder
output: Markdown trace hoặc output folder 8 file khi cần độ sâu cao
version: 2.0
last-updated: 2026-04-30
trigger-command: "trace flow <action>"
---

# Task: Trace Flow

> Single-flow analysis. Theo dấu 1 action cụ thể xuyên suốt các tầng kiến trúc. Dùng cho onboarding, debug, review integration và hiểu hệ thống trước khi sửa code.

## Khi dùng

- Bug "tôi click X mà không thấy gì xảy ra" → trace để biết action chết ở tầng nào.
- Onboard developer mới → cho họ thấy 1 action đi qua những module/layer nào.
- Verify integration end-to-end.
- Sau `samples/explore-project.md`, khi file 12 đã đề xuất một flow quan trọng cần trace.

## Khi KHÔNG dùng

- Chưa biết flow nào quan trọng → dùng `samples/explore-project.md` trước.
- Chỉ cần hiểu sâu 1 module → dùng `samples/deep-dive-validated.md`.
- Muốn sửa ngay → trace trước, rồi dùng `debug loop <bug>` hoặc `samples/fix-explain.md`.

## Quality bar

Output đạt chuẩn khi:

- Entry point được xác định bằng evidence hoặc ghi rõ `NEEDS CLARIFICATION`.
- Mỗi step happy path có `file:line`, input, output, next step và confidence.
- Diagram Mermaid khớp step table; không có arrow không trace được.
- Có branches/errors/edge cases, data transformations, state changes, side effects, security/performance/observability và tests.
- Mọi claim phân loại rõ: Fact / Inference / Gap / Risk / Recommendation.
- Không gọi risk là bug nếu chưa có repro/test fail.

## Task contract

- Goal: trace một action cụ thể end-to-end để người đọc hiểu flow và audit được từng bước bằng evidence.
- Scope:
  - Read allowed: entrypoint/candidate entrypoints, callers/callees trực tiếp, UI/state/API/controller/service/repository/model/schema/test/config liên quan.
  - Edit allowed: output file/folder do user chỉ định; nếu không có output folder thì chỉ trả trong chat.
  - Do not edit: source code, config, docs hiện có, memory-bank, ADR, PRP.
- Context to load:
  - `ROADMAP.md`.
  - `.prompts/system/base.md`.
  - `.prompts/snippets/prompt-contract.md`.
  - `.prompts/snippets/force-cite.md`, `.prompts/snippets/confidence-scale.md`, `.prompts/snippets/self-verify.md`.
  - `memory-bank/systemPatterns.md`, `memory-bank/techContext.md`, `memory-bank/activeContext.md` nếu tồn tại; chỉ đọc để đối chiếu, không sửa.
  - ADR/PRP/examples liên quan nếu code/docs reference.
- Acceptance criteria:
  - AC-1: Entry point confirmed hoặc candidate list + `NEEDS CLARIFICATION`.
  - AC-2: Mọi Fact về code có cite `file:line`.
  - AC-3: Happy path có step table và Mermaid diagram khớp nhau.
  - AC-4: Data/state/side effects được cover hoặc ghi Gap.
  - AC-5: Branches/errors/edge cases được cover hoặc ghi Gap.
  - AC-6: Security/performance/observability được cover hoặc ghi Gap/Risk.
  - AC-7: Tests và verification commands có expected result.
  - AC-8: Không sửa source code, docs hiện có, memory-bank, ADR, PRP.
- Memory-bank impact: không cập nhật memory-bank trong task này; nếu phát hiện thiếu/sai, ghi Recommendation trong output.
- Verification: chọn cite ngẫu nhiên để kiểm line tồn tại; render Mermaid; kiểm mọi Risk chưa bị gọi là bug khi chưa có repro/test fail.
- Execution mode: analysis-only với code app; edit/generate artifact chỉ trong output file/folder nếu user chỉ định.

## Recommended sample

Khi user cần output "cực sâu", dùng sample đầy đủ:

```text
samples/trace-flow.md
```

Sample này tạo 8 file:

1. `00-run-summary.md`
2. `01-evidence-and-coverage.md`
3. `02-flow-map-and-entrypoints.md`
4. `03-main-path-step-trace.md`
5. `04-data-state-and-side-effects.md`
6. `05-branches-errors-and-edge-cases.md`
7. `06-security-performance-observability.md`
8. `07-tests-verification-and-next-actions.md`

## Minimal output template

Dùng template này khi user chỉ cần trace rút gọn trong chat hoặc 1 file Markdown:

```markdown
# Flow trace: <action>

## Reader TL;DR
- Flow này bắt đầu từ đâu.
- Kết quả thành công là gì.
- Hệ thống đi qua những module/layer nào.
- Phần nào đã có evidence chắc.
- Phần nào còn là Gap/Risk.

## Flow contract

| Field | Value | Evidence | Confidence |
|---|---|---|---|
| Trigger | <user action / endpoint / job / webhook> | `<file:line>` | high/medium/low |
| Entry point | <component / handler / command> | `<file:line>` | high/medium/low |
| Expected outcome | <observable result> | `<file:line>` hoặc Gap | high/medium/low |
| Boundary outside repo | <yes/no/details> | `<file:line>` hoặc Gap | high/medium/low |

## Steps

| Step | Actor | Layer | File:line | What happens | Input | Output | Next | Type | Confidence |
|---|---|---|---|---|---|---|---|---|---|
| TF-S01 | User | UI | `path/file.ext:10` | <mô tả dễ hiểu> | <input> | <output> | TF-S02 | Fact | high |
| TF-S02 | UI | State/API | `path/file.ext:22` | <mô tả> | <input> | <output> | TF-S03 | Fact | high |

## Sequence diagram

~~~mermaid
sequenceDiagram
    actor User
    participant UI
    participant State
    participant API
    participant DB
    User->>UI: Step TF-S01
    UI->>State: Step TF-S02
    State->>API: Step TF-S03
    API->>DB: Step TF-S04
~~~

## Diagram trace table

| Mermaid arrow | Step ID | Evidence | Confidence |
|---|---|---|---|
| User -> UI | TF-S01 | `path/file.ext:10` | high |

## Data / state / side effects

| Step | Data/state change | Side effect | Evidence | Confidence |
|---|---|---|---|---|
| TF-S03 | DTO created | HTTP request | `path/file.ext:42` | high |

## Branches / errors / edge cases

| Branch | Condition | Where handled | User/system result | Evidence | Type | Confidence |
|---|---|---|---|---|---|---|
| TF-B01 | validation fails | `path/file.ext:55` | inline error | `path/file.ext:55` | Fact | high |

## Security / performance / observability

| Area | Finding | Evidence | Type | Suggested verification |
|---|---|---|---|---|
| Auth | <finding> | `<file:line>` | Fact/Risk/Gap | <check> |

## Tests covering this flow

| Test | Covers steps/branches | Evidence | Gap |
|---|---|---|---|
| <test name> | TF-S01..TF-S03 | `<test-file:line>` | <gap or none> |

## Verification

- `<test command>` -> expect: <result>.
- Manual: <action> -> expect: <observable behavior>.

## What to trust / What not to assume
- What to trust: <claims with direct evidence>.
- What not to assume: <gaps, inferred steps, outside-repo boundary>.

---
**Confidence**: low | medium | high
**Assumptions**:
- A-1: ...
**Decision points needing user input**:
- D-1: ... hoặc `none`
**Self-verify**: <N>/9 nhóm pass; nhóm fail: <list hoặc "none">.
```

## Halt / downgrade conditions

- Action không đủ cụ thể để tìm entry point → tạo candidate entrypoints nếu có evidence; nếu không có candidate đáng tin, hỏi user bằng Confirmation Gate.
- Flow vượt repo → trace đến boundary, annotate Gap, không bịa phần ngoài repo.
- Mermaid không map được về step table → bỏ arrow hoặc đánh dấu Inference.
- Code chưa load đủ → confidence không được high.

## Prompt template

```text
@workspace trace flow: <ACTION>

Adopt Mary (Analyst).

Task: .prompts/tasks/trace-flow.md

Action: <ACTION>
Entry point hint (optional): <screen/button/handler/endpoint/job/file>
Output folder (optional, recommended for deep trace): <output folder>

Requirements:
- Evidence-bound trace with cite file:line per Fact.
- Happy path + branches + data/state + side effects + security/performance + tests.
- If using deep output, follow samples/trace-flow.md and generate 8 files.
- Mode: analysis-only. Do not edit app code.
```
