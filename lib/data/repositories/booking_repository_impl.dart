import '../../domain/booking/booking_repository.dart';
import '../local/local_schedule_data_source.dart';
import '../models/booking.dart';
import '../models/time_slot.dart';

/// Concrete implementation of [BookingRepository] backed by [LocalScheduleDataSource].
class BookingRepositoryImpl implements BookingRepository {
  final LocalScheduleDataSource _dataSource;

  BookingRepositoryImpl({LocalScheduleDataSource? dataSource})
      : _dataSource = dataSource ?? LocalScheduleDataSource();

  @override
  List<TimeSlot> getSchedule() {
    return _dataSource.getSchedule();
  }

  @override
  Booking confirmBooking({
    required DateTime startTime,
    required DateTime endTime,
    required Duration duration,
    required List<TimeSlot> slotsToBook,
  }) {
    final updated = slotsToBook
        .map((s) => s.copyWith(status: SlotStatus.booked))
        .toList();
    _dataSource.updateSlots(updated);

    final booking = Booking(
      id: 'book_${startTime.millisecondsSinceEpoch}',
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      slotIds: slotsToBook.map((s) => s.id).toList(),
      createdAt: DateTime.now(),
    );

    return booking;
  }

  @override
  void resetSchedule() {
    _dataSource.reset();
  }
}
