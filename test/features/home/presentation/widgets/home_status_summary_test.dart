import 'package:app_prototype/app/theme/app_colors.dart';
import 'package:app_prototype/core/widgets/app_card.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_sample_data.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_status_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({
  double paid = HomeSampleData.paid,
  double pending = HomeSampleData.pending,
  double overdue = HomeSampleData.overdue,
}) {
  return MaterialApp(
    home: Scaffold(
      body: HomeStatusSummary(paid: paid, pending: pending, overdue: overdue),
    ),
  );
}

/// The coloured status dots, left to right.
///
/// Matches on the circular decoration so the white card surfaces, which are
/// also decorated containers, are not picked up.
List<Color> _dotColors(WidgetTester tester) =>
    tester
        .widgetList<Container>(find.byType(Container))
        .map((c) => c.decoration)
        .whereType<BoxDecoration>()
        .where((d) => d.shape == BoxShape.circle && d.color != null)
        .map((d) => d.color!)
        .toList();

void main() {
  testWidgets('labels all three statuses', (tester) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(find.text('Paid'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('Overdue'), findsOneWidget);
  });

  testWidgets('shows the amounts without cents', (tester) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(find.text(r'$19,820'), findsOneWidget);
    expect(find.text(r'$6,180'), findsOneWidget);
    expect(find.text(r'$2,450'), findsOneWidget);
  });

  testWidgets('keeps cents when an amount is not whole', (tester) async {
    await tester.pumpWidget(_host(paid: 1234.5));
    await tester.pumpAndSettle();

    expect(find.text(r'$1,234.50'), findsOneWidget);
  });

  testWidgets('colours the dots per status', (tester) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(_dotColors(tester), [
      AppColors.statusPaid,
      AppColors.statusPending,
      AppColors.statusOverdue,
    ]);
  });

  testWidgets('lays the three cards out in a single row', (tester) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    final paid = tester.getTopLeft(find.text('Paid'));
    final pending = tester.getTopLeft(find.text('Pending'));
    final overdue = tester.getTopLeft(find.text('Overdue'));

    expect(paid.dy, pending.dy);
    expect(pending.dy, overdue.dy);
    expect(pending.dx, greaterThan(paid.dx));
    expect(overdue.dx, greaterThan(pending.dx));
  });

  testWidgets('gives each of the three cards the same width and height', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(find.byType(AppCard), findsNWidgets(3));
    final paid = tester.getSize(find.byType(AppCard).at(0));
    final pending = tester.getSize(find.byType(AppCard).at(1));
    final overdue = tester.getSize(find.byType(AppCard).at(2));

    expect(paid.width, closeTo(pending.width, 0.5));
    expect(pending.width, closeTo(overdue.width, 0.5));
    expect(paid.height, closeTo(pending.height, 0.5));
    expect(pending.height, closeTo(overdue.height, 0.5));
  });

  testWidgets('does not overflow on a narrow phone', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('shrinks a large amount rather than overflowing', (tester) async {
    await tester.pumpWidget(_host(paid: 9876543.21));
    await tester.pumpAndSettle();

    expect(find.text(r'$9,876,543.21'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
