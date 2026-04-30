# USAGE GUIDE — Prompt System v3.1.3

> Hướng dẫn dùng TOÀN BỘ khả năng của prompt system. Bao quát mọi tính năng + điểm mạnh.
>
> Đọc xong file này, bạn biết: **tình huống nào → dùng prompt/workflow/persona/snippet nào**.
>
> Cấu trúc: tổng quan → bảng tra cứu nhanh → 7 nhóm tình huống chi tiết với ví dụ copy-paste → mẹo dùng hiệu quả.

---

## 1. Tổng quan kho prompt

```
.prompts/
├── system/         base.md                     ← rules cốt lõi 22 rules, AUTO load
├── personas/       analyst, architect, dev, qa, reviewer, party-mode
├── workflows/      multi-step processes (debug-loop, refactor-safe, ...)
├── tasks/          single-step tasks (optimize-prompt, plan-feature, ...)
└── snippets/       reusable blocks (force-cite, dry-run, rollback, self-verify, ...)

samples/            ← prompt mẫu copy-paste được, theo từng case study
memory-bank/        ← long-term project knowledge
docs/               ← reference (REQUEST-MODES, PROMPT-VALIDITY, BENCHMARK-MODE-1)
```

### Khi nào dùng cái gì?

| Loại | Khi nào | Cách trigger |
|---|---|---|
| **Persona** | Cần góc nhìn chuyên môn (analyst, architect, dev, qa, reviewer) | `hey Mary, ...` / `Winston, ...` |
| **Workflow** | Multi-step task có pattern lặp lại (debug, refactor, feature E2E) | `debug loop <bug>` / `refactor safely <scope>` |
| **Task** | Single-step rõ mục tiêu (plan, explain, trace, document) | `plan feature <name>` / `trace flow <action>` |
| **Snippet** | Block tái sử dụng (cite, rollback, dry-run, confirmation) | Paste hoặc reference trong prompt |
| **Sample** | Cần prompt template hoàn chỉnh copy-paste | Mở file `samples/<name>.md` copy paste |
| **Mode 1** | Tối đa giá trị trong 1 request | `mode 1: <task>` / `one-shot max <task>` |
| **Party mode** | Multi-persona debate | `party mode <topic>` |

---

## 2. Bảng tra cứu nhanh — Tình huống → Prompt

| Tình huống | Dùng | File reference |
|---|---|---|
| Prompt thô mơ hồ, sợ AI hiểu sai | Task `optimize prompt` | `.prompts/tasks/optimize-prompt.md` |
| Bug khó debug, cần vòng lặp evidence | Workflow `debug loop` | `.prompts/workflows/debug-loop.md` |
| Refactor module có rủi ro | Workflow `refactor safely` | `.prompts/workflows/refactor-safe.md` |
| Lập kế hoạch feature mới | Task `plan feature` | `.prompts/tasks/plan-feature.md` |
| Implement feature lớn end-to-end | Workflow `feature end-to-end` | `.prompts/workflows/feature-end-to-end.md` |
| Học sâu 1 module xa lạ | Workflow `deep dive into` | `.prompts/workflows/deep-dive-learn.md` |
| Trace 1 luồng (ví dụ "user nhấn login") | Task `trace flow` | `.prompts/tasks/trace-flow.md` |
| Giải thích module cho dev mới | Task `explain module` | `.prompts/tasks/explain-module.md` |
| Pattern xuất hiện ≥3 lần, muốn extract | Task `extract pattern` | `.prompts/tasks/extract-pattern.md` |
| Cần doc cho feature lớn | Task `document feature` | `.prompts/tasks/document-feature.md` |
| Setup memory-bank lần đầu | Workflow `initialize memory bank` | `.prompts/workflows/initialize-memory-bank.md` |
| Cập nhật memory-bank sau task | Workflow `update memory bank` | `.prompts/workflows/update-memory-bank.md` |
| Apply skeleton vào project khác | Workflow `apply skeleton to <path>` | `.prompts/workflows/apply-to-project.md` |
| Verify output AI có đáng tin không | Task `verify output` | `.prompts/tasks/verify-output.md` |
| Audit toàn bộ template | Task `audit template` | `.prompts/tasks/audit-template.md` |
| Tranh luận đa chiều | Persona `party mode` | `.prompts/personas/party-mode.md` |
| Chỉ cần phân tích chiến lược (không code) | Persona `Mary 📊` | `.prompts/personas/analyst.md` |
| Quyết định kiến trúc + ADR | Persona `Winston 🏗` | `.prompts/personas/architect.md` |
| Implement test-first | Persona `Amelia 💻` | `.prompts/personas/dev.md` |
| Adversarial review tìm lỗi | Persona `Casey 🔍` | `.prompts/personas/qa.md` |
| Pre-flight prompt trước khi gửi cho dev khác | Persona `Quinn 🧐` | `.prompts/personas/reviewer.md` |
| 1 request làm hết, depth-first | Mode 1 | `.prompts/snippets/one-shot-max.md` |

