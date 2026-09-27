import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import 'drawer_header_section.dart';
import 'drawer_language_option.dart';
import 'drawer_reset_section.dart';
import 'drawer_section_header.dart';
import 'drawer_theme_option.dart';

/// Side drawer providing appearance, language settings, and baseline reset.
class AppDrawer extends StatelessWidget {
  final VoidCallback onResetSchedule;

  const AppDrawer({super.key, required this.onResetSchedule});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final themeState = context.watch<ThemeCubit>().state;
    final localeState = context.watch<LocaleCubit>().state;

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeaderSection(isDark: isDark, l10n: l10n),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                children: [
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
                    isSelected: themeState.themeMode == ThemeMode.light,
                    isDark: isDark,
                    onSelect: context.read<ThemeCubit>().setThemeMode,
                  ),
                  DrawerThemeOption(
                    title: l10n.themeDark,
                    icon: Icons.dark_mode_rounded,
                    mode: ThemeMode.dark,
                    isSelected: themeState.themeMode == ThemeMode.dark,
                    isDark: isDark,
                    onSelect: context.read<ThemeCubit>().setThemeMode,
                  ),
                  DrawerThemeOption(
                    title: l10n.themeSystem,
                    icon: Icons.brightness_auto_rounded,
                    mode: ThemeMode.system,
                    isSelected: themeState.themeMode == ThemeMode.system,
                    isDark: isDark,
                    onSelect: context.read<ThemeCubit>().setThemeMode,
                  ),

                  const SizedBox(height: 24),

                  DrawerSectionHeader(
                    title: l10n.language,
                    icon: Icons.language_rounded,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  DrawerLanguageOption(
                    title: l10n.langEn,
                    locale: const Locale('en'),
                    isSelected: !localeState.isArabic,
                    isDark: isDark,
                    onSelect: context.read<LocaleCubit>().setLocale,
                  ),
                  DrawerLanguageOption(
                    title: l10n.langAr,
                    locale: const Locale('ar'),
                    isSelected: localeState.isArabic,
                    isDark: isDark,
                    onSelect: context.read<LocaleCubit>().setLocale,
                  ),

                  const SizedBox(height: 24),

                  DrawerResetSection(
                    isDark: isDark,
                    l10n: l10n,
                    onResetSchedule: onResetSchedule,
                  ),
                ],
              ),
            ),
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
