/// Formatter for displaying times and durations consistently across locales.
class TimeFormatter {
  TimeFormatter._();

  /// Formats a DateTime into 12-hour AM/PM format (e.g., 09:00 AM or 09:00 ص).
  static String formatTime(DateTime time, {bool isArabic = false}) {
    final hour24 = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour24 >= 12
        ? (isArabic ? 'م' : 'PM')
        : (isArabic ? 'ص' : 'AM');
    final hour12 = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
    final hourStr = hour12.toString().padLeft(2, '0');
    return '$hourStr:$minute $period';
  }

  /// Formats a 24-hour ID string (e.g., "09:30") into a clean display label.
  static String formatSlotId(String slotId, {bool isArabic = false}) {
    final parts = slotId.split(':');
    if (parts.length != 2) return slotId;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final period = hour >= 12
        ? (isArabic ? 'م' : 'PM')
        : (isArabic ? 'ص' : 'AM');
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${hour12.toString().padLeft(2, '0')}:$minute $period';
  }

  /// Formats a Duration into human readable string (e.g. 1h 30m or 1.5 س).
  static String formatDuration(Duration duration, {bool isArabic = false}) {
    final minutes = duration.inMinutes;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0 && remainingMinutes > 0) {
      return isArabic
          ? '$hours س $remainingMinutes د'
          : '${hours}h ${remainingMinutes}m';
    } else if (hours > 0) {
      return isArabic ? '$hours س' : '${hours}h';
    } else {
      return isArabic ? '$remainingMinutes د' : '${remainingMinutes}m';
    }
  }
}
