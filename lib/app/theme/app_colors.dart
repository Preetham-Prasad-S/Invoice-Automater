import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color(0xFF3B5BFF);
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B5BFF), Color(0xFF5B7CFF)],
  );
  static const Color success = Color(0xFF22C55E);
  static const Color surfaceMuted = Color(0xFFF1F2F7);
  static const Color border = Color(0xFFE6E8F0);
  static const Color textPrimary = Color(0xFF0B0B14);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9AA0AE);
  static const Color track = Color(0xFFE8EAF2);
  static const Color trail = Color(0xFFA5B4FC);
  static const Color backgroundStart = Color(0xFFF8F9FE);
  static const Color backgroundEnd = Color(0xFFFBFBFD);
}
