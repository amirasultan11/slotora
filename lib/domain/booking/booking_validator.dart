import '../../data/models/booking_validation_result.dart';
import '../../data/models/time_slot.dart';
import 'booking_calculator.dart';

/// Single-responsibility service for validating appointment booking requests.
class BookingValidator {
  final BookingCalculator calculator;

  const BookingValidator({this.calculator = const BookingCalculator()});

  /// Validates a proposed booking against the current schedule and business rules.
  BookingValidationResult validate({
    required List<TimeSlot> slots,
    required DateTime? start,
    required Duration duration,
  }) {
    if (start == null) {
      return BookingValidationResult.noSelection;
    }

    // Rule 4: Must not end after working hours (18:00)
    if (!calculator.isWithinWorkingHours(start, duration)) {
      return const BookingValidationResult(
        status: BookingValidationStatus.outsideWorkingHours,
        message: 'Your booking must end by 6:00 PM.',
      );
    }

    final requiredCount = calculator.getRequiredSlotCount(duration);
    final targetSlots = calculator.getTargetSlots(
      allSlots: slots,
      startTime: start,
      duration: duration,
    );

    // Rule 3 & 4: Enough slots exist within the schedule
    if (targetSlots.length < requiredCount) {
      return const BookingValidationResult(
        status: BookingValidationStatus.insufficientConsecutiveSlots,
        message: "There aren't enough consecutive available slots for this duration.",
      );
    }

    // Check consecutiveness
    for (int i = 0; i < targetSlots.length - 1; i++) {
      if (!targetSlots[i].endTime.isAtSameMomentAs(targetSlots[i + 1].startTime)) {
        return const BookingValidationResult(
          status: BookingValidationStatus.insufficientConsecutiveSlots,
          message: 'Slots must be strictly consecutive.',
        );
      }
    }

    // Rule 1: Contains booked slot
    for (final slot in targetSlots) {
      if (slot.isBooked) {
        return BookingValidationResult(
          status: BookingValidationStatus.bookedSlot,
          conflictingSlot: slot,
          message: 'This booking contains a slot that is already booked.',
        );
      }
    }

    // Rule 2: Contains unavailable slot
    for (final slot in targetSlots) {
      if (slot.isUnavailable) {
        return BookingValidationResult(
          status: BookingValidationStatus.unavailableSlot,
          conflictingSlot: slot,
          message: 'This booking overlaps an unavailable appointment.',
        );
      }
    }

    // Rule 6: Special Isolated 30-Minute Gap Rule
    if (_createsIsolatedGap(slots: slots, targetSlots: targetSlots)) {
      return const BookingValidationResult(
        status: BookingValidationStatus.isolatedGap,
        message: 'This booking would leave an isolated 30-minute gap.',
      );
    }

    return BookingValidationResult.valid;
  }

  /// Calculates all valid starting times for a given duration against the current schedule.
  List<DateTime> getValidStartTimes({
    required List<TimeSlot> slots,
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
  bool _createsIsolatedGap({
    required List<TimeSlot> slots,
    required List<TimeSlot> targetSlots,
  }) {
    if (slots.length < 3) return false;

    final targetIds = {for (final s in targetSlots) s.id};

    // Helper to determine if a slot is blocked (booked or unavailable)
    bool isBlocked(SlotStatus status) =>
        status == SlotStatus.booked || status == SlotStatus.unavailable;

    // Helper to check if slot at index `i` is an isolated gap in a given list
    bool isIsolatedInList(List<SlotStatus> statuses, int i) {
      if (i <= 0 || i >= statuses.length - 1) return false;
      return statuses[i] == SlotStatus.available &&
          isBlocked(statuses[i - 1]) &&
          isBlocked(statuses[i + 1]);
    }

    final originalStatuses = slots.map((s) => s.status).toList();

    // Create temporary copy of schedule with proposed booking applied
    final simulatedStatuses = slots.map((s) {
      if (targetIds.contains(s.id)) {
        return SlotStatus.booked;
      }
      return s.status;
    }).toList();

    // Check if any slot becomes isolated in the simulated schedule that was not already isolated
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