---

## 3. Bảy nhóm tình huống chi tiết

### Nhóm 1 — Khám phá code

#### 1.1. Khám phá tổng quan project xa lạ

**Khi nào**: vừa join team mới, được giao codebase chưa biết gì.

**Prompt copy-paste**:
```
follow your custom instructions

Khám phá tổng quan project này:
- Stack chính (cite file:line trong package.json/pubspec.yaml/...).
- Architecture chính: layers, modules, dataflow chính.
- 5 entry point quan trọng nhất (main, route handler, screens chính).
- 3 hotspot — file/module được sửa nhiều nhất gần đây (gợi ý qua git log).
- Pending issues / TODO / FIXME nổi bật.

Output: Markdown với section, mỗi claim cite file:line.
Mode: analysis-only. Không sửa code.
```

→ Hoặc dùng sample đầy đủ: [samples/explore-project.md](../samples/explore-project.md)

#### 1.2. Trace 1 luồng cụ thể

**Khi nào**: muốn hiểu "user nhấn nút X thì backend làm gì".

```
trace flow user clicks "Login button" → 200 OK response

Output: 
- Sequence diagram Mermaid.
- Mỗi step cite file:line.
- Bottleneck / failure point gợi ý.
Folder output: docs/flows/login.md
```

→ Sample: [samples/trace-flow.md](../samples/trace-flow.md)

#### 1.3. Giải thích module dày đặc

```
explain module src/payments/

Đối tượng đọc: dev mới onboard, đã biết stack nhưng chưa biết domain.
Output: 
- Mục đích module.
- Public API + 1 ví dụ dùng từng cái.
- Internal flow + diagram.
- Đặc thù / cạm bẫy.
- Cite file:line.
```

---

### Nhóm 2 — Phát triển feature

#### 2.1. Lập kế hoạch trước khi code

**Khi nào**: feature > 50 LOC, multi-module.

```
plan feature: thêm tính năng "đặt lịch nhắc nhở định kỳ"

Constraints:
- Tuân thủ ADR Active.
- Khớp pattern hiện có (cite examples/ nếu có).
- AC testable, có verification commands.
Output: PRPs/NNN-recurring-reminder.md theo template.
```

#### 2.2. Implement feature end-to-end

```
feature end-to-end: implement PRPs/NNN-recurring-reminder.md

Mode: edit-files.
Iterations: Plan → Implement → Test → Verify. Mỗi iteration confirm tôi.
Stop khi: build pass, test pass, AC pass, tôi confirm.
Rollback plan bắt buộc trước khi sửa.
```

→ Sample đầy đủ: [samples/refactor-loop.md](../samples/refactor-loop.md)

#### 2.3. Mode 1 — implement nhanh trong 1 request

**Khi nào**: feature nhỏ (< 100 LOC), rõ AC, muốn 1 request xong.

