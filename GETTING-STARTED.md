# Getting Started — Skeleton v3.1.1

> Hướng dẫn chi tiết cho người mới. Nếu vội, đọc 3-step ở `README.md` rồi quay lại đây khi cần.
>
> v3.1 thêm nhiều layer so với v3.0 — đọc Phần "Step 0 v3.1 additions" dưới.
>
> **Template Mode**: Repo gốc này là master template. Chỉ sau khi copy/apply sang project thật mới chạy `initialize memory bank`.

---

## Bạn cần gì

- Một project (mới hoặc đã có code).
- 1 AI tool: GitHub Copilot, Cursor, Claude Code, Cline, Aider, ... (đều work).
- 60-90 phút lần đầu setup (v3.1 nhiều thứ hơn v3.0).
- Bash shell (sẵn macOS / Linux / WSL / Git Bash trên Windows) — cho `scripts/*.sh`.

## Step 0 — Hiểu skeleton (10 phút)

### Architecture v3.1 — 5 layers

```
Layer 5 — Interface           AGENTS.md, .github/copilot-instructions.md
                              → Workflow commands, persona triggers
                              ↓
Layer 4 — Prompt library      .prompts/ (system + personas + workflows + tasks + snippets)
                              → Canonical templates
                              ↓
Layer 3 — Project memory      memory-bank/ (6 core + optional)
                              ROADMAP.md (god view)
                              → Long-term context
                              ↓
Layer 2 — Active artifacts    PRPs/, docs/adr/, docs/runbooks/, examples/, _logs/
                              → Per-feature, per-decision artifacts
                              ↓
Layer 1 — Validation          scripts/, docs/CHANGE-IMPACT.md, docs/PROMPT-VALIDITY.md
                              → Safety net
```

→ Đọc top-down: AGENTS.md → .prompts/ → memory-bank/ → PRPs/ADR → scripts/.

### v3.1 additions vs v3.0

| Thêm gì | Để giải quyết |
|---|---|
| `ROADMAP.md` | Q1.6 — cần file tổng quát "nhìn vào hiểu luôn" |
| `.prompts/` library | Q1.4 — prompt đồng nhất chuẩn |
| `.prompts/personas/` (5 + party) | Q1.3 — multi-perspective deep dive |
| `.prompts/workflows/debug-loop.md` | Q2 — vòng lặp debug |
| `.prompts/workflows/deep-dive-learn.md` | Q1.3 — học cực sâu |
| `scripts/check-impact.sh` + `CHANGE-IMPACT.md` | Q1.5 — sửa code biết update mb gì |
| `scripts/verify-prompt.sh` + `PROMPT-VALIDITY.md` | (+) — valid + complete |
| `scripts/build-context.sh` | Q1.1 — bundle context cho prompt lớn |
| `Casey 🔍 + Quinn 🧐` personas | Q1.2 — adversarial review |
| `.prompts/tasks/optimize-prompt.md` + `prompt-contract.md` | Prompt thô → task contract đủ goal/scope/context/AC/verification |
| `docs/REQUEST-MODES.md` + `mode-1-one-shot-max.md` | One-Shot Max cho task cần chất lượng cao nhất trong 1 request |
| `docs/BENCHMARK-MODE-1.md` + `scripts/check-all.sh` | Chấm điểm Mode 1 và release gate cho master template |
| `docs/TEMPLATE-MODE.md` + `scripts/check-template.sh` | Giữ repo master sạch, không lẫn facts của app cụ thể |

→ Đọc `memory-bank/README.md` để hiểu Memory Bank pattern.

## Step 1 — Copy skeleton vào project (3 phút)

### Project mới

```bash
# Giải nén skeleton tarball
tar -xzf prompt-system-skeleton-v3.1.1.tar.gz

# Copy ra thư mục project mới
cp -r prompt-system-skeleton-v3.1.1/* /path/to/your-project/
cp -r prompt-system-skeleton-v3.1.1/.github /path/to/your-project/

# Đảm bảo .gitignore không khoá file skeleton (xem .gitignore của skeleton)
```

### Project đã có code

Copy có chọn lọc — KHÔNG đè:

**Copy** (file/folder mới hoàn toàn):
- `memory-bank/` (toàn bộ folder)
- `PRPs/` (nếu chưa có)
- `examples/` (nếu chưa có)
- `_logs/` (nếu chưa có)
- `docs/adr/` (nếu chưa có — cẩn thận đừng đè ADR đã có)
- `docs/runbooks/` (cẩn thận đừng đè)

**Cẩn thận**:
- `AGENTS.md` — nếu project đã có, merge nội dung thay vì đè.
- `.github/copilot-instructions.md` — nếu đã có, merge.
- `README.md` — KHÔNG copy đè README project.

## Step 2 — Initialize Memory Bank trong project thật (10 phút)

Sau khi skeleton đã nằm trong project thật, mở AI tool tại project thật và gõ:

```
initialize memory bank

Yêu cầu:
1. Quét code project trong <root>/<source-folder> để hiểu stack, architecture.
2. Fill 6 file core trong memory-bank/ theo template:
   - projectBrief.md: project là gì, goals, scope (HỎI tôi nếu chưa rõ)
   - productContext.md: vấn đề giải quyết, user (HỎI tôi)
   - activeContext.md: "Memory bank initialized today. Awaiting first task."
   - systemPatterns.md: architecture từ code thật, cite file:line
   - techContext.md: stack từ package.json/pubspec.yaml/requirements.txt
   - progress.md: status hiện tại (đã có gì work, còn lại gì)
3. Cite file:line khi đề cập code thật.
4. Confidence + Assumptions + Decision Points cuối mỗi file.

Dùng Edit/Agent mode để TỰ SỬA 6 file, không chỉ trả lời text.
```

→ AI quét code 1-2 phút → xuất diff cho 6 file → bạn review + accept.

→ Sau accept: 6 file core có content.

Trong repo master template, không chạy bước này để fill facts project cụ thể. Kiểm tra template bằng:

```bash
./scripts/check-template.sh
./scripts/check-memory-bank.sh --allow-template
```

## Step 3 — Verify Memory Bank (5 phút)

Đầu conversation MỚI (đóng chat cũ, mở chat mới), gõ:

```
follow your custom instructions

Tóm tắt project này dựa trên memory-bank.
```

→ AI đọc memory-bank, tóm tắt 5-10 dòng. Verify:

- [ ] AI nhắc đúng project name.
- [ ] AI biết stack chính.
- [ ] AI biết architecture chính (layers/modules).
- [ ] AI biết "đang làm gì NOW" từ activeContext.
- [ ] AI cite file:line được khi hỏi tiếp.

→ Nếu OK → Memory Bank work.

→ Nếu sai → đọc lại memory-bank, fix file sai, gõ `update memory bank`.

## Step 4 — Daily workflow

### Bắt đầu task mới

```
follow your custom instructions

<task description>
```

Nếu task quan trọng hoặc prompt còn mơ hồ, chạy pre-flight trước:

```
optimize prompt:
<draft prompt>
```

Sau đó paste prompt đã tối ưu để AI thực thi.

Nếu bạn muốn tiết kiệm request và ép AI làm hết mức trong 1 lần:

```
mode 1: <task>
```

### Trong task — sửa file

Dùng Edit/Agent mode của tool:
- **Copilot**: tab "Edit" trong panel chat (Ctrl+Shift+I trên Win 11).
- **Cursor**: Composer (Ctrl+I).
- **Claude Code**: native (mặc định Agent).
- **Cline**: native (mặc định Agent).

### Sau task — update memory bank

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
