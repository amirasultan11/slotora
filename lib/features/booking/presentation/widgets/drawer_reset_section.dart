import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

/// Reset section in the drawer that allows restoring baseline mock schedule.
class DrawerResetSection extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;
  final VoidCallback onResetSchedule;

  const DrawerResetSection({
    super.key,
    required this.isDark,
    required this.l10n,
    required this.onResetSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkCard : AppColors.lightBg),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.isArabic
                ? 'إعادة ضبط الجدول التجريبي'
                : 'Reset Baseline Schedule',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.isArabic
                ? 'استعادة جدول المواعيد الافتراضي لاختبار سيناريوهات الحجز من جديد.'
                : 'Restores the original deterministic mock schedule for re-evaluating scenarios.',
            style: TextStyle(
              fontSize: 11.5,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              onResetSchedule();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.restore_rounded, size: 16),
            label: Text(
              l10n.isArabic
                  ? 'استعادة الجدول الأصلي'
                  : 'Restore Baseline',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(
                color: AppColors.primary,
                width: 1.2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
