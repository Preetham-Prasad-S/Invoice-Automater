import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// The "+ New Invoice" call to action.
///
/// The reference draws it as a blue gradient with a blue glow beneath, so it
/// is built as a decorated container with its own [InkWell] rather than a
/// themed [FilledButton]: the gradient would otherwise have to be faked with
/// a shadow, and the glow is part of the design rather than a state effect.
class HomeNewInvoiceButton extends StatelessWidget {
  const HomeNewInvoiceButton({
    super.key,
    this.onPressed,
    this.label = 'New Invoice',
  });

  /// Intentionally unused until the Invoices feature lands. Wired to a no-op
  /// so the button looks and behaves like a real control in the meantime.
  final VoidCallback? onPressed;

  final String label;

  static const Key buttonKey = Key('home_new_invoice_button');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppRadii.chip),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: buttonKey,
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppRadii.chip),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 20, color: Colors.white),
                  const SizedBox(width: AppSpacing.sm + 2),
                  Text(label, style: AppTypography.ctaLabel),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
