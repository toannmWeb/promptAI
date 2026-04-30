---
name: sample-explore-project
purpose: Khám phá tổng quan project với scope BE/FE/full, output đa file có evidence index, coverage log, self-validation và deep-dive queue
input: scope=BE|FE|full + output=<folder path>
output: 13 file .md trong folder output (summary, evidence, map, entrypoints, architecture, data, patterns, stack, tests, security/perf, issues, ranked modules/flows for next deep dives)
version: 1.2
last-updated: 2026-04-30
---

# Sample: Explore Project

## Khi nào dùng

- Vừa join team mới, được giao codebase chưa biết gì.
- Cần handover doc gọn cho dev mới.
- Refactor lớn, cần map toàn bộ trước khi đụng vào.
- Cần output rời để đọc lại, không muốn ghi thẳng vào `memory-bank/`.
- Cần biết module/flow nào quan trọng để chạy `samples/deep-dive-validated.md` hoặc `samples/trace-flow.md` tiếp theo.

## Khi KHÔNG dùng

- Muốn khởi tạo long-term memory cho AI ở project thật → dùng `samples/gather-context.md`.
- Chỉ cần hiểu 1 module sâu → dùng `samples/deep-dive-validated.md`.
- Chỉ cần trace 1 luồng cụ thể → dùng `samples/trace-flow.md`.

## Reference

- Workflow liên quan: [.prompts/workflows/deep-dive-learn.md](../.prompts/workflows/deep-dive-learn.md)
- Task liên quan: [.prompts/tasks/explain-module.md](../.prompts/tasks/explain-module.md), [.prompts/tasks/trace-flow.md](../.prompts/tasks/trace-flow.md), [.prompts/tasks/verify-output.md](../.prompts/tasks/verify-output.md)
- Snippet bắt buộc: [.prompts/snippets/force-cite.md](../.prompts/snippets/force-cite.md), [.prompts/snippets/self-verify.md](../.prompts/snippets/self-verify.md), [.prompts/snippets/confidence-scale.md](../.prompts/snippets/confidence-scale.md), [.prompts/snippets/confirmation-gate.md](../.prompts/snippets/confirmation-gate.md)

## Đánh giá cấu trúc

Cấu trúc 5 file cũ đủ cho overview gọn, nhưng chưa đủ nếu mục tiêu là độ chính xác cao:

- Thiếu `coverage log` nên người đọc không biết AI đã đọc hết hay chỉ sample.
- Thiếu `evidence index` nên khó audit cite.
- Trộn fact với inference, dễ làm output nghe chắc hơn evidence thật.
- Chưa tách testing, security, performance, data model thành file riêng.
- Chưa có danh sách module nên deep dive tiếp theo.

Cấu trúc mới bên dưới ưu tiên: **an toàn/chính xác > evidence/verification > mật độ thông tin > số lượng file**.

## Explore Project là AI hiểu hay tạo file cho người dùng?

Là cả hai, nhưng không giống nhau:

- **AI hiểu trong phiên hiện tại**: AI đọc project, lập bản đồ repo, phân loại fact/inference/gap/risk, rồi dùng hiểu biết đó để tạo output.
- **Người dùng hiểu sau phiên hiện tại**: output folder là tài liệu rời để người dùng đọc, audit cite, onboarding người khác, hoặc quyết định bước tiếp theo.
- **AI phiên sau hiểu lại được**: nếu người dùng đưa output folder vào context hoặc yêu cầu AI đọc lại folder đó, AI có thể dùng nó làm evidence thứ cấp. Nếu không được load lại, AI không tự nhớ vĩnh viễn.
- **Không phải memory-bank**: sample này không ghi long-term memory. Nếu muốn biến hiểu biết thành context bền cho mọi phiên AI, dùng `samples/gather-context.md` hoặc workflow `initialize memory bank`.

Vì vậy, `explore-project` nên được hiểu là **bước khảo sát toàn cảnh tạo artifact kiểm chứng được**. Nó không thay thế `deep-dive-validated`: explore trả lời "project có những vùng nào", còn deep-dive trả lời "module này vận hành chính xác ra sao".

## Luồng dùng với Deep Dive

Luồng khuyến nghị:

