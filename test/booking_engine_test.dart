import 'package:flutter_test/flutter_test.dart';
import 'package:slotora/features/booking/data/datasources/local_schedule_data_source.dart';
import 'package:slotora/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:slotora/features/booking/domain/entities/booking_duration.dart';
import 'package:slotora/features/booking/domain/entities/booking_validation_result.dart';
import 'package:slotora/features/booking/domain/entities/slot_status.dart';
import 'package:slotora/features/booking/domain/entities/time_slot_entity.dart';
import 'package:slotora/features/booking/domain/services/booking_calculator.dart';
import 'package:slotora/features/booking/domain/services/booking_validator.dart';
import 'package:slotora/features/booking/presentation/cubit/booking_cubit.dart';

void main() {
  group('Booking Engine Tests (Specification Scenarios)', () {
    late LocalScheduleDataSource dataSource;
    late BookingRepositoryImpl repository;
    late BookingCalculator calculator;
    late BookingValidator validator;
    late BookingCubit cubit;

    /// Reference base date used by [LocalScheduleDataSource] for slot DateTimes.
    final baseDate = DateTime(2026, 1, 1);

    DateTime slotTime(int hour, int minute) =>
        DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);

    setUp(() {
      dataSource = LocalScheduleDataSource();
      repository = BookingRepositoryImpl(dataSource: dataSource);
      calculator = const BookingCalculator();
      validator = BookingValidator(calculator: calculator);
      cubit = BookingCubit(
        repository: repository,
        calculator: calculator,
        validator: validator,
      );
    });

    tearDown(() => cubit.close());

    test('Test 1: 30-minute booking in an available slot is valid', () {
      final slots = repository.getSchedule();
      final start = slotTime(9, 0);

      final result = validator.validate(
        slots: slots,
        start: start,
        duration: const Duration(minutes: 30),
      );

      expect(result.isValid, isTrue);
      expect(result.status, BookingValidationStatus.valid);
    });

    test('Test 2: 1-hour booking where second slot is booked is invalid', () {
      // 10:00 is Available, 10:30 is Booked
      final slots = repository.getSchedule();
      final start = slotTime(10, 0);

      final result = validator.validate(
        slots: slots,
        start: start,
        duration: const Duration(minutes: 60),
      );

      expect(result.isValid, isFalse);
      expect(result.status, BookingValidationStatus.bookedSlot);
    });

    test('Test 3: 1.5-hour booking where one required slot is unavailable is invalid', () {
      // 11:00 Available, 11:30 Unavailable, 12:00 Available
      final slots = repository.getSchedule();
      final start = slotTime(11, 0);

      final result = validator.validate(
        slots: slots,
        start: start,
        duration: const Duration(minutes: 90),
      );

      expect(result.isValid, isFalse);
      expect(result.status, BookingValidationStatus.unavailableSlot);
    });

    test('Test 4: 2-hour booking that would end after 18:00 is invalid', () {
      // 17:00 + 2h = 19:00 > 18:00
      final slots = repository.getSchedule();
      final start = slotTime(17, 0);

      final result = validator.validate(
        slots: slots,
        start: start,
        duration: const Duration(minutes: 120),
      );

      expect(result.isValid, isFalse);
      expect(result.status, BookingValidationStatus.outsideWorkingHours);
    });

    test(
      'Test 5: Change duration from 30m to 2h triggers dynamic recalculation',
      () {
        // Start at 10:00 (10:00 is available, but 10:30 is booked)
        final start = slotTime(10, 0);

        cubit.selectStartTime(start);
        // At 30m, 10:00 alone is valid
        expect(cubit.state.selectedDuration, BookingDuration.minutes30);
        expect(cubit.state.isBookingValid, isTrue);

        // Now change duration to 2h — requires 4 slots (10:00, 10:30, 11:00, 11:30)
        // 10:30 is booked → must be invalid
        cubit.selectDuration(BookingDuration.minutes120);

        expect(cubit.state.selectedDuration, BookingDuration.minutes120);
        expect(cubit.state.isBookingValid, isFalse);
        expect(
          cubit.state.validationResult.status,
          BookingValidationStatus.bookedSlot,
        );
        expect(cubit.state.selectedSlots.length, 4);
      },
    );

    test('Test 6: Change start time triggers dynamic recalculation', () {
      final start1 = slotTime(14, 0);
      final start2 = slotTime(10, 0);

      cubit.selectDuration(BookingDuration.minutes60);

      cubit.selectStartTime(start1);
      // 14:00 + 14:30 are both available → valid
      expect(cubit.state.isBookingValid, isTrue);
      expect(cubit.state.calculatedEnd, DateTime(2026, 1, 1, 15, 0));

      cubit.selectStartTime(start2);
      // 10:00 + 10:30 → 10:30 is booked → invalid
      expect(cubit.state.isBookingValid, isFalse);
      expect(
        cubit.state.validationResult.status,
        BookingValidationStatus.bookedSlot,
      );
      expect(cubit.state.calculatedEnd, DateTime(2026, 1, 1, 11, 0));
    });

    test('Test 7: Booking that creates an isolated X O X gap is rejected', () {
      // 13:30 Booked | 14:00 Available | 14:30 Available | 15:00 Available | 16:00 Unavailable
      // Booking 14:30 for 1h (14:30+15:00) leaves 14:00 isolated between 13:30 (B) and 14:30 (B)
      final slots = repository.getSchedule();
      final start = slotTime(14, 30);

      final result = validator.validate(
        slots: slots,
        start: start,
        duration: const Duration(minutes: 60),
      );

      expect(result.isValid, isFalse);
      expect(result.status, BookingValidationStatus.isolatedGap);

      // Also 09:00 for 1h leaves 10:00 sandwiched between 09:30 and 10:30 (Booked)
      final start0900 = slotTime(9, 0);
      final result0900 = validator.validate(
        slots: slots,
        start: start0900,
        duration: const Duration(minutes: 60),
      );
      expect(result0900.isValid, isFalse);
      expect(result0900.status, BookingValidationStatus.isolatedGap);
    });

    test('Test 8: Valid booking confirmation updates schedule and valid start times', () {
      // 14:00 for 1 hour: 14:00 & 14:30 become booked
      final start = slotTime(14, 0);

      cubit.selectDuration(BookingDuration.minutes60);
      cubit.selectStartTime(start);
      expect(cubit.state.isBookingValid, isTrue);

      final booking = cubit.confirmBooking();
      expect(booking, isNotNull);
      expect(booking!.slotIds, ['14:00', '14:30']);

      // Check repository schedule reflects the booking
      final updatedSlots = repository.getSchedule();
      final slot1400 = updatedSlots.firstWhere((s) => s.id == '14:00');
      final slot1430 = updatedSlots.firstWhere((s) => s.id == '14:30');
      expect(slot1400.status, SlotStatus.booked);
      expect(slot1430.status, SlotStatus.booked);

      // Valid start times no longer include the booked start
      expect(cubit.state.validStartTimes.contains(start), isFalse);
    });

    test('Test 9: Reset restores default duration and clears selection without erasing schedule', () {
      // First confirm a booking at 09:00
      final start = slotTime(9, 0);
      cubit.selectDuration(BookingDuration.minutes30);
      cubit.selectStartTime(start);
      cubit.confirmBooking();

      // Now select something else
      final start2 = slotTime(12, 0);
      cubit.selectDuration(BookingDuration.minutes90);
      cubit.selectStartTime(start2);

      // Perform selection reset
      cubit.resetSelection();

      expect(cubit.state.selectedStart, isNull);
      expect(cubit.state.calculatedEnd, isNull);
      expect(cubit.state.selectedDuration, BookingDuration.minutes30);
      expect(cubit.state.selectedSlots, isEmpty);
      expect(cubit.state.validationResult, BookingValidationResult.noSelection);

      // Schedule still shows 09:00 as booked (schedule preserved across reset)
      final slot0900 = cubit.state.slots.firstWhere((s) => s.id == '09:00');
      expect(slot0900.status, SlotStatus.booked);
    });

    test(
      'Test 12: resetSchedule restores full baseline and clears selection',
      () {
        // Confirm a booking first
        cubit.selectDuration(BookingDuration.minutes30);
        cubit.selectStartTime(slotTime(9, 0));
        cubit.confirmBooking();

        // Verify 09:00 is now booked in state
        expect(
          cubit.state.slots.firstWhere((s) => s.id == '09:00').status,
          SlotStatus.booked,
        );

        // Full schedule reset
        cubit.resetSchedule();

        // 09:00 should be available again
        expect(
          cubit.state.slots.firstWhere((s) => s.id == '09:00').status,
          SlotStatus.available,
        );
        expect(cubit.state.selectedStart, isNull);
      },
    );

    test('Test 13: Selecting an already-selected slot deselects it', () {
      final start = slotTime(9, 0);
      cubit.selectStartTime(start);
      expect(cubit.state.selectedStart, equals(start));

      // Tap again — should deselect
      cubit.selectStartTime(start);
      expect(cubit.state.selectedStart, isNull);
      expect(cubit.state.selectedSlots, isEmpty);
    });

    test('Test 14: BookingCalculator slot count matches BookingDuration', () {
      expect(
        calculator.getRequiredSlotCount(BookingDuration.minutes30.duration),
        1,
      );
      expect(
        calculator.getRequiredSlotCount(BookingDuration.minutes60.duration),
        2,
      );
      expect(
        calculator.getRequiredSlotCount(BookingDuration.minutes90.duration),
        3,
      );
      expect(
        calculator.getRequiredSlotCount(BookingDuration.minutes120.duration),
        4,
      );
    });

    test('Test 15: Working hours boundary — 17:30 + 30m is valid, 17:30 + 60m is invalid', () {
      // 17:30 + 30m ends at 18:00 → valid
      expect(
        calculator.isWithinWorkingHours(
          slotTime(17, 30),
          const Duration(minutes: 30),
        ),
        isTrue,
      );
      // 17:30 + 60m ends at 18:30 → invalid
      expect(
        calculator.isWithinWorkingHours(
          slotTime(17, 30),
          const Duration(minutes: 60),
        ),
        isFalse,
      );
    });

    test('Test 16: noSelection validation result when no start chosen', () {
      // Cubit starts with no selection
      expect(cubit.state.selectedStart, isNull);
      expect(
        cubit.state.validationResult.status,
        BookingValidationStatus.noSelection,
      );

      // Attempt to confirm without selection → returns null
      final booking = cubit.confirmBooking();
      expect(booking, isNull);
    });

    group('Isolated gap algorithm (X O X)', () {
      TimeSlotEntity makeSlot(String id, int h, int m, SlotStatus status) {
        final base = DateTime(2026, 1, 1);
        final start = DateTime(base.year, base.month, base.day, h, m);
        final end = start.add(const Duration(minutes: 30));
        return TimeSlotEntity(
          id: id,
          startTime: start,
          endTime: end,
          status: status,
        );
      }

      test('Detects X O X isolation after simulated booking', () {
        // Use a proper target that would create isolation
        final slotsForTest = [
          makeSlot('09:00', 9, 0, SlotStatus.available),
          makeSlot('09:30', 9, 30, SlotStatus.available),
          makeSlot('10:00', 10, 0, SlotStatus.available),
          makeSlot('10:30', 10, 30, SlotStatus.booked),
        ];
        // Booking 09:00+09:30: after sim, 09:00→B, 09:30→B, 10:00→A, 10:30→B
        // i=2 (10:00): left=09:30(B), right=10:30(B) → newly isolated → rejected
        final result = validator.validate(
          slots: slotsForTest,
          start: slotTime(9, 0),
          duration: const Duration(minutes: 60),
        );
        expect(result.status, BookingValidationStatus.isolatedGap);
      });
    });
  });
}
