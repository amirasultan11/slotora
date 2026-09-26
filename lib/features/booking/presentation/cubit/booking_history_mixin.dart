import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_state.dart';
import '../../domain/models/slot_status.dart';
import '../../domain/models/time_slot.dart';

// Handles confirm, undo, and reset
mixin BookingHistoryMixin on Cubit<BookingState> {
  static const int _maxHistory = 10;

  // Confirm
  void confirmBooking() {
    if (!state.hasSelection) return;

    final cleanSlots = List<TimeSlot>.from(state.slots);

    final newHistory = List<List<TimeSlot>>.from(state.history)
      ..add(List<TimeSlot>.from(state.slots));

    if (newHistory.length > _maxHistory) {
      newHistory.removeAt(0);
    }

    final start = state.selectedStartIndex!;
    final end = start + state.selectedDuration.slotsCount;

    final bookedSlots = List<TimeSlot>.from(cleanSlots);
    for (int i = start; i < end; i++) {
      bookedSlots[i] = bookedSlots[i].copyWith(status: SlotStatus.booked);
    }

    emit(
      state.copyWith(
        slots: bookedSlots,
        selectedStartIndex: () => null,
        history: newHistory,
        errorMessage: () => null,
      ),
    );
  }
}
