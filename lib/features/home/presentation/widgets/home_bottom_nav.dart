import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Bottom navigation bar (decorative for now).
///
/// Renders the 4-tab nav from the reference with Home selected.
/// Taps are intentionally no-ops - navigation wiring will come
/// with the Invoices/Clients/Settings features.
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              // Expanded rather than spaceAround so the four tabs always share
              // the bar equally: labels then shrink and ellipsize instead of
              // overflowing on a narrow phone or at a large text scale.
              Expanded(
                child: _NavItem(
                  icon: Ionicons.grid,
                  label: 'Home',
                  isActive: true,
                  onTap: () {},
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Ionicons.receipt_outline,
                  label: 'Invoices',
                  isActive: false,
                  onTap: () {},
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Ionicons.people_outline,
                  label: 'Clients',
                  isActive: false,
                  onTap: () {},
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Ionicons.settings_outline,
                  label: 'Settings',
                  isActive: false,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.navInactive;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: AppSpacing.xs),
          // Flexible so the four tabs share the bar instead of overflowing on
          // long labels or when the user scales text up.
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTypography.navLabel.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
