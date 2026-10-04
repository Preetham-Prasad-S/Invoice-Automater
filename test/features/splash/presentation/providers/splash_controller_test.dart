import 'package:app_prototype/features/splash/domain/entities/splash_destination.dart';
import 'package:app_prototype/features/splash/domain/entities/splash_step.dart';
import 'package:app_prototype/features/splash/domain/repositories/splash_repository.dart';
import 'package:app_prototype/features/splash/domain/usecases/run_bootstrap.dart';
import 'package:app_prototype/features/splash/presentation/providers/splash_providers.dart';
import 'package:app_prototype/features/splash/presentation/state/splash_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeStep implements SplashStep {
  _FakeStep({required this.id, required this.label, required this.weight});

  @override
  final String id;
  @override
  final String label;
  @override
  final double weight;

  @override
  Future<void> run() async {}
}

class _FailingStep implements SplashStep {
  _FailingStep(this.error);

  final Object error;

  @override
  String get id => 'failing';
  @override
  String get label => 'Failing step';
  @override
  double get weight => 0.5;

  @override
  Future<void> run() async => throw error;
}

class _FakeSplashRepository implements SplashRepository {
  _FakeSplashRepository({this.firstRun = true, this.session = false});

  bool firstRun;
  bool session;

  @override
  Future<bool> hasSession() async => session;

  @override
  Future<bool> isFirstRun() async => firstRun;

  @override
  Future<void> markFirstRunComplete() async => firstRun = false;
}

void main() {
  ProviderContainer containerWith(List<SplashStep> steps, SplashRepository repo) {
    final container = ProviderContainer(
      overrides: [
        runBootstrapProvider.overrideWithValue(RunBootstrap(steps, repo)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('progress', () {
    test('starts idle at zero progress', () {
      final container = containerWith([], _FakeSplashRepository());

      final state = container.read(splashControllerProvider);
      expect(state.status, SplashStatus.idle);
      expect(state.progress, 0.0);
      expect(state.destination, isNull);
    });

    test('updates progress as each step completes', () async {
      final container = containerWith(
        [
          _FakeStep(id: 'a', label: 'Step A', weight: 0.5),
          _FakeStep(id: 'b', label: 'Step B', weight: 0.5),
        ],
        _FakeSplashRepository(),
      );

      final observed = <double>[];
      container.listen(
        splashControllerProvider,
        (_, next) => observed.add(next.progress),
        fireImmediately: false,
      );

      await container.read(splashControllerProvider.notifier).run();

      expect(observed, containsAllInOrder([0.5, 1.0]));
    });

    test('records the phase of the last completed step', () async {
      final container = containerWith(
        [
          _FakeStep(id: 'a', label: 'Step A', weight: 0.5),
          _FakeStep(id: 'b', label: 'Step B', weight: 0.5),
        ],
        _FakeSplashRepository(),
      );

      await container.read(splashControllerProvider.notifier).run();

      expect(container.read(splashControllerProvider).phase, 'Step B');
    });

    test('completes with the resolved destination', () async {
      final container = containerWith(
        [_FakeStep(id: 'a', label: 'Step A', weight: 1.0)],
        _FakeSplashRepository(firstRun: false, session: true),
      );

      await container.read(splashControllerProvider.notifier).run();

      final state = container.read(splashControllerProvider);
      expect(state.status, SplashStatus.completed);
      expect(state.destination, SplashDestination.home);
      expect(state.progress, 1.0);
      expect(state.error, isNull);
    });
  });

  group('failure', () {
    test('captures a failing step instead of throwing', () async {
      final container = containerWith(
        [_FailingStep(StateError('boom'))],
        _FakeSplashRepository(),
      );

      await container.read(splashControllerProvider.notifier).run();

      final state = container.read(splashControllerProvider);
      expect(state.status, SplashStatus.failed);
      expect(state.isFailed, isTrue);
      expect(state.error, contains('boom'));
      expect(state.destination, isNull, reason: 'must not route on failure');
    });

    test('retry clears the previous error and can succeed', () async {
      final step = _ToggleStep();
      final container = containerWith(
        [step],
        _FakeSplashRepository(),
      );

      await container.read(splashControllerProvider.notifier).run();
      expect(container.read(splashControllerProvider).isFailed, isTrue);

      step.shouldFail = false;
      await container.read(splashControllerProvider.notifier).retry();

      final state = container.read(splashControllerProvider);
      expect(state.status, SplashStatus.completed);
      expect(state.error, isNull);
      expect(state.destination, SplashDestination.onboarding);
    });

    test('ignores a concurrent run while already running', () async {
      final container = containerWith(
        [_SlowStep()],
        _FakeSplashRepository(),
      );
      final controller = container.read(splashControllerProvider.notifier);

      final first = controller.run();
      final second = controller.run();

      await Future.wait([first, second]);

      expect(container.read(splashControllerProvider).status,
          SplashStatus.completed);
    });
  });
}

/// Fails or succeeds depending on [shouldFail].
class _ToggleStep implements SplashStep {
  bool shouldFail = true;

  @override
  String get id => 'toggle';
  @override
  String get label => 'Toggle step';
  @override
  double get weight => 1.0;

  @override
  Future<void> run() async {
    if (shouldFail) throw StateError('boom');
  }
}

class _SlowStep implements SplashStep {
  @override
  String get id => 'slow';
  @override
  String get label => 'Slow step';
  @override
  double get weight => 1.0;

  @override
  Future<void> run() => Future<void>.delayed(const Duration(milliseconds: 20));
}