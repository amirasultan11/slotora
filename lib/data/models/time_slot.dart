import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';

/// Semantic status of a scheduling time slot.
enum SlotStatus {
  available,
  booked,
  unavailable,
}

/// Represents a discrete time slot within the appointment schedule.
@immutable
class TimeSlot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final SlotStatus status;

  const TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  /// Factory to create a TimeSlot from hour and minute on the base date.
  factory TimeSlot.fromTime({
    required int hour,
    required int minute,
    SlotStatus status = SlotStatus.available,
  }) {
    final start = DateTime(
      AppConstants.baseDate.year,
      AppConstants.baseDate.month,
      AppConstants.baseDate.day,
      hour,
      minute,
    );
    final end = start.add(
      const Duration(minutes: AppConstants.slotDurationMinutes),
    );
    final id = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    return TimeSlot(
      id: id,
      startTime: start,
      endTime: end,
      status: status,
    );
  }

  bool get isAvailable => status == SlotStatus.available;
  bool get isBooked => status == SlotStatus.booked;
  bool get isUnavailable => status == SlotStatus.unavailable;

  TimeSlot copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    SlotStatus? status,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlot &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          status == other.status;

  @override
  int get hashCode => Object.hash(id, startTime, endTime, status);

  @override
  String toString() => 'TimeSlot($id, $status)';
}
