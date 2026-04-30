---
name: sample-explore-project
purpose: Khám phá tổng quan project/hệ thống lớn với scope BE/FE/full, output đa file có evidence index, coverage log, system map, self-validation và deep-dive queue
input: source-project-root=<project path> + scope=BE|FE|full + system-scale=small|medium|large|monorepo|unknown + output=<folder path>
output: 13 file .md trong folder output (summary, evidence, repo/system map, entrypoints, architecture, data lineage, patterns, stack, tests, security/perf, issues, ranked modules/flows for next deep dives)
version: 1.5
last-updated: 2026-04-30
---

# Sample: Explore Project

## Khi nào dùng

- Vừa join team mới, được giao codebase chưa biết gì.
- Cần handover doc gọn cho dev mới.
- Refactor lớn, cần map toàn bộ trước khi đụng vào.
- Cần output rời để đọc lại, không muốn ghi thẳng vào `memory-bank/`.
- Cần biết module/flow nào quan trọng để chạy `samples/deep-dive-validated.md` hoặc `samples/trace-flow.md` tiếp theo.
- Cần hiểu hệ thống lớn, monorepo, multi-service, app có nhiều package/module/domain mà không muốn AI đọc lan man hoặc kết luận quá mức evidence.

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

## Quality bar 10/10 cho hệ thống lớn

Output chỉ đạt 10/10 thực dụng khi:

- Người đọc hiểu được hệ thống theo đúng thứ tự: mục đích → topology → entrypoint → runtime flow → architecture boundary → data lineage → dependency graph → test/quality → risk → deep-dive queue.
- AI không cố đọc brute-force toàn bộ repo nếu repo lớn; phải inventory trước, chọn sampling có lý do, rồi đọc sâu các hotspot có evidence.
- Mọi claim quan trọng có Claim ID, cite `file:line`, evidence strength và confidence; thiếu evidence thì ghi Gap.
- Có bản đồ rõ cho monorepo/multi-service: apps, packages, services, shared libraries, infra, contracts, generated code, owners nếu thấy được.
- Có "reader path": người mới nên đọc file nào trước, file nào đọc sau, file nào chỉ skim, file nào nguy hiểm khi sửa.
- Có "next action queue": top module để deep dive, top flow để trace, top risk để verify, top docs/memory-bank nên cập nhật.
- Không hứa chính xác tuyệt đối; thay vào đó làm cho người dùng kiểm chứng được mức đúng/sai của từng kết luận.

## Chỉ sửa 1 block ở đầu prompt

Khi dùng prompt bên dưới, người dùng chỉ cần sửa **một block duy nhất** ngay đầu prompt: `USER INPUT — CHỈ SỬA BLOCK NÀY`. Trong Markdown preview, marker dùng `<mark>...</mark>` để nổi bật như vùng được tô nền.

| Biến cần điền | Ý nghĩa | Gợi ý giá trị |
|---|---|---|
| <mark>Source project root</mark> | Đường dẫn source/project cần phân tích | Dùng `.` nếu AI đang mở đúng project root; hoặc đường dẫn thật như `C:\path\to\project`. |
| <mark>Scope filter</mark> | Phạm vi phân tích | `full` nếu muốn hiểu toàn bộ project; `BE` hoặc `FE` nếu chỉ xem một phía. |
| <mark>System scale</mark> | Độ lớn hệ thống | `unknown` nếu chưa biết; AI sẽ tự phân loại sau inventory. |
| <mark>Output folder</mark> | Nơi lưu đầu ra | Ví dụ `Question/explore-carparking`, `Question/explore-auth`, `docs/explore-output`. |

Quy tắc dùng:

- Copy toàn bộ block trong `## Prompt`.
- Sửa duy nhất block `USER INPUT — CHỈ SỬA BLOCK NÀY`.
- Không cần sửa các dòng phía dưới; chúng sẽ tham chiếu lại 4 biến trong block này.
- Có thể giữ dòng `[[USER_EDIT_BLOCK]]` khi gửi prompt; marker chỉ giúp AI và người dùng biết đâu là vùng input.

