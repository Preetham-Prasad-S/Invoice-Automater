import 'package:flutter/material.dart';

/// One slice of a stacked progress bar: how much of the bar it occupies, and
/// the colour it is drawn in.
class ProgressSegment {
  const ProgressSegment({required this.weight, required this.color});

  /// Relative size of this slice. Callers pass raw amounts (invoice totals,
  /// counts) rather than fractions; [AppProgressSegments] normalises them.
  /// A weight of zero or less contributes nothing to the bar.
  final double weight;

  final Color color;

  @override
  bool operator ==(Object other) =>
      other is ProgressSegment &&
      other.weight == weight &&
      other.color == color;

  @override
  int get hashCode => Object.hash(weight, color);
}

/// A stacked bar whose slices are proportional to their weights.
///
/// Distinct from `AppProgressBar`, which animates a single fill for task
/// progress: this one is for showing how a whole splits into parts, so it has
/// no animation and draws every slice at once.
///
/// Slices are laid out with [Expanded] plus a fixed [gap] between them, which
/// keeps the gaps from eating into the slices themselves — a nested-row
/// approach would shorten each slice by the gap and skew the proportions.
class AppProgressSegments extends StatelessWidget {
  const AppProgressSegments({
    super.key,
    required this.segments,
    this.height = 8,
    this.trackColor,
    this.gap = 2.5,
    this.semanticsLabel,
  });

  final List<ProgressSegment> segments;

  /// Thickness of the bar. Defaults to the 8dp used on the dashboard.
  final double height;

  /// Colour behind the slices, visible only when they do not fill the bar.
  final Color? trackColor;

  /// Space between slices. Fixed in logical pixels, not a share of the bar.
  final double gap;

  /// Read out in place of the individual slices, e.g.
  /// `Paid 70%, Pending 22%, Overdue 9%`.
  final String? semanticsLabel;

  static const Key trackKey = Key('app_progress_segments_track');

  /// Resolution of the integer [Expanded.flex] values. High enough that a
  /// slice narrower than a thousandth of the bar still gets a non-zero flex.
  static const int _flexScale = 100000;

  @override
  Widget build(BuildContext context) {
    final slices = segments.where((s) => s.weight > 0).toList();
    final totalWeight = slices.fold<double>(0, (sum, s) => sum + s.weight);

    // A bar with nothing in it, or with a single slice, renders as one
    // continuous fill: a lone gap would read as a rendering fault.
    final children = <Widget>[];
    if (totalWeight > 0 && slices.length > 1) {
      for (var i = 0; i < slices.length; i++) {
        children.add(
          Expanded(
            flex: (slices[i].weight / totalWeight * _flexScale).round(),
            child: ColoredBox(color: slices[i].color),
          ),
        );
        if (i < slices.length - 1 && gap > 0) {
          children.add(SizedBox(width: gap));
        }
      }
    } else if (totalWeight > 0) {
      children.add(
        Expanded(
          flex: _flexScale,
          child: ColoredBox(color: slices.first.color),
        ),
      );
    }

    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        // A DecoratedBox rather than a coloured Container: `Container(color:)`
        // inserts its own ColoredBox, which would be indistinguishable from a
        // slice to anything walking this subtree.
        child: DecoratedBox(
          key: trackKey,
          decoration: BoxDecoration(
            color: trackColor ?? const Color(0xFFE8EAF2),
          ),
          child: children.isEmpty ? null : Row(children: children),
        ),
      ),
    );

    if (semanticsLabel == null) return RepaintBoundary(child: bar);

    return Semantics(label: semanticsLabel, child: RepaintBoundary(child: bar));
  }
}
