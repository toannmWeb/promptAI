# Multi-Tool Setup Guide

> Skeleton này hỗ trợ NHIỀU AI tool đồng thời trong cùng 1 project. Nguyên tắc cốt lõi: `.prompts/`, `memory-bank/`, `samples/` dùng chung 100%; chỉ khác **file entry**.

---

## 1. Nguyên tắc shared / per-tool

```
SHARED (dùng chung 100%, không sửa khi đổi tool):
  .prompts/         ← prompt library (system + personas + workflows + tasks + snippets)
  memory-bank/      ← project knowledge
  samples/          ← prompt mẫu copy-paste
  docs/             ← reference docs
  scripts/          ← validation tooling
  ROADMAP.md        ← god view

PER-TOOL (mỗi tool có entry file riêng, mirror từ AGENTS.md):
  AGENTS.md                       ← Cursor, Cline, Aider (cross-tool standard)
  .github/copilot-instructions.md ← GitHub Copilot
  CLAUDE.md                       ← Claude Code (symlink → AGENTS.md)
  GEMINI.md                       ← Gemini Code Assist / CLI
  CODEX.md                        ← OpenAI Codex
  Antigravity user/workspace UI   ← Antigravity (paste rules vào UI)
```

→ Đổi từ tool A sang tool B: chỉ cần đảm bảo entry file cho tool B tồn tại. Không cần đụng `.prompts/` hay `memory-bank/`.

---

## 2. Bảng so sánh 4 tools chính được hỗ trợ đầy đủ

| Tool | Entry file | Edit mode | Memory-bank auto-load | Workflow command | Điểm mạnh | Hạn chế |
|---|---|---|---|---|---|---|
| **GitHub Copilot** | `.github/copilot-instructions.md` | Edit panel (Ctrl+Shift+I) | Có (qua instructions) | Có | Tích hợp VSCode chặt, indexing nhanh, miễn phí cho học sinh/OSS | Chat history limit, không phải agent autonomous |
| **Antigravity** | User/Workspace rules UI | Native agent | Có (qua rules) | Có | Agent autonomous mạnh, multi-step task, ổn định | Phải paste rules thủ công vào UI lần đầu |
| **Gemini** | `GEMINI.md` | Code Assist edit / CLI | Có (qua GEMINI.md) | Có | Context window lớn (1M+ tokens), multimodal, miễn phí với Google account | Edit experience tùy IDE plugin, agent mode còn mới |
| **Codex** | `CODEX.md` | Codex CLI / cloud agent | Có (qua CODEX.md) | Có | Agent cloud chạy task dài, sandboxed env, code execution native | Phải có ChatGPT Plus/Pro, latency cloud |

---

## 3. Khi nào dùng tool nào

| Tình huống | Tool đề xuất | Lý do |
|---|---|---|
| Coding hàng ngày trong VSCode | GitHub Copilot | Tích hợp tốt nhất với VSCode, edit mode nhanh |
| Task multi-step autonomous (refactor lớn, scaffold project) | Antigravity / Codex agent | Agent tự chạy nhiều bước, ít cần hand-hold |
| Cần đọc nhiều file lớn trong 1 context (codebase audit, mega-PR review) | Gemini | Context window 1M+ tokens |
| Task chạy lâu, cần sandbox an toàn | Codex cloud agent | Cloud sandbox, không chạm máy local |
| Pair-programming + chat sâu | Claude Code / Copilot | Reasoning mạnh, follow-up tốt |
| Terminal-first workflow | Aider | CLI-native, git-integration tốt |
| Self-host / open editor | Cursor / Cline | Editor riêng, kiểm soát cao |

---

## 4. Setup từng tool

### 4.1. GitHub Copilot

```
File entry: .github/copilot-instructions.md
```

- File đã có sẵn trong skeleton, mirror 18 rules từ `.prompts/system/base.md`.
- VS Code tự đọc file này. Không cần config thêm.
- Để verify: mở chat, gõ `follow your custom instructions` → Copilot phải tóm tắt được project từ memory-bank.

**Bonus**: nếu dùng Copilot Workspace / Copilot Coding Agent (cloud), upload thư mục project lên — agent đọc cùng file entry.

---

### 4.2. Antigravity

```
File entry: User/Workspace rules trong Antigravity UI (paste thủ công)
```

→ Chi tiết riêng: [antigravity-setup.md](antigravity-setup.md).

Tóm tắt:
1. Mở Antigravity → Settings → Rules.
2. Tạo Workspace rule (per-project) hoặc User rule (cross-project).
3. Paste nội dung từ `AGENTS.md` (toàn bộ) HOẶC tóm tắt 24 rules + bootstrap section.
4. Save.

