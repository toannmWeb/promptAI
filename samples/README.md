# Samples

> Prompt mẫu hoàn chỉnh, copy-paste vào AI tool dùng được luôn.
>
> Mỗi file có frontmatter `name / purpose / input / output / version`. Mỗi prompt reference đúng snippet/workflow trong `.prompts/`.

| Sample | Mục đích | Input chính | Output |
|---|---|---|---|
| [gather-context.md](gather-context.md) | Thu thập context lần đầu vào project — scan tối đa, ghi thẳng `memory-bank/`, hỗ trợ Continuation Handoff | scope BE/FE/full + project root | cập nhật `memory-bank/` (6 file core + features/ + domains/) |
| [explore-project.md](explore-project.md) | Khám phá tổng quan project (output rời, không ghi memory-bank) | scope: BE/FE/full + folder output | 13 file .md có run summary, evidence index, coverage log, architecture, patterns, security/performance, next deep dives |
| [trace-flow.md](trace-flow.md) | Trace 1 luồng cụ thể | tên flow + folder output | 1 file .md có sequence Mermaid + cite file:line |
| [refactor-loop.md](refactor-loop.md) | Refactor + feature mới với vòng lặp Plan→Implement→Test→Verify | scope edit-allowed | code đã sửa, mỗi iteration có Confirmation Gate |
| [fix-explain.md](fix-explain.md) | Fix bug + giải thích cho user hiểu rõ | mô tả bug + repro | output 4 phần: bối cảnh, bug ở đâu, cách sửa, sửa+verify |
| [deep-dive-validated.md](deep-dive-validated.md) | Học sâu 1 module với evidence ledger, coverage map, self-verify + quiz | module path + folder output | 9 file .md có summary, evidence, API, internals, risks/change guide, quiz active recall |

## Cách dùng

1. Mở file sample tương ứng tình huống.
2. Copy phần trong khối ``` ``` (sau dòng `## Prompt`).
3. Thay placeholder `<...>` bằng giá trị thật.
4. Paste vào chat AI tool (Copilot / Cursor / Claude Code / Cline / Antigravity / Gemini / Codex).

## Liên quan

- Bảng tra cứu chi tiết tình huống → prompt: [../docs/USAGE-GUIDE.md](../docs/USAGE-GUIDE.md)
- Tất cả workflow + task + persona + snippet: [../.prompts/](../.prompts/)
