import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const background = Color(0xFF070A09);
  static const backgroundSecondary = Color(0xFF0D1210);
  static const card = Color(0xFF111715);
  static const cardElevated = Color(0xFF151B18);

  static const green = Color(0xFF22E06F);
  static const greenBright = Color(0xFF35F27C);
  static const greenMuted = Color(0xFF0F6B3A);

  static const textPrimary = Color(0xFFF5F7F6);
  static const textSecondary = Color(0xFFA7B0AB);
  static const textMuted = Color(0xFF68736D);

  static const border = Color(0x12FFFFFF); // rgba(255,255,255,0.07)

  static const danger = Color(0xFFE0524B);

  static const greenGlow = [
    BoxShadow(
      color: Color(0x2622E06F),
      blurRadius: 24,
      spreadRadius: -4,
    ),
  ];
}
