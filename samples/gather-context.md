---
name: sample-gather-context
purpose: Thu thập context lần đầu khi mới vào project — scan tối đa, output thẳng vào memory-bank/, hỗ trợ Continuation Handoff khi 1 request không đủ
input: scope (BE | FE | full) + project root path
output: cập nhật `memory-bank/` (6 file core + features/ + domains/ nếu phát hiện)
version: 1.0
last-updated: 2026-04-30
---

# Sample: Gather Context (lần đầu vào project)

> Dùng MỘT LẦN khi AI mới vào 1 project chưa được khởi tạo memory-bank, hoặc khi muốn refresh toàn bộ context. Sample này khác `explore-project.md` ở 2 điểm:
> 1. Output ghi thẳng vào `memory-bank/` (không phải folder rời).
> 2. Hỗ trợ **Continuation Handoff** — nếu 1 request không đủ token, AI tự lưu progress vào `activeContext.md` và in block `⏩ TIẾP TỤC REQUEST SAU` để user paste ở request kế.

## Khi nào dùng

- Mới clone 1 codebase chưa có `memory-bank/` filled.
- Muốn AI build "god view" cho project lớn để các session sau dùng lại.
- Cần scan toàn bộ BE / FE / full và lưu thành long-term memory.

## Khi KHÔNG dùng

- Project nhỏ < 50 file → dùng `explore-project.md` cho output 1 folder rời.
- Chỉ cần tìm hiểu 1 luồng → dùng `trace-flow.md`.
- Memory-bank đã filled → dùng `update-memory-bank` workflow.

## Prompt

```
Goal: Thu thập context toàn bộ project và ghi vào `memory-bank/` để các session AI sau dùng lại làm long-term memory.

Scope:
- Read allowed: TOÀN BỘ project root (trừ node_modules, build, dist, .git, _logs).
- Edit allowed: chỉ `memory-bank/` (6 file core + tạo `features/<name>.md`, `domains/<name>.md`, `integrations/<name>.md` nếu phát hiện).
- Scope filter: <BE | FE | full>

Context to load TRƯỚC khi scan:
- ROADMAP.md (god view template)
- .prompts/system/base.md (rules)
- docs/TEMPLATE-MODE.md (phân biệt mode)
- memory-bank/README.md (cấu trúc 6 file core + sub-folders)
- memory-bank/projectBrief.md, productContext.md, activeContext.md, systemPatterns.md, techContext.md, progress.md (xem hiện trạng còn `<TODO>` hay đã filled)

Acceptance criteria:
- AC-1: 6 file core memory-bank được fill (hoặc cập nhật) với facts có cite `file:line` từ codebase thật, không bịa.
- AC-2: Mỗi feature/domain/integration phát hiện được tạo 1 file trong `memory-bank/features/`, `domains/`, hoặc `integrations/` (theo `_template.md`).
- AC-3: ROADMAP.md section 3 "Map by topic" được update với hàng tương ứng cho mỗi feature/domain mới tạo.
- AC-4: Mọi claim về architecture, tech stack, pattern phải có cite `file:line` ít nhất 1 chỗ.
- AC-5: Nếu phát hiện ADR cần thiết (quyết định kiến trúc đã làm nhưng chưa có ADR) → list trong `progress.md` section "ADR cần backfill".
- AC-6: Output có Confidence per file (low/medium/high) và Self-verify ≥ 7/9 group pass.

Constraints:
- KHÔNG bịa file/function/API; chưa thấy → ghi rõ "không thấy trong scan này".
- KHÔNG fill `<TODO>` bằng giả định; nếu không suy ra được an toàn → để `<TODO>` + ghi vào Decision Points.
- Tuân thủ Template Mode: nếu repo này là `prompt-system-skeleton-*` thì DỪNG, không scan vì đây là master template.
- Smallest safe change: chỉ edit `memory-bank/`, KHÔNG sửa code.

Execution mode: edit-files (chỉ memory-bank/) + analysis-only (cho code).

Strategy thực thi:
1. Risk preflight: kiểm Template Mode, scope, token budget.
2. Quét nhanh top-level: README, package.json/pubspec/pyproject/go.mod, folder structure, test setup.
3. Quét theo scope:
   - Scope `BE` → backend folders, API routes, DB schema, migration, auth, integration.
   - Scope `FE` → frontend folders, routing, state management, UI patterns, build config.
   - Scope `full` → cả BE + FE + shared + infra.
4. Tổng hợp → fill 6 file core memory-bank (cite file:line).
5. Phát hiện feature/domain/integration → tạo file template tương ứng.
6. Update `ROADMAP.md` section 3.
7. Self-verify checklist `.prompts/snippets/self-verify.md`.

Continuation Handoff (BẮT BUỘC nếu task quá lớn cho 1 response):
- Làm tối đa có thể trong response hiện tại theo thứ tự ưu tiên: projectBrief → techContext → systemPatterns → productContext → activeContext → progress → features/domains/integrations.
- Lưu progress vào `memory-bank/activeContext.md` heading `## Continuation — gather-context — <YYYY-MM-DD>` với:
  - Đã xong: <list file đã fill + cite chính>
  - Còn lại: <list file/folder chưa scan + lý do>
  - Files touched: <path list>
