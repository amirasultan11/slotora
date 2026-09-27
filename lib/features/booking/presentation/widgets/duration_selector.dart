import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/booking/domain/entities/booking_duration.dart';
import 'duration_option_tile.dart';

/// Duration selector component allowing users to choose between 30m, 1h, 1.5h, 2h.
class DurationSelector extends StatelessWidget {
  final BookingDuration selectedDuration;
  final ValueChanged<BookingDuration> onDurationChanged;

  const DurationSelector({
    super.key,
    required this.selectedDuration,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.selectDuration,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                letterSpacing: -0.2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.slotCountLabel(selectedDuration.requiredSlotCount),
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: BookingDuration.values.map((duration) {
            return DurationOptionTile(
              duration: duration,
              isSelected: selectedDuration == duration,
              isDark: isDark,
              onSelect: onDurationChanged,
            );
          }).toList(),
        ),
      ],
    );
  }
}
