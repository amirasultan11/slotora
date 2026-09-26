import '../../data/models/booking.dart';
import '../../data/models/time_slot.dart';

/// Contract for scheduling and booking repository operations.
abstract class BookingRepository {
  /// Retrieves the current schedule slots.
  List<TimeSlot> getSchedule();

  /// Confirms a booking and updates the affected slots to booked status.
  Booking confirmBooking({
    required DateTime startTime,
    required DateTime endTime,
    required Duration duration,
    required List<TimeSlot> slotsToBook,
  });

  /// Resets the schedule back to the original baseline state.
  void resetSchedule();
}
