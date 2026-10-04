import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import 'home_sample_data.dart';

/// The three status cards that split the total: Paid, Pending and Overdue.
///
/// Figures are shown compactly — whole currency units with no cents — because
/// at card size the decimals are noise, unlike the hero total above.
class HomeStatusSummary extends StatelessWidget {
  const HomeStatusSummary({
    super.key,
    this.paid = HomeSampleData.paid,
    this.pending = HomeSampleData.pending,
    this.overdue = HomeSampleData.overdue,
  });

  final double paid;
  final double pending;
  final double overdue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      // IntrinsicHeight gives the Row a bounded height so the cards can be
      // stretched to match each other. The scroll view cannot supply one, and
      // a bare `stretch` row there would ask for infinite height.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _StatusCard(
                label: 'Paid',
                amount: paid,
                dotColor: AppColors.statusPaid,
              ),
            ),
            const SizedBox(width: AppSpacing.md - 4),
            Expanded(
              child: _StatusCard(
                label: 'Pending',
                amount: pending,
                dotColor: AppColors.statusPending,
              ),
            ),
            const SizedBox(width: AppSpacing.md - 4),
            Expanded(
              child: _StatusCard(
                label: 'Overdue',
                amount: overdue,
                dotColor: AppColors.statusOverdue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single status card: coloured dot and label above the amount.
///
/// Private to this file — nothing else renders one, and pulling it out would
/// only give it a name that has to be kept in sync with this row.
class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.label,
    required this.amount,
    required this.dotColor,
  });

  final String label;
  final double amount;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadii.chip,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md - 4,
        vertical: AppSpacing.sm + 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.cardLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              Formatters.usdCompact(amount),
              style: AppTypography.statusAmount,
            ),
          ),
        ],
      ),
    );
  }
}
