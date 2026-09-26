import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/time_slot.dart';
import '../../domain/models/slot_status.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class SlotTile extends StatelessWidget {
  final TimeSlot slot;
  final bool isValidStart;
  final bool isSelectedRange;
  final VoidCallback onTap;

  const SlotTile({
    super.key,
    required this.slot,
    required this.isValidStart,
    required this.isSelectedRange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = AppColors.surface;
    Color textColor = AppColors.textPrimary;
    Color borderColor = Colors.transparent;

    if (slot.status == SlotStatus.booked) {
      bgColor = AppColors.error.withValues(alpha: 0.15);
      textColor = AppColors.error;
    } else if (slot.status == SlotStatus.unavailable) {
      bgColor = Colors.grey.withValues(alpha: 0.1);
      textColor = Colors.grey;
    } else if (isSelectedRange) {
      bgColor = AppColors.primary;
      textColor = Colors.white;
    } else if (!isValidStart) {
      bgColor = Colors.grey.withValues(alpha: 0.05);
      textColor = Colors.white38;
    } else {
      borderColor = AppColors.border;
    }

    final isClickable = (slot.status == SlotStatus.available && isValidStart) || isSelectedRange;

    return InkWell(
      onTap: isClickable ? onTap : null,
      borderRadius: BorderRadius.circular(24.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelectedRange ? AppColors.primary : borderColor, 
            width: isSelectedRange ? 2 : 1
          ),
          boxShadow: isSelectedRange ? [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3), 
              blurRadius: 8, 
              spreadRadius: 1
            )
          ] : [],
        ),
        child: Text(
          slot.label,
          style: AppTextStyles.semiBold16.copyWith(color: textColor),
        ),
      ),
    );
  }
}
