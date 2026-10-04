import 'package:app_prototype/core/widgets/app_progress_segments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const double _barWidth = 300;

const _green = Color(0xFF137A4A);
const _amber = Color(0xFFF5A623);
const _red = Color(0xFFE8384F);

Widget _host(
  List<ProgressSegment> segments, {
  double gap = 2.5,
  String? semanticsLabel,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: _barWidth,
          child: AppProgressSegments(
            segments: segments,
            gap: gap,
            semanticsLabel: semanticsLabel,
          ),
        ),
      ),
    ),
  );
}

/// The coloured slices inside the bar, in declaration order.
///
/// Scoped to the descendants of the track key so that `ColoredBox`es from
/// surrounding Material widgets are not mistaken for slices.
Finder _slices() => find.descendant(
  of: find.byKey(AppProgressSegments.trackKey),
  matching: find.byType(ColoredBox),
);

/// Widths of the coloured slices, in the order they were declared.
List<double> _sliceWidths(WidgetTester tester) =>
    tester
        .widgetList<ColoredBox>(_slices())
        .map((box) => tester.getSize(find.byWidget(box)).width)
        .toList();

double _availableWidth({required double gap, required int slices}) =>
    _barWidth - gap * (slices - 1);

void main() {
  testWidgets('slices are proportional to their weights', (tester) async {
    await tester.pumpWidget(
      _host([
        const ProgressSegment(weight: 19820, color: _green),
        const ProgressSegment(weight: 6180, color: _amber),
        const ProgressSegment(weight: 2450, color: _red),
      ]),
    );
    await tester.pumpAndSettle();

    final total = 19820 + 6180 + 2450;
    final available = _availableWidth(gap: 2.5, slices: 3);
    final widths = _sliceWidths(tester);

    expect(widths, hasLength(3));
    expect(widths[0], closeTo(available * 19820 / total, 1));
    expect(widths[1], closeTo(available * 6180 / total, 1));
    expect(widths[2], closeTo(available * 2450 / total, 1));
  });

  testWidgets('weights need not sum to one', (tester) async {
    await tester.pumpWidget(
      _host(const [
        ProgressSegment(weight: 3, color: _green),
        ProgressSegment(weight: 1, color: _red),
      ]),
    );
    await tester.pumpAndSettle();

    final widths = _sliceWidths(tester);
    final available = _availableWidth(gap: 2.5, slices: 2);
    expect(widths[0], closeTo(available * 0.75, 1));
    expect(widths[1], closeTo(available * 0.25, 1));
  });

  testWidgets('colours are applied per slice', (tester) async {
    await tester.pumpWidget(
      _host(const [
        ProgressSegment(weight: 1, color: _green),
        ProgressSegment(weight: 1, color: _red),
      ]),
    );
    await tester.pumpAndSettle();

    final boxes = tester.widgetList<ColoredBox>(_slices());
    expect(boxes.map((b) => b.color), [_green, _red]);
  });

  testWidgets('zero and negative weights collapse to nothing', (tester) async {
    await tester.pumpWidget(
      _host(const [
        ProgressSegment(weight: 10, color: _green),
        ProgressSegment(weight: 0, color: _amber),
        ProgressSegment(weight: -5, color: _red),
      ]),
    );
    await tester.pumpAndSettle();

    expect(_sliceWidths(tester), hasLength(1));
  });

  testWidgets('a single slice fills the whole track without a gap', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const [ProgressSegment(weight: 5, color: _green)]),
    );
    await tester.pumpAndSettle();

    expect(_sliceWidths(tester), [closeTo(_barWidth, 0.5)]);
  });

  testWidgets('an all-zero bar renders no slices', (tester) async {
    await tester.pumpWidget(
      _host(const [
        ProgressSegment(weight: 0, color: _green),
        ProgressSegment(weight: 0, color: _red),
      ]),
    );
    await tester.pumpAndSettle();

    expect(_slices(), findsNothing);
    expect(find.byKey(AppProgressSegments.trackKey), findsOneWidget);
  });

  testWidgets('an empty segment list renders an empty track', (tester) async {
    await tester.pumpWidget(_host(const []));
    await tester.pumpAndSettle();

    expect(_slices(), findsNothing);
    expect(find.byKey(AppProgressSegments.trackKey), findsOneWidget);
  });

  testWidgets('a gap of zero removes the spacing between slices', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const [
        ProgressSegment(weight: 1, color: _green),
        ProgressSegment(weight: 1, color: _red),
      ], gap: 0),
    );
    await tester.pumpAndSettle();

    expect(_sliceWidths(tester), hasLength(2));
    expect(_sliceWidths(tester).first, closeTo(_barWidth / 2, 0.5));
  });

  testWidgets('rounds its ends with the bar height', (tester) async {
    await tester.pumpWidget(
      _host(const [ProgressSegment(weight: 1, color: _green)]),
    );
    await tester.pumpAndSettle();

    final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
    expect(clip.borderRadius, BorderRadius.circular(4));
  });

  testWidgets('exposes a spoken breakdown when labelled', (tester) async {
    await tester.pumpWidget(
      _host(const [
        ProgressSegment(weight: 1, color: _green),
      ], semanticsLabel: 'Paid 100%'),
    );
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Paid 100%'), findsOneWidget);
  });
}
