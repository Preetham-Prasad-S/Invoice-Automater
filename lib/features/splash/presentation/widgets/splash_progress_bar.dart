import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_progress_bar.dart';

class SplashProgressBar extends StatelessWidget {
  const SplashProgressBar({super.key, required this.progress, this.semanticsLabel});

  final double progress;

  /// Describes the current phase so the bar is not announced as a bare number.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return AppProgressBar(
      progress: progress,
      trackColor: AppColors.track,
      fillColor: AppColors.primary,
      trailingTrailColor: AppColors.trail,
      semanticsLabel: semanticsLabel ?? 'Loading',
    );
  }
}
