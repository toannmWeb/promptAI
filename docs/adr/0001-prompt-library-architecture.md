# ADR-0001: Prompt Library Architecture — File-based Composable System

> **Status**: Accepted
> **Date**: 2026-04-29
> **Deciders**: Author (skeleton creator)
> **Tags**: architecture, prompt-engineering, multi-tool

---

## Context

Khi làm việc với AI coding assistants (Copilot, Cursor, Claude Code, Gemini, Codex, Antigravity), mỗi tool có convention khác nhau cho system instructions. Đồng thời, prompts cho development tasks (debug, refactor, feature planning) cần tái sử dụng xuyên suốt project mà không copy-paste thủ công.

Trước decision này:
- Prompts nằm rải rác trong chat history, không persist.
- Mỗi developer viết prompt khác nhau cho cùng task — không đồng nhất.
- Không có validation mechanism cho prompt quality.

Constraints:
- Phải hoạt động với ≥5 AI tools đồng thời.
- Không cần runtime dependency (no npm, no Python, no Docker).
- Phải human-readable (Markdown), version-controlled (git).

## Decision

Chúng ta sẽ dùng **file-based composable prompt library** tổ chức trong `.prompts/` với 5 sub-layers:
1. `system/` — Rules cốt lõi (auto-loaded bởi AI tool).
2. `personas/` — AI role-play templates (Analyst, Architect, Dev, QA, Reviewer).
3. `workflows/` — Multi-phase iterative processes (debug-loop, feature-E2E).
4. `tasks/` — Single-shot prompt templates (explain-module, plan-feature).
5. `snippets/` — Reusable blocks paste vào cuối prompt (force-cite, dry-run, self-verify).

Mỗi file có frontmatter YAML (`name`, `purpose`, `version`, `trigger-command`).

## Consequences

### Positive

- **Tool-agnostic**: Mọi AI tool đều đọc được Markdown — không lock-in.
- **Version-controlled**: Prompt thay đổi được track qua git diff, reviewable trong PR.
- **Composable**: User kết hợp persona + workflow + snippet tùy ý (`Casey + force-cite + self-verify`).
- **Discoverable**: `ROADMAP.md` section 6 liệt kê tất cả commands — user lookup nhanh.
- **Validatable**: `scripts/verify-prompt.sh` kiểm tra prompt quality tự động.

### Negative

- **Learning curve**: User phải biết ~20 commands + 5 personas — không zero-config.
- **Maintenance burden**: Mỗi prompt file cần maintain frontmatter, cross-references, version.
- **Mirror sync**: Entry files (`AGENTS.md`, `GEMINI.md`, `copilot-instructions.md`) mirror rules → DRY violation có chủ đích nhưng cần discipline khi update.

### Neutral

- Thêm ~80 files vào repo (không ảnh hưởng runtime, chỉ tăng repo size ~200KB).
- Cần bash shell cho validation scripts (Windows users dùng Git Bash / WSL).

## Alternatives considered

### Alternative 1: Single monolithic AGENTS.md

- Pros: Đơn giản, 1 file chứa tất cả.
- Cons: >5000 lines, không composable, không reuse snippet, khó maintain.
- Why rejected: Vi phạm SRP, không scale khi thêm workflows/tasks mới.

### Alternative 2: JSON/YAML prompt registry + runtime parser

- Pros: Machine-readable, có thể validate schema tự động.
- Cons: Cần runtime dependency (Node.js/Python), AI tools không đọc YAML natively, developer phải chuyển đổi format.
- Why rejected: Thêm complexity không cần thiết; Markdown + frontmatter đủ cho cả human và AI.

## Implementation

1. Tạo `.prompts/` với 5 sub-folders.
2. Mỗi prompt file có frontmatter YAML.
3. Per-tool entry files (`AGENTS.md`, `GEMINI.md`, `CODEX.md`) mirror 5-24 rules từ `base.md`.
4. Validation scripts parse frontmatter + check cross-references.
5. `ROADMAP.md` section 6 auto-documents tất cả commands.

## Verification

- `scripts/check-template.sh` pass: tất cả prompt files có frontmatter hợp lệ.
- `scripts/check-all.sh` pass: full release gate green.
- ≥3 AI tools (Copilot, Antigravity, Gemini) đọc đúng rules từ entry files.

## References

- [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD) — inspiration cho persona + workflow patterns.
- [Cline Memory Bank](https://docs.cline.bot/improving-your-prompting-skills/custom-instructions-library/cline-memory-bank) — inspiration cho persistent project memory.
- Michael Nielsen, "Thought as Technology" — prompts as reusable thought tools.

## Updates / superseded notes

- 2026-04-29: Decision accepted. Implemented in skeleton v3.1.
- 2026-04-30: Bumped to 24 rules, added Mode 1 workflow. Skeleton v3.2.
