import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../data/datasources/session_remote_datasource.dart';
import '../../data/datasources/splash_local_datasource.dart';
import '../../data/repositories/splash_repository_impl.dart';
import '../../data/steps/initialize_supabase_step.dart';
import '../../data/steps/load_config_step.dart';
import '../../domain/repositories/splash_repository.dart';
import '../../domain/usecases/run_bootstrap.dart';
import '../../domain/usecases/steps/first_run_check_step.dart';
import '../../domain/usecases/steps/restore_session_step.dart';
import '../state/splash_state.dart';

final splashRepositoryProvider = Provider<SplashRepository>((ref) {
  return SplashRepositoryImpl(
    local: SplashLocalDatasourceImpl(ref.watch(localStorageProvider)),
    remote: const SessionRemoteDatasourceImpl(),
  );
});

final runBootstrapProvider = Provider<RunBootstrap>((ref) {
  final repository = ref.watch(splashRepositoryProvider);
  return RunBootstrap(
    [
      // Supabase must be initialised before any step can read a session.
      LoadConfigStep(),
      InitializeSupabaseStep(),
      RestoreSessionStep(repository),
      FirstRunCheckStep(repository),
    ],
    repository,
  );
});

final splashControllerProvider = NotifierProvider<SplashController, SplashState>(
  SplashController.new,
);

class SplashController extends Notifier<SplashState> {
  @override
  SplashState build() => const SplashState.idle();

  /// Runs the bootstrap, streaming progress into state.
  ///
  /// Safe to call again after a failure, which is how retry works.
  Future<void> run() async {
    if (state.status == SplashStatus.running) return;

    state = state.copyWith(
      status: SplashStatus.running,
      progress: 0.0,
      clearError: true,
    );

    try {
      final outcome = await ref.read(runBootstrapProvider).call(
        (progress, phase) {
          state = state.copyWith(progress: progress, phase: phase);
        },
      );

      state = state.copyWith(
        status: SplashStatus.completed,
        progress: outcome.progress,
        destination: outcome.destination,
      );
    } on Object catch (error) {
      state = state.copyWith(
        status: SplashStatus.failed,
        error: _describe(error),
      );
    }
  }

  Future<void> retry() => run();

  /// Turns an arbitrary throw into something worth showing a user.
  String _describe(Object error) {
    final message = error is MissingConfigException
        ? error.message
        : error.toString();
    return message.replaceFirst('Exception: ', '');
  }
}