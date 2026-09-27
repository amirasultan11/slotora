import '../entities/booking_validation_result.dart';
import '../entities/slot_status.dart';
import '../entities/time_slot_entity.dart';
import 'booking_calculator.dart';

/// Single-responsibility service for validating appointment booking requests.
///
/// Pure domain service — imports only domain entities and domain calculator.
/// Returns semantic [BookingValidationStatus] values; UI strings are
/// resolved by the localization layer.
class BookingValidator {
  final BookingCalculator calculator;

  const BookingValidator({this.calculator = const BookingCalculator()});

  /// Validates a proposed booking against the current schedule and business rules.
  BookingValidationResult validate({
    required List<TimeSlotEntity> slots,
    required DateTime? start,
    required Duration duration,
  }) {
    if (start == null) {
      return BookingValidationResult.noSelection;
    }

    // Rule: Must not end after working hours (18:00)
    if (!calculator.isWithinWorkingHours(start, duration)) {
      return const BookingValidationResult(
        status: BookingValidationStatus.outsideWorkingHours,
      );
    }

    final requiredCount = calculator.getRequiredSlotCount(duration);
    final targetSlots = calculator.getTargetSlots(
      allSlots: slots,
      startTime: start,
      duration: duration,
    );

    // Rule: Enough consecutive slots exist within the schedule boundary
    if (targetSlots.length < requiredCount) {
      return const BookingValidationResult(
        status: BookingValidationStatus.insufficientConsecutiveSlots,
      );
    }

    // Check strict consecutiveness
    for (int i = 0; i < targetSlots.length - 1; i++) {
      if (!targetSlots[i].endTime.isAtSameMomentAs(
        targetSlots[i + 1].startTime,
      )) {
        return const BookingValidationResult(
          status: BookingValidationStatus.insufficientConsecutiveSlots,
        );
      }
    }

    // Rule: Contains a booked slot
    for (final slot in targetSlots) {
      if (slot.isBooked) {
        return BookingValidationResult(
          status: BookingValidationStatus.bookedSlot,
          conflictingSlot: slot,
        );
      }
    }

    // Rule: Contains an unavailable slot
    for (final slot in targetSlots) {
      if (slot.isUnavailable) {
        return BookingValidationResult(
          status: BookingValidationStatus.unavailableSlot,
          conflictingSlot: slot,
        );
      }
    }

    // Rule: X O X isolated 30-minute gap
    if (_createsIsolatedGap(slots: slots, targetSlots: targetSlots)) {
      return const BookingValidationResult(
        status: BookingValidationStatus.isolatedGap,
      );
    }

    return BookingValidationResult.valid;
  }

  /// Calculates all valid starting times for a given duration against the current schedule.
  List<DateTime> getValidStartTimes({
    required List<TimeSlotEntity> slots,
    required Duration duration,
  }) {
    final List<DateTime> validStarts = [];
    for (final slot in slots) {
      final result = validate(
        slots: slots,
        start: slot.startTime,
        duration: duration,
      );
      if (result.isValid) {
        validStarts.add(slot.startTime);
      }
    }
    return validStarts;
  }

  /// Evaluates whether the proposed booking creates a new isolated 30-minute available gap (X O X).
  ///
  /// Algorithm:
  /// 1. Records original slot statuses.
  /// 2. Simulates booking by marking target slots as booked.
  /// 3. Checks if any slot is now isolated that was not previously isolated.
  bool _createsIsolatedGap({
    required List<TimeSlotEntity> slots,
    required List<TimeSlotEntity> targetSlots,
  }) {
    if (slots.length < 3) return false;

    final targetIds = {for (final s in targetSlots) s.id};

    bool isBlocked(SlotStatus status) =>
        status == SlotStatus.booked || status == SlotStatus.unavailable;

    bool isIsolatedInList(List<SlotStatus> statuses, int i) {
      if (i <= 0 || i >= statuses.length - 1) return false;
      return statuses[i] == SlotStatus.available &&
          isBlocked(statuses[i - 1]) &&
          isBlocked(statuses[i + 1]);
    }

    final originalStatuses = slots.map((s) => s.status).toList();

    final simulatedStatuses = slots.map((s) {
      if (targetIds.contains(s.id)) return SlotStatus.booked;
      return s.status;
    }).toList();

    for (int i = 1; i < simulatedStatuses.length - 1; i++) {
      final isNowIsolated = isIsolatedInList(simulatedStatuses, i);
      final wasAlreadyIsolated = isIsolatedInList(originalStatuses, i);

      if (isNowIsolated && !wasAlreadyIsolated) {
        return true;
      }
    }

    return false;
  }
}
