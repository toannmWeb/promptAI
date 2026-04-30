# CHANGE-IMPACT.md — Lookup table

> **Mục đích**: Khi sửa code path X → biết file nào trong `memory-bank/` (và artifacts khác) phải update.
>
> **Dùng bởi**: `scripts/check-impact.sh` (parse table này) + workflow `update memory bank` (AI lookup).

---

## Cách dùng

### Bằng tay
1. Sau khi commit code, list file đã sửa.
2. Tra bảng dưới → biết file memory-bank nào cần touch.
3. Update từng file → cite code change.
4. Run `./scripts/check-memory-bank.sh` để verify consistency.

### Tự động
```bash
./scripts/check-impact.sh lib/data/services/user_service.dart
# → output: "Update: techContext.md, integrations/firebase.md"

./scripts/check-impact.sh --git HEAD~1
# → tự lấy danh sách file thay đổi từ git diff HEAD~1..HEAD
```

---

## Cấu trúc bảng

Bảng có 2 cột:
- **Pattern**: bash glob khớp file path (vd: `lib/data/services/*.dart`).
- **Memory-bank impact**: comma-separated list memory-bank file/folder bị affect.

Pattern dùng glob syntax bash:
- `*` — match bất kỳ ký tự (trừ `/`).
- `**` — recursive (khi `globstar` enabled).
- `?` — 1 ký tự.
- `[abc]` — character class.

> ⚠️ Bảng này **PER-PROJECT**. Mỗi project sẽ có pattern khác nhau (Flutter, FastAPI, Next.js có structure khác). Skeleton này có ví dụ template — bạn customize theo project.

---

## Lookup table (template — tuỳ chỉnh per project)

| Pattern | Memory-bank impact |
|---|---|
| `**/README.md` | `projectBrief.md`, `productContext.md` |
| `package.json` | `techContext.md`, `progress.md` |
| `pyproject.toml` | `techContext.md` |
| `pubspec.yaml` | `techContext.md` |
| `go.mod` | `techContext.md` |
| `Cargo.toml` | `techContext.md` |
| `Dockerfile` | `techContext.md`, `runbooks/local-dev.md` |
| `docker-compose.yml` | `techContext.md`, `runbooks/local-dev.md` |
| `.github/workflows/*.yml` | `techContext.md`, `runbooks/deploy.md` |
| `lib/data/services/*` | `techContext.md`, `integrations/*.md` |
| `lib/data/repositories/*` | `systemPatterns.md`, `features/*.md` |
| `lib/presentation/blocs/*` | `systemPatterns.md`, `activeContext.md`, `features/*.md` |
| `lib/presentation/screens/*` | `features/*.md`, `activeContext.md` |
| `lib/domain/usecases/*` | `systemPatterns.md`, `features/*.md` |
| `lib/domain/entities/*` | `domains/*.md`, `glossary.md` |
| `lib/core/*` | `systemPatterns.md`, `techContext.md` |
| `src/api/**/*` | `systemPatterns.md`, `integrations/*.md` |
| `src/components/**/*` | `features/*.md` |
| `src/pages/**/*` | `features/*.md` |
| `src/store/**/*` | `systemPatterns.md` |
| `migrations/*` | `domains/*.md`, `progress.md` |
| `prisma/schema.prisma` | `domains/*.md`, `systemPatterns.md` |
| `docs/adr/*` | `systemPatterns.md` (link new ADR) |
| `PRPs/*` | `progress.md`, `activeContext.md` |
| `.env.example` | `techContext.md`, `runbooks/local-dev.md` |
| `examples/*` | `systemPatterns.md` (link example) |

---

## Đặc biệt: pattern không match nào

Nếu file đã sửa không match pattern nào trong bảng:
1. AI vẫn phải update `activeContext.md` + `progress.md` (luôn áp dụng).
2. Suggest user thêm pattern mới vào bảng (nếu file thuộc category chưa cover).

---

## Ví dụ cụ thể (Flutter project)

Khi user sửa `lib/presentation/blocs/auth_bloc.dart`:

```bash
$ ./scripts/check-impact.sh lib/presentation/blocs/auth_bloc.dart
Inspecting path: lib/presentation/blocs/auth_bloc.dart

## Affected memory-bank files (by pattern match)

→ Update: systemPatterns.md, activeContext.md, features/*.md
  Triggered by:
    - lib/presentation/blocs/auth_bloc.dart

## Suggested next step
Run: 'update memory bank' workflow with this list.
→ See: .prompts/workflows/update-memory-bank.md
```

User sau đó:
1. Đọc `memory-bank/systemPatterns.md` → cần update section "BLoC pattern" nếu auth có nuance mới.
2. Đọc `memory-bank/activeContext.md` → log change.
3. Đọc `memory-bank/features/auth.md` → update implementation detail.
4. Run `./scripts/check-memory-bank.sh` để verify.

---

## Maintenance

- **Khi nào update bảng này**: 
  - Thêm folder/file pattern mới (vd thêm folder `lib/presentation/widgets/`).
  - Đổi convention naming (vd đổi `services/` → `gateways/`).
  - Thêm memory-bank folder mới (vd thêm `memory-bank/risks/`).

- **Cách update**:
  - Edit bảng trên (Markdown table).
  - Test với `./scripts/check-impact.sh <example-path>` để confirm parse đúng.
  - Commit với message: `docs: update CHANGE-IMPACT.md add <pattern>`.

---

## Anti-patterns

- ❌ Pattern quá generic (`*` match tất cả) → mọi change trigger mọi mb file → noise.
- ❌ Pattern quá specific (`lib/data/services/user_service.dart`) → maintain hell.
- ❌ Quên cập nhật bảng khi đổi structure → check-impact.sh ra kết quả sai.
- ❌ Hardcode tên feature cụ thể (vd `features/auth.md`) — dùng glob `features/*.md` thay.
