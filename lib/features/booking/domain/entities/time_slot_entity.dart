import 'package:flutter/foundation.dart';

import 'slot_status.dart';

/// Domain entity representing a discrete 30-minute appointment slot.
///
/// Owns no knowledge of data sources, persistence, or UI presentation.
@immutable
class TimeSlotEntity {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final SlotStatus status;

  const TimeSlotEntity({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  bool get isAvailable => status == SlotStatus.available;
  bool get isBooked => status == SlotStatus.booked;
  bool get isUnavailable => status == SlotStatus.unavailable;

  TimeSlotEntity copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    SlotStatus? status,
  }) {
    return TimeSlotEntity(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlotEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          status == other.status;

  @override
  int get hashCode => Object.hash(id, startTime, endTime, status);

  @override
  String toString() => 'TimeSlotEntity($id, $status)';
}
