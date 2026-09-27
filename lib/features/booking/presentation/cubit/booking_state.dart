import 'package:flutter/foundation.dart';

import '../../domain/entities/booking_duration.dart';
import '../../domain/entities/booking_validation_result.dart';
import '../../domain/entities/time_slot_entity.dart';

/// Immutable presentation state for the booking feature.
@immutable
class BookingState {
  final List<TimeSlotEntity> slots;
  final DateTime? selectedStart;
  final BookingDuration selectedDuration;
  final List<TimeSlotEntity> selectedSlots;
  final DateTime? calculatedEnd;
  final Set<DateTime> validStartTimes;
  final BookingValidationResult validationResult;

  const BookingState({
    required this.slots,
    this.selectedStart,
    required this.selectedDuration,
    required this.selectedSlots,
    this.calculatedEnd,
    required this.validStartTimes,
    required this.validationResult,
  });

  bool get isBookingValid => validationResult.isValid && selectedStart != null;
  bool get hasSelection => selectedStart != null;

  factory BookingState.initial({
    required List<TimeSlotEntity> slots,
    required Set<DateTime> validStartTimes,
  }) {
    return BookingState(
      slots: slots,
      selectedStart: null,
      selectedDuration: BookingDuration.minutes30,
      selectedSlots: const [],
      calculatedEnd: null,
      validStartTimes: validStartTimes,
      validationResult: BookingValidationResult.noSelection,
    );
  }

  BookingState copyWith({
    List<TimeSlotEntity>? slots,
    DateTime? selectedStart,
    bool clearSelectedStart = false,
    BookingDuration? selectedDuration,
    List<TimeSlotEntity>? selectedSlots,
    DateTime? calculatedEnd,
    bool clearCalculatedEnd = false,
    Set<DateTime>? validStartTimes,
    BookingValidationResult? validationResult,
  }) {
    return BookingState(
      slots: slots ?? this.slots,
      selectedStart: clearSelectedStart
          ? null
          : (selectedStart ?? this.selectedStart),
      selectedDuration: selectedDuration ?? this.selectedDuration,
      selectedSlots: selectedSlots ?? this.selectedSlots,
      calculatedEnd: clearCalculatedEnd
          ? null
          : (calculatedEnd ?? this.calculatedEnd),
      validStartTimes: validStartTimes ?? this.validStartTimes,
      validationResult: validationResult ?? this.validationResult,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingState &&
          runtimeType == other.runtimeType &&
          listEquals(slots, other.slots) &&
          selectedStart == other.selectedStart &&
          selectedDuration == other.selectedDuration &&
          listEquals(selectedSlots, other.selectedSlots) &&
          calculatedEnd == other.calculatedEnd &&
          setEquals(validStartTimes, other.validStartTimes) &&
          validationResult == other.validationResult;

  @override
  int get hashCode => Object.hash(
    Object.hashAll(slots),
    selectedStart,
    selectedDuration,
    Object.hashAll(selectedSlots),
    calculatedEnd,
    Object.hashAll(validStartTimes),
    validationResult,
  );
}
