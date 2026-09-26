import 'package:flutter/material.dart';

/// Centralized application constants for Slotora scheduling.
class AppConstants {
  AppConstants._();

  /// Working hours boundaries
  static const int startHour = 9; // 09:00 AM
  static const int startMinute = 0;
  static const int endHour = 18; // 06:00 PM (18:00)
  static const int endMinute = 0;

  /// Slot duration in minutes
  static const int slotDurationMinutes = 30;

  /// Working hours as TimeOfDay
  static const TimeOfDay workDayStart = TimeOfDay(hour: startHour, minute: startMinute);
  static const TimeOfDay workDayEnd = TimeOfDay(hour: endHour, minute: endMinute);

  /// Reference date used for standardizing TimeSlot DateTime instances
  static final DateTime baseDate = DateTime(2026, 1, 1);
}
