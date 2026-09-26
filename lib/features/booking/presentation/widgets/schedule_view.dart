import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/time_slot.dart';
import 'schedule_legend.dart';
import 'time_slot_tile.dart';

/// Renders the day schedule grid with semantic status legend.
class ScheduleView extends StatelessWidget {
  final List<TimeSlot> slots;
  final DateTime? selectedStart;
  final List<TimeSlot> selectedSlots;
  final Set<DateTime> validStartTimes;
  final ValueChanged<DateTime> onSelectSlot;

  const ScheduleView({
    super.key,
    required this.slots,
    required this.selectedStart,
    required this.selectedSlots,
    required this.validStartTimes,
    required this.onSelectSlot,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final selectedIds = {for (final s in selectedSlots) s.id};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title & Working Hours Notice
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.scheduleTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.workingHours,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Semantic Status Legend
        ScheduleLegend(isDark: isDark),

        const SizedBox(height: 12),

        // Grid of 30-minute Slots
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            final childAspectRatio = constraints.maxWidth > 360 ? 2.6 : 2.4;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: slots.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                final slot = slots[index];
                final isSelected = selectedIds.contains(slot.id);
                final isSelectedStart = selectedStart != null &&
                    selectedStart!.isAtSameMomentAs(slot.startTime);
                final isValidStart = validStartTimes.any(
                  (start) => start.isAtSameMomentAs(slot.startTime),
                );

                return TimeSlotTile(
                  slot: slot,
                  isSelected: isSelected,
                  isSelectedStart: isSelectedStart,
                  isValidStart: isValidStart,
                  onTap: () => onSelectSlot(slot.startTime),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
