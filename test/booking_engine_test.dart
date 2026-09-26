import 'package:flutter_test/flutter_test.dart';
import 'package:slotora/core/constants/app_constants.dart';
import 'package:slotora/data/local/local_schedule_data_source.dart';
import 'package:slotora/data/models/booking_duration.dart';
import 'package:slotora/data/models/booking_validation_result.dart';
import 'package:slotora/data/models/time_slot.dart';
import 'package:slotora/data/repositories/booking_repository_impl.dart';
import 'package:slotora/domain/booking/booking_calculator.dart';
import 'package:slotora/domain/booking/booking_validator.dart';
import 'package:slotora/features/booking/presentation/view_models/booking_view_model.dart';

void main() {
  group('Booking Engine Tests (Specification Scenarios)', () {
    late LocalScheduleDataSource dataSource;
    late BookingRepositoryImpl repository;
    late BookingCalculator calculator;
    late BookingValidator validator;
    late BookingViewModel viewModel;

    setUp(() {
      dataSource = LocalScheduleDataSource();
      repository = BookingRepositoryImpl(dataSource: dataSource);
      calculator = const BookingCalculator();
      validator = BookingValidator(calculator: calculator);
      viewModel = BookingViewModel(
        repository: repository,
        calculator: calculator,
        validator: validator,
      );
    });

    test('Test 1: 30-minute booking in an available slot is valid', () {
      final slots = repository.getSchedule();
      final start = DateTime(
        AppConstants.baseDate.year,
        AppConstants.baseDate.month,
        AppConstants.baseDate.day,
        9,
        0,
      );

      final result = validator.validate(
        slots: slots,
        start: start,
        duration: const Duration(minutes: 30),
      );

      expect(result.isValid, isTrue);
      expect(result.status, BookingValidationStatus.valid);
    });

    test('Test 2: 1-hour booking where second slot is booked is invalid', () {
      // In deterministic mock data: 10:00 is Available, 10:30 is Booked.
      final slots = repository.getSchedule();
      final start = DateTime(
        AppConstants.baseDate.year,
        AppConstants.baseDate.month,
        AppConstants.baseDate.day,
        10,
        0,
      );

      final result = validator.validate(
        slots: slots,
        start: start,
        duration: const Duration(minutes: 60),
      );

      expect(result.isValid, isFalse);
      expect(result.status, BookingValidationStatus.bookedSlot);
    });

    test('Test 3: 1.5-hour booking where one required slot is unavailable is invalid', () {
      // In deterministic mock data: 11:00 is Available, 11:30 is Unavailable, 12:00 is Available.
      final slots = repository.getSchedule();
      final start = DateTime(
        AppConstants.baseDate.year,
        AppConstants.baseDate.month,
        AppConstants.baseDate.day,
        11,
        0,
      );

      final result = validator.validate(
        slots: slots,
        start: start,
        duration: const Duration(minutes: 90),
      );

      expect(result.isValid, isFalse);
      expect(result.status, BookingValidationStatus.unavailableSlot);
    });

    test('Test 4: 2-hour booking that would end after 18:00 is invalid', () {
      final slots = repository.getSchedule();
      // 17:00 with 2-hour duration ends at 19:00 (> 18:00)
      final start = DateTime(
        AppConstants.baseDate.year,
        AppConstants.baseDate.month,
        AppConstants.baseDate.day,
        17,
        0,
      );

      final result = validator.validate(
        slots: slots,
        start: start,
        duration: const Duration(minutes: 120),
      );

      expect(result.isValid, isFalse);
      expect(result.status, BookingValidationStatus.outsideWorkingHours);
    });

    test('Test 5: Change duration from 30m to 2h triggers dynamic recalculation', () {
      // Start at 10:00 (10:00 is available, but 10:30 is booked)
      final start = DateTime(
        AppConstants.baseDate.year,
        AppConstants.baseDate.month,
        AppConstants.baseDate.day,
        10,
        0,
      );

      viewModel.selectStartTime(start);
      // At 30m, 10:00 alone is available and valid
      expect(viewModel.state.selectedDuration, BookingDuration.minutes30);
      expect(viewModel.state.isBookingValid, isTrue);

      // Now change duration to 2h
      viewModel.selectDuration(BookingDuration.minutes120);

      // State is immediately recalculated: requires 4 slots (10:00, 10:30, 11:00, 11:30)
      // 10:30 is booked, so it must be invalid
      expect(viewModel.state.selectedDuration, BookingDuration.minutes120);
      expect(viewModel.state.isBookingValid, isFalse);
      expect(viewModel.state.validationResult.status, BookingValidationStatus.bookedSlot);
      expect(viewModel.state.selectedSlots.length, 4);
    });

    test('Test 6: Change start time triggers dynamic recalculation', () {
      final start1 = DateTime(
        AppConstants.baseDate.year,
        AppConstants.baseDate.month,
        AppConstants.baseDate.day,
        14,
        0,
      );
      final start2 = DateTime(
        AppConstants.baseDate.year,
        AppConstants.baseDate.month,
        AppConstants.baseDate.day,
        10,
        0,
      );

      viewModel.selectDuration(BookingDuration.minutes60); // 1 hour

      viewModel.selectStartTime(start1);
      // 14:00 + 14:30 are both available and don't create an isolated gap -> valid
      expect(viewModel.state.isBookingValid, isTrue);
      expect(viewModel.state.calculatedEnd, DateTime(2026, 1, 1, 15, 0));

      viewModel.selectStartTime(start2);
      // 10:00 + 10:30 -> 10:30 is booked -> invalid
      expect(viewModel.state.isBookingValid, isFalse);
      expect(viewModel.state.validationResult.status, BookingValidationStatus.bookedSlot);
      expect(viewModel.state.calculatedEnd, DateTime(2026, 1, 1, 11, 0));
    });

    test('Test 7: Booking that creates an isolated X O X gap is rejected', () {
      // In deterministic mock data:
      // 13:00 Booked
      // 13:30 Booked
      // 14:00 Available
      // 14:30 Available
      // 15:00 Available
      // 15:30 Available
      // 16:00 Unavailable
      // If someone books 14:30 for 1 hour (14:30 and 15:00):
      // Then 14:00 has 13:30 (Booked) on left and 14:30 (Booked) on right -> isolated X O X!
      final slots = repository.getSchedule();
      final start = DateTime(
        AppConstants.baseDate.year,
        AppConstants.baseDate.month,
        AppConstants.baseDate.day,
        14,
        30,
      );

      final result = validator.validate(
        slots: slots,
        start: start,
        duration: const Duration(minutes: 60),
      );

      expect(result.isValid, isFalse);
      expect(result.status, BookingValidationStatus.isolatedGap);

      // Also 09:00 for 1 hour leaves 10:00 sandwiched between 09:30 and 10:30 (Booked)
      final start0900 = DateTime(
        AppConstants.baseDate.year,
        AppConstants.baseDate.month,
        AppConstants.baseDate.day,
        9,
        0,
      );
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
      final start = DateTime(
        AppConstants.baseDate.year,
        AppConstants.baseDate.month,
        AppConstants.baseDate.day,
        14,
        0,
      );

      viewModel.selectDuration(BookingDuration.minutes60);
      viewModel.selectStartTime(start);
      expect(viewModel.state.isBookingValid, isTrue);

      final booking = viewModel.confirmBooking();
      expect(booking, isNotNull);
      expect(booking!.slotIds, ['14:00', '14:30']);

      // Check repository schedule
      final updatedSlots = repository.getSchedule();
      final slot1400 = updatedSlots.firstWhere((s) => s.id == '14:00');
      final slot1430 = updatedSlots.firstWhere((s) => s.id == '14:30');
      expect(slot1400.status, SlotStatus.booked);
      expect(slot1430.status, SlotStatus.booked);

      // Check valid start times in viewModel
      expect(viewModel.state.validStartTimes.contains(start), isFalse);
    });

    test('Test 9: Reset restores default duration and clears selection without erasing schedule', () {
      // First, confirm a booking at 09:00
      final start = DateTime(
        AppConstants.baseDate.year,
        AppConstants.baseDate.month,
        AppConstants.baseDate.day,
        9,
        0,
      );
      viewModel.selectDuration(BookingDuration.minutes30);
      viewModel.selectStartTime(start);
      viewModel.confirmBooking();

      // Now select something else
      final start2 = DateTime(
        AppConstants.baseDate.year,
        AppConstants.baseDate.month,
        AppConstants.baseDate.day,
        12,
        0,
      );
      viewModel.selectDuration(BookingDuration.minutes90);
      viewModel.selectStartTime(start2);

      // Perform reset
      viewModel.resetSelection();

      expect(viewModel.state.selectedStart, isNull);
      expect(viewModel.state.calculatedEnd, isNull);
      expect(viewModel.state.selectedDuration, BookingDuration.minutes30);
      expect(viewModel.state.selectedSlots, isEmpty);
      expect(viewModel.state.validationResult, BookingValidationResult.noSelection);

      // Schedule still has 09:00 as booked (schedule was preserved)
      final slot0900 = viewModel.state.slots.firstWhere((s) => s.id == '09:00');
      expect(slot0900.status, SlotStatus.booked);
    });
  });
}
