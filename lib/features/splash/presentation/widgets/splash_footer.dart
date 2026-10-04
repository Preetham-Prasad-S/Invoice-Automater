import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class SplashFooter extends StatelessWidget {
  const SplashFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Ionicons.lock_closed_outline,
              size: 16,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: 6),
            Text(
              'Bank-grade 256-bit encryption',
              style: AppTypography.textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'v2.4.0',
          style: AppTypography.textTheme.labelSmall,
        ),
      ],
    );
  }
}