```
mode 1: implement endpoint POST /api/users/:id/avatar

Constraints:
- Multipart upload, max 5MB, MIME image/* only.
- Lưu vào storage/avatars/, return URL.
- Test happy + sad path.

Scope: edit allowed = [src/routes/users.ts, src/services/storage.ts, tests/users.test.ts].
```

---

### Nhóm 3 — Debug

#### 3.1. Bug đơn giản

```
follow your custom instructions

Bug: nút Submit không hoạt động sau khi validate form fail lần đầu.
Steps to reproduce:
1. Mở /signup
2. Nhấn Submit khi email rỗng → thấy lỗi "email required" (đúng).
3. Nhập email → nhấn Submit → KHÔNG có gì xảy ra.

Expected: form submit success.
Mode: analysis-only trước, edit-files sau khi tôi confirm root cause.
```

#### 3.2. Bug khó — debug loop với evidence

```
debug loop: app crash khi upload file > 10MB ở trang /import

Yêu cầu:
- Iteration 1: hypothesis + evidence cite file:line + verification commands.
- Tôi run command, paste output.
- Iteration 2: refine hypothesis dựa trên output.
- Tối đa 5 iterations.
- Stop khi: root cause cite được + fix plan có rollback.
```

→ Workflow: `.prompts/workflows/debug-loop.md`

#### 3.3. Bug + giải thích cho người không biết code

```
fix and explain: lỗi 500 khi gọi /api/orders/:id

Output 4 phần:
1. Bối cảnh: code đang làm gì khi gọi endpoint này.
2. Bug ở đâu, tại sao lỗi (cite file:line).
3. Cách sửa + tại sao chọn cách đó (so sánh 2 alternatives).
4. Sửa + verify (test command + expected).

Mục tiêu: tôi HIỂU bug + cách sửa, không chỉ thấy patch.
```

→ Sample: [samples/fix-explain.md](../samples/fix-explain.md)

---

### Nhóm 4 — Refactor

#### 4.1. Refactor an toàn (smallest change)

```
refactor safely: tách function processOrder() trong src/orders/service.ts thành 3 function nhỏ

Constraints:
- Smallest safe change. Không đổi behavior.
- Test hiện có phải pass nguyên xi (không sửa test).
- Rollback plan bắt buộc trước khi edit.
- Dry-run trước, Confirmation Gate, sau đó edit.
```

#### 4.2. Refactor + tính năng mới — vòng lặp

```
refactor + feature loop:
- Refactor: tách OrderService thành 3 service nhỏ (Pricing, Inventory, Notification).
- Feature mới: thêm "discount code" áp dụng khi tính giá.

Iterations:
1. Plan (chia nhỏ task, dependencies, rollback plan).
2. Tôi confirm.
3. Implement bước 1.
4. Test + verify.
5. Fail → quay lại Plan. Pass → bước tiếp.
End: tất cả test+build pass + tôi confirm.
```

→ Sample: [samples/refactor-loop.md](../samples/refactor-loop.md)

#### 4.3. Extract pattern xuất hiện nhiều lần

```
extract pattern repository-with-cache from src/users/repo.ts:42-89

Yêu cầu:
- Tạo examples/repository-with-cache.md theo template.
- Liệt kê 3+ chỗ pattern đã xuất hiện.
- Variants nếu có.
```

---

### Nhóm 5 — Review

#### 5.1. Review trước khi merge PR

```
hey Casey, review PR sau với góc nhìn adversarial:

Files changed:
- src/auth/login.ts
- src/auth/session.ts

Find:
- Edge cases.
- Security holes (auth, validation, injection, secret).
- Race conditions / failure modes.
- Test coverage gap.

Output: list findings sorted by severity, mỗi finding cite file:line + cách fix.
```

#### 5.2. Verify output AI vừa generate

```
verify output: <paste AI output cần verify>

Check:
- Mỗi claim có cite file:line không? File:line đó thực sự đúng không?
- Có hallucination không (file/function không tồn tại)?
- Verification commands có chạy được không?
- AC có testable không?

Output: pass/fail per item + remediation.
```

→ Task: `.prompts/tasks/verify-output.md`

