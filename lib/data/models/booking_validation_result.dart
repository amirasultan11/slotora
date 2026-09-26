import 'package:flutter/foundation.dart';
import 'time_slot.dart';

/// Semantic status of the booking validation.
enum BookingValidationStatus {
  valid,
  noSelection,
  bookedSlot,
  unavailableSlot,
  insufficientConsecutiveSlots,
  outsideWorkingHours,
  isolatedGap,
  conflict,
}

/// Detailed result of validating a proposed appointment booking.
@immutable
class BookingValidationResult {
  final BookingValidationStatus status;
  final String? message;
  final TimeSlot? conflictingSlot;

  const BookingValidationResult({
    required this.status,
    this.message,
    this.conflictingSlot,
  });

  bool get isValid => status == BookingValidationStatus.valid;

  static const BookingValidationResult valid = BookingValidationResult(
    status: BookingValidationStatus.valid,
    message: null,
  );

  static const BookingValidationResult noSelection = BookingValidationResult(
    status: BookingValidationStatus.noSelection,
    message: 'Please select a starting time slot.',
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingValidationResult &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          conflictingSlot == other.conflictingSlot;

  @override
  int get hashCode => Object.hash(status, conflictingSlot);

  @override
  String toString() => 'BookingValidationResult($status, $message)';
}
