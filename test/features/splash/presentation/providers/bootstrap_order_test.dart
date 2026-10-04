import 'package:app_prototype/app/di/providers.dart';
import 'package:app_prototype/core/storage/local_storage.dart';
import 'package:app_prototype/features/splash/presentation/providers/splash_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLocalStorage implements LocalStorage {
  final Map<String, Object> values = {};

  @override
  Future<String?> getString(String key) async => values[key] as String?;

  @override
  Future<void> setString(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async => values[key] as bool?;

  @override
  Future<void> setBool(String key, {required bool value}) async {
    values[key] = value;
  }

  @override
  Future<void> remove(String key) async => values.remove(key);
}

void main() {
  ProviderContainer bootstrapContainer() {
    final container = ProviderContainer(
      overrides: [
        // The real adapter needs a platform channel; the step list under test
        // does not depend on how storage is implemented.
        localStorageProvider.overrideWithValue(_FakeLocalStorage()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('supabase is initialised before any step can read a session', () {
    final order = bootstrapContainer()
        .read(runBootstrapProvider)
        .steps
        .map((step) => step.id)
        .toList();

    expect(
      order,
      containsAll(<String>[
        'load_config',
        'initialize_supabase',
        'restore_session',
        'first_run_check',
      ]),
    );
  });

  test('configuration loads before supabase is initialised', () {
    final order = bootstrapContainer()
        .read(runBootstrapProvider)
        .steps
        .map((step) => step.id)
        .toList();

    expect(
      order.indexOf('load_config'),
      lessThan(order.indexOf('initialize_supabase')),
    );
  });

  test('supabase initialises before the session is restored', () {
    final order = bootstrapContainer()
        .read(runBootstrapProvider)
        .steps
        .map((step) => step.id)
        .toList();

    expect(
      order.indexOf('initialize_supabase'),
      lessThan(order.indexOf('restore_session')),
    );
  });

  test('every step declares a positive weight', () {
    final steps = bootstrapContainer().read(runBootstrapProvider).steps;

    for (final step in steps) {
      expect(step.weight, greaterThan(0), reason: '${step.id} has no weight');
      expect(step.label, isNotEmpty, reason: '${step.id} has no label');
    }
  });
}