import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Single metric column displayed inside the booking summary card.
class BookingMetricTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isDark;

  const BookingMetricTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 13,
                color:
                    isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Subtle vertical divider placed between metric tiles.
class BookingMetricDivider extends StatelessWidget {
  final bool isDark;

  const BookingMetricDivider({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
    );
  }
}
