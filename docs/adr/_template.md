# ADR-<NNNN>: <TITLE>

> **Status**: Proposed / Accepted / Deprecated / Superseded by ADR-XXXX
> **Date**: <YYYY-MM-DD>
> **Deciders**: <names>
> **Tags**: <tag1, tag2>

---

## Context

> Vấn đề / driving force / business need khiến cần decision này.

<TODO — 2-4 đoạn:
- Background: tình hình trước decision.
- Pain point: vì sao status quo không OK.
- Constraints: technical / business / team forcing the decision.>

## Decision

> Một câu rõ: chúng ta quyết gì.

<TODO — vd "We will use flutter_bloc for state management.">

## Consequences

### Positive

<TODO — vd:
- Tách UI khỏi business logic, dễ test.
- Pattern phổ biến, tài liệu phong phú.
- TypeScript-like type safety with sealed events/states.>

### Negative

<TODO — vd:
- Boilerplate cao hơn Provider.
- Learning curve cho dev mới.
- Có thể overkill cho UI state đơn giản.>

### Neutral

<TODO — vd:
- Thêm dependency `flutter_bloc: ^8.1.0`.
- Phải refactor 5 existing screens.>

## Alternatives considered

> Bắt buộc liệt kê ≥ 1 alternative + lý do reject.

### Alternative 1: <NAME>

- Pros: <TODO>
- Cons: <TODO>
- Why rejected: <TODO>

### Alternative 2: <NAME>

- Pros: <TODO>
- Cons: <TODO>
- Why rejected: <TODO>

## Implementation

> Cụ thể làm gì.

<TODO — vd:
1. Add `flutter_bloc` to `pubspec.yaml`.
2. Create base BLoC pattern in `lib/core/blocs/`.
3. Migrate `LoginScreen` to BLoC (proof of concept).
4. Document pattern in `examples/bloc-pattern.md`.
5. Migrate remaining screens incrementally.>

## Verification

> Cách verify decision implemented đúng.

<TODO — vd:
- All screens use BLoC by Q3 2026.
- Test coverage on BLoC > 80%.
- No `setState` in screens (lint rule).>

## References

- <TODO — link to similar ADR in industry, blog post, official docs>

## Updates / superseded notes

<TODO — chỉ điền khi status thay đổi:
- 2026-09-01: Decision validated, all screens migrated.
- 2027-01-15: Superseded by ADR-0010 (switch to Riverpod).>
