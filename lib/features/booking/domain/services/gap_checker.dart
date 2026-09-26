import 'package:slotora/features/booking/domain/models/slot_status.dart';
import 'package:slotora/features/booking/domain/models/time_slot.dart';

class GapChecker {
  static const int totalSlots = 18;

  const GapChecker._();

  static int? findOrphanGap(List<TimeSlot> slots) {
    for (var i = 0; i < totalSlots; i++) {
      if (slots[i].status != SlotStatus.available) continue;

      final rightBlocked =
          i == totalSlots - 1 || slots[i + 1].status != SlotStatus.available;
      final leftBlocked = i == 0 || slots[i - 1].status != SlotStatus.available;

      if (leftBlocked && rightBlocked) {
        return i;
      }
    }
    return null;
  }

  static List<TimeSlot> simulateBooking(
    List<TimeSlot> original,
    int startIndex,
    int endIndex,
  ) {
    return [
      for (var i = 0; i < original.length; i++)
        if (i >= startIndex && i < endIndex)
          original[i].copyWith(status: SlotStatus.booked)
        else
          original[i],
    ];
  }
}