#### 5.3. Pre-flight prompt trước khi gửi cho dev khác

```
hey Quinn, review prompt sau trước khi tôi gửi:

<paste draft prompt>

Check: goal/scope/context/AC/verification/halt rõ chưa?
Suggest fix.
```

---

### Nhóm 6 — Học sâu

#### 6.1. Deep dive 1 module với validation

```
deep dive into src/queue/

Yêu cầu:
- AI trình bày dần từng layer (use case → API → internal → infra).
- Mỗi claim cite file:line.
- Self-verify: AI tự đọc lại, xác nhận file:line tồn tại.
- Nếu không tìm thấy evidence → nói rõ "không thấy trong codebase loaded".
- Output dạng folder 9 file có evidence ledger, coverage map, risk/change guide.
- Cuối: 10 câu quiz active recall + đáp án + cite.

Folder output: docs/learn/queue-deep-dive/
```

→ Sample: [samples/deep-dive-validated.md](../samples/deep-dive-validated.md)

#### 6.2. Active recall + Feynman

```
explain module <path> using Feynman technique:
- Giải thích như cho người 12 tuổi.
- Phát hiện chỗ tôi (AI) chưa hiểu rõ → đào sâu lại.
- 5 quiz câu hỏi mở (không phải yes/no).
- 3 câu so sánh với pattern khác.
```

#### 6.3. Party mode — debate học thuật

```
party mode: nên dùng REST hay tRPC cho project này?

Yêu cầu: Mary, Winston, Amelia, Casey, Quinn debate 2 round.
Round 1: mỗi persona nêu góc nhìn.
Round 2: phản biện chéo.
Output cuối: synthesis + recommendation + decision points.
```

---

### Nhóm 7 — Quản lý knowledge

#### 7.1. Initialize memory-bank lần đầu

```
initialize memory bank

Quét code project, fill 6 file core memory-bank/ theo template.
Cite file:line. Dùng Edit mode.
```

→ Workflow: `.prompts/workflows/initialize-memory-bank.md`

#### 7.2. Update memory-bank sau task

```
update memory bank

Vừa xong: <task>.
Cập nhật:
- activeContext.md với current focus mới.
- progress.md mark <feature> done.
- systemPatterns.md nếu architecture đổi.
```

#### 7.3. Document feature lớn

```
document feature recurring-reminder

Tạo memory-bank/features/recurring-reminder.md từ template.
Source: code thật + PRPs/NNN-recurring-reminder.md + ADR liên quan.
Cite file:line.
```

#### 7.4. Audit toàn bộ template

```
audit template

Check: 
- Tất cả prompt có frontmatter không.
- Mọi reference giữa các file có đúng path không.
- Có dead reference không.
- Output structure có nhất quán không.

Output: report fail/warn/pass.
```

→ Task: `.prompts/tasks/audit-template.md`

---

## 4. Mẹo dùng hiệu quả nhất

### 4.1. Mode 1 — khi nào nên & không nên

**Nên**:
- Task rõ scope, AC testable, < 100 LOC change.
- Cần phân tích depth-first 1-3 vấn đề trọng yếu.
- Multi-lens review (Code/Architecture/Security/Performance/DX).
- Tiết kiệm request (limit chat).

**Không nên**:
- Task có > 5 unknowns (cần optimize-prompt trước).
- Cần dry-run user confirm nhiều bước.
- Bug khó cần evidence loop nhiều iteration.

→ Reference: [docs/REQUEST-MODES.md](REQUEST-MODES.md), [docs/BENCHMARK-MODE-1.md](BENCHMARK-MODE-1.md)

### 4.2. Kết hợp persona + snippet

