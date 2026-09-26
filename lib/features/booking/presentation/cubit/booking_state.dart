import '../../domain/models/booking_duration.dart';
import '../../domain/models/slot_status.dart';
import '../../domain/models/time_slot.dart';

class BookingState {
  final List<TimeSlot> slots;
  final BookingDuration selectedDuration;
  final int? selectedStartIndex;
  final String? errorMessage;
  final List<List<TimeSlot>> history;
  final List<int> validStartIndices;

  const BookingState({
    required this.slots,
    this.selectedDuration = BookingDuration.thirtyMin,
    this.selectedStartIndex,
    this.errorMessage,
    this.history = const [],
    this.validStartIndices = const [],
  });

  bool get hasSelection => selectedStartIndex != null;
  bool get canUndo => history.isNotEmpty;
  
  int get bookedMinutes => slots.where((s) => s.status == SlotStatus.booked).length * 30;
  int get availableMinutes => slots.where((s) => s.status == SlotStatus.available).length * 30;
  
  String? get selectedStartLabel => selectedStartIndex != null ? slots[selectedStartIndex!].label : null;
  
  String? get selectedEndLabel {
    if (selectedStartIndex == null) return null;
    final endIndex = selectedStartIndex! + selectedDuration.slotsCount;
    final totalMinutes = (9 * 60) + (endIndex * 30);
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : hour;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  BookingState copyWith({
    List<TimeSlot>? slots,
    BookingDuration? selectedDuration,
    int? Function()? selectedStartIndex,
    String? Function()? errorMessage,
    List<List<TimeSlot>>? history,
    List<int>? validStartIndices,
  }) {
    return BookingState(
      slots: slots ?? this.slots,
      selectedDuration: selectedDuration ?? this.selectedDuration,
      selectedStartIndex: selectedStartIndex != null ? selectedStartIndex() : this.selectedStartIndex,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      history: history ?? this.history,
      validStartIndices: validStartIndices ?? this.validStartIndices,
    );
  }
}