---

### 4.3. Gemini

```
File entry: GEMINI.md (đã có trong skeleton)
```

**Gemini Code Assist (IDE plugin)**:
- Mở Settings → Custom instructions → paste nội dung `GEMINI.md`.
- Hoặc trỏ tới file: `path: ./GEMINI.md`.

**Gemini CLI**:
```bash
gemini --rules-file GEMINI.md "<task>"
```

**Gemini Web/API**:
- Dùng nội dung `GEMINI.md` làm system prompt.
- Note context window: với codebase lớn, Gemini 1.5 Pro có thể đọc tới ~1M tokens — tận dụng để load nhiều file cùng lúc.

---

### 4.4. Codex

```
File entry: CODEX.md (đã có trong skeleton)
```

**Codex CLI**:
```bash
codex --instructions CODEX.md "<task>"
```

**Codex cloud agent** (qua chatgpt.com):
1. Tạo task mới.
2. Connect GitHub repo.
3. Paste nội dung `CODEX.md` vào "Task instructions" hoặc "System prompt".
4. Chạy.

**Codex IDE integration**:
- Paste section "5 rules" của `CODEX.md` vào project rules trong IDE.

---

### 4.5. Cursor

```
File entry: AGENTS.md (Cursor tự đọc)
```

- Nếu có `.cursor/rules/`, Cursor ưu tiên đọc folder đó. Để dùng `AGENTS.md`, đảm bảo `.cursor/rules/` rỗng hoặc trỏ về `AGENTS.md`.
- Composer mode (Ctrl+I) là Edit mode — dùng cho task sửa file.

---

### 4.6. Cline

```
File entry: AGENTS.md + .clinerules/
```

- Cline đọc `AGENTS.md` mặc định.
- Nếu cần override per-folder, tạo `.clinerules/<rule-name>.md`.

---

### 4.7. Claude Code

```
File entry: CLAUDE.md → AGENTS.md (symlink hoặc copy)
```

```bash
# Linux/macOS
ln -s AGENTS.md CLAUDE.md

# Windows (PowerShell as admin)
New-Item -ItemType SymbolicLink -Path CLAUDE.md -Target AGENTS.md
```

Hoặc đơn giản: `cp AGENTS.md CLAUDE.md` (nhược điểm: phải sync khi `AGENTS.md` đổi).

---

### 4.8. Aider

```
File entry: AGENTS.md (qua --read flag hoặc config)
```

Cách 1 — CLI flag:
```bash
aider --read AGENTS.md
```

Cách 2 — config file `.aider.conf.yml`:
```yaml
read: AGENTS.md
```

---

## 5. Multi-tool trong cùng project

Skeleton hỗ trợ NHIỀU tool cùng lúc. Bạn có thể có ĐỒNG THỜI:
- `.github/copilot-instructions.md` (Copilot)
- `AGENTS.md` (Cursor / Cline / Aider)
- `GEMINI.md` (Gemini)
- `CODEX.md` (Codex)
- `CLAUDE.md` symlink (Claude Code)

→ Mỗi tool đọc file của nó, không xung đột.

**Lưu ý**: 
- Khi update rules, sync giữa các entry file. Recommended: sửa `AGENTS.md` trước, sau đó cập nhật mirror trong `.github/copilot-instructions.md`, `GEMINI.md`, `CODEX.md`.
- Mặc định, các file mirror (`GEMINI.md` / `CODEX.md`) chỉ chứa 5 rules quan trọng — không cần sync mọi rule, chỉ sync khi 5 rules core đổi.

---

## 6. Verification

Sau khi setup, mỗi tool đều phải pass test sau:

```
follow your custom instructions

Tóm tắt project này dựa trên memory-bank.
```

Tool phải:
- [ ] Nhắc đúng project name + mục tiêu (từ `memory-bank/projectBrief.md`).
- [ ] Biết stack chính (từ `memory-bank/techContext.md`).
- [ ] Biết "đang làm gì NOW" (từ `memory-bank/activeContext.md`).
- [ ] Cite được file:line khi hỏi sâu.
- [ ] Output có Confidence + Self-verify line.

→ Nếu không pass → entry file chưa được tool đọc. Kiểm tra lại theo section 4.

---

## 7. Đọc thêm

- [AGENTS.md](../../AGENTS.md) — full rules + workflow commands.
- [.prompts/system/base.md](../../.prompts/system/base.md) — 24 rules cốt lõi (source of truth).
- [docs/USAGE-GUIDE.md](../USAGE-GUIDE.md) — bảng tra cứu tình huống → prompt.
- [antigravity-setup.md](antigravity-setup.md) — Antigravity setup chi tiết.
