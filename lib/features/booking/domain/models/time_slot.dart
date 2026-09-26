import 'slot_status.dart';

class TimeSlot {
  const TimeSlot({
    required this.index,
    this.status = SlotStatus.available,
  });

  final int index;
  final SlotStatus status;

  String get label {
    final totalMinutes = (9 * 60) + (index * 30);
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : hour;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  TimeSlot copyWith({SlotStatus? status}) {
    return TimeSlot(
      index: index,
      status: status ?? this.status,
    );
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
