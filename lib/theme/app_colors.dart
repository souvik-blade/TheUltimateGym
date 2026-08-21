import 'package:flutter/material.dart';

/// Core palette for Glacy UI — dark glass surfaces with an orange accent.
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF121214);
  static const Color backgroundAlt = Color(0xFF1A1A1D);

  // Accent
  static const Color orange = Color(0xFFFF7A30);
  static const Color orangeSoft = Color(0xFFFFB07A);

  // Glass surface
  static const Color glassFill = Color(0x1FFFFFFF); // white @ 12%
  static const Color glassBorder = Color(0x26FFFFFF); // white @ 15%

  // Text
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFFA1A1AA);

  static const List<Color> backgroundGradient = [
    Color(0xFF17130F),
    Color(0xFF121214),
    Color(0xFF0E0E10),
  ];

  static const List<Color> orangeGradient = [orange, orangeSoft];
}
