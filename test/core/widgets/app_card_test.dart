import 'package:app_prototype/core/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({
  required Widget child,
  EdgeInsetsGeometry? padding,
  double radius = 20,
}) {
  return MaterialApp(
    home: Scaffold(
      body: AppCard(padding: padding, radius: radius, child: child),
    ),
  );
}

void main() {
  testWidgets('renders its child', (tester) async {
    await tester.pumpWidget(_host(child: const Text('inside')));
    await tester.pumpAndSettle();

    expect(find.text('inside'), findsOneWidget);
  });

  testWidgets('paints a white surface with a border and soft shadow', (
    tester,
  ) async {
    await tester.pumpWidget(_host(child: const SizedBox.shrink()));
    await tester.pumpAndSettle();

    final card = tester.widget<AppCard>(find.byType(AppCard));
    expect(card.radius, 20);

    final decorated = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(AppCard),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = decorated.decoration! as BoxDecoration;
    expect(decoration.color, Colors.white);
    expect(decoration.borderRadius, BorderRadius.circular(20));
    expect((decoration.border! as Border).top.color, const Color(0xFFE6E8F0));
    expect(decoration.boxShadow, isNotEmpty);
  });

  testWidgets('applies the requested radius', (tester) async {
    await tester.pumpWidget(_host(child: const SizedBox.shrink(), radius: 14));
    await tester.pumpAndSettle();

    final card = tester.widget<AppCard>(find.byType(AppCard));
    expect(card.radius, 14);
  });

  testWidgets('omits padding when none is given', (tester) async {
    await tester.pumpWidget(_host(child: const Text('flush')));
    await tester.pumpAndSettle();

    // Asserted on the widget rather than by scanning for a Padding, because
    // the subtree contains paddings Flutter inserts itself.
    expect(tester.widget<AppCard>(find.byType(AppCard)).padding, isNull);
  });

  testWidgets('applies padding when given', (tester) async {
    await tester.pumpWidget(
      _host(child: const Text('inset'), padding: const EdgeInsets.all(16)),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<AppCard>(find.byType(AppCard)).padding,
      const EdgeInsets.all(16),
    );
    final padding = tester.widgetList<Padding>(
      find.descendant(of: find.byType(AppCard), matching: find.byType(Padding)),
    );
    expect(padding.map((p) => p.padding), contains(const EdgeInsets.all(16)));
  });
}
