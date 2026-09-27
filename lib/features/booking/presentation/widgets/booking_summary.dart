import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../features/booking/domain/entities/booking_duration.dart';
import '../../../../features/booking/domain/entities/booking_validation_result.dart';
import 'booking_metric_tile.dart';
import 'booking_status_badge.dart';
import 'booking_validation_banner.dart';

/// Live booking summary card displaying dynamic Start, End, Duration, and Validation Status.
class BookingSummary extends StatelessWidget {
  final DateTime? startTime;
  final DateTime? endTime;
  final BookingDuration duration;
  final BookingValidationResult validationResult;

  const BookingSummary({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.validationResult,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final startStr = startTime != null
        ? TimeFormatter.formatTime(startTime!, isArabic: l10n.isArabic)
        : '—';
    final endStr = endTime != null
        ? TimeFormatter.formatTime(endTime!, isArabic: l10n.isArabic)
        : '—';
    final durationStr = l10n.durationFullLabel(duration);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _getCardBorderColor(isDark), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.bookingSummary,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              BookingStatusBadge(
                hasSelection: startTime != null,
                validationResult: validationResult,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3-Column Summary metrics (Start, End, Duration)
          Row(
            children: [
              BookingMetricTile(
                title: l10n.startTime,
                value: startStr,
                icon: Icons.login_rounded,
                isDark: isDark,
              ),
              BookingMetricDivider(isDark: isDark),
              BookingMetricTile(
                title: l10n.endTime,
                value: endStr,
                icon: Icons.logout_rounded,
                isDark: isDark,
              ),
              BookingMetricDivider(isDark: isDark),
              BookingMetricTile(
                title: l10n.duration,
                value: durationStr,
                icon: Icons.timelapse_rounded,
                isDark: isDark,
              ),
            ],
          ),

          // Explanatory error / guidance message if not valid
          if (startTime != null && !validationResult.isValid) ...[
            const SizedBox(height: 12),
            BookingValidationBanner(validationResult: validationResult),
          ] else if (startTime == null) ...[
            const SizedBox(height: 10),
            Text(
              l10n.noStartSelected,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getCardBorderColor(bool isDark) {
    if (startTime == null) {
      return isDark ? AppColors.darkBorder : AppColors.lightBorder;
    }
    if (validationResult.isValid) {
      return isDark
          ? AppColors.availableDark.withValues(alpha: 0.5)
          : AppColors.availableLight.withValues(alpha: 0.5);
    }
    return AppColors.error.withValues(alpha: 0.4);
  }
}
