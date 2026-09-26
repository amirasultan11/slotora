import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slotora/core/theme/app_theme.dart';
import 'package:slotora/features/booking/presentation/screens/booking_screen.dart';

void main() {
  runApp(const SlotoraApp());
}

class SlotoraApp extends StatelessWidget {
  const SlotoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Slotora Booking',
          theme: AppTheme.darkTheme,
          home: const BookingScreen(),
        );
      },
    );
  }
}
