import 'package:app_prototype/app/theme/app_colors.dart';
import 'package:app_prototype/app/theme/app_radii.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_sample_data.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_status_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(InvoiceStatus status) {
  return MaterialApp(
    home: Scaffold(body: Center(child: HomeStatusPill(status: status))),
  );
}

/// The pill's own background, taken from its outermost decorated container.
Color _background(WidgetTester tester) {
  final container = tester.widget<Container>(
    find
        .descendant(
          of: find.byType(HomeStatusPill),
          matching: find.byType(Container),
        )
        .first,
  );
  return (container.decoration! as BoxDecoration).color!;
}

void main() {
  testWidgets('paid reads Paid on a green tint', (tester) async {
    await tester.pumpWidget(_host(InvoiceStatus.paid));
    await tester.pumpAndSettle();

    expect(find.text('Paid'), findsOneWidget);
    expect(_background(tester), AppColors.statusPaidTint);
  });

  testWidgets('pending reads Pending on an amber tint', (tester) async {
    await tester.pumpWidget(_host(InvoiceStatus.pending));
    await tester.pumpAndSettle();

    expect(find.text('Pending'), findsOneWidget);
    expect(_background(tester), AppColors.statusPendingTint);
  });

  testWidgets('overdue reads Overdue on a red tint', (tester) async {
    await tester.pumpWidget(_host(InvoiceStatus.overdue));
    await tester.pumpAndSettle();

    expect(find.text('Overdue'), findsOneWidget);
    expect(_background(tester), AppColors.statusOverdueTint);
  });

  testWidgets('tints the label to match its status', (tester) async {
    await tester.pumpWidget(_host(InvoiceStatus.overdue));
    await tester.pumpAndSettle();

    expect(
      tester.widget<Text>(find.text('Overdue')).style?.color,
      AppColors.statusOverdue,
    );
  });

  testWidgets('is fully rounded', (tester) async {
    await tester.pumpWidget(_host(InvoiceStatus.paid));
    await tester.pumpAndSettle();

    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(HomeStatusPill),
            matching: find.byType(Container),
          )
          .first,
    );
    final radius = (container.decoration! as BoxDecoration).borderRadius!;
    expect(radius, BorderRadius.circular(AppRadii.pill));
  });
}
