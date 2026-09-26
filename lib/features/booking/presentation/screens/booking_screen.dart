import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../widgets/booking_header.dart';
import '../widgets/duration_selector.dart';
import '../widgets/slot_grid.dart';
import '../widgets/booking_actions.dart';

import '../widgets/booking_summary_card.dart';
import '../../../../core/utils/app_text_styles.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Slotora Booking')),
        body: BlocListener<BookingCubit, BookingState>(
          listenWhen: (prev, curr) => prev.errorMessage != curr.errorMessage,
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              context.read<BookingCubit>().clearError();
            }
          },
          child: ListView(
            padding: EdgeInsets.all(16.r),
            children: [
              const BookingHeader(),
              SizedBox(height: 24.h),
              Text('1. Select Duration', style: AppTextStyles.bold18),
              SizedBox(height: 12.h),
              const DurationSelector(),
              SizedBox(height: 30.h),
              Text('2. Select Start Time', style: AppTextStyles.bold18),
              SizedBox(height: 12.h),

              SizedBox(height: 16.h),
              const SlotGrid(),
              SizedBox(height: 24.h),
              const BookingSummaryCard(),
              SizedBox(height: 24.h),
              const BookingActions(),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
