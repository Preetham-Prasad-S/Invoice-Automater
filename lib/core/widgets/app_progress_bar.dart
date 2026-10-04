import 'package:flutter/material.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.progress,
    this.height = 6,
    this.trackColor,
    this.fillColor,
    this.showTrailingTrail = true,
    this.trailingTrailColor,
    this.duration = const Duration(milliseconds: 450),
    this.curve = Curves.easeOutCubic,
    this.semanticsLabel,
  });

  /// Current progress in the 0.0..1.0 range. Values outside the range are
  /// clamped. The bar animates from its previous value whenever this changes,
  /// and sweeps up from zero on first layout.
  final double progress;

  final double height;
  final Color? trackColor;
  final Color? fillColor;

  /// Renders a short fading tail just ahead of the fill, mimicking the
  /// reference design. Suppressed at 0% and 100% where it has no meaning.
  final bool showTrailingTrail;
  final Color? trailingTrailColor;

  final Duration duration;
  final Curve curve;

  /// When provided, exposes the bar to assistive tech as a progress indicator.
  final String? semanticsLabel;

  static const Key trackKey = Key('app_progress_bar_track');
  static const Key fillKey = Key('app_progress_bar_fill');
  static const Key trailKey = Key('app_progress_bar_trail');

  static const Color _defaultTrack = Color(0xFFE8EAF2);
  static const Color _defaultFill = Color(0xFF3B5BFF);
  static const Color _defaultTrail = Color(0xFFA5B4FC);

  @override
  Widget build(BuildContext context) {
    final track = trackColor ?? _defaultTrack;
    final fill = fillColor ?? _defaultFill;
    final trail = trailingTrailColor ?? _defaultTrail;

    final bar = TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress),
      duration: duration,
      curve: curve,
      builder: (context, value, _) => LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final p = value.clamp(0.0, 1.0);
          return ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: Stack(
              children: [
                Container(
                  key: trackKey,
                  width: width,
                  height: height,
                  color: track,
                ),
                Container(
                  key: fillKey,
                  width: width * p,
                  height: height,
                  color: fill,
                ),
                if (showTrailingTrail && p > 0 && p < 1)
                  Positioned(
                    key: trailKey,
                    left: (width * p - height / 2).clamp(0.0, width),
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: height * 2.5,
                      height: height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [fill.withValues(alpha: 0), trail],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );

    if (semanticsLabel == null) {
      return RepaintBoundary(child: bar);
    }

    return Semantics(
      label: semanticsLabel,
      value: '\%',
      child: RepaintBoundary(child: bar),
    );
  }
}
