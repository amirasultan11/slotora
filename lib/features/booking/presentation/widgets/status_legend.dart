import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class StatusLegend extends StatelessWidget {
  const StatusLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const _LegendItem(color: AppColors.surface, text: 'Available'),
        const _LegendItem(color: AppColors.primary, text: 'Selected'),
        const _LegendItem(color: AppColors.secondary, text: 'Booked'),
        _LegendItem(color: Colors.grey.withOpacity(0.3), text: 'Unavailable'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 6.r, backgroundColor: color),
        SizedBox(width: 6.w),
        Text(text, style: AppTextStyles.regular12),
      ],
    );
  }
}