| Combo | Khi nào | Cách trigger |
|---|---|---|
| `Casey + force-cite + self-verify` | Adversarial review không hallucinate | `hey Casey, review <scope>; áp dụng .prompts/snippets/force-cite.md + self-verify.md` |
| `Winston + dry-run + rollback` | Quyết định kiến trúc lớn | `Winston, đề xuất ADR cho <decision>; dry-run trước, có rollback plan` |
| `Amelia + force-cite + confidence-scale` | Implement test-first | `Amelia, implement <feature> test-first, cite file:line, confidence rõ` |
| `party mode + 5×5 multi-lens` | Quyết định trade-off lớn | `party mode <topic>; multi-lens 5 dimensions × 5 personas` |

### 4.3. Confirmation Gate

Khi cần user xác nhận:
- Reply `OK` → dùng recommended default.
- Reply `D-1=A D-2=N` → chọn từng decision point.
- Reply `OK except #2` → OK trừ item #2.
- Reply `STOP` → hủy.

→ Snippet: `.prompts/snippets/confirmation-gate.md`

### 4.4. Khi AI có vẻ không đọc memory-bank

```
follow your custom instructions

Tóm tắt project dựa TRÊN memory-bank/. Cite tên file memory-bank/<file>.md trong tóm tắt.
```

→ Nếu AI vẫn không cite → tool có thể chưa load AGENTS.md/.github. Xem `docs/setup/multi-tool-guide.md`.

### 4.5. Khi prompt quá rộng / risky

AI sẽ tự gọi Confirmation Gate. Hoặc bạn chạy pre-flight:

```
optimize prompt:
<draft>

Cụ thể hóa: goal, scope edit-allowed, AC testable, verification command, rollback plan.
```

### 4.6. Khi cần kiểm chứng output AI

```
verify output: <paste output>

Check force-cite + self-verify checklist 9 nhóm.
```

→ Snippet: `.prompts/snippets/self-verify.md`

### 4.7. Tận dụng samples/

Folder [samples/](../samples/) chứa prompt mẫu hoàn chỉnh:
- [samples/gather-context.md](../samples/gather-context.md) — thu thập context lần đầu, ghi thẳng `memory-bank/`, hỗ trợ Continuation Handoff.
- [samples/explore-project.md](../samples/explore-project.md) — khám phá tổng quan, output đa file.
- [samples/trace-flow.md](../samples/trace-flow.md) — trace 1 luồng + sequence diagram.
- [samples/refactor-loop.md](../samples/refactor-loop.md) — refactor + feature loop.
- [samples/fix-explain.md](../samples/fix-explain.md) — fix bug có giải thích.
- [samples/deep-dive-validated.md](../samples/deep-dive-validated.md) — học sâu có evidence ledger, coverage map, self-validation và quiz.

Copy-paste, sửa placeholder, dùng ngay.

---

## 5. Checklist daily — chọn đúng tool

```
Mỗi task mới, trả lời 4 câu:

1. Task này CÓ AC rõ ràng chưa?
   - Chưa → optimize prompt trước.
   - Rồi → tiếp.

2. Task có RISKY (destructive / >3 file / migration / prod config)?
   - Có → bắt buộc dry-run + confirmation gate.
   - Không → tiếp.

3. Task có Pattern lặp (debug, refactor, feature E2E, deep dive)?
   - Có → dùng workflow.
   - Không → dùng task / persona.

4. Tôi muốn 1 request hay nhiều iteration?
   - 1 request, depth-first 1-3 vấn đề → mode 1.
   - Nhiều iteration với evidence loop → workflow tương ứng.
```

---

## 6. Đọc thêm

- [docs/REQUEST-MODES.md](REQUEST-MODES.md) — Mode 1 vs default mode.
- [docs/BENCHMARK-MODE-1.md](BENCHMARK-MODE-1.md) — Cách chấm điểm Mode 1.
- [docs/PROMPT-VALIDITY.md](PROMPT-VALIDITY.md) — Tiêu chí prompt valid.
- [docs/CHANGE-IMPACT.md](CHANGE-IMPACT.md) — Sửa code → memory-bank cần update gì.
- [docs/setup/multi-tool-guide.md](setup/multi-tool-guide.md) — Setup từng AI tool.
- [docs/TEMPLATE-MODE.md](TEMPLATE-MODE.md) — Repo master template purity.
