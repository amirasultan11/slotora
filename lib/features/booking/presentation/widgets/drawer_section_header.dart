import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Section header displaying an icon and category title in the drawer.
class DrawerSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDark;

  const DrawerSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
