import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: AppConstants.appFamilyFont,
  scaffoldBackgroundColor: AppColors.lightBackground,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.primaryLight,
    surface: AppColors.lightSurface,
    error: AppColors.error,
    onSurface: AppColors.lightTextPrimary,
    onSurfaceVariant: AppColors.lightTextSecondary,
    outline: AppColors.lightBorder,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.lightBackground,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
    titleTextStyle: AppTextStyles.bold20.copyWith(color: AppColors.lightTextPrimary),
  ),
  cardTheme: CardThemeData(
    color: AppColors.lightSurface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: AppColors.lightBorder),
    ),
  ),
);
