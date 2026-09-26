import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/app_scope.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/localization_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'data/local/local_schedule_data_source.dart';
import 'data/repositories/booking_repository_impl.dart';
import 'features/booking/presentation/views/splash_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final themeController = ThemeController();
  final localizationController = LocalizationController();
  final scheduleDataSource = LocalScheduleDataSource();
  final bookingRepository = BookingRepositoryImpl(dataSource: scheduleDataSource);

  runApp(
    SlotoraApp(
      themeController: themeController,
      localizationController: localizationController,
      bookingRepository: bookingRepository,
    ),
  );
}

/// Root application widget configuring Theme, Localization, and AppScope.
class SlotoraApp extends StatelessWidget {
  final ThemeController themeController;
  final LocalizationController localizationController;
  final BookingRepositoryImpl bookingRepository;

  const SlotoraApp({
    super.key,
    required this.themeController,
    required this.localizationController,
    required this.bookingRepository,
  });

  @override
  Widget build(BuildContext context) {
    return AppScope(
      themeController: themeController,
      localizationController: localizationController,
      bookingRepository: bookingRepository,
      child: ListenableBuilder(
        listenable: Listenable.merge([themeController, localizationController]),
        builder: (context, _) {
          return MaterialApp(
            title: 'Slotora',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,
            locale: localizationController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashView(),
          );
        },
      ),
    );
  }
}
