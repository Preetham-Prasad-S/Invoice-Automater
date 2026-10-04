import 'package:flutter/material.dart';

/// App icon shown on the splash screen.
///
/// Renders the shipped `assets/icon.png` as a single layer, so the mark is
/// always identical to the launcher icon.
///
/// The asset is a 517x483 canvas whose visible rounded tile occupies roughly
/// 72% of it, with the rest transparent padding. [size] therefore refers to
/// the whole canvas, and the visible tile renders at about `size * 0.72`.
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key, this.size = 144});

  static const String assetPath = 'assets/icon.png';

  /// Full canvas size. The visible tile is roughly 72% of this, so the default
  /// of 144 yields a ~104pt tile to match the design.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      // The green badge is part of the artwork, so no overlay is drawn.
      filterQuality: FilterQuality.medium,
    );
  }
}