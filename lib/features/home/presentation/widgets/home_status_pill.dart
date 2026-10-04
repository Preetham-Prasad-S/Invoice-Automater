import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import 'home_sample_data.dart';

/// Status pill showing invoice status with colored dot and label.
///
/// Used in the invoice list tiles. Colors and text match the reference.
class HomeStatusPill extends StatelessWidget {
  const HomeStatusPill({super.key, required this.status});

  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color dotColor;
    late final Color bgColor;
    late final Color textColor;
    late final String label;

    switch (status) {
      case InvoiceStatus.paid:
        dotColor = AppColors.statusPaid;
        bgColor = AppColors.statusPaidTint;
        textColor = AppColors.statusPaid;
        label = 'Paid';
        break;
      case InvoiceStatus.pending:
        dotColor = AppColors.statusPending;
        bgColor = AppColors.statusPendingTint;
        textColor = AppColors.statusPending;
        label = 'Pending';
        break;
      case InvoiceStatus.overdue:
        dotColor = AppColors.statusOverdue;
        bgColor = AppColors.statusOverdueTint;
        textColor = AppColors.statusOverdue;
        label = 'Overdue';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.pillLabel.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
