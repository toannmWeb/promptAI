# REQUEST-MODES.md — AI Request Modes

> Mục đích: chọn chế độ làm việc theo chi phí request, độ rủi ro và mức cần chính xác.

---

## Mode 1 — One-Shot Max

**Dùng khi**: user tính theo request và muốn AI làm xuất sắc nhất trong một lần hỏi.

Priority:

1. An toàn và chính xác.
2. Verification và evidence.
3. Tối đa hóa giá trị trong 1 request.
4. Tiết kiệm token.

Nếu các mục này xung đột, mục trên thắng mục dưới. Không đánh đổi an toàn/chính xác để lấy hiệu năng, tốc độ hoặc tiết kiệm request.

Trigger:

- `mode 1: <task>`
- `one-shot max: <task>`
- `tận dụng tối đa 1 request: <task>`
- `làm hết trong 1 lần hỏi: <task>`

AI phải:

1. Chạy risk preflight trước khi execute: instruction conflict, global/tool conflict, memory-bank freshness, destructive/security/data risk, prompt injection, scope/context overflow, verification feasibility.
2. Load context nhiều nhất có ích, không đọc lan man.
3. Chạy nhiều lens trong một response:
   - Mary: yêu cầu, scope, missing context.
   - Winston: architecture, trade-off, reversibility.
   - Amelia: implementation path, AC, tests.
   - Casey: risk, edge cases, failure modes.
   - Quinn: prompt/task validity, completeness.
4. Nén kết quả thành output cô đọng, có thể hành động ngay.
5. Cite `file:line` cho claim về code/docs thật.
6. Có verification commands + expected result.
7. Có decision points rõ; nếu không cần decision thì ghi `none`.

AI không được:

- Lộ chain-of-thought nội bộ.
- Trả dài vì dài; ưu tiên mật độ thông tin.
- Bắt user hỏi tiếp chỉ vì output chưa được tổ chức tốt.
- Bắt đầu nếu task quá lớn hoặc rủi ro mà cần user chọn trước.
- Hy sinh safety để "làm hết trong 1 request".

Nếu bắt buộc cần input, AI phải dùng **Confirmation Gate**:

- Gom mọi câu hỏi vào 1 block.
- Có recommended default.
- Cho phép user trả lời `OK` hoặc `D-1=A D-2=N`.
- Không hỏi rải rác nhiều lượt.

## Mode 2 — Standard

**Dùng khi**: task bình thường, scope rõ, rủi ro thấp.

AI làm theo `.prompts/system/base.md`: bootstrap, task contract, execute, verify, report.

## Mode 3 — Interactive / Decision-Gated

**Dùng khi**:

- Task có kiến trúc lớn.
- Risk cao: data, security, migration, destructive ops.
- Requirements conflict.
- User cần chọn trade-off trước khi code.

AI phải dừng ở decision points thay vì tự làm hết.

Khi dừng, dùng `.prompts/snippets/confirmation-gate.md` để tối ưu số request trong IDE chat.

## Default policy

- Nếu user nói `mode 1` hoặc tương đương → dùng Mode 1.
- Nếu user không nói mode → dùng Mode 2.
- Nếu risky/halt condition xuất hiện → chuyển sang Mode 3 dù user yêu cầu Mode 1.
- Nếu Mode 1 bị chặn bởi risk, output tốt nhất là Confirmation Gate hoặc plan ưu tiên trong một response, không phải cố sửa nửa vời.
- Request economy luôn đứng sau safety, accuracy, evidence và verification.

## Quality benchmark

Mode 1 không được gọi là "10/10" chỉ vì prompt dài hoặc nghe mạnh. Muốn đánh giá chất lượng:

- Dùng rubric trong `docs/BENCHMARK-MODE-1.md`.
- Chạy prompt mẫu trong `docs/benchmarks/mode-1/`.
- Chỉ coi Mode 1 đạt 10/10 thực dụng khi score trung bình >= 95 và không prompt nào dưới 90.

---

**Last updated**: 2026-04-30
