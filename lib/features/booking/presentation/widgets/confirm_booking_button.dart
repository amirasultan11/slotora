import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

/// Primary call-to-action button for confirming an appointment.
class ConfirmBookingButton extends StatelessWidget {
  final bool isValid;
  final bool hasSelection;
  final VoidCallback onConfirm;

  const ConfirmBookingButton({
    super.key,
    required this.isValid,
    required this.hasSelection,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final bool isEnabled = hasSelection && isValid;

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: onConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppColors.primary
              : (isDark ? AppColors.darkCard : AppColors.lightBorder),
          foregroundColor: isEnabled
              ? Colors.white
              : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isEnabled
                  ? AppColors.primaryLight.withValues(alpha: 0.5)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isEnabled
                  ? Icons.check_circle_rounded
                  : Icons.lock_outline_rounded,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.confirmBooking,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
