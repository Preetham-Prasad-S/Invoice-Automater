import 'package:flutter/material.dart';

class AppTypography {
  static const String _fontFamily = 'Quicksand';

  static TextTheme textTheme = const TextTheme(
    displaySmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 34,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: Color(0xFF0B0B14),
      height: 1.1,
    ),
    bodyMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 15.5,
      fontWeight: FontWeight.w400,
      color: Color(0xFF6B7280),
      height: 1.5,
    ),
    labelMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Color(0xFF3A3F52),
      height: 1.2,
    ),
    bodySmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFF9AA0AE),
      height: 1.2,
    ),
    labelSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFFB6BAC6),
      height: 1.2,
    ),
  );
}
