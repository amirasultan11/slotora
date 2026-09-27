import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../features/booking/domain/entities/time_slot_entity.dart';

/// Interactive tile representing a 30-minute time slot with multi-attribute semantic states.
class TimeSlotTile extends StatelessWidget {
  final TimeSlotEntity slot;
  final bool isSelected;
  final bool isSelectedStart;
  final bool isValidStart;
  final VoidCallback onTap;

  const TimeSlotTile({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.isSelectedStart,
    required this.isValidStart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final timeStr = TimeFormatter.formatSlotId(
      slot.id,
      isArabic: l10n.isArabic,
    );

    // Multi-attribute styling configuration
    Color bgColor;
    Color borderColor;
    Color textColor;
    Color statusColor;
    IconData iconData;
    String statusLabel;
    double opacity = 1.0;

    if (isSelected) {
      bgColor = isDark ? AppColors.selectedDarkBg : AppColors.selectedLightBg;
      borderColor = AppColors.primary;
      textColor = isDark ? Colors.white : AppColors.primaryDark;
      statusColor = AppColors.primary;
      iconData = isSelectedStart
          ? Icons.flag_rounded
          : Icons.check_circle_rounded;
      statusLabel = l10n.legendSelected;
    } else if (slot.isBooked) {
      bgColor = isDark
          ? AppColors.bookedDarkBg.withValues(alpha: 0.4)
          : AppColors.bookedLightBg;
      borderColor = isDark
          ? AppColors.bookedDark.withValues(alpha: 0.3)
          : AppColors.bookedLight.withValues(alpha: 0.3);
      textColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
      statusColor = isDark ? AppColors.bookedDark : AppColors.bookedLight;
      iconData = Icons.lock_outline_rounded;
      statusLabel = l10n.legendBooked;
      opacity = 0.72;
    } else if (slot.isUnavailable) {
      bgColor = isDark
          ? AppColors.unavailableDarkBg.withValues(alpha: 0.3)
          : AppColors.unavailableLightBg;
      borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
      textColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
      statusColor = isDark
          ? AppColors.unavailableDark
          : AppColors.unavailableLight;
      iconData = Icons.block_flipped;
      statusLabel = l10n.legendUnavailable;
      opacity = 0.65;
    } else {
      // Available
      bgColor = isDark ? AppColors.darkCard : AppColors.lightSurface;
      borderColor = isValidStart
          ? (isDark
                ? AppColors.availableDark.withValues(alpha: 0.4)
                : AppColors.availableLight.withValues(alpha: 0.4))
          : (isDark ? AppColors.darkBorder : AppColors.lightBorder);
      textColor = isDark
          ? AppColors.darkTextPrimary
          : AppColors.lightTextPrimary;
      statusColor = isDark ? AppColors.availableDark : AppColors.availableLight;
      iconData = isValidStart
          ? Icons.radio_button_unchecked_rounded
          : Icons.schedule_rounded;
      statusLabel = l10n.legendAvailable;
    }

    final isClickable = slot.isAvailable;

    return Opacity(
      opacity: opacity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isClickable ? onTap : null,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  // Semantic Status Icon
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(iconData, size: 16, color: statusColor),
                  ),
                  const SizedBox(width: 8),

                  // Slot Time and Status Label
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Row(
                          children: [
                            Text(
                              statusLabel,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                            if (slot.isAvailable &&
                                !isValidStart &&
                                !isSelected) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 11,
                                color: AppColors.warning,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Selection indicator dot or start badge
                  if (isSelectedStart)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        l10n.startLabel,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    )
                  else if (isSelected)
                    const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
