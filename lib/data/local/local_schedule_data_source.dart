import '../models/time_slot.dart';

/// Data source providing deterministic mock schedule data and local state.
class LocalScheduleDataSource {
  List<TimeSlot> _slots = [];

  LocalScheduleDataSource() {
    reset();
  }

  /// Returns the deterministic default schedule for Slotora.
  List<TimeSlot> _buildDefaultSchedule() {
    return [
      TimeSlot.fromTime(hour: 9, minute: 0, status: SlotStatus.available),
      TimeSlot.fromTime(hour: 9, minute: 30, status: SlotStatus.available),
      TimeSlot.fromTime(hour: 10, minute: 0, status: SlotStatus.available),
      TimeSlot.fromTime(hour: 10, minute: 30, status: SlotStatus.booked),
      TimeSlot.fromTime(hour: 11, minute: 0, status: SlotStatus.available),
      TimeSlot.fromTime(hour: 11, minute: 30, status: SlotStatus.unavailable),
      TimeSlot.fromTime(hour: 12, minute: 0, status: SlotStatus.available),
      TimeSlot.fromTime(hour: 12, minute: 30, status: SlotStatus.available),
      TimeSlot.fromTime(hour: 13, minute: 0, status: SlotStatus.booked),
      TimeSlot.fromTime(hour: 13, minute: 30, status: SlotStatus.booked),
      TimeSlot.fromTime(hour: 14, minute: 0, status: SlotStatus.available),
      TimeSlot.fromTime(hour: 14, minute: 30, status: SlotStatus.available),
      TimeSlot.fromTime(hour: 15, minute: 0, status: SlotStatus.available),
      TimeSlot.fromTime(hour: 15, minute: 30, status: SlotStatus.available),
      TimeSlot.fromTime(hour: 16, minute: 0, status: SlotStatus.unavailable),
      TimeSlot.fromTime(hour: 16, minute: 30, status: SlotStatus.available),
      TimeSlot.fromTime(hour: 17, minute: 0, status: SlotStatus.available),
      TimeSlot.fromTime(hour: 17, minute: 30, status: SlotStatus.available),
    ];
  }

  /// Retrieves the current schedule.
  List<TimeSlot> getSchedule() {
    return List.unmodifiable(_slots);
  }

  /// Updates slots in the local schedule.
  void updateSlots(List<TimeSlot> updatedSlots) {
    final Map<String, TimeSlot> updatedMap = {
      for (final s in updatedSlots) s.id: s,
    };
    _slots = _slots.map((s) => updatedMap[s.id] ?? s).toList();
  }

  /// Resets the schedule back to the initial deterministic mock data.
  void reset() {
    _slots = _buildDefaultSchedule();
  }
}
