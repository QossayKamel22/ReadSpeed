import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.green,
        secondary: AppColors.greenBright,
        surface: AppColors.card,
        background: AppColors.background,
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      dividerColor: AppColors.border,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.green,
        inactiveTrackColor: AppColors.border,
        thumbColor: AppColors.greenBright,
        overlayColor: AppColors.green.withOpacity(0.15),
        trackHeight: 4,
      ),
    );
  }
}