## Prompt

```
follow your custom instructions

Task: explore project tổng quan với độ chính xác ưu tiên tuyệt đối.

USER INPUT — CHỈ SỬA BLOCK NÀY:
[[USER_EDIT_BLOCK]]
- Source project root: <source: absolute-or-relative-path-to-project-root>
- Scope filter: <BE | FE | full>
- System scale: <small | medium | large | monorepo | unknown>
- Output folder: <output: path/to/folder>
END USER INPUT

Goal:
- Tạo bộ tài liệu khám phá project dạng output rời, dùng để onboarding, review kiến trúc, chọn module/flow cần deep dive.
- Hỗ trợ cả hệ thống nhỏ và hệ thống lớn: single app, monorepo, multi-service, app + packages + infra, hoặc legacy codebase thiếu docs.
- Làm rõ hai mục tiêu khác nhau:
  - AI hiểu project trong phiên hiện tại để tạo output có evidence.
  - Người dùng và AI phiên sau đọc output folder để hiểu lại, audit lại, hoặc tiếp tục deep dive.
- Không giả định AI sẽ nhớ output ở phiên sau nếu output folder không được đưa lại vào context.
- Không ghi vào memory-bank, không sửa code app.
- Mọi kết luận phải evidence-bound: có bằng chứng thì ghi Fact; suy ra thì ghi Inference; thiếu bằng chứng thì ghi Gap; nghi ngờ rủi ro thì ghi Risk.
- Chất lượng 10/10 nghĩa là: có system map đủ dùng cho người mới, có coverage minh bạch, có deep-dive queue chính xác, dễ audit, nhưng không nói chắc hơn evidence cho phép.

Scope:
- Source project root: dùng giá trị `Source project root` trong `USER INPUT` làm root để đọc source.
- Scope filter: dùng giá trị `Scope filter` trong `USER INPUT`.
  - BE: chỉ quét backend (api, services, db, infra config).
  - FE: chỉ quét frontend (ui, state, routing, build config).
  - full: cả hai + tích hợp giữa BE và FE.
- System scale: dùng giá trị `System scale` trong `USER INPUT`.
  - small: có thể đọc gần như toàn bộ source theo scope.
  - medium: đọc toàn bộ manifest/entrypoint/docs/tests chính, sample module đại diện, đọc sâu hotspot.
  - large: inventory trước, đọc theo tầng ưu tiên, không cố nhồi toàn bộ code vào context.
  - monorepo: bắt buộc map apps/packages/services/libs/tools/infra và boundary giữa chúng.
  - unknown: tự phân loại scale sau inventory và ghi lý do.
- Read allowed: toàn bộ `Source project root` theo scope filter.
- Exclude: `.git`, `node_modules`, `vendor`, `build`, `dist`, `coverage`, `.next`, `.nuxt`, `.turbo`, `.cache`, generated files, lockfile quá lớn, binary/media files.
- Edit allowed: chỉ `Output folder` trong `USER INPUT`.
- Do not edit: source code, config, docs hiện có, memory-bank, ADR, PRP.

Large-system policy:
- Không bắt đầu bằng đọc mọi file. Bắt đầu bằng inventory có cấu trúc: manifest/workspace config, app/service roots, package boundaries, entrypoints, tests, CI, infra, docs.
- Nếu repo quá lớn cho 1 request, ưu tiên evidence có giá trị cao: manifests, route maps, public exports, schemas, migrations, entrypoints, core services, tests, CI, security/performance hotspots.
- Dùng sampling có ghi lý do: representative sample theo layer/domain/package + hotspot sample theo file lớn/import nhiều/TODO nhiều/risk cao.
- Mỗi kết luận toàn hệ thống phải ghi coverage basis: "full read", "representative sample", "hotspot sample", hoặc "inference from manifests/file names".
- Nếu một vùng chưa đọc đủ, ghi Gap và đưa vào deep-dive queue thay vì đoán.

Context to load before scan:
- `ROADMAP.md` để hiểu cấu trúc project/skeleton.
- `.prompts/system/base.md` để tuân thủ output format, safety, accuracy, scope lock.
- `.prompts/snippets/prompt-contract.md` để dựng task contract.
- `.prompts/snippets/force-cite.md`, `.prompts/snippets/confidence-scale.md`, `.prompts/snippets/self-verify.md`.
- `memory-bank/` core files nếu tồn tại trong project; chỉ đọc để đối chiếu, không sửa.
- README / manifest / entrypoint / tests / CI / docs liên quan theo scope.
- Workspace/monorepo config nếu tồn tại: `pnpm-workspace.yaml`, `lerna.json`, `turbo.json`, `nx.json`, `rush.json`, `package.json` workspaces, `go.work`, `Cargo.toml` workspace, `pubspec.yaml` workspace, `docker-compose*`, `Makefile`, CI config.

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
- AC-11: Với hệ thống lớn/monorepo, phải có topology map: apps, services, packages/libs, infra, shared code, generated code, contracts.
- AC-12: Có quality scorecard 100 điểm: Accuracy 35, Coverage 20, System understanding 20, Actionability 15, Verification 10.
- AC-13: Có reader path và AI handoff path: file nào người mới đọc trước, file nào AI phiên sau phải load trước.
- AC-14: Có "Do not assume" list cho mọi vùng chưa đủ evidence; không để khoảng trống bị biến thành kết luận.

Language:
- Trả lời và viết output bằng TIẾNG VIỆT CÓ DẤU.
- Code, path, command, identifier giữ nguyên theo cú pháp gốc.

Memory-bank impact:
- Không cập nhật memory-bank trong task này.
- Nếu phát hiện memory-bank thiếu/sai so với code, hoặc cần ghi nhận module/flow quan trọng cho long-term memory, ghi vào `<output>/12-open-questions-and-next-deep-dives.md` như Gap/Recommendation, không tự sửa.

Output folder: dùng giá trị `Output folder` trong `USER INPUT`.
- Nếu folder chưa có: tạo folder.
- Nếu folder đã tồn tại và có file: DỪNG, in dry-run + Confirmation Gate; không overwrite im lặng.
- Ghi 13 file Markdown sau. Nếu project quá lớn cho 1 request, làm theo thứ tự ưu tiên và dùng Continuation Handoff thay vì đoán.

## Output files

File 00: <output>/00-run-summary.md
- Mục tiêu scan, scope thực tế, thời điểm scan.
- System scale detected: small / medium / large / monorepo / unknown + evidence.
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
- Quality scorecard 100 điểm:
  - Accuracy /35: claim có evidence, không overclaim, confidence đúng mức.
  - Coverage /20: manifest/entrypoint/runtime/data/tests/infra đọc đủ theo scope.
  - System understanding /20: topology, boundary, dependency, dataflow, runtime flow rõ.
  - Actionability /15: reader path, deep-dive queue, verification queue rõ.
  - Verification /10: cite validation + commands/checks rõ.
- Verdict: READY / PARTIAL / NOT TRUSTWORTHY, kèm lý do.

File 01: <output>/01-evidence-index.md
- Inventory bằng chứng đã dùng: README, manifest, config, source entrypoint, tests, CI, docs.
- Bảng cite index: Claim ID | Claim ngắn | Evidence `file:line` | Loại evidence.
- Claim ledger toàn output:
  - Claim ID.
  - Type: Fact / Inference / Gap / Risk / Recommendation.
  - Evidence strength: direct / derived / sampled / missing.
  - Coverage basis: full read / representative sample / hotspot sample / manifest-only / not loaded.
  - Confidence.
  - Used in file nào.
- Coverage log toàn project:
  - Files read fully.
  - Files sampled.
  - Files skipped + lý do.
  - Folders excluded.
- Coverage matrix theo khu vực: docs, manifests, app entrypoints, services/packages, data/schema, tests, CI/deploy, infra, security-sensitive files.
- Citation validation sample tối thiểu 20 cite hoặc toàn bộ cite nếu ít hơn 20.

File 02: <output>/02-repository-map.md
- Sơ đồ thư mục cấp 1-3 theo scope.
- Mỗi folder chính: purpose, evidence `file:line` hoặc "inference từ file names".
- Phân loại folder: app / domain / infra / tests / docs / generated / unknown.
- Repository topology:
  - Repo type: single app / monorepo / multi-service / package library / app + infra / unknown.
  - Apps/services/packages/libs/tools/infra nếu thấy.
  - Ownership signals nếu có: CODEOWNERS, docs owners, package names, team labels.
  - Generated/vendor/build output phải tách khỏi source thật.
- Dependency/workspace graph:
  - Package manager/workspace config.
  - Internal package dependencies.
  - Shared libraries được nhiều nơi dùng.
  - Potential circular/cross-layer dependencies nếu thấy evidence.
- Hotspot candidates: file lớn, file nhiều import, file nhiều TODO, entrypoint.
- Module candidate raw signals: entrypoint, public export, route/controller/screen, domain model, service, repository, worker, scheduler, adapter, integration boundary.
- Reader path:
  - Read first: 5-15 file/folder quan trọng nhất.
  - Skim later: file/folder hỗ trợ.
  - Avoid editing before deep dive: file/folder rủi ro cao.

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
- Runtime surface matrix:
  - HTTP/API endpoints, UI routes/screens, CLI commands, background jobs, scheduled jobs, webhooks, message consumers, workers, migrations/scripts.
  - For each surface: entrypoint evidence, inputs, outputs, side effects, auth/authz presence, tests if visible.
- Runtime topology:
  - In-process modules.
  - Cross-process/service calls.
  - Queues/events/pubsub/webhooks.
  - External services/integrations.
- Flow shortlist:
  - 5-15 runtime flows đáng trace bằng `samples/trace-flow.md`, kèm evidence và lý do.

File 05: <output>/05-architecture.md
- Layers / modules chính, mỗi module cite `file:line`.
- Boundary giữa module: interface/event/RPC/import direction.
- Dataflow chính: request -> response hoặc user action -> state.
- Mermaid diagram: component + sequence.
- Architecture risks: coupling, circular deps, unclear ownership, missing ADR.
- Module importance map: module nào là core, supporting, integration, infra, test-only, unknown; mỗi phân loại phải ghi evidence hoặc Inference.
- Architecture views bắt buộc:
  - Static view: modules/packages/components và dependency direction.
  - Runtime view: services/processes/jobs và communication.
  - Data view: owners của entity/schema/state/cache.
  - Change view: nếu sửa feature mới thường chạm những file/module nào.
- Boundary contract matrix:
  - Boundary | Contract type (function/interface/API/event/schema/file) | Provider | Consumer | Evidence | Risk.
- ADR alignment:
  - ADR/docs architecture nếu tồn tại.
  - Code có đi đúng/khác ADR không; nếu chưa đủ evidence thì ghi Gap.

File 06: <output>/06-data-and-domain-model.md
- Domain entities / models / schema / migration / API DTO.
- Data ownership: module nào tạo, đọc, mutate, persist.
- Validation rules nếu thấy trong code.
- Storage/cache/session/offline behavior nếu có.
- Nếu không có DB/schema rõ: ghi "không thấy trong codebase loaded".
- Data lineage:
  - Input source -> validation -> transform -> persistence/cache -> output/API/UI/event.
  - Mỗi bước phải có evidence hoặc ghi Gap.
- Consistency/concurrency:
  - Transaction, idempotency, locking, retry, conflict resolution, eventual consistency nếu thấy.
- Sensitive data:
  - PII/secrets/tokens/session/payment/file upload nếu thấy.
  - Không claim compliance/security bug nếu chưa verify; ghi Risk/Gaps.

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
- Build/test/run matrix:
  - Command | Source evidence | Preconditions | Expected result | Confidence | Not run reason.
- Environment matrix:
  - Required runtime versions, env vars, secrets references, config files, local/dev/prod differences nếu thấy.
- Dependency risk:
  - Critical framework/library.
  - Deprecated/legacy-looking package nếu thấy.
  - Generated client/schema dependency nếu thấy.

File 09: <output>/09-testing-and-quality.md
- Test framework, test folders, test naming convention.
- Coverage visible nếu có config/report.
- Lint/format/typecheck commands.
- Gaps: module quan trọng không thấy test, test yếu, TODO test.
- Quality risks: long file, duplicated logic, high branching, dead code candidates.
- Test strategy map:
  - Unit / integration / e2e / contract / snapshot / golden / smoke nếu thấy.
  - Module/flow quan trọng có test hay chưa.
  - Commands cần chạy trước khi sửa code.
- Quality hotspot scoring:
  - Complexity signal, churn signal nếu thấy được, TODO density, weak tests, central dependency, risky side effects.

File 10: <output>/10-security-and-performance.md
- Security scan theo evidence: auth/authz, input validation, secret handling, CORS, SQL/query, eval/exec, file upload, PII.
- Performance scan theo evidence: N+1, unbounded loop, heavy sync IO, cache, pagination, large bundle, repeated network calls.
- Mỗi item phân loại: Fact / Risk / Gap.
- Không claim lỗ hổng nếu chỉ là nghi ngờ; ghi "Risk cần verify".
- Threat/performance surface matrix:
  - Surface | Evidence | Security concern | Performance concern | Severity | Verification.
- Reliability/operability:
  - Logging, metrics, tracing, retry, timeout, circuit breaker, healthcheck, migration safety nếu thấy.
- Large-system failure modes:
  - Cross-service contract drift, shared library blast radius, config/env mismatch, duplicated auth, async job retry/idempotency gaps.

File 11: <output>/11-pending-issues.md
- TODO / FIXME / HACK / XXX comments nổi bật, tối thiểu 10 nếu có.
- Commented-out code đáng ngờ.
- Technical debt rõ ràng.
- Broken docs/scripts/config nếu phát hiện.
- Bảng: Severity | Issue | Evidence | Impact | Suggested verification.
- Issue triage:
  - Must verify before coding.
  - Can wait.
  - Needs user/product decision.
  - Candidate for memory-bank/ADR/docs update.

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
- Large-system next action queues:
  - Top 5 module deep dives.
  - Top 5 flow traces.
  - Top 5 risk verifications.
  - Top 5 docs/memory-bank updates nên làm sau nếu user muốn lưu dài hạn.
  - Top 5 questions cần user hoặc domain owner trả lời.
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

## Reader TL;DR
- 5-7 dòng: file này trả lời câu hỏi gì, kết luận nào đáng tin, kết luận nào chưa đủ evidence.

## Scope & Coverage
- Scope thực tế của file này.
- Files read fully.
- Files sampled.
- Files not read / skipped + lý do.
- Coverage basis: full read / representative sample / hotspot sample / manifest-only / not loaded.

## Evidence
- Bảng evidence chính: Claim ID | Type | Claim | Evidence | Evidence strength | Coverage basis | Confidence.
- Type chỉ được dùng một trong: Fact, Inference, Gap, Risk, Recommendation.
- Claim ID ổn định dạng `EP-<file>-<type>-<nn>`; ví dụ `EP-05-F-01`, `EP-10-R-03`.

## Findings
- Nội dung chính của file.
- Mỗi Fact phải có `file:line`.
- Mỗi Inference phải nói rõ suy ra từ evidence nào.
- Mỗi Gap phải ghi cần đọc file/gặp user nào để xác minh.
- Mỗi Risk phải có impact + suggested verification.

## Verification
- Commands/checks cụ thể để user verify.
- Ghi rõ: đã chạy / chưa chạy / không áp dụng.

## What to trust / What not to assume
- What to trust: claim có direct evidence và coverage đủ.
- What not to assume: gap, inference yếu, vùng chưa đọc, risk chưa verify.

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
- Không biến "đã thấy 1 ví dụ" thành "toàn hệ thống dùng pattern này"; muốn claim toàn hệ thống phải có representative coverage hoặc nhiều evidence từ nhiều khu vực.
- Không dùng số liệu như LOC/import count/churn nếu chưa đo bằng tool hoặc cite output; nếu ước lượng thì ghi Inference và confidence thấp/medium.
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
- Với hệ thống lớn:
  - Confidence high bị cấm nếu chỉ đọc manifest hoặc sample nhỏ.
  - Claim về boundary/service/package phải cite manifest/config/export/import/caller thật.
  - Nếu context không đủ, ưu tiên tạo `CONTINUATION.md` và deep-dive queue thay vì output dài nhưng đoán.
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
   - Kiểm system-scale input; nếu unknown thì tự phân loại sau inventory.
   - Kiểm token/context budget.
   - Kiểm repo có quá lớn không.
2. Inventory:
   - Liệt kê files bằng công cụ search hiệu quả.
   - Tìm manifest/workspace config, README/docs, route/entrypoint, tests, CI, config, infra.
   - Tạo sơ bộ repo topology: apps, services, packages/libs, tools, infra, generated.
3. Classify scale:
   - small: đọc sâu nhiều file.
   - medium: đọc sâu core + representative modules.
   - large/monorepo: inventory rộng, đọc sâu hotspot, sample theo layer/domain/package.
4. Read priority:
   - Always read: README/docs setup, root manifest/workspace config, build/test scripts, CI, top-level app/service entrypoints.
   - Then read: route/controller/screen/state, domain/model/schema/migration, public exports, core services, integration adapters, tests.
   - Then read hotspots: TODO/security/performance, file lớn/import nhiều, shared libraries, auth/data/payment/session/upload/queue/worker.
5. Build system views:
   - Topology view từ file 02.
   - Runtime view từ file 04.
   - Architecture/data views từ file 05-06.
   - Quality/risk views từ file 09-11.
6. Write files theo thứ tự 00 -> 12.
7. Tạo `01-evidence-index.md` song song, không để cite rời rạc không kiểm được.
8. Trước khi viết file 12, tổng hợp signals từ file 02, 04, 05, 06, 09, 10, 11 để score module/flow/risk.
9. Với module candidate:
   - Ưu tiên path thật có evidence.
   - Nếu candidate là folder lớn, đề xuất submodule cụ thể thay vì yêu cầu deep dive cả folder quá rộng.
   - Nếu candidate là cross-cutting concern, chuyển sang flow trace nếu không có module boundary rõ.
10. Với flow candidate:
   - Ưu tiên action có entrypoint thật.
   - Nếu chưa thấy entrypoint, ghi Gap và không tạo prompt trace-flow cho flow đó.
11. Self-verify từng file theo `.prompts/snippets/self-verify.md`.
12. Output cuối trong chat: list 13 file đã tạo + trạng thái + quality scorecard + top 5 gaps + top 3 module/flow/risk nên làm tiếp.

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
- Mở `00-run-summary.md`, kiểm quality scorecard có điểm và lý do trừ điểm.
- Mở `02-repository-map.md`, kiểm repo topology không lẫn generated/vendor/build output với source thật.
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
- **Large system / monorepo mode**: giữ đủ 13 file, tăng trọng số cho `02-repository-map.md`, `04-entrypoints-and-runtime.md`, `05-architecture.md`, `06-data-and-domain-model.md`, `12-open-questions-and-next-deep-dives.md`; bắt buộc có topology, dependency/workspace graph, sampling rationale và continuation plan.

## Verification

- `ls <output>/` -> phải có 13 file `.md` hoặc có `CONTINUATION.md`.
- Mở `01-evidence-index.md`, chọn 10 cite ngẫu nhiên, verify trong codebase.
- Mở từng file, kiểm mọi `Fact` có cite `file:line`.
- Mở `12-open-questions-and-next-deep-dives.md`, kiểm mỗi module/flow được đề xuất đều có score, evidence, confidence, output folder và prompt tiếp theo.
- Với hệ thống lớn, kiểm `02-repository-map.md` có topology map và `01-evidence-index.md` có coverage matrix; nếu thiếu thì output không được gọi là READY.
- Chạy `verify output` cho `00-run-summary.md` và `01-evidence-index.md`.
- `bash scripts/check-impact.sh <output>` (nếu output nằm trong tracked path).
