import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base = GoogleFonts.inter();

  static TextStyle get display => _base.copyWith(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -1,
        height: 1.1,
      );

  static TextStyle get h1 => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get h2 => _base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.3,
      );

  static TextStyle get h3 => _base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get body => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySecondary => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get caption => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
        letterSpacing: 0.2,
      );

  static TextStyle get numberLarge => _base.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -1,
      );

  static TextStyle get numberGreen => _base.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: AppColors.green,
        letterSpacing: -1,
      );

  static TextStyle get button => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      );
}