- Cuối response in block:
  ```
  ⏩ TIẾP TỤC REQUEST SAU
  - Đã xong: ...
  - Còn lại: ...
  - Context đã lưu: memory-bank/activeContext.md (## Continuation — gather-context — <date>)
  - Prompt tiếp (copy-paste):
    ```
    Tiếp tục gather-context theo activeContext.md heading "Continuation — gather-context — <date>". Scope còn lại: <list>. Đọc activeContext trước để biết đã xong gì.
    ```
  ```

Verification:
- `bash scripts/check-memory-bank.sh` (hoặc `--allow-template` nếu là master template)
- `grep -r "<TODO>" memory-bank/` → list ô còn TODO
- Đọc lại 6 file core kiểm coherence (productContext nói gì, activeContext có khớp progress không)

Snippets bắt buộc apply:
- `.prompts/snippets/force-cite.md` — mọi claim có cite file:line
- `.prompts/snippets/confidence-scale.md` — confidence per file
- `.prompts/snippets/rollback-plan.md` — backup trước khi overwrite memory-bank đã filled
- `.prompts/snippets/dry-run.md` — nếu sẽ overwrite > 3 file đã có content
- `.prompts/snippets/self-verify.md` — checklist cuối

Output format:
- Mỗi file memory-bank được fill → 1 dòng tóm tắt: "memory-bank/<file>.md — <fact chính>, confidence=<level>".
- Bảng features/domains/integrations phát hiện.
- Decision Points: ô không suy ra được an toàn (vd auth strategy chưa rõ).
- Continuation Handoff block nếu chưa hoàn thành.

Halt conditions:
- Repo là master template (`docs/TEMPLATE-MODE.md` tồn tại + README ghi skeleton) → DỪNG, đề nghị user apply skeleton vào project thật trước.
- Memory-bank đã filled hoàn chỉnh (no `<TODO>` trong 6 file core) → DỪNG, đề nghị dùng `update memory bank` thay vì gather lại từ đầu.
- Phát hiện secret/credential trong scan → KHÔNG ghi vào memory-bank, cảnh báo user.

Confirmation Gate (nếu cần input):
- Reply: `OK` để dùng recommended default, hoặc `D-1=BE D-2=overwrite`, hoặc `STOP`.
```

## Liên quan

- Workflow đầy đủ: [`.prompts/workflows/initialize-memory-bank.md`](../.prompts/workflows/initialize-memory-bank.md)
- Update sau này: [`.prompts/workflows/update-memory-bank.md`](../.prompts/workflows/update-memory-bank.md)
- Khám phá output rời (không ghi memory-bank): [`explore-project.md`](explore-project.md)
- Continuation Handoff rule: [`../.prompts/system/base.md`](../.prompts/system/base.md) (rule 24, section 8.1)
