import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  static TextStyle get bold20 => TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bold18 => TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get semiBold16 => TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get regular16 => TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get regular14 => TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      );
      
  static TextStyle get regular12 => TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      );
}
