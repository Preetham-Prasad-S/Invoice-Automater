import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_greeting_header.dart';
import '../widgets/home_invoice_tile.dart';
import '../widgets/home_new_invoice_button.dart';
import '../widgets/home_sample_data.dart';
import '../widgets/home_section_header.dart';
import '../widgets/home_status_summary.dart';
import '../widgets/home_total_card.dart';

/// The dashboard shown after a successful bootstrap.
///
/// A single scrolling column of sections in reference order: greeting header,
/// total card, status summary, new-invoice call to action, then the recent
/// invoice list. Deliberately free of entrance animations — the screen
/// arrives already settled so it can be compared directly against the design.
///
/// [maxContentWidth] keeps the layout readable on tablets and desktop: the
/// reference is a 360dp phone layout, and letting a two-column card stretch
/// across a desktop window would strand the text at opposite edges.
class HomePage extends StatelessWidget {
  const HomePage({super.key, this.maxContentWidth = 420});

  /// Widest the content column is allowed to become before it is centred in
  /// the viewport.
  final double maxContentWidth;

  static const Key contentKey = Key('home_content');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundStart, AppColors.backgroundEnd],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final column = ListView(
                key: contentKey,
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                children: [
                  const HomeGreetingHeader(
                    initials: HomeSampleData.userInitials,
                  ),
                  const HomeTotalCard(),
                  const SizedBox(height: AppSpacing.md),
                  const HomeStatusSummary(),
                  const SizedBox(height: AppSpacing.lg - 4),
                  const HomeNewInvoiceButton(),
                  const SizedBox(height: AppSpacing.sm),
                  const HomeSectionHeader(title: 'Recent Invoices'),
                  for (final invoice in HomeSampleData.recentInvoices)
                    HomeInvoiceTile(invoice: invoice),
                ],
              );

              if (constraints.maxWidth <= maxContentWidth) return column;

              return Center(
                child: SizedBox(width: maxContentWidth, child: column),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
