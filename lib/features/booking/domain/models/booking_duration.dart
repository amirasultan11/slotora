// TODO: BookingDuration enum with slotsCount property

enum BookingDuration {
  thirtyMin(slotsCount: 1, label: '30 min'),
  oneHour(slotsCount: 2, label: '1 hour'),
  ninetyMin(slotsCount: 3, label: '1.5 hours'),
  twoHours(slotsCount: 4, label: '2 hours');

  final int slotsCount;
  final String label;
  const BookingDuration({required this.slotsCount, required this.label});

  int get totalMinutes => slotsCount * 30;
}
