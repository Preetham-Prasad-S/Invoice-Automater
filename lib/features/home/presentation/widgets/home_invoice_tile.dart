import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card.dart';
import 'home_sample_data.dart';
import 'home_status_pill.dart';

/// One invoice in the "Recent Invoices" list.
///
/// Two columns: client name over `INV-0042 • Due May 18` on the left, amount
/// over the status pill on the right. Both columns size to their content and
/// the client column takes the remaining space, so long client names truncate
/// instead of pushing the amount off the card.
class HomeInvoiceTile extends StatelessWidget {
  const HomeInvoiceTile({super.key, required this.invoice});

  final HomeInvoice invoice;

  static const Key tileKey = Key('home_invoice_tile');

  @override
  Widget build(BuildContext context) {
    return Padding(
      // 5dp vertical padding on each tile yields the 10dp gap between cards
      // in the reference, without double-counting padding at the list edges.
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 5,
      ),
      child: AppCard(
        key: tileKey,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    invoice.clientName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.invoiceClient,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${invoice.invoiceNumber} • Due ${invoice.dueDate}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.invoiceMeta,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Formatters.usd(invoice.amount),
                  style: AppTypography.statusAmount,
                ),
                const SizedBox(height: AppSpacing.xs),
                HomeStatusPill(status: invoice.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
