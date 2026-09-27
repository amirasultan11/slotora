import 'package:flutter/foundation.dart';

import 'time_slot_entity.dart';

/// Semantic status of the booking validation — pure domain concept, no UI strings.
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

/// Domain result of validating a proposed appointment booking.
///
/// Contains only semantic data. UI messages are mapped from [BookingValidationStatus]
/// by the localization layer (AppLocalizations.validationMessage).
@immutable
class BookingValidationResult {
  final BookingValidationStatus status;
  final TimeSlotEntity? conflictingSlot;

  const BookingValidationResult({required this.status, this.conflictingSlot});

  bool get isValid => status == BookingValidationStatus.valid;

  static const BookingValidationResult valid = BookingValidationResult(
    status: BookingValidationStatus.valid,
  );

  static const BookingValidationResult noSelection = BookingValidationResult(
    status: BookingValidationStatus.noSelection,
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
  String toString() => 'BookingValidationResult($status)';
}
