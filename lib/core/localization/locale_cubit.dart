import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Immutable state for locale selection.
class LocaleState {
  final Locale locale;

  const LocaleState(this.locale);

  bool get isArabic => locale.languageCode == 'ar';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocaleState &&
          runtimeType == other.runtimeType &&
          locale == other.locale;

  @override
  int get hashCode => locale.hashCode;
}

/// Cubit managing the application's active Locale.
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(Locale('en')));

  void setLocale(Locale locale) {
    if (state.locale == locale) return;
    emit(LocaleState(locale));
  }
}
