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
      bgColor = AppColors.error.withValues(alpha: 0.2);
      textColor = AppColors.error;
    } else if (slot.status == SlotStatus.unavailable) {
      bgColor = Colors.grey.withValues(alpha: 0.2);
      textColor = Colors.grey;
    } else if (isSelectedRange) {
      bgColor = AppColors.primary;
      textColor = Colors.white;
    } else if (!isValidStart) {
      bgColor = Colors.grey.withValues(alpha: 0.1);
      textColor = Colors.grey;
    } else {
      borderColor = AppColors.border;
    }

    final isClickable = slot.status == SlotStatus.available && isValidStart;

    return InkWell(
      onTap: isClickable ? onTap : null,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          slot.label,
          style: AppTextStyles.semiBold16.copyWith(color: textColor),
        ),
      ),
    );
  }
}
