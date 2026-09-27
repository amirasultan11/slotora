import '../../domain/entities/slot_status.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/services/booking_calculator.dart';

/// Data source providing the deterministic mock schedule and local mutable state.
class LocalScheduleDataSource {
  List<TimeSlotEntity> _slots = [];

  LocalScheduleDataSource() {
    reset();
  }

  /// Returns the current schedule as an unmodifiable list.
  List<TimeSlotEntity> getSchedule() => List.unmodifiable(_slots);

  /// Applies updated slots back into the local schedule.
  void updateSlots(List<TimeSlotEntity> updatedSlots) {
    final updatedMap = {for (final s in updatedSlots) s.id: s};
    _slots = _slots.map((s) => updatedMap[s.id] ?? s).toList();
  }

  /// Resets the schedule to the initial deterministic seed data.
  void reset() {
    _slots = _buildDefaultSchedule();
  }

  List<TimeSlotEntity> _buildDefaultSchedule() {
    return [
      _slot(hour: 9, minute: 0, status: SlotStatus.available),
      _slot(hour: 9, minute: 30, status: SlotStatus.available),
      _slot(hour: 10, minute: 0, status: SlotStatus.available),
      _slot(hour: 10, minute: 30, status: SlotStatus.booked),
      _slot(hour: 11, minute: 0, status: SlotStatus.available),
      _slot(hour: 11, minute: 30, status: SlotStatus.unavailable),
      _slot(hour: 12, minute: 0, status: SlotStatus.available),
      _slot(hour: 12, minute: 30, status: SlotStatus.available),
      _slot(hour: 13, minute: 0, status: SlotStatus.booked),
      _slot(hour: 13, minute: 30, status: SlotStatus.booked),
      _slot(hour: 14, minute: 0, status: SlotStatus.available),
      _slot(hour: 14, minute: 30, status: SlotStatus.available),
      _slot(hour: 15, minute: 0, status: SlotStatus.available),
      _slot(hour: 15, minute: 30, status: SlotStatus.available),
      _slot(hour: 16, minute: 0, status: SlotStatus.unavailable),
      _slot(hour: 16, minute: 30, status: SlotStatus.available),
      _slot(hour: 17, minute: 0, status: SlotStatus.available),
      _slot(hour: 17, minute: 30, status: SlotStatus.available),
    ];
  }

  static TimeSlotEntity _slot({
    required int hour,
    required int minute,
    required SlotStatus status,
  }) {
    final base = BookingConfig.baseDate;
    final start = DateTime(base.year, base.month, base.day, hour, minute);
    final end = start.add(
      const Duration(minutes: BookingConfig.slotDurationMinutes),
    );
    final id =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    return TimeSlotEntity(
      id: id,
      startTime: start,
      endTime: end,
      status: status,
    );
  }
}
