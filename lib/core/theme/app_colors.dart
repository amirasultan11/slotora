import 'package:flutter/material.dart';

/// Centralized color palette and design tokens for Slotora.
class AppColors {
  AppColors._();

  // Brand Palette
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF3730A3); // Indigo 800
  static const Color secondary = Color(0xFF0EA5E9); // Sky 500
  static const Color accent = Color(0xFF10B981); // Emerald 500

  // Semantic Status Colors
  static const Color availableLight = Color(0xFF059669);
  static const Color availableLightBg = Color(0xFFECFDF5);
  static const Color availableDark = Color(0xFF34D399);
  static const Color availableDarkBg = Color(0xFF064E3B);

  static const Color bookedLight = Color(0xFFDC2626);
  static const Color bookedLightBg = Color(0xFFFEF2F2);
  static const Color bookedDark = Color(0xFFF87171);
  static const Color bookedDarkBg = Color(0xFF450A0A);

  static const Color unavailableLight = Color(0xFF6B7280);
  static const Color unavailableLightBg = Color(0xFFF3F4F6);
  static const Color unavailableDark = Color(0xFF9CA3AF);
  static const Color unavailableDarkBg = Color(0xFF1F2937);

  static const Color selectedLight = Color(0xFF4F46E5);
  static const Color selectedLightBg = Color(0xFFEEF2FF);
  static const Color selectedDark = Color(0xFF818CF8);
  static const Color selectedDarkBg = Color(0xFF312E81);

  // Success / Warning / Error
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Light Theme Surfaces
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dark Theme Surfaces
  static const Color darkBg = Color(0xFF090D16);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1A2234);
  static const Color darkBorder = Color(0xFF1F293D);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Glassmorphic tokens
  static const Color glassLight = Color(0xCCFFFFFF);
  static const Color glassLightBorder = Color(0x66FFFFFF);
  static const Color glassDark = Color(0xCC111827);
  static const Color glassDarkBorder = Color(0x33FFFFFF);
}
