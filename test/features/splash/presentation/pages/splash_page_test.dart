import 'package:app_prototype/app/di/providers.dart';
import 'package:app_prototype/app/router/route_paths.dart';
import 'package:app_prototype/core/storage/local_storage.dart';
import 'package:app_prototype/core/widgets/error_view.dart';
import 'package:app_prototype/features/splash/domain/entities/splash_step.dart';
import 'package:app_prototype/features/splash/domain/repositories/splash_repository.dart';
import 'package:app_prototype/features/splash/domain/usecases/run_bootstrap.dart';
import 'package:app_prototype/features/splash/presentation/pages/splash_page.dart';
import 'package:app_prototype/features/splash/presentation/providers/splash_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeLocalStorage implements LocalStorage {
  @override
  Future<String?> getString(String key) async => null;
  @override
  Future<void> setString(String key, String value) async {}
  @override
  Future<bool?> getBool(String key) async => null;
  @override
  Future<void> setBool(String key, {required bool value}) async {}
  @override
  Future<void> remove(String key) async {}
}

class _FakeSplashRepository implements SplashRepository {
  @override
  Future<bool> hasSession() async => false;
  @override
  Future<bool> isFirstRun() async => true;
  @override
  Future<void> markFirstRunComplete() async {}
}

class _FailingStep implements SplashStep {
  @override
  String get id => 'failing';
  @override
  String get label => 'Failing step';
  @override
  double get weight => 1.0;

  @override
  Future<void> run() async => throw StateError('backend unreachable');
}

class _SlowStep implements SplashStep {
  _SlowStep(this.stepLabel);

  final String stepLabel;

  @override
  String get id => stepLabel;

  @override
  String get label => stepLabel;

  @override
  double get weight => 0.5;

  @override
  Future<void> run() async => Future<void>.delayed(
    const Duration(milliseconds: 300),
  );
}

void main() {
  ProviderContainer containerFor(SplashStep step) {
    final container = ProviderContainer(
      overrides: [
        localStorageProvider.overrideWithValue(_FakeLocalStorage()),
        runBootstrapProvider.overrideWithValue(
          RunBootstrap([step], _FakeSplashRepository()),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<void> settleBootstrap(WidgetTester tester) async {
    // The page starts bootstrap after its entrance animation completes.
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pumpAndSettle();
  }

  testWidgets('renders without errors', (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: containerFor(_SlowStep('ok')),
        child: const MaterialApp(home: SplashPage()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(SplashPage), findsOneWidget);
  });

  testWidgets('shows the progress bar while bootstrapping', (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: containerFor(_SlowStep('ok')),
        child: const MaterialApp(home: SplashPage()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1800));

    expect(find.byKey(const Key('app_progress_bar_track')), findsOneWidget);
  });

  testWidgets('shows an error with retry when a step fails', (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: containerFor(_FailingStep()),
        child: const MaterialApp(home: SplashPage()),
      ),
    );
    await settleBootstrap(tester);

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.textContaining('backend unreachable'), findsOneWidget);
  });

  testWidgets('hides the footer while failed', (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: containerFor(_FailingStep()),
        child: const MaterialApp(home: SplashPage()),
      ),
    );
    await settleBootstrap(tester);

    expect(find.text('Bank-grade 256-bit encryption'), findsNothing);
  });

  testWidgets('retry is available after a failure', (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: containerFor(_FailingStep()),
        child: const MaterialApp(home: SplashPage()),
      ),
    );
    await settleBootstrap(tester);

    expect(find.text('Retry'), findsOneWidget);
  });

  group('routing', () {
    // Pins the temporary "always go home" behaviour. The bootstrap still
    // resolves onboarding/login correctly in the domain; only the page's route
    // mapping is stubbed, so these tests will fail the moment real onboarding
    // and login screens land.
    Future<void> pumpRoutedSplash(
      WidgetTester tester,
      SplashRepository repository,
    ) async {
      final router = GoRouter(
        initialLocation: RoutePaths.splash,
        routes: [
          GoRoute(
            path: RoutePaths.splash,
            builder: (_, __) => const SplashPage(),
          ),
          for (final path in [
            RoutePaths.onboarding,
            RoutePaths.login,
            RoutePaths.home,
          ])
            GoRoute(
              path: path,
              builder: (_, __) => Scaffold(body: Text('at $path')),
            ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: ProviderContainer(
            overrides: [
              localStorageProvider.overrideWithValue(_FakeLocalStorage()),
              runBootstrapProvider.overrideWithValue(
                RunBootstrap([_ImmediateStep()], repository),
              ),
            ],
          ),
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await settleBootstrap(tester);
    }

    testWidgets('first run lands on home', (tester) async {
      await pumpRoutedSplash(tester, _FirstRunRepository());

      expect(find.text('at /home'), findsOneWidget);
    });

    testWidgets('signed out returning user lands on home', (tester) async {
      await pumpRoutedSplash(tester, _ReturningSignedOutRepository());

      expect(find.text('at /home'), findsOneWidget);
    });

    testWidgets('returning user with a session lands on home', (
      tester,
    ) async {
      await pumpRoutedSplash(tester, _ReturningWithSessionRepository());

      expect(find.text('at /home'), findsOneWidget);
    });
  });
}

class _ImmediateStep implements SplashStep {
  @override
  String get id => 'immediate';
  @override
  String get label => 'Immediate';
  @override
  double get weight => 1.0;

  @override
  Future<void> run() async {}
}

class _FirstRunRepository implements SplashRepository {
  @override
  Future<bool> hasSession() async => false;
  @override
  Future<bool> isFirstRun() async => true;
  @override
  Future<void> markFirstRunComplete() async {}
}

class _ReturningSignedOutRepository implements SplashRepository {
  @override
  Future<bool> hasSession() async => false;
  @override
  Future<bool> isFirstRun() async => false;
  @override
  Future<void> markFirstRunComplete() async {}
}

class _ReturningWithSessionRepository implements SplashRepository {
  @override
  Future<bool> hasSession() async => true;
  @override
  Future<bool> isFirstRun() async => false;
  @override
  Future<void> markFirstRunComplete() async {}
}