/// Standard booking duration options supported by Slotora.
///
/// Domain enum — no UI strings, no presentation concerns.
/// Labels are handled by the localization layer.
enum BookingDuration {
  minutes30(Duration(minutes: 30), 1),
  minutes60(Duration(minutes: 60), 2),
  minutes90(Duration(minutes: 90), 3),
  minutes120(Duration(minutes: 120), 4);

  final Duration duration;
  final int requiredSlotCount;

  const BookingDuration(this.duration, this.requiredSlotCount);

  static BookingDuration fromDuration(Duration d) {
    for (final opt in BookingDuration.values) {
      if (opt.duration == d) return opt;
    }
    return BookingDuration.minutes30;
  }
}
