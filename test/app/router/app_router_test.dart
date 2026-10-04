import 'package:app_prototype/app/di/providers.dart';
import 'package:app_prototype/app/router/app_router.dart';
import 'package:app_prototype/app/router/route_paths.dart';
import 'package:app_prototype/core/storage/local_storage.dart';
import 'package:app_prototype/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLocalStorage implements LocalStorage {
  @override
  Future<String?> getString(String key) async => null;
  @override
  Future<void> setString(String key, String value) async {}
  @override
  Future<bool?> getBool(String key) async => true;
  @override
  Future<void> setBool(String key, {required bool value}) async {}
  @override
  Future<void> remove(String key) async {}
}

void main() {
  testWidgets('/home serves the dashboard rather than a placeholder', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [localStorageProvider.overrideWithValue(_FakeLocalStorage())],
    );
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    // Straight to home: the splash bootstrap is covered by the splash tests,
    // and this is about what the router serves at this path.
    router.go(RoutePaths.home);
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Total Invoiced'), findsOneWidget);
    expect(find.text('Recent Invoices'), findsOneWidget);
  });

  testWidgets('every declared route resolves to a page', (tester) async {
    final container = ProviderContainer(
      overrides: [localStorageProvider.overrideWithValue(_FakeLocalStorage())],
    );
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    for (final path in [
      RoutePaths.onboarding,
      RoutePaths.login,
      RoutePaths.home,
    ]) {
      router.go(path);
      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
        reason: 'routing to $path should not throw',
      );
    }
  });
}
