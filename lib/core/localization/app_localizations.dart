import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/models/booking_duration.dart';
import '../../data/models/booking_validation_result.dart';

/// Centralized internationalization service supporting English and Arabic.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  bool get isArabic => locale.languageCode == 'ar';

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Slotora',
      'app_subtitle': 'Local Appointment Scheduling',
      'schedule_title': "Today's Schedule",
      'schedule_subtitle': 'Select a duration and start time to book',
      'working_hours': 'Working hours: 9:00 AM – 6:00 PM (30m slots)',
      'select_duration': 'Select Duration',
      'legend_available': 'Available',
      'legend_booked': 'Booked',
      'legend_unavailable': 'Unavailable',
      'legend_selected': 'Selected',
      'booking_summary': 'Booking Summary',
      'start_time': 'Start Time',
      'end_time': 'End Time',
      'duration': 'Duration',
      'status': 'Status',
      'confirm_booking': 'Confirm Booking',
      'reset': 'Reset',
      'settings': 'Settings',
      'appearance': 'Appearance',
      'theme_light': 'Light',
      'theme_dark': 'Dark',
      'theme_system': 'System Default',
      'language': 'Language',
      'lang_en': 'English',
      'lang_ar': 'العربية (Arabic)',
      'ready_to_book': 'Ready to confirm',
      'no_start_selected': 'Tap an available slot to start',
      'err_no_selection': 'Please select a starting time slot.',
      'err_booked': 'This booking contains a slot that is already booked.',
      'err_unavailable': 'This booking overlaps an unavailable appointment.',
      'err_consecutive': "There aren't enough consecutive available slots for this duration.",
      'err_outside_hours': 'Your booking must end by 6:00 PM.',
      'err_isolated_gap': 'This booking would leave an isolated 30-minute gap.',
      'toast_success_title': 'Booking Confirmed',
      'toast_success_desc': 'Your appointment has been successfully scheduled.',
      'toast_error_title': 'Validation Issue',
      'drawer_subtitle': 'Smart Local Appointment Scheduling',
      'drawer_version': 'Version 1.0.0 (Local-Only)',
    },
    'ar': {
      'app_title': 'سلوتورا',
      'app_subtitle': 'جدولة المواعيد المحلية',
      'schedule_title': 'جدول اليوم',
      'schedule_subtitle': 'اختر المدة ووقت البدء لإتمام الحجز',
      'working_hours': 'ساعات العمل: 9:00 ص – 6:00 م (خانات 30 دقيقة)',
      'select_duration': 'تحديد المدة',
      'legend_available': 'متاح',
      'legend_booked': 'محجوز',
      'legend_unavailable': 'غير متاح',
      'legend_selected': 'محدد',
      'booking_summary': 'ملخص الحجز',
      'start_time': 'وقت البدء',
      'end_time': 'وقت الانتهاء',
      'duration': 'المدة',
      'status': 'الحالة',
      'confirm_booking': 'تأكيد الحجز',
      'reset': 'إعادة ضبط',
      'settings': 'الإعدادات',
      'appearance': 'المظهر',
      'theme_light': 'فاتح',
      'theme_dark': 'داكن',
      'theme_system': 'افتراضي النظام',
      'language': 'اللغة',
      'lang_en': 'English (الإنجليزية)',
      'lang_ar': 'العربية',
      'ready_to_book': 'جاهز للتأكيد',
      'no_start_selected': 'انقر على خانة متاحة للبدء',
      'err_no_selection': 'يرجى تحديد وقت البدء.',
      'err_booked': 'هذا الحجز يتضمن موعداً محجوزاً مسبقاً.',
      'err_unavailable': 'هذا الحجز يتداخل مع موعد غير متاح.',
      'err_consecutive': 'لا توجد خانات متتالية كافية ومتاحة لهذه المدة.',
      'err_outside_hours': 'يجب أن ينتهي الحجز بحلول الساعة 6:00 مساءً.',
      'err_isolated_gap': 'هذا الحجز سيترك فجوة شاغرة معزولة مدتها 30 دقيقة.',
      'toast_success_title': 'تم تأكيد الحجز',
      'toast_success_desc': 'تمت جدولة موعدك بنجاح.',
      'toast_error_title': 'تعذر تأكيد الحجز',
      'drawer_subtitle': 'جدولة ذكية للمواعيد المحلية',
      'drawer_version': 'الإصدار 1.0.0 (محلي بالكامل)',
    },
  };

  String _get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  String get appTitle => _get('app_title');
  String get appSubtitle => _get('app_subtitle');
  String get scheduleTitle => _get('schedule_title');
  String get scheduleSubtitle => _get('schedule_subtitle');
  String get workingHours => _get('working_hours');
  String get selectDuration => _get('select_duration');
  String get legendAvailable => _get('legend_available');
  String get legendBooked => _get('legend_booked');
  String get legendUnavailable => _get('legend_unavailable');
  String get legendSelected => _get('legend_selected');
  String get bookingSummary => _get('booking_summary');
  String get startTime => _get('start_time');
  String get endTime => _get('end_time');
  String get duration => _get('duration');
  String get status => _get('status');
  String get confirmBooking => _get('confirm_booking');
  String get reset => _get('reset');
  String get settings => _get('settings');
  String get appearance => _get('appearance');
  String get themeLight => _get('theme_light');
  String get themeDark => _get('theme_dark');
  String get themeSystem => _get('theme_system');
  String get language => _get('language');
  String get langEn => _get('lang_en');
  String get langAr => _get('lang_ar');
  String get msgNoSelection => _get('err_no_selection');
  String get msgBooked => _get('err_booked');
  String get msgUnavailable => _get('err_unavailable');
  String get msgConsecutive => _get('err_consecutive');
  String get msgOutsideHours => _get('err_outside_hours');
  String get msgIsolatedGap => _get('err_isolated_gap');
  String get readyToBook => _get('ready_to_book');
  String get noStartSelected => _get('no_start_selected');
  String get toastSuccessTitle => _get('toast_success_title');
  String get toastSuccessDesc => _get('toast_success_desc');
  String get toastErrorTitle => _get('toast_error_title');
  String get drawerSubtitle => _get('drawer_subtitle');
  String get drawerVersion => _get('drawer_version');

  String durationLabel(BookingDuration d) {
    switch (d) {
      case BookingDuration.minutes30:
        return isArabic ? '30 د' : '30m';
      case BookingDuration.minutes60:
        return isArabic ? '1 س' : '1h';
      case BookingDuration.minutes90:
        return isArabic ? '1.5 س' : '1.5h';
      case BookingDuration.minutes120:
        return isArabic ? '2 س' : '2h';
    }
  }

  String durationFullLabel(BookingDuration d) {
    switch (d) {
      case BookingDuration.minutes30:
        return isArabic ? '30 دقيقة' : '30 mins';
      case BookingDuration.minutes60:
        return isArabic ? 'ساعة واحدة' : '1 hour';
      case BookingDuration.minutes90:
        return isArabic ? 'ساعة ونصف' : '1h 30m';
      case BookingDuration.minutes120:
        return isArabic ? 'ساعتان' : '2 hours';
    }
  }

  String validationMessage(BookingValidationStatus status) {
    switch (status) {
      case BookingValidationStatus.valid:
        return readyToBook;
      case BookingValidationStatus.noSelection:
        return _get('err_no_selection');
      case BookingValidationStatus.bookedSlot:
        return _get('err_booked');
      case BookingValidationStatus.unavailableSlot:
        return _get('err_unavailable');
      case BookingValidationStatus.insufficientConsecutiveSlots:
        return _get('err_consecutive');
      case BookingValidationStatus.outsideWorkingHours:
        return _get('err_outside_hours');
      case BookingValidationStatus.isolatedGap:
        return _get('err_isolated_gap');
      case BookingValidationStatus.conflict:
        return _get('err_booked');
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
