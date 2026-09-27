import '../../domain/entities/slot_status.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/local_schedule_data_source.dart';

/// Concrete implementation of [BookingRepository] backed by [LocalScheduleDataSource].
class BookingRepositoryImpl implements BookingRepository {
  final LocalScheduleDataSource _dataSource;

  BookingRepositoryImpl({LocalScheduleDataSource? dataSource})
    : _dataSource = dataSource ?? LocalScheduleDataSource();

  @override
  List<TimeSlotEntity> getSchedule() => _dataSource.getSchedule();

  @override
  BookingEntity confirmBooking({
    required DateTime startTime,
    required DateTime endTime,
    required Duration duration,
    required List<TimeSlotEntity> slotsToBook,
  }) {
    final updated = slotsToBook
        .map((s) => s.copyWith(status: SlotStatus.booked))
        .toList();
    _dataSource.updateSlots(updated);

    return BookingEntity(
      id: 'book_${startTime.millisecondsSinceEpoch}',
      startTime: startTime,
      endTime: endTime,
      duration: duration,
      slotIds: slotsToBook.map((s) => s.id).toList(),
      createdAt: DateTime.now(),
    );
  }

  @override
  void resetSchedule() => _dataSource.reset();
}
