import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary
  static const Color primary = Color(0xFF2563EB); // Modern Blue
  static const Color primaryLight = Color(0xFFDBEAFE);
  static const Color secondary = Color(0xFF10B981); // Emerald Green / Success / Booked

  // Backgrounds
  static const Color background = Color(0xFF0F172A); // Dark mode background
  static const Color surface = Color(0xFF1E293B);    // Dark mode surface
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFFF1F5F9); // Light text for dark mode
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color lightTextPrimary = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Borders & Dividers
  static const Color border = Color(0xFF334155);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}
