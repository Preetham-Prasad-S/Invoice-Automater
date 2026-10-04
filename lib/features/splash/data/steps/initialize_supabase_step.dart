import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/splash_step.dart';

/// Initialises the Supabase client. Lives in `data/` because it depends on the
/// Supabase plugin, which `domain/` must stay free of.
class InitializeSupabaseStep implements SplashStep {
  @override
  String get id => 'initialize_supabase';

  @override
  String get label => 'Connecting to backend';

  @override
  double get weight => 0.35;

  @override
  Future<void> run() async {
    if (!dotenv.isInitialized) {
      throw const MissingConfigException(
        'Environment configuration was never loaded. Check that .env exists '
        'and that the config step runs before Supabase is initialised.',
      );
    }

    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANNON_KEY'];

    if (url == null || anonKey == null) {
      throw const MissingConfigException(
        'Supabase configuration is missing. Check that .env defines '
        'SUPABASE_URL and SUPABASE_ANNON_KEY.',
      );
    }

    await Supabase.initialize(url: url, anonKey: anonKey);
  }
}

/// Raised when required environment configuration is absent.
class MissingConfigException implements Exception {
  const MissingConfigException(this.message);

  final String message;

  @override
  String toString() => message;
}