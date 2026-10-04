import 'package:app_prototype/features/home/presentation/pages/home_page.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_greeting_header.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_invoice_tile.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_new_invoice_button.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_sample_data.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_section_header.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_status_summary.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_total_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps the page at a given logical size, matching the 360dp-wide phone the
/// reference design was drawn at.
Future<void> pumpAt(
  WidgetTester tester,
  Size size, {
  double maxContentWidth = 420,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(home: HomePage(maxContentWidth: maxContentWidth)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders every section of the dashboard', (tester) async {
    await pumpAt(tester, const Size(360, 800));

    expect(find.byType(HomeGreetingHeader), findsOneWidget);
    expect(find.byType(HomeTotalCard), findsOneWidget);
    expect(find.byType(HomeStatusSummary), findsOneWidget);
    expect(find.byType(HomeNewInvoiceButton), findsOneWidget);
    expect(find.byType(HomeSectionHeader), findsOneWidget);
    expect(find.byType(HomeBottomNav), findsOneWidget);
  });

  testWidgets('renders the reference content', (tester) async {
    await pumpAt(tester, const Size(360, 800));

    expect(find.text('Good morning, Alex'), findsOneWidget);
    expect(find.text('Total Invoiced'), findsOneWidget);
    expect(find.text(r'$28,450.00'), findsOneWidget);
    expect(find.text('Recent Invoices'), findsOneWidget);
    expect(find.text('See all'), findsOneWidget);
    expect(find.text('New Invoice'), findsOneWidget);
  });

  testWidgets('shows every sample client once scrolled into view', (
    tester,
  ) async {
    await pumpAt(tester, const Size(360, 800));

    for (final invoice in HomeSampleData.recentInvoices) {
      await tester.scrollUntilVisible(find.text(invoice.clientName), 150);
      expect(find.text(invoice.clientName), findsOneWidget);
    }
  });

  testWidgets('lists one tile per sample invoice', (tester) async {
    // Tall enough that the whole list is inside the viewport, so the count is
    // about the data rather than about lazy list building.
    await pumpAt(tester, const Size(360, 1600));

    expect(
      find.byType(HomeInvoiceTile),
      findsNWidgets(HomeSampleData.recentInvoices.length),
    );
  });

  testWidgets('shows the sample initials in the avatar', (tester) async {
    await pumpAt(tester, const Size(360, 800));

    expect(find.text(HomeSampleData.userInitials), findsOneWidget);
  });

  testWidgets('does not overflow at the reference size', (tester) async {
    await pumpAt(tester, const Size(360, 800));

    expect(tester.takeException(), isNull);
  });

  testWidgets('does not overflow on a small phone', (tester) async {
    await pumpAt(tester, const Size(320, 568));

    expect(tester.takeException(), isNull);
  });

  testWidgets('does not overflow on a tablet', (tester) async {
    await pumpAt(tester, const Size(834, 1112));

    expect(tester.takeException(), isNull);
  });

  testWidgets('scrolls the invoice list on a short viewport', (tester) async {
    await pumpAt(tester, const Size(360, 640));

    await tester.scrollUntilVisible(find.text('Supabase Inc'), 200);
    expect(find.text('Supabase Inc'), findsOneWidget);
  });

  testWidgets('keeps the bottom nav pinned while the content scrolls', (
    tester,
  ) async {
    await pumpAt(tester, const Size(360, 640));

    final navBefore = tester.getTopLeft(find.byType(HomeBottomNav));
    await tester.drag(find.byKey(HomePage.contentKey), const Offset(0, -200));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.byType(HomeBottomNav)), navBefore);
  });

  group('wide viewports', () {
    testWidgets('caps and centres the content column', (tester) async {
      await pumpAt(tester, const Size(1400, 900));

      final column = tester.getSize(find.byKey(HomePage.contentKey));
      expect(column.width, closeTo(420, 0.5));

      final columnLeft = tester.getTopLeft(find.byKey(HomePage.contentKey)).dx;
      // Equal space either side of the capped column.
      expect(columnLeft, closeTo((1400 - 420) / 2, 1));
    });

    testWidgets('honours a custom cap', (tester) async {
      await pumpAt(tester, const Size(1400, 900), maxContentWidth: 600);

      expect(
        tester.getSize(find.byKey(HomePage.contentKey)).width,
        closeTo(600, 0.5),
      );
    });

    testWidgets('leaves a phone viewport uncapped', (tester) async {
      await pumpAt(tester, const Size(360, 800));

      expect(
        tester.getSize(find.byKey(HomePage.contentKey)).width,
        closeTo(360, 0.5),
      );
    });
  });

  testWidgets('the new invoice button reports taps', (tester) async {
    await pumpAt(tester, const Size(360, 800));

    await tester.tap(find.byKey(HomeNewInvoiceButton.buttonKey));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
