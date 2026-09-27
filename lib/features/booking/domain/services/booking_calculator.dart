import '../entities/time_slot_entity.dart';

/// Booking-specific configuration constants.
///
/// Kept inside the booking feature domain to avoid polluting core constants
/// with feature-specific business rules.
class BookingConfig {
  BookingConfig._();

  static const int startHour = 9;
  static const int startMinute = 0;
  static const int endHour = 18;
  static const int endMinute = 0;

  static const int slotDurationMinutes = 30;

  /// Reference date for deterministic mock schedule (tests rely on this).
  static final DateTime baseDate = DateTime(2026, 1, 1);
}

/// Single-responsibility service for booking calculations.
///
/// Pure domain service — imports only domain entities.
class BookingCalculator {
  const BookingCalculator();

  /// Converts a duration into the required number of 30-minute slots.
  int getRequiredSlotCount(Duration duration) {
    if (duration.inMinutes <= 0) return 0;
    return (duration.inMinutes / BookingConfig.slotDurationMinutes).ceil();
  }

  /// Calculates the expected end time for a given start time and duration.
  DateTime calculateEndTime(DateTime startTime, Duration duration) {
    return startTime.add(duration);
  }

  /// Retrieves the consecutive slots that a booking would occupy.
  List<TimeSlotEntity> getTargetSlots({
    required List<TimeSlotEntity> allSlots,
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

  /// Checks if the proposed booking ends strictly on or before closing time (18:00).
  bool isWithinWorkingHours(DateTime startTime, Duration duration) {
    final endTime = calculateEndTime(startTime, duration);
    final closingTime = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
      BookingConfig.endHour,
      BookingConfig.endMinute,
    );
    return !endTime.isAfter(closingTime);
  }
}
