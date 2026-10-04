import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/entities/splash_step.dart';

/// Loads environment configuration. Lives in `data/` because it depends on the
/// dotenv plugin, which `domain/` must stay free of.
class LoadConfigStep implements SplashStep {
  @override
  String get id => 'load_config';

  @override
  String get label => 'Loading configuration';

  @override
  double get weight => 0.15;

  @override
  Future<void> run() => dotenv.load(fileName: '.env');
}