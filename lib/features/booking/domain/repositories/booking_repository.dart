import '../entities/time_slot_entity.dart';

/// Domain entity for a confirmed appointment booking.
class BookingEntity {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final List<String> slotIds;
  final DateTime createdAt;

  const BookingEntity({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.slotIds,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Domain contract for schedule data access.
///
/// Uses only domain entities — implementation details are in the data layer.
abstract class BookingRepository {
  /// Retrieves the current schedule slots.
  List<TimeSlotEntity> getSchedule();

  /// Confirms a booking, marks affected slots as booked, and returns the booking.
  BookingEntity confirmBooking({
    required DateTime startTime,
    required DateTime endTime,
    required Duration duration,
    required List<TimeSlotEntity> slotsToBook,
  });

  /// Resets the schedule back to the original baseline state.
  void resetSchedule();
}
