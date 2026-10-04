import 'package:app_prototype/features/splash/data/steps/initialize_supabase_step.dart';
import 'package:app_prototype/features/splash/data/steps/load_config_step.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadConfigStep', () {
    test('exposes stable metadata', () {
      final step = LoadConfigStep();

      expect(step.id, 'load_config');
      expect(step.weight, greaterThan(0));
      expect(step.label, isNotEmpty);
    });
  });

  group('InitializeSupabaseStep', () {
    test('exposes stable metadata', () {
      final step = InitializeSupabaseStep();

      expect(step.id, 'initialize_supabase');
      expect(step.weight, greaterThan(0));
      expect(step.label, isNotEmpty);
    });

    test('throws a configuration error when the environment is empty', () async {
      // The unit test host has no .env loaded, so this covers the path where
      // the app would otherwise start with a half-configured backend.
      await expectLater(
        InitializeSupabaseStep().run(),
        throwsA(isA<MissingConfigException>()),
      );
    });
  });
}