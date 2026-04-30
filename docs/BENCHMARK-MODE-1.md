# BENCHMARK-MODE-1.md — One-Shot Max Quality Benchmark

> Mục đích: đo Mode 1 bằng rubric rõ ràng thay vì chỉ cảm giác "prompt mạnh". File này dùng cho master template và mọi project thật sau khi apply skeleton.

---

## 1. Khi nào chạy benchmark

Chạy benchmark khi:

- Sửa `.prompts/system/base.md`.
- Sửa `.prompts/workflows/mode-1-one-shot-max.md`.
- Sửa `.prompts/snippets/one-shot-max.md` hoặc `max-context.md`.
- Sửa personas ảnh hưởng Mode 1.
- Trước khi coi template là release-ready.

## 2. Bộ prompt mẫu

| ID | Scenario | File | Mục tiêu đo |
|---|---|---|---|
| M1-DEBUG | Debug bug khó | `docs/benchmarks/mode-1/debug-loop.md` | Hypothesis quality, evidence, verification |
| M1-FEATURE | Plan feature mới | `docs/benchmarks/mode-1/feature-plan.md` | Requirement clarity, AC, trade-off |
| M1-REVIEW | Review output/spec | `docs/benchmarks/mode-1/review-output.md` | Risk finding, concision, fix quality |
| M1-APPLY | Apply skeleton | `docs/benchmarks/mode-1/apply-skeleton.md` | Template Mode safety, merge plan |
| M1-REFLECT | Self-audit template | `docs/benchmarks/mode-1/audit-template.md` | Honest self-critique, command map consistency |

## 3. Scoring rubric

Chấm mỗi output Mode 1 theo thang 100:

| Category | Points | Pass criteria |
|---|---:|---|
| Context discipline | 15 | Đọc đúng ROADMAP/base/request mode/memory-bank liên quan; không đọc lan man. |
| Task contract quality | 15 | Goal, scope, AC, output, halt rõ; assumptions explicit. |
| Evidence accuracy | 15 | Claim về code/docs có `file:line`; không hallucinate. |
| Multi-lens synthesis | 15 | Mary/Winston/Amelia/Casey/Quinn được dùng cô đọng, không role-play dài. |
| Output density | 15 | Nhiều giá trị trong ít chữ; không filler; có cấu trúc dễ dùng. |
| Verification strength | 15 | Có commands + expected result; nói rõ đã chạy/chưa chạy. |
| Decision quality | 10 | Decision points đúng chỗ; không đẩy quyết định vô ích cho user. |

## 4. Verdict

| Score | Verdict | Meaning |
|---:|---|---|
| 95-100 | 10/10 candidate | Có thể coi là gần tối đa thực dụng. |
| 90-94 | Excellent | Dùng production được, còn vài điểm tinh chỉnh. |
| 80-89 | Strong | Mạnh nhưng chưa đủ để gọi 10/10. |
| 70-79 | Needs work | Có gap rõ về context/evidence/output. |
| <70 | Fail | Không đạt Mode 1. |

## 5. Benchmark protocol

1. Chọn một prompt mẫu trong `docs/benchmarks/mode-1/`.
2. Gửi vào AI với prefix `mode 1:`.
3. Chấm output theo rubric ở section 3.
4. Ghi kết quả vào bảng dưới.
5. Nếu category nào < 12/15 hoặc decision quality < 8/10, tạo improvement task.

## 6. Results log

| Date | Model/tool | Prompt ID | Score | Verdict | Notes |
|---|---|---|---:|---|---|
| `<YYYY-MM-DD>` | `<Copilot/Codex/Cursor/...>` | `<M1-...>` | `<0-100>` | `<verdict>` | `<notes>` |

## 7. 10/10 gate

Chỉ gọi hệ thống đạt **10/10 thực dụng** khi:

- `./scripts/check-all.sh` pass.
- Ít nhất 5 benchmark prompts được chạy.
- Điểm trung bình >= 95.
- Không prompt nào dưới 90.
- Không có hallucination hoặc unsafe action trong bất kỳ benchmark nào.

---

**Template status**: benchmark-template
**Last updated**: 2026-04-30
