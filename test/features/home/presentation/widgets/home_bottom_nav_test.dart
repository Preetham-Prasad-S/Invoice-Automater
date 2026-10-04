import 'package:app_prototype/app/theme/app_colors.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ionicons/ionicons.dart';

Widget _host() {
  return MaterialApp(home: Scaffold(body: const HomeBottomNav()));
}

void main() {
  testWidgets('shows all four tabs', (tester) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Invoices'), findsOneWidget);
    expect(find.text('Clients'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('renders one icon per tab', (tester) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(find.byIcon(Ionicons.grid), findsOneWidget);
    expect(find.byIcon(Ionicons.receipt_outline), findsOneWidget);
    expect(find.byIcon(Ionicons.people_outline), findsOneWidget);
    expect(find.byIcon(Ionicons.settings_outline), findsOneWidget);
  });

  testWidgets('marks Home as the active tab in the primary colour', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    final homeLabel = tester.widget<Text>(find.text('Home'));
    expect(homeLabel.style?.color, AppColors.primary);

    for (final inactive in ['Invoices', 'Clients', 'Settings']) {
      expect(
        tester.widget<Text>(find.text(inactive)).style?.color,
        AppColors.navInactive,
      );
    }
  });

  testWidgets('is a no-op when tapped, as documented', (tester) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Invoices'));
    await tester.pumpAndSettle();

    // The nav is decorative until the other tabs exist: Home must stay the
    // active one, and nothing may navigate away.
    expect(find.text('Home'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('Home')).style?.color,
      AppColors.primary,
    );
  });

  testWidgets('spreads the tabs evenly across the bar', (tester) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    final home = tester.getCenter(find.text('Home'));
    final invoices = tester.getCenter(find.text('Invoices'));
    final clients = tester.getCenter(find.text('Clients'));
    final settings = tester.getCenter(find.text('Settings'));

    expect(invoices.dx - home.dx, closeTo(clients.dx - invoices.dx, 1));
    expect(clients.dx - invoices.dx, closeTo(settings.dx - clients.dx, 1));
    expect(home.dy, closeTo(settings.dy, 1));
  });
}
