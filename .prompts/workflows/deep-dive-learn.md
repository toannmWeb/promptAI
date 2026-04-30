---
name: deep-dive-learn
purpose: Học CỰC SÂU 1 module trong codebase + lưu doc cho future + extract patterns
input: <module path / feature name>
output: memory-bank/features/<X>.md hoặc memory-bank/domains/<X>.md + examples/<pattern>.md (nếu có pattern)
version: 1.0
last-updated: 2026-04-29
adapted-from: BMAD-METHOD bmad-document-project (deep-dive-workflow)
trigger-command: "deep dive into <module>" / "Mary, deep dive <module>"
---

# Workflow: Deep-Dive Learn

> Vòng lặp **học sâu** 1 module. Output: AI hiểu module + bạn hiểu module + doc persistent. Không phải "tóm tắt nhanh", mà **literal full-file review** + extract patterns.

## Tại sao cần workflow này

Khi bạn nói "tôi muốn hiểu cực sâu module X":
- Đọc summary 1 lần → quên.
- Đọc code 1 lần → mơ hồ.
- → Cần workflow **iterative**: phase by phase, mỗi phase 1 layer hiểu, output lưu lại.

## Phases (5 phases, 1 vòng lặp / phase)

### Phase 1: Scope & Map (5-10 phút)

User input: `<module path / feature name>`

AI làm:
1. Đọc `ROADMAP.md` + `memory-bank/systemPatterns.md` để biết position của module trong system.
2. Liệt kê **all files** trong module với 1 dòng mô tả mỗi file (parse imports, exports, class names).
3. Identify **entry points** (public API exposed) + **dependencies** (file/lib import từ ngoài).
4. Output **Module map** Markdown:
   ```
   ## Module: <name>
   - Path: <path>
   - Position: <where in system>
   - Files: <count>, total LOC: <estimate>
   - Entry points: <list>
   - External deps: <list>
   - Internal deps: <list of sub-folders>
   ```
5. Save: tạo `memory-bank/features/<name>.md` (nếu feature) hoặc `memory-bank/domains/<name>.md` (nếu domain) với section "Map".

User confirm: "OK Phase 1, next" hoặc "wait, missed <X>".

### Phase 2: Full-file review (15-30 phút)

AI làm:
1. Đọc **ENTIRE** content của top 3-5 file quan trọng nhất (entry points + biggest LOC).
2. Mỗi file output:
   ```
   ### File: <path>
   - Purpose: <1 sentence>
   - Public exports: <list with signature>
   - Key logic: <bullet 3-5 items, cite line ranges>
   - Side effects: <list> (DB, network, fs, mutation, ...)
   - Error handling: <list catch / throw points>
   - Test coverage: <if test file exists>
   ```
3. Append vào `memory-bank/features/<name>.md` section "Files".

User confirm hoặc ask follow-up.

### Phase 3: Data flow + sequence diagram (10-15 phút)

AI làm:
1. Vẽ **Mermaid sequence diagram** cho 1-2 critical user actions trong module (vd: "register user", "submit form").
2. List data shape evolution (input → transform → persist → response).
3. Append vào `memory-bank/features/<name>.md` section "Flows".

User confirm.

### Phase 4: Pattern extraction (10-15 phút)

AI làm:
1. Identify **3-5 patterns** module dùng (vd: "Repository pattern", "BLoC", "Saga", "Factory").
2. Mỗi pattern:
   - Tên pattern.
   - Why used (problem solved).
   - Where used (cite file:line).
   - Generalize: bộ skeleton code áp dụng pattern (tạo `examples/<pattern>.md`).
3. Append vào `memory-bank/features/<name>.md` section "Patterns".

### Phase 5: Quiz + open questions (10 phút)

AI làm:
1. Generate **5 question** user CẦN trả lời để xác nhận hiểu sâu (Socratic style):
   - Q-1: "Tại sao module dùng <pattern A> thay vì <pattern B>?"
   - Q-2: "Nếu thêm feature X, file nào sẽ phải sửa?"
   - Q-3: "Edge case nào module hiện chưa handle?"
   - Q-4: "Performance bottleneck đáng ngờ ở đâu?"
   - Q-5: "Decision điểm gây tranh cãi nào trong code?"
2. User trả lời từng câu → AI refine, correct, add insight.
3. Sau khi xong: append "Q&A" section vào `memory-bank/features/<name>.md`.

## Loop control

Sau mỗi phase, AI hỏi:
- ✅ "OK, next phase?" → tiếp tục.
- 🔁 "Wait, dig deeper into <X>" → loop lại phase với focus narrow.
- ⏹ "Stop, that's enough" → save state + dừng.

## Output artifacts

Cuối workflow, có:
1. **`memory-bank/features/<name>.md`** (hoặc `domains/<name>.md`) đầy đủ 5 sections.
2. **`examples/<pattern-1>.md`, `examples/<pattern-2>.md`, ...** — patterns extracted.
3. **`_logs/<YYYY-MM-DD>-deep-dive-<module>.md`** — chat transcript (optional).
4. Update `ROADMAP.md` section 3 "Map by topic" — add new domain/feature row.

## Token efficiency

Mỗi phase = 1 prompt. KHÔNG split phase nhỏ. User confirm → continue.

→ 5 phase = 5 round prompt-response, mỗi round dùng max context cho phase đó.

## Halt conditions

DỪNG, hỏi user khi:
- Module quá lớn (>30 file) → chia thành sub-modules trước.
- File AI không read được (binary, generated, encrypted) → user cung cấp source.
- Pattern không clear → ask Mary verify trước khi extract.

## Prompt template (copy-paste vào IDE chat)

```
@workspace deep dive into <MODULE_PATH>

Adopt persona Mary 📊 (Analyst). Đọc .prompts/personas/analyst.md trước.

Workflow: .prompts/workflows/deep-dive-learn.md (5 phases).

Bắt đầu Phase 1: Scope & Map cho module <MODULE_PATH>.

Sau Phase 1, đợi tôi confirm "OK Phase 1, next" trước khi sang Phase 2.

Save output vào memory-bank/features/<NAME>.md (tạo file nếu chưa có).
```
