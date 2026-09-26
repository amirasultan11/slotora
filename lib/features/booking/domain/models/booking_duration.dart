enum BookingDuration {
  thirtyMin(slotsCount: 1, label: '30 min'),
  oneHour(slotsCount: 2, label: '1 hour'),
  ninetyMin(slotsCount: 3, label: '1.5 hours'),
  twoHours(slotsCount: 4, label: '2 hours');

  const BookingDuration({
    required this.slotsCount,
    required this.label,
  });

  final int slotsCount;
  final String label;
  
  int get totalMinutes => slotsCount * 30;
}
