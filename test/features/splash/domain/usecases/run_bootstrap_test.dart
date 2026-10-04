import 'package:app_prototype/features/splash/domain/entities/splash_destination.dart';
import 'package:app_prototype/features/splash/domain/entities/splash_step.dart';
import 'package:app_prototype/features/splash/domain/repositories/splash_repository.dart';
import 'package:app_prototype/features/splash/domain/usecases/run_bootstrap.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeStep implements SplashStep {
  _FakeStep({this.id = 'fake', this.label = 'Doing work', this.weight = 1.0});

  @override
  final String id;

  @override
  final String label;

  @override
  final double weight;

  bool ran = false;

  @override
  Future<void> run() async => ran = true;
}

class _ThrowingStep implements SplashStep {
  _ThrowingStep(this.error);

  final Object error;

  @override
  String get id => 'throwing';

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

/// Records every `(progress, phase)` pair the usecase emits.
class _ProgressLog {
  final List<double> progress = [];
  final List<String> phases = [];

  void call(double value, String phase) {
    progress.add(value);
    phases.add(phase);
  }
}

void main() {
  group('destination selection', () {
    test('first run goes to onboarding', () async {
      final outcome = await RunBootstrap(
        [_FakeStep()],
        _FakeSplashRepository(firstRun: true, session: false),
      )((_, __) {});

      expect(outcome.destination, SplashDestination.onboarding);
    });

    test('first run takes precedence over an existing session', () async {
      final outcome = await RunBootstrap(
        [_FakeStep()],
        _FakeSplashRepository(firstRun: true, session: true),
      )((_, __) {});

      expect(outcome.destination, SplashDestination.onboarding);
    });

    test('returning user with a session goes home', () async {
      final outcome = await RunBootstrap(
        [_FakeStep()],
        _FakeSplashRepository(firstRun: false, session: true),
      )((_, __) {});

      expect(outcome.destination, SplashDestination.home);
    });

    test('returning user without a session goes to login', () async {
      final outcome = await RunBootstrap(
        [_FakeStep()],
        _FakeSplashRepository(firstRun: false, session: false),
      )((_, __) {});

      expect(outcome.destination, SplashDestination.login);
    });
  });

  group('progress reporting', () {
    test('reports cumulative progress after every step', () async {
      final log = _ProgressLog();
      await RunBootstrap(
        [
          _FakeStep(id: 'a', label: 'Step A', weight: 0.15),
          _FakeStep(id: 'b', label: 'Step B', weight: 0.35),
          _FakeStep(id: 'c', label: 'Step C', weight: 0.25),
          _FakeStep(id: 'd', label: 'Step D', weight: 0.25),
        ],
        _FakeSplashRepository(),
      )(log.call);

      expect(log.progress, [0.15, 0.5, 0.75, 1.0]);
      expect(log.phases, ['Step A', 'Step B', 'Step C', 'Step D']);
    });

    test('progress never decreases', () async {
      final log = _ProgressLog();
      await RunBootstrap(
        [
          _FakeStep(weight: 0.4),
          _FakeStep(weight: 0.1),
          _FakeStep(weight: 0.5),
        ],
        _FakeSplashRepository(),
      )(log.call);

      for (var i = 1; i < log.progress.length; i++) {
        expect(log.progress[i], greaterThanOrEqualTo(log.progress[i - 1]));
      }
    });

    test('normalises weights that do not sum to one', () async {
      final log = _ProgressLog();
      await RunBootstrap(
        [_FakeStep(weight: 2), _FakeStep(weight: 2)],
        _FakeSplashRepository(),
      )(log.call);

      expect(log.progress, [0.5, 1.0]);
    });

    test('handles an empty step list without dividing by zero', () async {
      final log = _ProgressLog();
      final outcome = await RunBootstrap(
        [],
        _FakeSplashRepository(),
      )(log.call);

      expect(log.progress, isEmpty);
      expect(outcome.progress, 1.0);
      expect(outcome.destination, SplashDestination.onboarding);
    });
  });

  group('step execution', () {
    test('runs every step in order', () async {
      final order = <String>[];
      await RunBootstrap(
        [
          _RecordingStep('first', order),
          _RecordingStep('second', order),
          _RecordingStep('third', order),
        ],
        _FakeSplashRepository(),
      )((_, __) {});

      expect(order, ['first', 'second', 'third']);
    });

    test('stops at the first failing step', () async {
      final order = <String>[];
      await expectLater(
        RunBootstrap(
          [
            _RecordingStep('first', order),
            _ThrowingStep(StateError('boom')),
            _RecordingStep('third', order),
          ],
          _FakeSplashRepository(),
        )((_, __) {}),
        throwsStateError,
      );

      expect(order, ['first'], reason: 'later steps must not run');
    });
  });
}

class _RecordingStep implements SplashStep {
  _RecordingStep(this.id, this._order);

  @override
  final String id;
  final List<String> _order;

  @override
  String get label => id;

  @override
  double get weight => 1.0;

  @override
  Future<void> run() async => _order.add(id);
}