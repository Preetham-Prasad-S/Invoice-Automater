import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_prototype/core/widgets/app_progress_bar.dart';

const double _trackWidth = 200;

Widget _host(double progress, {Duration duration = Duration.zero}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: _trackWidth,
          child: AppProgressBar(progress: progress, duration: duration),
        ),
      ),
    ),
  );
}

double _fillWidth(WidgetTester tester) =>
    tester.getSize(find.byKey(AppProgressBar.fillKey)).width;

void main() {
  testWidgets('fill width tracks the progress fraction', (tester) async {
    await tester.pumpWidget(_host(0.5));
    await tester.pumpAndSettle();

    expect(find.byKey(AppProgressBar.trackKey), findsOneWidget);
    expect(_fillWidth(tester), closeTo(_trackWidth * 0.5, 0.5));
  });

  testWidgets('empty progress renders no fill', (tester) async {
    await tester.pumpWidget(_host(0));
    await tester.pumpAndSettle();

    expect(_fillWidth(tester), 0);
  });

  testWidgets('full progress fills the entire track', (tester) async {
    await tester.pumpWidget(_host(1));
    await tester.pumpAndSettle();

    expect(_fillWidth(tester), closeTo(_trackWidth, 0.5));
  });

  testWidgets('clamps progress above one', (tester) async {
    await tester.pumpWidget(_host(1.8));
    await tester.pumpAndSettle();

    expect(_fillWidth(tester), closeTo(_trackWidth, 0.5));
  });

  testWidgets('clamps progress below zero', (tester) async {
    await tester.pumpWidget(_host(-0.5));
    await tester.pumpAndSettle();

    expect(_fillWidth(tester), 0);
  });

  testWidgets('sweeps up from zero on first layout', (tester) async {
    await tester.pumpWidget(_host(0.8, duration: const Duration(milliseconds: 400)));

    expect(_fillWidth(tester), 0);

    await tester.pump(const Duration(milliseconds: 200));
    final midway = _fillWidth(tester);
    expect(midway, greaterThan(0));
    expect(midway, lessThan(_trackWidth * 0.8));

    await tester.pumpAndSettle();
    expect(_fillWidth(tester), closeTo(_trackWidth * 0.8, 0.5));
  });

  testWidgets('animates towards a new progress value', (tester) async {
    await tester.pumpWidget(_host(0.2, duration: const Duration(milliseconds: 400)));
    await tester.pumpAndSettle();
    expect(_fillWidth(tester), closeTo(_trackWidth * 0.2, 0.5));

    await tester.pumpWidget(_host(0.9, duration: const Duration(milliseconds: 400)));
    await tester.pump(const Duration(milliseconds: 200));

    final midway = _fillWidth(tester);
    expect(midway, lessThan(_trackWidth * 0.9));
    expect(midway, greaterThan(_trackWidth * 0.2));

    await tester.pumpAndSettle();
    expect(_fillWidth(tester), closeTo(_trackWidth * 0.9, 0.5));
  });

  testWidgets('trailing trail is hidden at both extremes', (tester) async {
    await tester.pumpWidget(_host(0));
    await tester.pumpAndSettle();
    expect(find.byKey(AppProgressBar.trailKey), findsNothing);

    await tester.pumpWidget(_host(1));
    await tester.pumpAndSettle();
    expect(find.byKey(AppProgressBar.trailKey), findsNothing);
  });

  testWidgets('trailing trail is visible mid-progress', (tester) async {
    await tester.pumpWidget(_host(0.5));
    await tester.pumpAndSettle();

    expect(find.byKey(AppProgressBar.trailKey), findsOneWidget);
  });

  testWidgets('can suppress the trailing trail', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: _trackWidth,
            child: AppProgressBar(
              progress: 0.5,
              showTrailingTrail: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(AppProgressBar.trailKey), findsNothing);
  });

  testWidgets('exposes progress to assistive tech when labelled', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: _trackWidth,
          child: AppProgressBar(progress: 0.42, semanticsLabel: 'Loading'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
  });

  testWidgets('stays within the track bounds while animating', (tester) async {
    await tester.pumpWidget(_host(0.02, duration: const Duration(milliseconds: 400)));
    await tester.pumpAndSettle();

    final trailLeft = tester.getTopLeft(find.byKey(AppProgressBar.trailKey)).dx;
    final trackLeft = tester.getTopLeft(find.byKey(AppProgressBar.trackKey)).dx;
    expect(trailLeft, greaterThanOrEqualTo(trackLeft));
  });
}
