import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Section header for "Recent Invoices" with "See all" link.
///
/// Layout matches the reference: title left, "See all" right-aligned.
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.actionLabel = 'See all',
    this.onActionPressed,
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.sectionTitle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          TextButton(
            onPressed: onActionPressed,
            child: Text(
              actionLabel,
              style: AppTypography.cardLabel.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
