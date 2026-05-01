# Getting Started — Skeleton v3.2

> Hai path rõ ràng: **Path A — Project mới** (greenfield) hoặc **Path B — Project đã có code** (brownfield).
>
> Đọc Step 0 chung trước, rồi rẽ nhánh theo path phù hợp.

---

## Step 0 — Hiểu skeleton (10 phút, đọc 1 lần)

### Architecture v3.1 — 5 layers

```
Layer 5 — Interface           AGENTS.md, .github/copilot-instructions.md, GEMINI.md, CODEX.md
Layer 4 — Prompt library      .prompts/ (system + personas + workflows + tasks + snippets) + samples/
Layer 3 — Project memory      memory-bank/ (6 core + optional) + ROADMAP.md
Layer 2 — Active artifacts    PRPs/, docs/adr/, docs/runbooks/, examples/, _logs/
Layer 1 — Validation          scripts/, docs/CHANGE-IMPACT.md, docs/PROMPT-VALIDITY.md
```

→ Đọc top-down: `AGENTS.md` → `.prompts/` → `memory-bank/` → PRPs/ADR → `scripts/`.

### Bạn cần gì

- 1 AI tool: GitHub Copilot, Cursor, Claude Code, Cline, Aider, Antigravity, Gemini, Codex.
- Bash shell (macOS / Linux / WSL / Git Bash trên Windows) — chạy `scripts/*.sh`.
  - **Windows users**: cài [Git for Windows](https://gitforwindows.org/) (bao gồm Git Bash) hoặc dùng WSL. PowerShell không hỗ trợ trực tiếp các validation scripts.
- 30-60 phút lần đầu setup.

### Decision: Path nào?

| Tình huống | Path |
|---|---|
| Project chưa có code, bắt đầu từ con số 0 | **Path A** |
| Project đã có code nhưng chưa có prompt system | **Path B** |
| Project đã có prompt system cũ không chuẩn, muốn thay bằng skeleton này | **Path B + workflow `overwrite prompt system`** |

---

# 🟢 Path A — Project mới (greenfield)

## A1. Khởi tạo project (2 phút)

```bash
# Tạo folder project
mkdir my-project && cd my-project
git init

# Giải nén skeleton tarball (hoặc clone repo skeleton)
tar -xzf /path/to/prompt-system-skeleton-v3.1.tar.gz --strip-components=1

# Verify cấu trúc
ls -la   # Phải thấy: .prompts/ memory-bank/ AGENTS.md ROADMAP.md scripts/ samples/ docs/
ls -la .github/   # Phải thấy: copilot-instructions.md
```

## A2. Setup tool entry file (1 phút)

Tùy AI tool đang dùng, đảm bảo entry file có đúng:

| Tool | File entry | Action |
|---|---|---|
| Copilot | `.github/copilot-instructions.md` | đã có sẵn |
| Cursor | `AGENTS.md` | đã có sẵn |
| Claude Code | `CLAUDE.md` → `AGENTS.md` | `ln -s AGENTS.md CLAUDE.md` |
| Gemini | `GEMINI.md` | đã có sẵn |
| Codex | `CODEX.md` | đã có sẵn |
| Antigravity | user/workspace rules | xem `docs/setup/antigravity-setup.md` |
| Cline | `AGENTS.md` + `.clinerules/` | đã có sẵn |
| Aider | `AGENTS.md` | thêm `read: AGENTS.md` vào `.aider.conf.yml` |

→ Chi tiết tất cả tool: `docs/setup/multi-tool-guide.md`.

## A3. Khởi tạo Memory Bank (10 phút)

Mở AI tool tại root project, gõ:

```
initialize memory bank

Yêu cầu:
1. Hỏi tôi: project name, mục tiêu, scope, target user, stack dự kiến.
2. Sau khi tôi trả lời, fill 6 file core trong memory-bank/ theo template:
   - projectBrief.md
   - productContext.md
   - activeContext.md (ghi: "Memory bank initialized today. Awaiting first task.")
   - systemPatterns.md (placeholder cho đến khi có code)
   - techContext.md
   - progress.md (status: "Project just started")
3. Confidence + Assumptions + Decision Points cuối mỗi file.
Dùng Edit/Agent mode để TỰ SỬA 6 file, không chỉ trả lời text.
```

→ AI hỏi 5-10 câu → bạn trả lời → AI fill 6 file → review + accept.

## A4. First commit (1 phút)

```bash
git add -A
git commit -m "chore: bootstrap with prompt-system-skeleton v3.2"
```

## A5. Checklist hoàn tất Path A

- [ ] Tất cả 6 file `memory-bank/*.md` core không còn `<TODO>`.
- [ ] Entry file đúng cho AI tool đang dùng (xem A2).
- [ ] `bash scripts/check-memory-bank.sh` PASS (không cần `--allow-template`).
- [ ] Mở chat MỚI, gõ `follow your custom instructions` → AI tóm tắt được project.
- [ ] First commit đã push.

→ Sang **Step 4 — Daily workflow** (cuối file).

---

# 🟡 Path B — Project đã có code (brownfield)

## B1. Pre-flight: kiểm tra xung đột (3 phút)

```bash
cd /path/to/existing-project

# Liệt kê file có thể xung đột
ls AGENTS.md CLAUDE.md GEMINI.md CODEX.md 2>/dev/null
ls .github/copilot-instructions.md 2>/dev/null
ls .cursor/ .clinerules/ .aider.conf.yml 2>/dev/null
ls memory-bank/ docs/adr/ PRPs/ examples/ 2>/dev/null
```

→ Note lại file/folder NÀO ĐÃ CÓ. Sau B3 sẽ merge thay vì đè.

## B2. Backup project (BẮT BUỘC, 1 phút)

```bash
git status                                # đảm bảo working tree clean
git checkout -b chore/adopt-prompt-skeleton
git tag backup-pre-skeleton-$(date +%Y%m%d)
```

→ Nếu có sự cố, rollback bằng `git reset --hard backup-pre-skeleton-<date>`.

## B3. Adopt skeleton — 2 cách

### Cách 1: Workflow tự động (khuyến nghị)

Mở AI tool tại project, gõ:

```
apply skeleton to <absolute path to project>

Source skeleton: <absolute path to prompt-system-skeleton folder>
Mode: merge-safe (KHÔNG đè file đã có; với AGENTS.md / .github/copilot-instructions.md / README.md, hỏi tôi confirm trước khi merge).
Goal: project có đầy đủ .prompts/ memory-bank/ samples/ docs/ scripts/ AGENTS.md GEMINI.md CODEX.md, và .github/copilot-instructions.md.
Tôn trọng: code app, README.md, .gitignore, ADR/PRP đã có.
```

→ Workflow này dùng `.prompts/workflows/apply-to-project.md`. Nó sẽ:
1. Dry-run liệt kê file copy / merge / skip + Confirmation Gate.
2. Sau khi user OK → copy file mới, merge file conflict.
3. Đề xuất rollback plan.

### Cách 2: Thủ công (kiểm soát chi tiết hơn)

Copy có chọn lọc — KHÔNG ĐÈ:

**Copy mới hoàn toàn (an toàn)**:
```bash
SKELETON=/path/to/prompt-system-skeleton-v3.1
cp -rn "$SKELETON/.prompts" .
cp -rn "$SKELETON/samples" .
cp -rn "$SKELETON/scripts" .
cp -rn "$SKELETON/docs" .              # cẩn thận nếu đã có docs/
cp -rn "$SKELETON/memory-bank" .
cp -rn "$SKELETON/PRPs" .              # nếu đã có PRPs cũ → -n giữ nguyên
cp -rn "$SKELETON/examples" .
cp -rn "$SKELETON/_logs" .
cp -n "$SKELETON/ROADMAP.md" .
cp -n "$SKELETON/INITIAL.md" .
```

`cp -n` = no-clobber, không đè file tồn tại.

**File entry — xử lý conflict thủ công**:

| File | Project đã có? | Hành động |
|---|---|---|
| `AGENTS.md` | Không | `cp $SKELETON/AGENTS.md .` |
| `AGENTS.md` | Có | Merge: giữ project rules + thêm 24 rules từ skeleton + thêm command table |
| `.github/copilot-instructions.md` | Không | `cp $SKELETON/.github/copilot-instructions.md .github/` |
| `.github/copilot-instructions.md` | Có | Merge: giữ rule project-specific + append section "Skeleton rules" từ template |
| `GEMINI.md` / `CODEX.md` | Không | `cp $SKELETON/GEMINI.md . ; cp $SKELETON/CODEX.md .` |
| `GEMINI.md` / `CODEX.md` | Có | Merge tương tự AGENTS.md |
| `README.md` | Có | **KHÔNG đè**. Có thể thêm 1 dòng "Project follows prompt-system-skeleton v3.1, xem AGENTS.md" |

**Mẹo merge AGENTS.md/.github**: dùng AI tool gõ:

```
merge skeleton AGENTS.md vào AGENTS.md hiện có:
- Giữ TẤT CẢ project-specific rules đang có.
- Thêm section "Bootstrap" từ skeleton (đọc memory-bank/...).
- Thêm "Rules cốt lõi (priority order)" 24 rules từ skeleton.
- Thêm "Workflow commands" table.
- Thêm "Tool-specific notes".
- Conflict rule → hỏi tôi chọn rule nào thắng.
Output: AGENTS.md đã merge + diff cho tôi review.
```

### Cách 3: Force overwrite (chỉ khi muốn dọn sạch prompt cũ)

Nếu project có prompt/instruction cũ không chuẩn và muốn thay bằng skeleton làm nguồn sự thật duy nhất:

```
overwrite prompt system in <project path>
```

Workflow này backup file cũ → ghi đè → có Confirmation Gate. Mặc định vẫn giữ `README.md`, code app, `memory-bank/`, `ROADMAP.md`, `docs/adr/`, `PRPs/`, `examples/`, `_logs/`.

## B4. Initialize Memory Bank trên codebase có sẵn (15 phút)

Mở AI tool tại project, gõ:

```
initialize memory bank

Project này ĐÃ CÓ CODE. Yêu cầu:
1. Quét code trong <root>/<source-folder> (ví dụ: src/, app/, lib/).
2. Đọc README.md, package.json/pubspec.yaml/requirements.txt/Cargo.toml để hiểu stack.
3. Fill 6 file core trong memory-bank/ theo template, dựa CHỦ YẾU vào code thật:
   - projectBrief.md: project là gì (suy ra từ README, name) — HỎI tôi confirm goals.
   - productContext.md: vấn đề giải quyết — HỎI tôi nếu code không nói rõ.
   - activeContext.md: ghi "Adopted skeleton today. Awaiting first task on <hotspot module>".
   - systemPatterns.md: architecture từ code thật, cite file:line.
   - techContext.md: stack từ manifest files.
   - progress.md: status hiện tại từ git log + code coverage cảm nhận được.
4. Cite file:line khi đề cập code thật. Không bịa.
5. Confidence + Assumptions + Decision Points cuối mỗi file.

Dùng Edit/Agent mode để TỰ SỬA 6 file. Risk preflight + dry-run trước khi ghi.
```

→ AI quét code 2-5 phút → xuất diff cho 6 file → bạn review + accept.

## B5. Verify (5 phút)

```bash
bash scripts/check-memory-bank.sh        # phải PASS (không cần --allow-template)
bash scripts/check-impact.sh src/        # demo: thử check 1 path code
```

Mở chat MỚI, gõ:

```
follow your custom instructions

Tóm tắt project này dựa trên memory-bank.
```

Verify:
- [ ] AI nhắc đúng project name + mục tiêu.
- [ ] AI biết stack chính (cite được file manifest).
- [ ] AI biết architecture chính (layers/modules) + cite file:line được khi hỏi sâu.
- [ ] AI biết "đang làm gì NOW" từ activeContext.

## B6. Commit (1 phút)

```bash
git add -A
git diff --cached --stat                  # review tổng quan
git commit -m "chore: adopt prompt-system-skeleton v3.2"
git push -u origin chore/adopt-prompt-skeleton
```

→ Tạo PR review trước khi merge vào main.

## B7. Checklist hoàn tất Path B

- [ ] Backup tag `backup-pre-skeleton-<date>` đã tạo.
- [ ] `.prompts/`, `samples/`, `scripts/`, `docs/`, `memory-bank/`, `ROADMAP.md` đã có.
- [ ] `AGENTS.md` + `.github/copilot-instructions.md` (+ `GEMINI.md` / `CODEX.md` nếu dùng) đã merge.
- [ ] 6 file `memory-bank/*.md` core không còn `<TODO>`.
- [ ] `bash scripts/check-memory-bank.sh` PASS.
- [ ] AI tóm tắt được project trong chat MỚI.
- [ ] Code app KHÔNG bị đụng (chỉ thêm file, không modify code).
- [ ] PR đã tạo + có người review.

---

# Step 4 — Daily workflow (chung cho cả 2 path)

## Bắt đầu task mới

```
follow your custom instructions

<task description>
```

Nếu task quan trọng hoặc prompt mơ hồ:

```
optimize prompt:
<draft prompt>
```

Tiết kiệm request, ép AI làm hết mức trong 1 lần:

```
mode 1: <task>
```

## Sửa file

Dùng Edit/Agent mode của tool:
- **Copilot**: tab Edit (Ctrl+Shift+I).
- **Cursor**: Composer (Ctrl+I).
- **Claude Code / Cline / Antigravity**: native Agent.

## Sau task — update memory bank

Sau khi feature done / quyết định kiến trúc / refactor lớn:

```
update memory bank

Vừa xong: <task description>.
Cập nhật:
- activeContext.md với current focus mới.
- progress.md mark <feature> done (nếu xong).
- systemPatterns.md nếu architecture đổi.
- techContext.md nếu stack đổi.
```

## Step 5 — Khi nào tạo file optional

### Tạo PRP

Khi viết feature > 50 LOC, multi-module:

```
create PRP for <feature description>
```

→ AI tạo `PRPs/<n>-<feature>.md`. Bạn review, refine, sau đó:

```
execute PRPs/<n>-<feature>.md
```

### Tạo ADR

Khi quyết định kiến trúc với alternative đáng cân nhắc:

```
create ADR for <decision title>
```

→ AI hỏi context/options/trade-offs, fill `docs/adr/<n>-<title>.md`.

### Tạo example pattern

Khi pattern xuất hiện ≥ 3 lần:

```
extract pattern <name> from <file:line>
```

→ AI tạo `examples/<name>.md`.

### Tạo feature doc

Khi feature lớn cần doc riêng:

```
document feature <name>

Tạo memory-bank/features/<name>.md từ template, fill dựa trên code hiện tại.
```

### Lưu chat output

Sau output AI quan trọng (research, plan, debug session):

```
save chat to log
```

→ AI tạo `_logs/<YYYY-MM-DD>-<task>.md` với prompt + output.

## Step 6 — Maintenance

### Hàng tuần

- Review `memory-bank/activeContext.md` — còn current không?
- Review `memory-bank/progress.md` — done items đã merge?

### Hàng tháng

- Review `docs/adr/` — có ADR cần promote `Proposed` → `Accepted`?
- Review `examples/` — pattern nào outdated?
- Cleanup `_logs/` — xóa entries không còn relevant.

### Khi có dev mới onboard

Cho họ đọc theo thứ tự:
1. `memory-bank/projectBrief.md`
2. `memory-bank/productContext.md`
3. `memory-bank/systemPatterns.md`
4. `memory-bank/techContext.md`
5. `docs/runbooks/local-dev.md`
6. `memory-bank/activeContext.md` (hiểu hiện tại đang làm gì)

→ 30-60 phút onboarding với memory-bank tốt = tương đương 1 buổi pairing.

## FAQ

### Q: Memory Bank vs CLAUDE.md / AGENTS.md có gì khác?

- **AGENTS.md / CLAUDE.md** = "rules" (làm gì, không làm gì).
- **Memory Bank** = "knowledge" (project là gì, làm sao chạy, đang ở đâu).

→ Cả 2 cần thiết. Skeleton v3.0 có cả 2.

### Q: Tôi đang dùng skeleton v2.x, switch sao?

1. Copy skeleton v3.0 vào project mới.
2. Migrate content từ v2 sang v3:
   - `MAP.md` → `memory-bank/projectBrief.md` + `productContext.md`.
   - `AGENTS.md` v2 → merge vào v3 AGENTS.md (giữ rules, bỏ section về v2 templates).
   - `docs/architecture/00-overview.md` → `memory-bank/systemPatterns.md`.
   - PRPs giữ nguyên.
3. Xóa `.prompts/` (v3 không cần).

### Q: AI không tự đọc memory-bank, làm sao?

- Verify `.github/copilot-instructions.md` (Copilot) hoặc `AGENTS.md` (others) có trỏ đến memory-bank.
- Đầu chat, prompt explicit: `Read memory-bank/*.md before answering.`
- Nếu vẫn không work → tool có thể cần config riêng (xem `AGENTS.md` § Tool-specific notes).

### Q: Memory Bank có conflict với git?

- Toàn bộ memory-bank check-in git (đây là intent — share team).
- `_logs/` có thể gitignored nếu lưu nhiều output cá nhân.

### Q: Project có > 1 dev, conflict memory-bank?

- `activeContext.md` thường conflict (mỗi dev đang làm khác nhau).
- Solution: dùng **branch-specific activeContext** hoặc move dev-specific work sang `_logs/<dev>/`.
- Hoặc: `activeContext.md` chỉ track team-level focus, không cá nhân.

## Đọc thêm

- `DESIGN-RATIONALE.md` — đánh giá sâu, tại sao chọn pattern này.
- `memory-bank/README.md` — Memory Bank pattern detail.
- `PRPs/README.md` — PRP workflow detail.
- `docs/adr/README.md` — ADR convention.
