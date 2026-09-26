import '../models/booking_duration.dart';
import '../models/slot_status.dart';
import '../models/time_slot.dart';
import 'booking_result.dart';
import 'gap_checker.dart';

class BookingValidator {
  const BookingValidator._();
  static const int totalSlots = 18;

  static BookingResult validate({
    required List<TimeSlot> slots,
    required int startIndex,
    required BookingDuration duration,
  }) {
    final endIndex = startIndex + duration.slotsCount;

    if (startIndex < 0 || endIndex > totalSlots) {
      return const BookingFailure('Booking exceeds working hours (6:00 PM).');
    }

    for (var i = startIndex; i < endIndex; i++) {
      if (slots[i].status != SlotStatus.available) {
        return BookingFailure('Slot at ${slots[i].label} is ${slots[i].status.name}.');
      }
    }

    final simulated = GapChecker.simulateBooking(slots, startIndex, endIndex);
    final orphanIndex = GapChecker.findOrphanGap(simulated);

    if (orphanIndex != null) {
      return const BookingFailure('This booking would leave an isolated 30-minute gap.');
    }

    return const BookingSuccess();
  }

  static List<int> getValidStartIndices({
    required List<TimeSlot> slots,
    required BookingDuration duration,
  }) {
    final validIndices = <int>[];
    for (var i = 0; i <= totalSlots - duration.slotsCount; i++) {
      if (validate(slots: slots, startIndex: i, duration: duration) is BookingSuccess) {
        validIndices.add(i);
      }
    }
    return validIndices;
  }
}
