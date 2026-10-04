import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_progress_segments.dart';
import 'home_sample_data.dart';

/// The proportional breakdown of the dashboard total by payment status.
///
/// Wraps [AppProgressSegments] with the design's segment colours so callers
/// only deal in amounts. The slices are deliberately computed from the same
/// three figures the status cards display — in the reference the bar is a
/// readout of the totals, not a decorative stripe: paid is 69.7% of the bar,
/// pending 21.7% and overdue 8.6%.
class HomeSegmentedBar extends StatelessWidget {
  const HomeSegmentedBar({
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
    final total = HomeSampleData.totalOf(
      paid: paid,
      pending: pending,
      overdue: overdue,
    );

    return AppProgressSegments(
      segments: [
        ProgressSegment(weight: paid, color: AppColors.barPaid),
        ProgressSegment(weight: pending, color: AppColors.barPending),
        ProgressSegment(weight: overdue, color: AppColors.barOverdue),
      ],
      height: 8,
      gap: 2.5,
      semanticsLabel:
          total <= 0
              ? 'No invoices'
              : 'Paid ${_percent(paid, total)}, '
                  'Pending ${_percent(pending, total)}, '
                  'Overdue ${_percent(overdue, total)}',
    );
  }

  /// Percentage of [total], rounded to a whole number for the spoken label.
  static String _percent(double value, double total) =>
      '${(value / total * 100).round()}%';
}
