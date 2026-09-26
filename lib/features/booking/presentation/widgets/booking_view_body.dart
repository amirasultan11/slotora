import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slotora/features/booking/presentation/widgets/booking_actions.dart';
import 'package:slotora/features/booking/presentation/widgets/booking_summary_card.dart';
import 'package:slotora/features/booking/presentation/widgets/duration_selector.dart';

import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import 'time_slot_list_widget.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class BookingViewBody extends StatelessWidget {
  const BookingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listenWhen: (prev, curr) => prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage!,
                style: AppTextStyles.regular14.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16.r),
            ),
          );
          context.read<BookingCubit>().clearError();
        }
      },
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const TimeSlotListWidget(),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Choose duration', style: AppTextStyles.bold18),
                SizedBox(height: 12.h),
                const DurationSelector(),
                SizedBox(height: 16.h),
                const BookingSummaryCard(),
                SizedBox(height: 16.h),
                const BookingActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
