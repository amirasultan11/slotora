import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slotora/core/localization/localization_controller.dart';
import 'package:slotora/core/theme/theme_controller.dart';
import 'package:slotora/data/local/local_schedule_data_source.dart';
import 'package:slotora/data/repositories/booking_repository_impl.dart';
import 'package:slotora/features/booking/presentation/views/booking_view.dart';
import 'package:slotora/main.dart';

void main() {
  testWidgets('SlotoraApp smoke and splash to main view test', (WidgetTester tester) async {
    final themeController = ThemeController();
    final localizationController = LocalizationController();
    final dataSource = LocalScheduleDataSource();
    final repository = BookingRepositoryImpl(dataSource: dataSource);

    await tester.pumpWidget(
      SlotoraApp(
        themeController: themeController,
        localizationController: localizationController,
        bookingRepository: repository,
      ),
    );

    // Initial frame shows SplashView
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Pump past splash duration (2100ms + transition 600ms)
    await tester.pump(const Duration(milliseconds: 2800));
    await tester.pumpAndSettle();

    // Now BookingView is visible
    expect(find.byType(BookingView), findsOneWidget);
    expect(find.text("Today's Schedule"), findsOneWidget);
    expect(find.text('Select Duration'), findsOneWidget);
    expect(find.text('Booking Summary'), findsOneWidget);
    expect(find.text('Confirm Booking'), findsOneWidget);
  });

  testWidgets('Test 10: Theme switching Light -> Dark -> System', (WidgetTester tester) async {
    final themeController = ThemeController();
    final localizationController = LocalizationController();
    final dataSource = LocalScheduleDataSource();
    final repository = BookingRepositoryImpl(dataSource: dataSource);

    await tester.pumpWidget(
      SlotoraApp(
        themeController: themeController,
        localizationController: localizationController,
        bookingRepository: repository,
      ),
    );

    await tester.pump(const Duration(milliseconds: 2800));
    await tester.pumpAndSettle();

    // Open Drawer
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Appearance'), findsOneWidget);

    // Switch to Dark
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(themeController.themeMode, ThemeMode.dark);

    // Switch to Light
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(themeController.themeMode, ThemeMode.light);

    // Switch to System
    await tester.tap(find.text('System Default'));
    await tester.pumpAndSettle();
    expect(themeController.themeMode, ThemeMode.system);
  });

  testWidgets('Test 11: Language switching English -> Arabic supports RTL and translations', (WidgetTester tester) async {
    final themeController = ThemeController();
    final localizationController = LocalizationController();
    final dataSource = LocalScheduleDataSource();
    final repository = BookingRepositoryImpl(dataSource: dataSource);

    await tester.pumpWidget(
      SlotoraApp(
        themeController: themeController,
        localizationController: localizationController,
        bookingRepository: repository,
      ),
    );

    await tester.pump(const Duration(milliseconds: 2800));
    await tester.pumpAndSettle();

    // Open Drawer
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsOneWidget);

    // Switch to Arabic
    await tester.tap(find.text('العربية (Arabic)'));
    await tester.pumpAndSettle();

    expect(localizationController.locale.languageCode, 'ar');
    expect(localizationController.isArabic, isTrue);

    // Verify Arabic translations appear
    expect(find.text('جدول اليوم'), findsOneWidget);
    expect(find.text('ملخص الحجز'), findsOneWidget);
    expect(find.text('تأكيد الحجز'), findsOneWidget);

    // Check RTL text direction
    final BuildContext context = tester.element(find.byType(BookingView));
    expect(Directionality.of(context), TextDirection.rtl);
  });
}
