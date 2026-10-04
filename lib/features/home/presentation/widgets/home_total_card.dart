import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import 'home_sample_data.dart';
import 'home_segmented_bar.dart';

/// The "Total Invoiced" headline card.
///
/// Stacks a label row (caption plus trend badge), the hero amount, and the
/// proportional status bar. The hero amount is stated in full with cents,
/// unlike the compact figures on the status cards below.
class HomeTotalCard extends StatelessWidget {
  const HomeTotalCard({
    super.key,
    this.total = HomeSampleData.totalInvoiced,
    this.trendPercent = HomeSampleData.trendPercent,
    this.paid = HomeSampleData.paid,
    this.pending = HomeSampleData.pending,
    this.overdue = HomeSampleData.overdue,
  });

  final double total;

  /// Month-on-month growth, shown in the trend badge. A negative or zero value
  /// is not modelled yet — the design only shows growth.
  final double trendPercent;

  final double paid;
  final double pending;
  final double overdue;

  static const Key cardKey = Key('home_total_card');
  static const Key amountKey = Key('home_total_card_amount');
  static const Key trendBadgeKey = Key('home_total_card_trend_badge');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: AppCard(
        key: cardKey,
        padding: const EdgeInsets.all(AppSpacing.lg - 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total Invoiced',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.cardLabel,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _TrendBadge(percent: trendPercent),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              Formatters.usd(total),
              key: amountKey,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.heroAmount,
            ),
            const SizedBox(height: AppSpacing.md + 4),
            HomeSegmentedBar(paid: paid, pending: pending, overdue: overdue),
          ],
        ),
      ),
    );
  }
}

/// Green pill reporting month-on-month growth, e.g. "↑ +12% this mo".
class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: HomeTotalCard.trendBadgeKey,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 4,
        vertical: AppSpacing.xs + 1,
      ),
      decoration: BoxDecoration(
        color: AppColors.trendPositiveTint,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Ionicons.arrow_up,
            size: 12,
            color: AppColors.trendPositive,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '+${percent.toStringAsFixed(0)}% this mo',
            style: AppTypography.pillLabel.copyWith(
              color: AppColors.trendPositive,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
