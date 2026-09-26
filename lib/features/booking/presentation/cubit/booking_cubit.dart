import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_state.dart';
import '../../domain/models/booking_duration.dart';
import '../../domain/models/slot_status.dart';
import '../../domain/models/time_slot.dart';
import '../../domain/services/booking_validator.dart';
import '../../data/local/booking_local_data.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingState(slots: BookingLocalData.generateInitialSlots())) {
    _calculateValidStarts();
  }

  void _calculateValidStarts() {
    final validIndices = BookingValidator.getValidStartIndices(
      slots: state.slots,
      duration: state.selectedDuration,
    );
    emit(state.copyWith(validStartIndices: validIndices));
  }

  void changeDuration(BookingDuration duration) {
    emit(state.copyWith(selectedDuration: duration));
    _calculateValidStarts();

    if (state.selectedStartIndex != null) {
      if (!state.validStartIndices.contains(state.selectedStartIndex)) {
        emit(state.copyWith(
          selectedStartIndex: () => null,
          errorMessage: () => 'This duration cannot start at the selected time.',
        ));
      }
    }
  }

  void selectStartTime(int index) {
    if (!state.validStartIndices.contains(index)) {
      emit(state.copyWith(
        errorMessage: () => 'This booking would leave an isolated 30-minute gap.',
      ));
      return;
    }
    emit(state.copyWith(
      selectedStartIndex: () => index,
      errorMessage: () => null,
    ));
  }

  void confirmBooking() {
    if (state.selectedStartIndex == null) return;
    
    final start = state.selectedStartIndex!;
    final end = start + state.selectedDuration.slotsCount;
    
    final newHistory = List<List<TimeSlot>>.from(state.history)..add(List.of(state.slots));
    if (newHistory.length > 10) newHistory.removeAt(0);
    
    final newSlots = List<TimeSlot>.from(state.slots);
    for (int i = start; i < end; i++) {
      newSlots[i] = newSlots[i].copyWith(status: SlotStatus.booked);
    }

    emit(state.copyWith(
      slots: newSlots,
      selectedStartIndex: () => null,
      selectedDuration: BookingDuration.thirtyMin,
      history: newHistory,
      errorMessage: () => null,
    ));
    _calculateValidStarts();
  }

  void undoLastBooking() {
    if (!state.canUndo) return;
    final newHistory = List<List<TimeSlot>>.from(state.history);
    final prevSlots = newHistory.removeLast();

    emit(state.copyWith(
      slots: prevSlots,
      selectedStartIndex: () => null,
      selectedDuration: BookingDuration.thirtyMin,
      errorMessage: () => null,
      history: newHistory,
    ));
    _calculateValidStarts();
  }

  void reset() {
    emit(BookingState(slots: BookingLocalData.generateInitialSlots()));
    _calculateValidStarts();
  }

  void clearError() => emit(state.copyWith(errorMessage: () => null));
}
