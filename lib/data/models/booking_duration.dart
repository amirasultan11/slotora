/// Standard booking duration options supported by Slotora.
enum BookingDuration {
  minutes30(Duration(minutes: 30), 1, '30m'),
  minutes60(Duration(minutes: 60), 2, '1h'),
  minutes90(Duration(minutes: 90), 3, '1h 30m'),
  minutes120(Duration(minutes: 120), 4, '2h');

  final Duration duration;
  final int requiredSlotCount;
  final String label;

  const BookingDuration(this.duration, this.requiredSlotCount, this.label);

  static BookingDuration fromDuration(Duration d) {
    for (final opt in BookingDuration.values) {
      if (opt.duration == d) return opt;
    }
    return BookingDuration.minutes30;
  }
}
