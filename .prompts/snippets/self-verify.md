---
name: snippet-self-verify
purpose: Ép AI tự kiểm output (self-check) TRƯỚC khi gửi cho user, theo checklist deterministic
usage: paste vào cuối mọi workflow / task; bắt buộc khi output là code, ADR, PRP, plan, hoặc bulk edit
version: 1.0
last-updated: 2026-04-30
---

# Snippet: Self-Verification Step

```
SELF-VERIFY TRƯỚC KHI TRẢ.

Trước khi xuất output cuối cho user, AI phải tự đi qua checklist sau và sửa output cho tới khi pass HẾT các check áp dụng. Nếu có check fail không sửa được, AI phải nêu rõ trong phần `Self-verify` thay vì giấu.

## Checklist (deterministic, không skip)

### A. Anti-hallucination
- [ ] Mọi claim về code/file/API/section đều có cite `file:line` hoặc đã đọc file đó trong phiên này.
- [ ] Không có file/function/identifier không tồn tại; nếu nghi ngờ, đã viết "không thấy trong codebase loaded" thay vì đoán.
- [ ] Quote ngắn từ file thật được copy đúng nguyên văn (không paraphrase rồi gắn dấu nháy).

### B. Scope lock
- [ ] Mọi file đã / sẽ sửa nằm trong `Scope: edit allowed` đã khai báo.
- [ ] Không sửa file ngoài scope; nếu phát hiện cần, đã DỪNG và nêu trong Decision points.

### C. Evidence → inference → decision
- [ ] Mỗi recommendation/decision có evidence link rõ.
- [ ] Inference được đánh dấu rõ "infer", không trộn với fact.
- [ ] Guess (nếu có) được đẩy vào Assumptions hoặc Decision points, không xuất hiện như fact.

### D. Acceptance criteria
- [ ] AC trong Task Contract testable; mỗi AC có cách verify cụ thể.
- [ ] Output đã cover từng AC; AC nào chưa cover được nêu rõ.

### E. Verification
- [ ] Có verification commands cụ thể với expected result.
- [ ] Phân biệt rõ "đã chạy" vs "đề xuất user chạy".
- [ ] Nếu không chạy được trong môi trường, đã nêu lý do.

### F. Safety
- [ ] Nếu sửa > 3 file hoặc destructive, đã có Dry-Run + Confirmation Gate.
- [ ] Nếu reversibility low, đã có Rollback plan với backup path.
- [ ] Không có lệnh nguy hiểm (force push, drop, rm -rf, reset --hard) chạy ngầm.

### G. Decision hygiene
- [ ] Decision points list explicit, có recommended default.
- [ ] User có thể trả lời 1 dòng (`OK`, `D-1=A`, `STOP`).
- [ ] Không tự decide thay user ở các điểm không reversible.

### H. Output format
- [ ] Có Confidence (low/medium/high).
- [ ] Có Assumptions nếu có giả định.
- [ ] Có Files touched nếu sửa code.
- [ ] Có Memory-bank impact nếu áp dụng.
- [ ] Tiếng Việt có dấu đầy đủ; code/path/identifier giữ nguyên cú pháp.

### I. Comprehensive single-response
- [ ] Output trả lời được câu hỏi trong 1 response, không yêu cầu user "hỏi thêm để tôi tiếp" trừ khi halt.
- [ ] Không lộ chain-of-thought nội bộ; chỉ xuất reasoning summary.

## Output block

Cuối câu trả lời, thêm dòng ngắn:

```text
**Self-verify**: <N>/9 nhóm pass. Nhóm fail: <list hoặc "none">.
```

Nếu có nhóm fail, kèm 1 dòng giải thích lý do và đề xuất follow-up.
```
