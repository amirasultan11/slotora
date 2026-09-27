import 'package:flutter/material.dart';

import '../../core/localization/localization_controller.dart';
import '../../core/theme/theme_controller.dart';
import '../../domain/booking/booking_repository.dart';

/// Scoped provider making core controllers and services accessible without global state.
class AppScope extends InheritedWidget {
  final ThemeController themeController;
  final LocalizationController localizationController;
  final BookingRepository bookingRepository;

  const AppScope({
    super.key,
    required this.themeController,
    required this.localizationController,
    required this.bookingRepository,
    required super.child,
  });

  static AppScope of(BuildContext context) {
    final AppScope? result = context
        .dependOnInheritedWidgetOfExactType<AppScope>();
    assert(result != null, 'No AppScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      themeController != oldWidget.themeController ||
      localizationController != oldWidget.localizationController ||
      bookingRepository != oldWidget.bookingRepository;
}