1. Chạy `samples/explore-project.md` với scope `full`, `BE` hoặc `FE`.
2. Mở `<output>/12-open-questions-and-next-deep-dives.md`.
3. Chọn module trong bảng `Ranked module candidates` nếu cần hiểu sâu một vùng code.
4. Chọn flow trong bảng `Ranked flow candidates` nếu cần hiểu một hành động xuyên nhiều module.
5. Với module: copy prompt `deep-dive-validated` đã được file 12 tạo sẵn.
6. Với flow: copy prompt `trace-flow` đã được file 12 tạo sẵn.

Một module nên được ưu tiên deep dive khi nó có nhiều tín hiệu quan trọng: nằm trên user journey chính, nhiều caller/callee, giữ state hoặc data ownership, đụng auth/payment/security, ít test, nhiều TODO/risk, hoặc sắp bị sửa.

## Prompt

```
follow your custom instructions

Task: explore project tổng quan với độ chính xác ưu tiên tuyệt đối.

Goal:
- Tạo bộ tài liệu khám phá project dạng output rời, dùng để onboarding, review kiến trúc, chọn module/flow cần deep dive.
- Làm rõ hai mục tiêu khác nhau:
  - AI hiểu project trong phiên hiện tại để tạo output có evidence.
  - Người dùng và AI phiên sau đọc output folder để hiểu lại, audit lại, hoặc tiếp tục deep dive.
- Không giả định AI sẽ nhớ output ở phiên sau nếu output folder không được đưa lại vào context.
- Không ghi vào memory-bank, không sửa code app.
- Mọi kết luận phải evidence-bound: có bằng chứng thì ghi Fact; suy ra thì ghi Inference; thiếu bằng chứng thì ghi Gap; nghi ngờ rủi ro thì ghi Risk.

Scope:
- Scope filter: <BE | FE | full>
  - BE: chỉ quét backend (api, services, db, infra config).
  - FE: chỉ quét frontend (ui, state, routing, build config).
  - full: cả hai + tích hợp giữa BE và FE.
- Read allowed: toàn bộ project root theo scope filter.
- Exclude: `.git`, `node_modules`, `vendor`, `build`, `dist`, `coverage`, `.next`, `.nuxt`, `.turbo`, `.cache`, generated files, lockfile quá lớn, binary/media files.
- Edit allowed: chỉ `<output: path/to/folder>`.
- Do not edit: source code, config, docs hiện có, memory-bank, ADR, PRP.

Context to load before scan:
- `ROADMAP.md` để hiểu cấu trúc project/skeleton.
- `.prompts/system/base.md` để tuân thủ output format, safety, accuracy, scope lock.
- `.prompts/snippets/prompt-contract.md` để dựng task contract.
- `.prompts/snippets/force-cite.md`, `.prompts/snippets/confidence-scale.md`, `.prompts/snippets/self-verify.md`.
- `memory-bank/` core files nếu tồn tại trong project; chỉ đọc để đối chiếu, không sửa.
- README / manifest / entrypoint / tests / CI / docs liên quan theo scope.

Acceptance criteria:
- AC-1: Output folder có 13 file `.md` hoặc có `CONTINUATION.md` giải thích phần chưa xong.
- AC-2: Mọi Fact về code thật có cite `file:line`.
- AC-3: Mọi Inference, Gap, Risk được gắn nhãn rõ, không trình bày như fact.
- AC-4: `01-evidence-index.md` có coverage log và citation validation sample.
- AC-5: Mỗi file có Confidence, Assumptions, Coverage gap, Decision points, Self-verify.
- AC-6: Không sửa source code, docs hiện có, memory-bank, ADR, PRP.
- AC-7: Verification commands có expected result và phân biệt đã chạy / chưa chạy.
- AC-8: `12-open-questions-and-next-deep-dives.md` có bảng xếp hạng module quan trọng bằng scoring rubric, không chọn theo cảm giác.
- AC-9: `12-open-questions-and-next-deep-dives.md` có bảng xếp hạng flow quan trọng để chạy `samples/trace-flow.md`.
- AC-10: Có prompt copy-paste sẵn cho tối thiểu top 3 module và top 3 flow, hoặc ít hơn nếu project không đủ evidence.

Language:
- Trả lời và viết output bằng TIẾNG VIỆT CÓ DẤU.
- Code, path, command, identifier giữ nguyên theo cú pháp gốc.

Memory-bank impact:
- Không cập nhật memory-bank trong task này.
- Nếu phát hiện memory-bank thiếu/sai so với code, hoặc cần ghi nhận module/flow quan trọng cho long-term memory, ghi vào `<output>/12-open-questions-and-next-deep-dives.md` như Gap/Recommendation, không tự sửa.

Output folder: <output: path/to/folder>
- Nếu folder chưa có: tạo folder.
- Nếu folder đã tồn tại và có file: DỪNG, in dry-run + Confirmation Gate; không overwrite im lặng.
- Ghi 13 file Markdown sau. Nếu project quá lớn cho 1 request, làm theo thứ tự ưu tiên và dùng Continuation Handoff thay vì đoán.

## Output files

File 00: <output>/00-run-summary.md
- Mục tiêu scan, scope thực tế, thời điểm scan.
- "Cách dùng output này" gồm:
  - Người dùng đọc file nào trước.
  - AI phiên sau cần đọc lại file nào.
  - Khi nào chuyển sang `deep-dive-validated` hoặc `trace-flow`.
- Risk preflight: low/medium/high + lý do.
- Danh sách 13 file output và trạng thái: complete / partial / skipped.
- Top 10 facts quan trọng nhất, mỗi fact cite `file:line`.
- Top 10 gaps cần user/AI kiểm tiếp.
- Confidence matrix theo file.
- Top 5 module và top 5 flow nên phân tích tiếp, lấy từ file 12.

File 01: <output>/01-evidence-index.md
- Inventory bằng chứng đã dùng: README, manifest, config, source entrypoint, tests, CI, docs.
- Bảng cite index: Claim ID | Claim ngắn | Evidence `file:line` | Loại evidence.
- Coverage log toàn project:
  - Files read fully.
  - Files sampled.
  - Files skipped + lý do.
  - Folders excluded.
- Citation validation sample tối thiểu 20 cite hoặc toàn bộ cite nếu ít hơn 20.

File 02: <output>/02-repository-map.md
- Sơ đồ thư mục cấp 1-3 theo scope.
- Mỗi folder chính: purpose, evidence `file:line` hoặc "inference từ file names".
- Phân loại folder: app / domain / infra / tests / docs / generated / unknown.
- Hotspot candidates: file lớn, file nhiều import, file nhiều TODO, entrypoint.
- Module candidate raw signals: entrypoint, public export, route/controller/screen, domain model, service, repository, worker, scheduler, adapter, integration boundary.

File 03: <output>/03-overview.md
- Project là gì, mục tiêu chính.
- User/use case chính nếu suy ra được từ README/docs/product text.
- 5-10 entry point quan trọng nhất, cite `file:line`.
- Build / run / test commands chính, cite manifest/docs/config.
- "Không thấy" section cho mục không tìm được.

File 04: <output>/04-entrypoints-and-runtime.md
- App entrypoints: main/server/router/screen/bootstrap/worker/cron.
- Request/user-action lifecycle ở mức runtime.
- Environment/config loading.
- Startup side effects: DB connect, network call, file IO, scheduled job.
- Mermaid sequence diagram cho startup hoặc request/action chính.

File 05: <output>/05-architecture.md
- Layers / modules chính, mỗi module cite `file:line`.
- Boundary giữa module: interface/event/RPC/import direction.
- Dataflow chính: request -> response hoặc user action -> state.
- Mermaid diagram: component + sequence.
- Architecture risks: coupling, circular deps, unclear ownership, missing ADR.
- Module importance map: module nào là core, supporting, integration, infra, test-only, unknown; mỗi phân loại phải ghi evidence hoặc Inference.

File 06: <output>/06-data-and-domain-model.md
- Domain entities / models / schema / migration / API DTO.
- Data ownership: module nào tạo, đọc, mutate, persist.
- Validation rules nếu thấy trong code.
- Storage/cache/session/offline behavior nếu có.
- Nếu không có DB/schema rõ: ghi "không thấy trong codebase loaded".

File 07: <output>/07-patterns-and-conventions.md
- Pattern lặp >= 3 lần: repository, service, factory, hook, bloc, controller, adapter, middleware...
- Mỗi pattern phải cite >= 3 chỗ xuất hiện.
- Naming convention quan sát được, cite >= 2 instance.
- Error handling pattern, logging pattern, dependency injection pattern.
- Test pattern nếu có.

File 08: <output>/08-tech-stack-and-dependencies.md
- Stack từ manifest: `package.json`, `pubspec.yaml`, `requirements.txt`, `pyproject.toml`, `Cargo.toml`, `go.mod`, v.v.
- Dependency chính + evidence usage thật trong code.
- Version constraints đáng chú ý.
- Infra/deploy stack: Docker, CI/CD, cloud config, scripts.
- External services/integrations phát hiện được.

File 09: <output>/09-testing-and-quality.md
- Test framework, test folders, test naming convention.
- Coverage visible nếu có config/report.
- Lint/format/typecheck commands.
- Gaps: module quan trọng không thấy test, test yếu, TODO test.
- Quality risks: long file, duplicated logic, high branching, dead code candidates.

File 10: <output>/10-security-and-performance.md
- Security scan theo evidence: auth/authz, input validation, secret handling, CORS, SQL/query, eval/exec, file upload, PII.
- Performance scan theo evidence: N+1, unbounded loop, heavy sync IO, cache, pagination, large bundle, repeated network calls.
- Mỗi item phân loại: Fact / Risk / Gap.
- Không claim lỗ hổng nếu chỉ là nghi ngờ; ghi "Risk cần verify".

File 11: <output>/11-pending-issues.md
- TODO / FIXME / HACK / XXX comments nổi bật, tối thiểu 10 nếu có.
- Commented-out code đáng ngờ.
- Technical debt rõ ràng.
- Broken docs/scripts/config nếu phát hiện.
- Bảng: Severity | Issue | Evidence | Impact | Suggested verification.

File 12: <output>/12-open-questions-and-next-deep-dives.md
- Open questions không thể trả lời chắc từ evidence.
- Decision points cần user xác nhận.
- Giải thích ngắn: `explore-project` đã đủ để hiểu toàn cảnh; `deep-dive-validated` dùng khi cần hiểu sâu một module trước khi sửa/refactor/debug; `trace-flow` dùng khi cần hiểu một hành động xuyên nhiều module.
- Ranked module candidates để chạy `samples/deep-dive-validated.md`:
  - Chọn 5-15 module nếu có đủ evidence; nếu ít hơn thì ghi đúng số tìm được.
  - Mỗi module phải có path thật, role, evidence, score, lý do chọn, output folder đề xuất, confidence.
  - Không chọn module chỉ vì tên nghe quan trọng; phải có signal trong code/docs.
- Ranked flow candidates để chạy `samples/trace-flow.md`:
  - Chọn 5-15 flow/action nếu có đủ evidence; ví dụ: login, checkout, create item, sync, import/export, background job, webhook, notification, report generation.
  - Mỗi flow phải có entrypoint/caller đầu tiên nếu tìm được, modules involved, evidence, score, lý do chọn, output folder đề xuất, confidence.
- Module importance scoring rubric, dùng điểm 0-3 cho từng tiêu chí:
  - Business/user criticality: liên quan journey chính, feature chính, hoặc action người dùng thường dùng.
  - Runtime centrality: entrypoint, router, controller, screen, bootstrap, worker, cron, public API.
  - Dependency centrality: nhiều import/caller/callee, nhiều module phụ thuộc vào nó, hoặc là integration boundary.
  - Data/state ownership: sở hữu schema/model/store/cache/session/queue/state machine.
  - Risk surface: auth/authz, payment, PII, file upload, external API, concurrency, persistence, permissions.
  - Change likelihood: user sắp sửa vùng này, roadmap/docs nhắc tới, TODO/FIXME nhiều, issue nổi bật.
  - Test gap: module quan trọng nhưng test yếu/không thấy test/coverage không rõ.
  - Evidence quality: có cite trực tiếp từ code/docs/test/config; nếu chỉ inference thì điểm tiêu chí này thấp.
- Flow importance scoring rubric, dùng điểm 0-3 cho từng tiêu chí:
  - User/business impact.
  - Number of modules crossed.
  - Error/security/data risk.
  - Observability/testability gap.
  - Change likelihood.
  - Evidence quality.
- Bảng bắt buộc cho module:
  - Rank | Module path | Role | Score breakdown | Total | Evidence | Why deep dive next | Recommended output folder | Confidence.
- Bảng bắt buộc cho flow:
  - Rank | Flow/action | First entrypoint | Modules involved | Score breakdown | Total | Evidence | Why trace next | Recommended output folder | Confidence.
- Prompt copy-paste sẵn:
  - Tối thiểu top 3 module dùng `samples/deep-dive-validated.md`.
  - Tối thiểu top 3 flow dùng `samples/trace-flow.md`.
  - Nếu project quá nhỏ hoặc evidence thiếu, ghi Gap và chỉ tạo prompt cho item có đủ path/entrypoint.
- Mẫu prompt cho module:
  ~~~text
  follow your custom instructions
  Task: deep dive module với độ chính xác ưu tiên tuyệt đối, dùng tối đa token có ích trong 1 request.
  Module: <module path thật từ bảng ranked module candidates>
  Output folder: <output>/<module-slug>-deep-dive/
  Use sample: samples/deep-dive-validated.md
  Priority reason: <copy lý do + score>
  ~~~
- Mẫu prompt cho flow:
  ~~~text
  follow your custom instructions
  Task: trace flow với độ chính xác ưu tiên tuyệt đối.
  Flow/action: <flow/action thật từ bảng ranked flow candidates>
  Scope: <entrypoint + modules involved nếu đã biết>
  Output: <output>/<flow-slug>-trace.md
  Use sample: samples/trace-flow.md
  Priority reason: <copy lý do + score>
  ~~~

## Per-file format bắt buộc

Mỗi file output phải theo format:

# <Tên file>

## Scope & Coverage
- Scope thực tế của file này.
- Files read fully.
- Files sampled.
- Files not read / skipped + lý do.

## Evidence
- Bảng evidence chính: Claim ID | Type | Claim | Evidence.
- Type chỉ được dùng một trong: Fact, Inference, Gap, Risk, Recommendation.

## Findings
- Nội dung chính của file.
- Mỗi Fact phải có `file:line`.
- Mỗi Inference phải nói rõ suy ra từ evidence nào.
- Mỗi Gap phải ghi cần đọc file/gặp user nào để xác minh.
- Mỗi Risk phải có impact + suggested verification.

## Verification
- Commands/checks cụ thể để user verify.
- Ghi rõ: đã chạy / chưa chạy / không áp dụng.

---
**Confidence**: low | medium | high
**Assumptions**:
- A-1: ...
**Coverage gap**:
- ...
**Decision points needing user input**:
- D-1: ... hoặc `none`
**Self-verify**: <N>/9 nhóm pass; nhóm fail: <list hoặc "none">.

## Accuracy rules

- Không được hứa "100% chính xác". Thay vào đó, output phải làm rõ claim nào đã có evidence và claim nào còn là gap/risk.
- Mỗi claim về code thật phải cite `file:line`. Áp dụng `.prompts/snippets/force-cite.md`.
- Không bịa file/function/API. Nếu không thấy evidence, ghi đúng câu: "không thấy trong codebase loaded".
- Không biến tên folder/file thành kết luận kiến trúc nếu chưa đọc file đại diện; khi chỉ nhìn tên, ghi Type = Inference.
- Pattern chỉ được gọi là pattern nếu có >= 3 occurrences có cite.
- Convention chỉ được gọi là convention nếu có >= 2 occurrences có cite.
- Security/performance item phải phân biệt rõ:
  - Fact: có bằng chứng trực tiếp.
  - Risk: dấu hiệu đáng nghi nhưng cần verify.
  - Gap: chưa đủ dữ liệu.
- Khi xếp hạng module/flow quan trọng:
  - Điểm phải trace được về evidence hoặc ghi rõ là Inference.
  - Nếu một module có score cao nhưng coverage thấp, vẫn có thể đề xuất deep dive nhưng confidence phải thấp/medium.
  - Nếu không tìm được user journey/business context, không tự bịa; dùng runtime/data/risk/test signals thay thế và ghi Gap.
- Confidence high chỉ khi:
  - Có >= 3 evidence direct cho kết luận chính.
  - Không có contradiction.
  - Coverage chính của file đủ rộng.
- Confidence low nếu:
  - Chỉ đọc sample nhỏ.
  - Thiếu manifest/entrypoint/test.
  - Có contradiction hoặc nhiều gap.

## Execution strategy

1. Risk preflight:
   - Kiểm tra output folder có tồn tại không.
   - Kiểm scope BE/FE/full.
   - Kiểm token/context budget.
   - Kiểm repo có quá lớn không.
2. Inventory:
   - Liệt kê files bằng công cụ search hiệu quả.
   - Tìm manifest, README, route/entrypoint, tests, CI, config, docs.
3. Read priority:
   - README/docs setup.
   - Manifest/config/scripts.
   - Entry points.
   - Route/controller/screen/state.
   - Domain/model/schema.
   - Tests.
   - CI/deploy.
   - TODO/security/performance hotspots.
4. Write files theo thứ tự 00 -> 12.
5. Tạo `01-evidence-index.md` song song, không để cite rời rạc không kiểm được.
6. Trước khi viết file 12, tổng hợp signals từ file 02, 04, 05, 06, 09, 10, 11 để score module/flow.
7. Với module candidate:
   - Ưu tiên path thật có evidence.
   - Nếu candidate là folder lớn, đề xuất submodule cụ thể thay vì yêu cầu deep dive cả folder quá rộng.
   - Nếu candidate là cross-cutting concern, chuyển sang flow trace nếu không có module boundary rõ.
8. Với flow candidate:
   - Ưu tiên action có entrypoint thật.
   - Nếu chưa thấy entrypoint, ghi Gap và không tạo prompt trace-flow cho flow đó.
9. Self-verify từng file theo `.prompts/snippets/self-verify.md`.
10. Output cuối trong chat: list 13 file đã tạo + trạng thái + top 5 gaps + top 3 module/flow nên làm tiếp.

## Continuation Handoff

Nếu không đủ 1 request:
- Vẫn tạo các file đã hoàn thành.
- File chưa hoàn thành phải ghi status `partial` trong `00-run-summary.md`.
- Tạo hoặc cập nhật `<output>/CONTINUATION.md` với:
  - Đã xong.
  - Còn lại.
  - Files read fully.
  - Files sampled.
  - Prompt tiếp theo để user copy-paste.
- Không ghi vào `memory-bank/activeContext.md` trừ khi user cho phép sửa memory-bank.

## Verification sau khi tạo output

- `ls <output>/` -> phải có 13 file `.md` hoặc có `CONTINUATION.md` giải thích phần chưa xong.
- Chọn ngẫu nhiên 10 cite trong `01-evidence-index.md`, verify line có tồn tại.
- Mở `12-open-questions-and-next-deep-dives.md`, kiểm top 3 module có path thật và score có evidence.
- Mở `12-open-questions-and-next-deep-dives.md`, kiểm top 3 flow có entrypoint hoặc Gap rõ nếu chưa thấy entrypoint.
- Chạy `verify output` trên `<output>/00-run-summary.md` và `<output>/01-evidence-index.md`.
- Nếu output nằm trong tracked path, chạy `bash scripts/check-impact.sh <output>`.

Execution mode: analysis-only với code app; dùng Edit mode / Agent mode chỉ để edit-files/generate-artifact trong output folder.
```

