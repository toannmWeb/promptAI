---
name: initialize-memory-bank
purpose: Lần đầu fill 6 file core memory-bank từ codebase (sau khi áp dụng skeleton vào project mới)
input: <root path of project / specific subfolder if monorepo>
output: 6 file memory-bank/*.md filled với nội dung thật + ROADMAP.md updated
version: 1.0
last-updated: 2026-04-29
trigger-command: "initialize memory bank"
---

# Workflow: Initialize Memory Bank

> Khi áp dụng skeleton v3.1 vào project mới (existing codebase), workflow này fill 6 file core từ scan code thật.

## Pre-conditions

- Skeleton v3.1 đã áp dụng vào project (có folder `memory-bank/`, `ROADMAP.md`, `.prompts/`).
- 6 file memory-bank/ core đang ở trạng thái template (chứa `<TODO>`).
- AI có quyền đọc toàn bộ source code project.

## Workflow (1 prompt comprehensive — token-max usage)

AI làm trong 1 response (Edit mode để sửa file):

### Step 1: Scope detection

1. Detect project type:
   - Single-app (FE only / BE only / mobile only).
   - Monorepo (multiple apps under 1 repo).
   - Multi-part (FE + BE in same repo, separate folders).
2. Identify **primary stack**:
   - Read `package.json`, `pyproject.toml`, `pubspec.yaml`, `go.mod`, `Cargo.toml`, `Gemfile`, ...
3. Identify **entry points**:
   - `main.dart`, `index.ts`, `app.py`, `main.go`, ...

### Step 2: Fill `projectBrief.md`

Content:
```markdown
# Project Brief — <name>

## What

<1-2 paragraph from README + package metadata>

## Goals

<from README "objectives" section, or infer from features>

## Scope

- In scope: <list>
- Out of scope: <list> (mark explicit)

## Stage

<idea | poc | mvp | growth | mature | legacy>

## Owners

<from package.json "author", git log top contributors>

## Source skeleton

prompt-system-skeleton v3.1 (initialized YYYY-MM-DD)
```

### Step 3: Fill `productContext.md`

Content:
```markdown
# Product Context — <name>

## Why this exists

<infer from README + feature flow>

## Problem solved

<who has problem, what problem, how this solves it>

## Users / personas

<list user types from code (auth roles), UI flows, API endpoints>

## Success metrics

<TODO — ask user>
```

### Step 4: Fill `activeContext.md`

```markdown
# Active Context — <name>

## Current focus

Memory Bank initialized YYYY-MM-DD. Awaiting first feature task.

## Recent changes (last 5)

<from git log, last 5 commits with hash + summary>

## Recent decisions

<TODO — ask user>

## Next 3 tasks

<TODO — ask user>

## Open questions

<TODO>
```

### Step 5: Fill `systemPatterns.md`

Content:
```markdown
# System Patterns — <name>

## Architecture overview

<Mermaid block diagram inferred from folder structure>

## Layers / tiers

<list each layer with cite folder + 1 sentence>

## Design patterns used

<infer: MVC, MVVM, BLoC, Redux, Repository, Service, Use Case, ...>

## Cross-cutting concerns

- Auth: <how>
- Logging: <how>
- Error handling: <how>
- Internationalization: <how>
- State management: <how>

## Conventions

- Naming: <e.g. snake_case for files, PascalCase for classes>
- File organization: <e.g. feature-first vs layer-first>
- Commit style: <Conventional Commits / freestyle>
```

### Step 6: Fill `techContext.md`

Content:
```markdown
# Tech Context — <name>

## Stack

<from manifest files, list each tech with version>

## Setup

```bash
<from README install/setup>
```

## Run locally

```bash
<from README>
```

## Test

```bash
<from README + test script in manifest>
```

## Deploy / build

```bash
<from CI config, scripts>
```

## Constraints

- <browser support / mobile platform / OS / runtime version>
- <perf budget / bundle size>
- <compliance requirements>

## External services

<list APIs, DBs, message queues, ...>
```

### Step 7: Fill `progress.md`

Content:
```markdown
# Progress — <name>

## What works

<list features inferred from code routing/screens/endpoints>

## What's left

<TODO — ask user>

## Known issues

<from git issues if available, or scan TODO/FIXME comments>

## Recent achievements

<last 5 PRs / releases from git log>
```

### Step 8: Update ROADMAP.md

1. Fill section 1 (Project là gì, stage, primary stack, owners).
2. Fill section 5 (Current sprint — set to "Memory Bank initialized, awaiting first sprint").

### Step 9: Confirm with user

```
Memory Bank initialized.

✅ Filled:
- memory-bank/projectBrief.md
- memory-bank/productContext.md
- memory-bank/activeContext.md
- memory-bank/systemPatterns.md
- memory-bank/techContext.md
- memory-bank/progress.md
- ROADMAP.md (section 1 + 5)

⚠ Có <N> chỗ <TODO> cần user fill (success metrics, recent decisions, next tasks, ...).

📋 Confidence per file:
- projectBrief: <high/med/low> — <reason>
- productContext: <high/med/low>
- ...

Cite all assumptions made. Ask user verify trước khi commit.
```

## Halt conditions

DỪNG, hỏi user nếu:
- README không có / quá ngắn → user cung cấp project description.
- Manifest file không exist → user xác nhận stack.
- Project là greenfield (no code yet) → skip systemPatterns/progress, chỉ fill projectBrief/productContext.

## Token efficiency

Tất cả 6 file + ROADMAP fill trong 1 Edit-mode session. Không split nhỏ.

→ User Edit panel sẽ thấy 7 diff. Review từng file → Accept hoặc Reject.

## Prompt template

```
@workspace initialize memory bank

Workflow: .prompts/workflows/initialize-memory-bank.md (9 steps).

Project root: <path or "current workspace">

Scan code, infer answers, fill 6 file memory-bank/*.md + ROADMAP.md sections 1, 5.

Dùng Edit mode để TỰ SỬA file. Cite assumption explicitly. Confidence per file.

Output cuối: list <TODO> chỗ user cần fill.
```
