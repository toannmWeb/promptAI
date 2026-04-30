# Product Context

> Tại sao project tồn tại. UX/UI/business context.
> CẬP NHẬT: hiếm (khi pivot hoặc thêm major use case).

---

## Problem statement

> Vấn đề cụ thể project giải quyết.

<TODO — vd:
"Field workers ở công trường mất 30-45 phút/ngày để ghi log thủ công bằng giấy.
Quản lý không biết tình trạng real-time. Sau ngày làm việc, họ phải nhập lại
vào hệ thống cũ → duplicate effort + sai sót cao."

Cấu trúc:
- Ai gặp vấn đề: <user role>
- Vấn đề là gì: <pain point>
- Hậu quả nếu không giải quyết: <impact>>

## Why this solution

> Lý do chọn approach này thay vì cách khác.

<TODO — vd:
"Web app responsive thay vì native: 3 lý do
1. Đa platform (Android, iOS, desktop) với 1 codebase.
2. Update không cần app store approval.
3. Team có expertise web sẵn, không có native.">

## Target users

| Role | Goals | Pain points hiện tại |
|---|---|---|
| <TODO — User type 1> | <TODO> | <TODO> |
| <TODO — User type 2> | <TODO> | <TODO> |
| <TODO — User type 3> | <TODO> | <TODO> |

## User journeys (top 3)

> Flow chính từ user's perspective.

### Journey 1: <TODO — vd "Submit daily log">

1. User opens app → login.
2. <TODO — step 2>
3. <TODO — step 3>
4. User receives confirmation.

### Journey 2: <TODO>

<TODO>

### Journey 3: <TODO>

<TODO>

## UX goals

> Nguyên tắc UX project ưu tiên.

<TODO — vd:
- **Speed**: Top 3 actions (log entry, photo upload, view today's log) phải < 3 taps.
- **Offline-first**: Tất cả write actions queue khi offline, sync khi online.
- **Accessibility**: WCAG 2.1 AA. High contrast option.
- **Multilingual**: VI + JA (đặc thù 建築DX vì Nhật-Việt collaboration).>

## How it should NOT work

> Anti-features. Để AI không "auto-suggest" sai hướng.

<TODO — vd:
- KHÔNG có thông báo push (user complain spam).
- KHÔNG yêu cầu login lại trong session (UX cũ).
- KHÔNG hiển thị data của user khác (privacy).>

## Success indicators (UX-level)

<TODO — vd:
- < 3% drop-off rate ở step "Submit log".
- > 80% users hoàn thành onboarding trong 1 lần.
- NPS > 40.>

---

**Confidence**: <TODO>
**Last updated**: <YYYY-MM-DD>
