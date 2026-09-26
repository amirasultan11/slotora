import 'package:flutter/foundation.dart';

/// Represents a confirmed appointment booking.
@immutable
class Booking {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final List<String> slotIds;
  final DateTime createdAt;

  const Booking({
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
      other is Booking &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
