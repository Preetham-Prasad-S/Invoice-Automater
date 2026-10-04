import 'package:app_prototype/features/splash/data/steps/load_config_step.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Regression guard: this only passes when `.env` is declared in the pubspec
  // `assets` list. flutter_dotenv reads through rootBundle, so a file present
  // on disk but absent from pubspec fails to load at runtime.
  test('loads the .env bundled with the app', () async {
    await expectLater(LoadConfigStep().run(), completes);
  });

  test('exposes stable metadata', () {
    final step = LoadConfigStep();

    expect(step.id, 'load_config');
    expect(step.weight, greaterThan(0));
    expect(step.label, isNotEmpty);
  });
}