# Integrations

> Optional folder. Tạo khi project có tích hợp external service.

---

## Khi nào tạo `integrations/<name>.md`

- Auth providers (Auth0, Firebase Auth, OAuth, ...).
- Payment (Stripe, PayPal, ...).
- Analytics (GA, Mixpanel, Amplitude, ...).
- Storage (S3, GCS, Firebase Storage, ...).
- Communication (Twilio, SendGrid, ...).
- Maps (Google Maps, Mapbox, ...).
- Internal APIs (separate service team).

## Cấu trúc

Copy từ `_template.md`. File chứa:

1. **Service name + URL**.
2. **Why this integration** (lý do chọn).
3. **Auth method** (API key, OAuth, etc.).
4. **Endpoints used** (chỉ những endpoint project gọi).
5. **Rate limits**.
6. **Fallback strategy** (khi service down).
7. **Cost** (free tier limits, pricing).
8. **Account info** (sandbox/prod, contact).
9. **Code references** (file:line where integration lives).

## Tên file

Format: `<service-name>.md` (kebab-case).

Vd:
- `firebase-auth.md`
- `stripe-payments.md`
- `sentry-monitoring.md`
- `internal-api-v2.md`
