import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    textTheme: AppTypography.textTheme,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  );
}
