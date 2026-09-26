import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../../domain/models/booking_duration.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class DurationSelector extends StatelessWidget {
  const DurationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (prev, curr) => prev.selectedDuration != curr.selectedDuration,
      builder: (context, state) {
        return Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: BookingDuration.values.map((duration) {
            final isSelected = state.selectedDuration == duration;
            return ChoiceChip(
              label: Text(duration.label),
              selected: isSelected,
              onSelected: (_) => context.read<BookingCubit>().changeDuration(duration),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface.withValues(alpha: 0.5),
              showCheckmark: false,
              labelStyle: isSelected 
                  ? AppTextStyles.semiBold16.copyWith(color: Colors.white)
                  : AppTextStyles.regular14,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
                side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
