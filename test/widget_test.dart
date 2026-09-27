import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:slotora/core/di/injection_container.dart';
import 'package:slotora/core/localization/locale_cubit.dart';
import 'package:slotora/core/theme/theme_cubit.dart';
import 'package:slotora/features/booking/data/datasources/local_schedule_data_source.dart';
import 'package:slotora/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:slotora/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:slotora/features/booking/presentation/views/booking_view.dart';
import 'package:slotora/main.dart';

void main() {
  setUp(() {
    // Reset GetIt before each test to ensure clean state
    if (GetIt.instance.isRegistered<ThemeCubit>()) {
      GetIt.instance.reset();
    }
    configureDependencies();
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('SlotoraApp smoke and splash to main view test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SlotoraApp());

    // Initial frame shows SplashView with loading indicator
    expect(find.byType(CircularProgressIndicator), findsWidgets);

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

  testWidgets('Test 10: Theme switching Light -> Dark -> System', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SlotoraApp());

    await tester.pump(const Duration(milliseconds: 2800));
    await tester.pumpAndSettle();

    // Open Drawer
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Appearance'), findsOneWidget);

    final themeCubit = GetIt.instance<ThemeCubit>();

    // Switch to Dark
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(themeCubit.state.themeMode, ThemeMode.dark);

    // Switch to Light
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(themeCubit.state.themeMode, ThemeMode.light);

    // Switch to System
    await tester.tap(find.text('System Default'));
    await tester.pumpAndSettle();
    expect(themeCubit.state.themeMode, ThemeMode.system);
  });

  testWidgets(
    'Test 11: Language switching English -> Arabic supports RTL and translations',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SlotoraApp());

      await tester.pump(const Duration(milliseconds: 2800));
      await tester.pumpAndSettle();

      // Open Drawer
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Language'), findsOneWidget);

      final localeCubit = GetIt.instance<LocaleCubit>();

      // Switch to Arabic
      await tester.tap(find.text('العربية (Arabic)'));
      await tester.pumpAndSettle();

      expect(localeCubit.state.locale.languageCode, 'ar');
      expect(localeCubit.state.isArabic, isTrue);

      // Verify Arabic translations appear
      expect(find.text('جدول اليوم'), findsOneWidget);
      expect(find.text('ملخص الحجز'), findsOneWidget);
      expect(find.text('تأكيد الحجز'), findsOneWidget);

      // Check RTL text direction
      final BuildContext context = tester.element(find.byType(BookingView));
      expect(Directionality.of(context), TextDirection.rtl);
    },
  );

  testWidgets('BookingCubit resetSchedule restores baseline', (
    WidgetTester tester,
  ) async {
    final dataSource = LocalScheduleDataSource();
    final repository = BookingRepositoryImpl(dataSource: dataSource);
    final cubit = BookingCubit(repository: repository);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: cubit, child: const Text('test')),
      ),
    );

    // Select something
    final slot = repository.getSchedule().first;
    cubit.selectStartTime(slot.startTime);
    expect(cubit.state.hasSelection, isTrue);

    // Reset schedule
    cubit.resetSchedule();
    expect(cubit.state.selectedStart, isNull);
    expect(cubit.state.selectedSlots, isEmpty);
  });
}
