import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Immutable state for theme selection.
class ThemeState {
  final ThemeMode themeMode;

  const ThemeState(this.themeMode);

  bool get isDark => themeMode == ThemeMode.dark;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeState &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode;

  @override
  int get hashCode => themeMode.hashCode;
}

/// Cubit managing ThemeMode selection (Light, Dark, System Default).
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.system));

  void setThemeMode(ThemeMode mode) {
    if (state.themeMode == mode) return;
    emit(ThemeState(mode));
  }
}
