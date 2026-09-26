# CLAUDE.md — Slotora Project Constitution

## Overview
Slotora is a **local-only**, logic-based Flutter appointment booking screen.
No API, no Backend, no remote data. All data lives in-memory.

---

## Hard Constraints (NEVER Violate)

1. **No UseCases layer** — Domain services handle logic directly.
2. **No Repositories** — Data is local/in-memory only; the `data/local/` layer provides initial seed data.
3. **No API / Backend** — Everything is local.
4. **Separation of Concerns** — ALL booking logic lives in `domain/services/`. The Cubit orchestrates, the UI renders. Zero business logic in widgets.
5. **State Management** — `flutter_bloc` (Cubit pattern). One `BookingCubit` + `BookingState`.
6. **Index-Based Time Model** — Slots use `int index` (0–17) mapped to 9:00 AM – 5:30 PM (18 × 30-min slots). Day ends at 6:00 PM.
7. **BookingDuration** — An enum holding `slotsCount`: `thirtyMin(1)`, `oneHour(2)`, `ninetyMin(3)`, `twoHours(4)`.
8. **X O X Gap Rule** — A booking MUST NOT leave exactly one `available` slot stranded between two non-available boundaries (booked/unavailable/day-edge). This is the core algorithmic constraint.

---

## Architecture (Feature-First)

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart        # Day start/end, slot duration, seed data
│   ├── theme/
│   │   └── app_theme.dart            # ThemeData, colors, text styles
│   └── localization/                  # (future-ready, empty for now)
├── features/
│   └── booking/
│       ├── data/
│       │   └── local/
│       │       └── booking_local_data.dart   # Seed: pre-booked & unavailable slots
│       ├── domain/
│       │   ├── models/
│       │   │   ├── time_slot.dart             # TimeSlot { index, status, label }
│       │   │   ├── slot_status.dart           # enum: available, booked, unavailable, selected
│       │   │   └── booking_duration.dart      # enum with slotsCount
│       │   └── services/
│       │       └── booking_validator.dart     # ALL validation logic (overlaps, gaps, XOX)
│       └── presentation/
│           ├── cubit/
│           │   ├── booking_cubit.dart         # Orchestrates state transitions
│           │   └── booking_state.dart         # Immutable state: slots, duration, error, history
│           ├── screens/
│           │   └── booking_screen.dart        # Main scaffold / screen
│           └── widgets/
│               ├── slot_grid.dart            # Grid/list of time slot tiles
│               ├── slot_tile.dart            # Individual slot chip/card
│               ├── duration_selector.dart    # Duration picker (radio/chips)
│               ├── booking_header.dart       # Stats: booked mins, available mins
│               └── booking_actions.dart      # Confirm, Undo, Reset buttons
└── main.dart

test/
├── booking_validator_test.dart               # Unit tests for gap/overlap/XOX logic
└── booking_cubit_test.dart                   # State transition tests
```

---

## Validation Rules (BookingValidator)

Given a list of `TimeSlot`s, a `startIndex`, and a `BookingDuration`:

1. **Range Check** — `startIndex + duration.slotsCount <= 18` (must not exceed 6 PM).
2. **Availability Check** — All slots in `[startIndex, startIndex + slotsCount)` must be `available`.
3. **Contiguity** — Implicitly guaranteed by the index range.
4. **X O X Gap Check** — After hypothetically placing the booking, scan the full slot array. If any single `available` slot is surrounded on BOTH sides by non-available boundaries (booked/unavailable/day-start/day-end), the booking is **rejected**.
5. **Return** — Either `BookingResult.success` or `BookingResult.failure(reason: String)` with a human-readable Arabic/English explanation.

---

## Pro Features

- **Undo Last Booking** — Cubit keeps a `List<List<TimeSlot>>` history stack.
- **Header Stats** — Total booked minutes vs. available minutes, calculated from slot statuses.
- **Smart Disabling** — When a duration is selected, start-time slots that can't possibly fit are pre-disabled (greyed out) before the user even taps.
- **Reset** — Restores slots to original seed data state.
- **Clear Error Messaging** — Every rejection shows *why* (e.g., "This would leave a 30-min gap at 11:00 that can't be used").

---

## Dependencies (pubspec.yaml)

- `flutter_bloc: ^8.1.5`
- `flutter_screenutil: ^5.9.0`
- `intl: ^0.19.0`
- `flutter_test` (dev)
- `flutter_lints` (dev)

No additional packages unless explicitly approved.
