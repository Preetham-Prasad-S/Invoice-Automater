import 'package:app_prototype/app/theme/app_colors.dart';
import 'package:app_prototype/core/widgets/app_card.dart';
import 'package:app_prototype/core/widgets/app_progress_segments.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_sample_data.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_total_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({
  double total = HomeSampleData.totalInvoiced,
  double trend = HomeSampleData.trendPercent,
  double paid = HomeSampleData.paid,
  double pending = HomeSampleData.pending,
  double overdue = HomeSampleData.overdue,
}) {
  return MaterialApp(
    home: Scaffold(
      body: HomeTotalCard(
        total: total,
        trendPercent: trend,
        paid: paid,
        pending: pending,
        overdue: overdue,
      ),
    ),
  );
}

/// Slice widths of the segmented bar inside the card.
List<double> _sliceWidths(WidgetTester tester) =>
    tester
        .widgetList<ColoredBox>(
          find.descendant(
            of: find.byKey(AppProgressSegments.trackKey),
            matching: find.byType(ColoredBox),
          ),
        )
        .map((box) => tester.getSize(find.byWidget(box)).width)
        .toList();

void main() {
  testWidgets('labels the card and shows the hero amount', (tester) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(find.text('Total Invoiced'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(HomeTotalCard.amountKey)).data,
      r'$28,450.00',
    );
  });

  testWidgets('keeps cents on the hero amount', (tester) async {
    await tester.pumpWidget(_host(total: 1234.5));
    await tester.pumpAndSettle();

    expect(
      tester.widget<Text>(find.byKey(HomeTotalCard.amountKey)).data,
      r'$1,234.50',
    );
  });

  testWidgets('shows the growth badge', (tester) async {
    await tester.pumpWidget(_host(trend: 12));
    await tester.pumpAndSettle();

    expect(find.byKey(HomeTotalCard.trendBadgeKey), findsOneWidget);
    expect(find.text('+12% this mo'), findsOneWidget);
  });

  testWidgets('rounds the growth badge to whole percent', (tester) async {
    await tester.pumpWidget(_host(trend: 12.4));
    await tester.pumpAndSettle();

    expect(find.text('+12% this mo'), findsOneWidget);
  });

  testWidgets('sits on a card surface', (tester) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(find.byKey(HomeTotalCard.cardKey), findsOneWidget);
    expect(find.byType(AppCard), findsOneWidget);
  });

  group('segmented bar', () {
    testWidgets('splits the bar in proportion to the status amounts', (
      tester,
    ) async {
      await tester.pumpWidget(_host());
      await tester.pumpAndSettle();

      final widths = _sliceWidths(tester);
      final bar = tester.getSize(find.byKey(AppProgressSegments.trackKey));
      final total = HomeSampleData.totalOf(
        paid: HomeSampleData.paid,
        pending: HomeSampleData.pending,
        overdue: HomeSampleData.overdue,
      );
      // Two 2.5dp gaps sit between the three slices.
      final available = bar.width - 5;

      expect(widths, hasLength(3));
      expect(widths[0] / available, closeTo(19820 / total, 0.01));
      expect(widths[1] / available, closeTo(6180 / total, 0.01));
      expect(widths[2] / available, closeTo(2450 / total, 0.01));
    });

    testWidgets('colours the slices by status', (tester) async {
      await tester.pumpWidget(_host());
      await tester.pumpAndSettle();

      final boxes = tester.widgetList<ColoredBox>(
        find.descendant(
          of: find.byKey(AppProgressSegments.trackKey),
          matching: find.byType(ColoredBox),
        ),
      );
      expect(boxes.map((b) => b.color), [
        AppColors.barPaid,
        AppColors.barPending,
        AppColors.barOverdue,
      ]);
    });

    testWidgets('is 8dp tall with rounded ends', (tester) async {
      await tester.pumpWidget(_host());
      await tester.pumpAndSettle();

      expect(
        tester.getSize(find.byKey(AppProgressSegments.trackKey)).height,
        8,
      );
    });

    testWidgets('reads the split out to assistive tech', (tester) async {
      await tester.pumpWidget(_host());
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel('Paid 70%, Pending 22%, Overdue 9%'),
        findsOneWidget,
      );
    });

    testWidgets('a zero total does not divide by zero', (tester) async {
      await tester.pumpWidget(_host(total: 0, paid: 0, pending: 0, overdue: 0));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('No invoices'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('reflects overridden figures', (tester) async {
      await tester.pumpWidget(_host(paid: 0, pending: 0, overdue: 100));
      await tester.pumpAndSettle();

      expect(_sliceWidths(tester), hasLength(1));
      expect(
        find.bySemanticsLabel('Paid 0%, Pending 0%, Overdue 100%'),
        findsOneWidget,
      );
    });
  });
}
