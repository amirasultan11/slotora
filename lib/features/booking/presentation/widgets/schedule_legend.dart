import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

/// Semantic status legend showing Available, Selected, Booked, Unavailable.
class ScheduleLegend extends StatelessWidget {
  final bool isDark;

  const ScheduleLegend({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCard.withValues(alpha: 0.5)
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 6,
        children: [
          ScheduleLegendItem(
            color: isDark ? AppColors.availableDark : AppColors.availableLight,
            label: l10n.legendAvailable,
            icon: Icons.radio_button_unchecked_rounded,
            isDark: isDark,
          ),
          ScheduleLegendItem(
            color: AppColors.primary,
            label: l10n.legendSelected,
            icon: Icons.check_circle_rounded,
            isDark: isDark,
          ),
          ScheduleLegendItem(
            color: isDark ? AppColors.bookedDark : AppColors.bookedLight,
            label: l10n.legendBooked,
            icon: Icons.lock_outline_rounded,
            isDark: isDark,
          ),
          ScheduleLegendItem(
            color:
                isDark ? AppColors.unavailableDark : AppColors.unavailableLight,
            label: l10n.legendUnavailable,
            icon: Icons.block_flipped,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

/// An individual status indicator item inside the schedule legend.
class ScheduleLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;
  final bool isDark;

  const ScheduleLegendItem({
    super.key,
    required this.color,
    required this.label,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
