import 'package:flutter_test/flutter_test.dart';
import 'package:slotora/features/booking/domain/models/booking_duration.dart';
import 'package:slotora/features/booking/domain/models/slot_status.dart';
import 'package:slotora/features/booking/domain/models/time_slot.dart';
import 'package:slotora/features/booking/domain/services/booking_result.dart';
import 'package:slotora/features/booking/domain/services/booking_validator.dart';

void main() {
  List<TimeSlot> generateAvailableSlots() {
    return List.generate(
      18,
      (index) => TimeSlot(index: index, status: SlotStatus.available),
    );
  }

  group('BookingValidator', () {
    test('1. valid 30-minute booking', () {
      final slots = generateAvailableSlots();
      final result = BookingValidator.validate(
        slots: slots,
        startIndex: 0,
        duration: BookingDuration.thirtyMin,
      );
      expect(result, isA<BookingSuccess>());
    });

    test('2. rejects booked slot', () {
      final slots = generateAvailableSlots();
      slots[2] = slots[2].copyWith(status: SlotStatus.booked);
      
      final result = BookingValidator.validate(
        slots: slots,
        startIndex: 1,
        duration: BookingDuration.oneHour,
      );
      expect(result, isA<BookingFailure>());
    });

    test('3. rejects unavailable slot', () {
      final slots = generateAvailableSlots();
      slots[5] = slots[5].copyWith(status: SlotStatus.unavailable);
      
      final result = BookingValidator.validate(
        slots: slots,
        startIndex: 4,
        duration: BookingDuration.oneHour,
      );
      expect(result, isA<BookingFailure>());
    });

    test('4. rejects duration beyond 6 PM', () {
      final slots = generateAvailableSlots();
      
      final result = BookingValidator.validate(
        slots: slots,
        startIndex: 17,
        duration: BookingDuration.oneHour,
      );
      expect(result, isA<BookingFailure>());
    });

    test('5. rejects non-consecutive availability (overlap)', () {
      final slots = generateAvailableSlots();
      slots[1] = slots[1].copyWith(status: SlotStatus.booked);
      
      final result = BookingValidator.validate(
        slots: slots,
        startIndex: 0,
        duration: BookingDuration.oneHour,
      );
      expect(result, isA<BookingFailure>());
    });

    test('6. rejects overlap', () {
      final slots = generateAvailableSlots();
      slots[3] = slots[3].copyWith(status: SlotStatus.booked);
      
      final result = BookingValidator.validate(
        slots: slots,
        startIndex: 2,
        duration: BookingDuration.oneHour,
      );
      expect(result, isA<BookingFailure>());
    });

    test('7. rejects X O X (isolated gap)', () {
      final slots = generateAvailableSlots();
      slots[0] = slots[0].copyWith(status: SlotStatus.booked);
      slots[4] = slots[4].copyWith(status: SlotStatus.booked);
      
      // We want to book slots 1 and 2, which leaves slot 3 as an O between 2 (booked) and 4 (booked).
      final result = BookingValidator.validate(
        slots: slots,
        startIndex: 1,
        duration: BookingDuration.oneHour,
      );
      expect(result, isA<BookingFailure>());
      expect((result as BookingFailure).reason, contains('isolated'));
    });

    test('8. edge case: O X at the end is valid (no virtual wall)', () {
      final slots = generateAvailableSlots();
      slots[17] = slots[17].copyWith(status: SlotStatus.booked);
      
      // Book slot 15. This leaves slot 16 as an O between 15 (booked) and 17 (booked).
      // Oh wait, if 17 is booked, and we book 15, then 16 is O. The gap is 16.
      // Left is 15 (booked), right is 17 (booked). That IS an orphan gap! X O X
      // What about O X at the edge?
      // Book slot 16. So 16 and 17 are booked. No gap.
      // What if we book slot 1? (0 is available, 1 is booked). No orphan gap since 0 is at the edge.
      final result = BookingValidator.validate(
        slots: slots,
        startIndex: 1,
        duration: BookingDuration.thirtyMin,
      );
      expect(result, isA<BookingSuccess>());
    });
  });
}
