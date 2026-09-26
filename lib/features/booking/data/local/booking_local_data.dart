import '../../domain/models/slot_status.dart';
import '../../domain/models/time_slot.dart';

class BookingLocalData {
  const BookingLocalData._();

  static const Set<int> _preBookedIndices = {3, 4, 12};
  static const Set<int> _unavailableIndices = {9};

  static List<TimeSlot> generateInitialSlots() {
    return List.generate(18, (index) {
      final SlotStatus status;
      if (_preBookedIndices.contains(index)) {
        status = SlotStatus.booked;
      } else if (_unavailableIndices.contains(index)) {
        status = SlotStatus.unavailable;
      } else {
        status = SlotStatus.available;
      }
      return TimeSlot(index: index, status: status);
    });
  }
}
