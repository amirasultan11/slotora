import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (!state.hasSelection) return const SizedBox.shrink();

        return Card(
          color: AppColors.secondary.withValues(alpha: 0.2),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected Time', style: AppTextStyles.regular14),
                    SizedBox(height: 4.h),
                    Text(
                      '${state.selectedStartLabel} - ${state.selectedEndLabel}',
                      style: AppTextStyles.semiBold16,
                    ),
                  ],
                ),
                Text(
                  state.selectedDuration.label,
                  style: AppTextStyles.bold18.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
