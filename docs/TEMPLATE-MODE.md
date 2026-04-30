# TEMPLATE-MODE.md — Master Template Rules

> File này định nghĩa mode vận hành của repo gốc này: **master template cá nhân** cho nhiều dự án tương lai, không phải memory-bank của một dự án app cụ thể.

---

## 1. Hai mode bắt buộc phân biệt

| Mode | Dùng ở đâu | Memory-bank | Validation |
|---|---|---|---|
| **Template Mode** | Repo gốc `prompt-system-skeleton-*` | Giữ placeholder `<TODO>` có chủ đích | `./scripts/check-template.sh` và `./scripts/check-memory-bank.sh --allow-template` |
| **Applied Project Mode** | Sau khi copy skeleton vào project thật | Fill bằng facts của project thật | `./scripts/check-memory-bank.sh` |

## 2. Template Mode là gì

Repo này là **bộ prompt system dùng chung**:

- `.prompts/` chứa system prompt, personas, workflows, tasks, snippets.
- `memory-bank/` chứa template để dự án thật fill sau.
- `ROADMAP.md` chứa structure mẫu + command map.
- `scripts/` chứa validation/tooling dùng lại được.
- `docs/` chứa checklist và hướng dẫn universal.

Trong Template Mode, AI **không được**:

- Fill `memory-bank/projectBrief.md` bằng một dự án giả.
- Biến skeleton thành ASBLOG/CRM/dashboard hoặc bất kỳ app cụ thể nào.
- Xóa `<TODO>` trong memory-bank chỉ để làm validation xanh.
- Viết facts project-specific trừ khi đó là ví dụ template rõ ràng.

AI **được phép**:

- Nâng cấp prompt framework.
- Thêm workflow/task/snippet/persona universal.
- Sửa script validation.
- Sửa docs để skeleton dễ áp dụng cho mọi project.
- Thêm ví dụ placeholder nếu ví dụ đó clearly marked as example.

## 3. Applied Project Mode là gì

Sau khi copy skeleton sang project thật:

1. Chạy workflow `apply skeleton to project`.
2. Chạy `initialize memory bank`.
3. Fill 6 core memory-bank bằng facts từ codebase thật.
4. Customize `docs/CHANGE-IMPACT.md` theo cấu trúc project.
5. Chạy `./scripts/check-memory-bank.sh` cho tới khi pass.

Khi đó `<TODO>` trong core memory-bank là lỗi thật, không còn được phép giữ.

## 4. Rule cho AI trong repo master này

Trước khi sửa file, AI phải hỏi nội bộ:

1. Thay đổi này có universal cho mọi project không?
2. Có làm mất placeholder cần thiết khi copy sang project thật không?
3. Có đưa facts của một app cụ thể vào skeleton không?
4. Có cập nhật command map, README, ROADMAP, validation nếu thêm workflow/task/script không?
5. Có chạy `./scripts/check-template.sh` sau khi sửa không?

Nếu câu trả lời cho 1 là "không" hoặc 3 là "có" → dừng, hỏi user.

## 5. Commands chuẩn

```bash
# Kiểm tra master template
./scripts/check-template.sh

# Kiểm tra memory-bank trong template mode
./scripts/check-memory-bank.sh --allow-template

# Kiểm tra memory-bank sau khi áp dụng vào project thật
./scripts/check-memory-bank.sh
```

---

**Template status**: master-template
**Last updated**: 2026-04-29
