import 'package:flutter/foundation.dart';
import '../../../../data/models/booking.dart';
import '../../../../data/models/booking_duration.dart';
import '../../../../data/models/booking_validation_result.dart';
import '../../../../domain/booking/booking_calculator.dart';
import '../../../../domain/booking/booking_repository.dart';
import '../../../../domain/booking/booking_validator.dart';
import 'booking_state.dart';

/// ViewModel managing presentation state and business interactions for appointment booking.
class BookingViewModel extends ChangeNotifier {
  final BookingRepository repository;
  final BookingCalculator calculator;
  final BookingValidator validator;

  late BookingState _state;

  BookingViewModel({
    required this.repository,
    this.calculator = const BookingCalculator(),
    BookingValidator? validator,
  })  : validator = validator ?? BookingValidator(calculator: calculator) {
    _init();
  }

  BookingState get state => _state;

  void _init() {
    final slots = repository.getSchedule();
    final validStarts = validator.getValidStartTimes(
      slots: slots,
      duration: BookingDuration.minutes30.duration,
    ).toSet();

    _state = BookingState.initial(
      slots: slots,
      validStartTimes: validStarts,
    );
  }

  /// Changes the requested duration and dynamically recalculates state.
  void selectDuration(BookingDuration duration) {
    if (_state.selectedDuration == duration) return;

    final validStarts = validator.getValidStartTimes(
      slots: _state.slots,
      duration: duration.duration,
    ).toSet();

    if (_state.selectedStart == null) {
      _state = _state.copyWith(
        selectedDuration: duration,
        validStartTimes: validStarts,
        validationResult: BookingValidationResult.noSelection,
      );
    } else {
      final selectedSlots = calculator.getTargetSlots(
        allSlots: _state.slots,
        startTime: _state.selectedStart!,
        duration: duration.duration,
      );
      final calculatedEnd = calculator.calculateEndTime(
        _state.selectedStart!,
        duration.duration,
      );
      final validationResult = validator.validate(
        slots: _state.slots,
        start: _state.selectedStart,
        duration: duration.duration,
      );

      _state = _state.copyWith(
        selectedDuration: duration,
        selectedSlots: selectedSlots,
        calculatedEnd: calculatedEnd,
        validStartTimes: validStarts,
        validationResult: validationResult,
      );
    }

    notifyListeners();
  }

  /// Selects or toggles a starting time slot.
  void selectStartTime(DateTime start) {
    // If user taps the already selected start time, they might want to deselect it or re-affirm
    if (_state.selectedStart != null &&
        _state.selectedStart!.isAtSameMomentAs(start)) {
      // Deselect
      _state = _state.copyWith(
        clearSelectedStart: true,
        clearCalculatedEnd: true,
        selectedSlots: const [],
        validationResult: BookingValidationResult.noSelection,
      );
      notifyListeners();
      return;
    }

    final selectedSlots = calculator.getTargetSlots(
      allSlots: _state.slots,
      startTime: start,
      duration: _state.selectedDuration.duration,
    );
    final calculatedEnd = calculator.calculateEndTime(
      start,
      _state.selectedDuration.duration,
    );
    final validationResult = validator.validate(
      slots: _state.slots,
      start: start,
      duration: _state.selectedDuration.duration,
    );

    _state = _state.copyWith(
      selectedStart: start,
      selectedSlots: selectedSlots,
      calculatedEnd: calculatedEnd,
      validationResult: validationResult,
    );

    notifyListeners();
  }

  /// Final confirmation of the booking.
  /// Runs the entire validation pipeline again before committing changes.
  Booking? confirmBooking() {
    if (_state.selectedStart == null) {
      _state = _state.copyWith(
        validationResult: BookingValidationResult.noSelection,
      );
      notifyListeners();
      return null;
    }

    // Re-validate against the latest repository schedule
    final currentSlots = repository.getSchedule();
    final validationResult = validator.validate(
      slots: currentSlots,
      start: _state.selectedStart,
      duration: _state.selectedDuration.duration,
    );

    if (!validationResult.isValid) {
      _state = _state.copyWith(validationResult: validationResult);
      notifyListeners();
      return null;
    }

    final slotsToBook = calculator.getTargetSlots(
      allSlots: currentSlots,
      startTime: _state.selectedStart!,
      duration: _state.selectedDuration.duration,
    );
    final endTime = calculator.calculateEndTime(
      _state.selectedStart!,
      _state.selectedDuration.duration,
    );

    // Commit to repository
    final booking = repository.confirmBooking(
      startTime: _state.selectedStart!,
      endTime: endTime,
      duration: _state.selectedDuration.duration,
      slotsToBook: slotsToBook,
    );

    // Refresh state after booking
    final updatedSlots = repository.getSchedule();
    final updatedValidStarts = validator.getValidStartTimes(
      slots: updatedSlots,
      duration: _state.selectedDuration.duration,
    ).toSet();

    _state = _state.copyWith(
      slots: updatedSlots,
      clearSelectedStart: true,
      clearCalculatedEnd: true,
      selectedSlots: const [],
      validStartTimes: updatedValidStarts,
      validationResult: BookingValidationResult.noSelection,
    );

    notifyListeners();
    return booking;
  }

  /// Resets the current selection and returns to default duration.
  /// Preserves the existing schedule.
  void resetSelection() {
    final validStarts = validator.getValidStartTimes(
      slots: _state.slots,
      duration: BookingDuration.minutes30.duration,
    ).toSet();

    _state = _state.copyWith(
      clearSelectedStart: true,
      clearCalculatedEnd: true,
      selectedDuration: BookingDuration.minutes30,
      selectedSlots: const [],
      validStartTimes: validStarts,
      validationResult: BookingValidationResult.noSelection,
    );

    notifyListeners();
  }

  /// Full reset back to initial schedule (optional developer/demo action).
  void resetAll() {
    repository.resetSchedule();
    _init();
    notifyListeners();
  }
}
