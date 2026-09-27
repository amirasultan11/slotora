import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/booking_duration.dart';
import '../../domain/entities/booking_validation_result.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/services/booking_calculator.dart';
import '../../domain/services/booking_validator.dart';
import 'booking_state.dart';

export 'booking_state.dart';

/// Cubit managing presentation state and booking interactions.
///
/// Coordinates between domain services ([BookingCalculator], [BookingValidator])
/// and the [BookingRepository] without holding any UI or data-source concerns.
class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _repository;
  final BookingCalculator _calculator;
  final BookingValidator _validator;

  // ignore: prefer_initializing_formals — _calculator/_validator have interdependent defaults
  BookingCubit({
    required BookingRepository repository,
    BookingCalculator calculator = const BookingCalculator(),
    BookingValidator? validator,
  }) : _repository = repository, // ignore: prefer_initializing_formals
       _calculator = calculator,
       _validator = validator ?? BookingValidator(calculator: calculator),
       super(
         BookingState(
           slots: const [],
           selectedDuration: BookingDuration.minutes30,
           selectedSlots: const [],
           validStartTimes: const {},
           validationResult: BookingValidationResult.noSelection,
         ),
       ) {
    initialize();
  }

  /// Loads the schedule and computes valid start times for the default duration.
  void initialize() {
    final slots = _repository.getSchedule();
    final validStarts = _validator
        .getValidStartTimes(
          slots: slots,
          duration: BookingDuration.minutes30.duration,
        )
        .toSet();

    emit(BookingState.initial(slots: slots, validStartTimes: validStarts));
  }

  /// Changes the requested duration and dynamically recalculates valid start times.
  void selectDuration(BookingDuration duration) {
    if (state.selectedDuration == duration) return;

    final validStarts = _validator
        .getValidStartTimes(slots: state.slots, duration: duration.duration)
        .toSet();

    if (state.selectedStart == null) {
      emit(
        state.copyWith(
          selectedDuration: duration,
          validStartTimes: validStarts,
          validationResult: BookingValidationResult.noSelection,
        ),
      );
    } else {
      final selectedSlots = _calculator.getTargetSlots(
        allSlots: state.slots,
        startTime: state.selectedStart!,
        duration: duration.duration,
      );
      final calculatedEnd = _calculator.calculateEndTime(
        state.selectedStart!,
        duration.duration,
      );
      final validationResult = _validator.validate(
        slots: state.slots,
        start: state.selectedStart,
        duration: duration.duration,
      );

      emit(
        state.copyWith(
          selectedDuration: duration,
          selectedSlots: selectedSlots,
          calculatedEnd: calculatedEnd,
          validStartTimes: validStarts,
          validationResult: validationResult,
        ),
      );
    }
  }

  /// Selects or toggles a starting time slot.
  void selectStartTime(DateTime start) {
    // Toggle off if already selected
    if (state.selectedStart != null &&
        state.selectedStart!.isAtSameMomentAs(start)) {
      emit(
        state.copyWith(
          clearSelectedStart: true,
          clearCalculatedEnd: true,
          selectedSlots: const [],
          validationResult: BookingValidationResult.noSelection,
        ),
      );
      return;
    }

    final selectedSlots = _calculator.getTargetSlots(
      allSlots: state.slots,
      startTime: start,
      duration: state.selectedDuration.duration,
    );
    final calculatedEnd = _calculator.calculateEndTime(
      start,
      state.selectedDuration.duration,
    );
    final validationResult = _validator.validate(
      slots: state.slots,
      start: start,
      duration: state.selectedDuration.duration,
    );

    emit(
      state.copyWith(
        selectedStart: start,
        selectedSlots: selectedSlots,
        calculatedEnd: calculatedEnd,
        validationResult: validationResult,
      ),
    );
  }

  /// Final confirmation of the booking.
  ///
  /// Re-validates against the latest schedule before committing.
  /// Returns the confirmed [BookingEntity] or null on failure.
  BookingEntity? confirmBooking() {
    if (state.selectedStart == null) {
      emit(
        state.copyWith(validationResult: BookingValidationResult.noSelection),
      );
      return null;
    }

    final currentSlots = _repository.getSchedule();
    final validationResult = _validator.validate(
      slots: currentSlots,
      start: state.selectedStart,
      duration: state.selectedDuration.duration,
    );

    if (!validationResult.isValid) {
      emit(state.copyWith(validationResult: validationResult));
      return null;
    }

    final slotsToBook = _calculator.getTargetSlots(
      allSlots: currentSlots,
      startTime: state.selectedStart!,
      duration: state.selectedDuration.duration,
    );
    final endTime = _calculator.calculateEndTime(
      state.selectedStart!,
      state.selectedDuration.duration,
    );

    final booking = _repository.confirmBooking(
      startTime: state.selectedStart!,
      endTime: endTime,
      duration: state.selectedDuration.duration,
      slotsToBook: slotsToBook,
    );

    final updatedSlots = _repository.getSchedule();
    final updatedValidStarts = _validator
        .getValidStartTimes(
          slots: updatedSlots,
          duration: state.selectedDuration.duration,
        )
        .toSet();

    emit(
      state.copyWith(
        slots: updatedSlots,
        clearSelectedStart: true,
        clearCalculatedEnd: true,
        selectedSlots: const [],
        validStartTimes: updatedValidStarts,
        validationResult: BookingValidationResult.noSelection,
      ),
    );

    return booking;
  }

  /// Resets the current selection and returns to the default 30-minute duration.
  ///
  /// Preserves the existing schedule (bookings remain).
  void resetSelection() {
    final validStarts = _validator
        .getValidStartTimes(
          slots: state.slots,
          duration: BookingDuration.minutes30.duration,
        )
        .toSet();

    emit(
      state.copyWith(
        clearSelectedStart: true,
        clearCalculatedEnd: true,
        selectedDuration: BookingDuration.minutes30,
        selectedSlots: const [],
        validStartTimes: validStarts,
        validationResult: BookingValidationResult.noSelection,
      ),
    );
  }

  /// Full reset back to the initial deterministic baseline schedule.
  void resetSchedule() {
    _repository.resetSchedule();
    initialize();
  }
}
