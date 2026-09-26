// TODO: TimeSlot model with index, status, and computed label

import 'package:slotora/features/booking/domain/models/slot_status.dart';

class TimeSlot {
  final int index;
  final SlotStatus status;

  const TimeSlot({this.status = SlotStatus.available, required this.index});

  String get label {
    final totalMinutes = (9 * 60) + (index * 30);
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;

    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : hour;

    return '${displayHour.toString()} : ${minute.toString().padLeft(2, '0')} $period';
  }

  TimeSlot copyWith({SlotStatus? status}) {
    return TimeSlot(index: index, status: status ?? this.status);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlot &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          status == other.status;

  @override
  int get hashCode => index.hashCode ^ status.hashCode;
}
