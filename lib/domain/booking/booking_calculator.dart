import '../../core/constants/app_constants.dart';
import '../../data/models/time_slot.dart';

/// Single-responsibility service for booking calculations.
class BookingCalculator {
  const BookingCalculator();

  /// Converts a duration into the required number of 30-minute slots.
  int getRequiredSlotCount(Duration duration) {
    if (duration.inMinutes <= 0) return 0;
    return (duration.inMinutes / AppConstants.slotDurationMinutes).ceil();
  }

  /// Calculates the expected end time for a given start time and duration.
  DateTime calculateEndTime(DateTime startTime, Duration duration) {
    return startTime.add(duration);
  }

  /// Retrieves the consecutive slots that a booking starting at [startTime] with [duration] would occupy.
  List<TimeSlot> getTargetSlots({
    required List<TimeSlot> allSlots,
    required DateTime startTime,
    required Duration duration,
  }) {
    final requiredCount = getRequiredSlotCount(duration);
    final startIndex = allSlots.indexWhere(
      (slot) => slot.startTime.isAtSameMomentAs(startTime),
    );

    if (startIndex == -1 || requiredCount <= 0) {
      return const [];
    }

    final endIndex = (startIndex + requiredCount).clamp(0, allSlots.length);
    return allSlots.sublist(startIndex, endIndex);
  }

  /// Checks if the proposed booking ends strictly on or before working hours (18:00).
  bool isWithinWorkingHours(DateTime startTime, Duration duration) {
    final endTime = calculateEndTime(startTime, duration);
    final closingTime = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
      AppConstants.endHour,
      AppConstants.endMinute,
    );
    return !endTime.isAfter(closingTime);
  }
}
