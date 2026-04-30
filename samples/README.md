# Samples

> Prompt mẫu hoàn chỉnh, copy-paste vào AI tool dùng được luôn.
>
> Mỗi file có frontmatter `name / purpose / input / output / version`. Mỗi prompt reference đúng snippet/workflow trong `.prompts/`.

| Sample | Mục đích | Input chính | Output |
|---|---|---|---|
| [gather-context.md](gather-context.md) | Khởi tạo long-term memory — scan có chọn lọc, ghi vào `memory-bank/` với evidence ledger, write-policy enforce, hỗ trợ Continuation Handoff | source root + scope BE/FE/full + system scale + write-policy + project name | cập nhật `memory-bank/` (6 file core + features/ + domains/ + integrations/ + `_evidence-ledger.md` + `_coverage-log.md` + `_continuation.md`) + ROADMAP.md section 3 |
| [explore-project.md](explore-project.md) | Khám phá tổng quan project (output rời, không ghi memory-bank) | source root + scope BE/FE/full + system scale + folder output | 13 file .md có run summary, evidence index, coverage log, architecture, patterns, security/performance, next deep dives |
| [trace-flow.md](trace-flow.md) | Trace 1 luồng cụ thể với evidence ledger, happy path, branches, data/state, risk và tests | source root + flow/action + optional hint/outcome/problem + folder output | 8 file .md có summary, evidence, flow map, main path, data/state, branches/errors, security/performance, tests/next actions |
| [refactor-loop.md](refactor-loop.md) | Refactor + feature mới với vòng lặp Plan→Implement→Test→Verify, behavior preservation matrix, evidence ledger per iteration | source root + refactor/feature goal + edit-allowed + commands + max-iterations + folder output | code đã sửa + `iterations.md` (audit log) + `final-report.md` với quality scorecard |
| [fix-explain.md](fix-explain.md) | Fix bug với hypothesis ledger, repro proof, ≥ 2 fix options, regression test bắt buộc | source root + bug description + repro + logs + frequency + edit-allowed + folder output | 6 file .md (summary, evidence-and-hypothesis, bug-location-and-cause, fix-options, applied-fix-and-tests, rollback-and-followup) + diff trong code (sau Confirmation Gate) |
| [quick-install.md](quick-install.md) | Cài skeleton vào project có sẵn code — 2 prompt copy-paste, không cần đọc workflow dài | skeleton path + target project path | Skeleton files installed + memory-bank initialized |
| [deep-dive-validated.md](deep-dive-validated.md) | Học sâu 1 module với evidence ledger, coverage map, self-verify + quiz | source root + module path + folder output | 9 file .md có summary, evidence, API, internals, risks/change guide, quiz active recall |

## Cách dùng

1. Mở file sample tương ứng tình huống.
2. Copy phần trong khối ``` ``` (sau dòng `## Prompt`).
3. Thay placeholder `<...>` bằng giá trị thật.
4. Paste vào chat AI tool (Copilot / Cursor / Claude Code / Cline / Antigravity / Gemini / Codex).

## Liên quan

- Bảng tra cứu chi tiết tình huống → prompt: [../docs/USAGE-GUIDE.md](../docs/USAGE-GUIDE.md)
- Tất cả workflow + task + persona + snippet: [../.prompts/](../.prompts/)