## Variants

- **Quick overview (5 file)**: chỉ tạo `00-run-summary.md`, `01-evidence-index.md`, `03-overview.md`, `05-architecture.md`, `12-open-questions-and-next-deep-dives.md`.
- **BE deep-dive prep**: thêm yêu cầu chi tiết hơn cho `06-data-and-domain-model.md`, API route, DB schema, migration, auth.
- **FE deep-dive prep**: thêm yêu cầu chi tiết hơn cho `04-entrypoints-and-runtime.md`, routing, state management, component tree.
- **Audit mode**: tăng trọng số cho `09-testing-and-quality.md`, `10-security-and-performance.md`, `11-pending-issues.md`.
- **Deep-dive planning mode**: giữ đủ 13 file nhưng dành nhiều token hơn cho file 12, bắt buộc tạo ranked queue cho module và flow kèm prompt copy-paste sẵn.

## Verification

- `ls <output>/` -> phải có 13 file `.md` hoặc có `CONTINUATION.md`.
- Mở `01-evidence-index.md`, chọn 10 cite ngẫu nhiên, verify trong codebase.
- Mở từng file, kiểm mọi `Fact` có cite `file:line`.
- Mở `12-open-questions-and-next-deep-dives.md`, kiểm mỗi module/flow được đề xuất đều có score, evidence, confidence, output folder và prompt tiếp theo.
- Chạy `verify output` cho `00-run-summary.md` và `01-evidence-index.md`.
- `bash scripts/check-impact.sh <output>` (nếu output nằm trong tracked path).
