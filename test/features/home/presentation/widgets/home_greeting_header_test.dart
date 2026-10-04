import 'package:app_prototype/features/home/presentation/widgets/home_greeting_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host({
  String name = 'Alex',
  String? initials,
  VoidCallback? onBellPressed,
}) {
  return MaterialApp(
    home: Scaffold(
      body: HomeGreetingHeader(
        userName: name,
        initials: initials,
        onNotificationsPressed: onBellPressed,
      ),
    ),
  );
}

void main() {
  testWidgets('shows the greeting for the given user', (tester) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Good morning, Alex'), findsOneWidget);
  });

  testWidgets('shows supplied initials', (tester) async {
    await tester.pumpWidget(_host(initials: 'AL'));
    await tester.pumpAndSettle();

    expect(find.text('AL'), findsOneWidget);
  });

  testWidgets('derives initials from a single name when none are given', (
    tester,
  ) async {
    await tester.pumpWidget(_host(name: 'Alex'));
    await tester.pumpAndSettle();

    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('derives initials from first and last name', (tester) async {
    await tester.pumpWidget(_host(name: 'Alex Jordan'));
    await tester.pumpAndSettle();

    expect(find.text('AJ'), findsOneWidget);
  });

  testWidgets('ignores extra whitespace when deriving initials', (
    tester,
  ) async {
    await tester.pumpWidget(_host(name: '  Alex   Jordan  '));
    await tester.pumpAndSettle();

    expect(find.text('AJ'), findsOneWidget);
  });

  testWidgets('survives an empty name', (tester) async {
    await tester.pumpWidget(_host(name: ''));
    await tester.pumpAndSettle();

    expect(find.byKey(HomeGreetingHeader.avatarKey), findsOneWidget);
    expect(find.text('Good morning, '), findsOneWidget);
  });

  testWidgets('truncates a long name instead of overflowing', (tester) async {
    await tester.pumpWidget(
      _host(name: 'Bartholomew Featherstonehaugh the Third'),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('exposes a bell target that reports taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_host(onBellPressed: () => taps++));
    await tester.pumpAndSettle();

    expect(find.byKey(HomeGreetingHeader.bellKey), findsOneWidget);
    await tester.tap(find.byKey(HomeGreetingHeader.bellKey));
    expect(taps, 1);
  });

  testWidgets('lays the avatar, greeting and bell out in one row', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    final avatar = tester.getTopLeft(find.byKey(HomeGreetingHeader.avatarKey));
    final greeting = tester.getTopLeft(find.text('Welcome back'));
    final bell = tester.getTopLeft(find.byKey(HomeGreetingHeader.bellKey));

    expect(greeting.dx, greaterThan(avatar.dx));
    expect(bell.dx, greaterThan(greeting.dx));
  });
}
