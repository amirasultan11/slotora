import 'package:flutter/material.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/localization_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import 'drawer_header_section.dart';
import 'drawer_language_option.dart';
import 'drawer_reset_section.dart';
import 'drawer_section_header.dart';
import 'drawer_theme_option.dart';

/// Side drawer providing appearance, language settings, and branding.
class AppDrawer extends StatelessWidget {
  final ThemeController themeController;
  final LocalizationController localizationController;
  final VoidCallback onResetSchedule;

  const AppDrawer({
    super.key,
    required this.themeController,
    required this.localizationController,
    required this.onResetSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Header with SVG Logo
            DrawerHeaderSection(isDark: isDark, l10n: l10n),

            // Settings Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                children: [
                  // Appearance Section
                  DrawerSectionHeader(
                    title: l10n.appearance,
                    icon: Icons.palette_outlined,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  DrawerThemeOption(
                    title: l10n.themeLight,
                    icon: Icons.light_mode_rounded,
                    mode: ThemeMode.light,
                    isSelected: themeController.themeMode == ThemeMode.light,
                    isDark: isDark,
                    onSelect: themeController.setThemeMode,
                  ),
                  DrawerThemeOption(
                    title: l10n.themeDark,
                    icon: Icons.dark_mode_rounded,
                    mode: ThemeMode.dark,
                    isSelected: themeController.themeMode == ThemeMode.dark,
                    isDark: isDark,
                    onSelect: themeController.setThemeMode,
                  ),
                  DrawerThemeOption(
                    title: l10n.themeSystem,
                    icon: Icons.brightness_auto_rounded,
                    mode: ThemeMode.system,
                    isSelected: themeController.themeMode == ThemeMode.system,
                    isDark: isDark,
                    onSelect: themeController.setThemeMode,
                  ),

                  const SizedBox(height: 24),

                  // Language Section
                  DrawerSectionHeader(
                    title: l10n.language,
                    icon: Icons.language_rounded,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  DrawerLanguageOption(
                    title: l10n.langEn,
                    locale: const Locale('en'),
                    isSelected: !localizationController.isArabic,
                    isDark: isDark,
                    onSelect: localizationController.setLocale,
                  ),
                  DrawerLanguageOption(
                    title: l10n.langAr,
                    locale: const Locale('ar'),
                    isSelected: localizationController.isArabic,
                    isDark: isDark,
                    onSelect: localizationController.setLocale,
                  ),

                  const SizedBox(height: 24),

                  // Reset Demo Baseline action
                  DrawerResetSection(
                    isDark: isDark,
                    l10n: l10n,
                    onResetSchedule: onResetSchedule,
                  ),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                l10n.drawerVersion,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
