import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';

/// A reusable card surface used throughout the dashboard.
///
/// Renders a white fill with a 1dp [AppColors.border], rounded corners
/// ([AppRadii.card] by default), and a soft drop shadow matching the
/// reference design. Padding is configurable via [padding].
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = AppRadii.card,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 24,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: padding == null ? child : Padding(padding: padding!, child: child),
    );
  }
}
