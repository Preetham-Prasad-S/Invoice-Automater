import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class SplashHeroText extends StatelessWidget {
  const SplashHeroText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Invoicely',
          style: AppTypography.textTheme.displaySmall,
        ),
        const SizedBox(height: 10),
        Text(
          'Smart invoicing for modern creators\nand businesses.',
          textAlign: TextAlign.center,
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
