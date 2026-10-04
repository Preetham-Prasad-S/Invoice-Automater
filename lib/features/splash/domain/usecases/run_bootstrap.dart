import '../entities/splash_destination.dart';
import '../entities/splash_outcome.dart';
import '../entities/splash_step.dart';
import '../repositories/splash_repository.dart';

/// Signature for progress updates emitted while the bootstrap runs.
///
/// The phase label identifies the step that just completed, which lets the UI
/// describe progress instead of showing an unexplained moving bar.
typedef SplashProgressCallback = void Function(double progress, String phase);

/// Runs the bootstrap steps in order, reporting cumulative progress, then
/// resolves where the app should start.
///
/// Depends only on the [SplashStep] contract, so it stays unaware of Supabase,
/// storage or any other infrastructure the concrete steps use.
class RunBootstrap {
  RunBootstrap(this.steps, this.repository);

  final List<SplashStep> steps;
  final SplashRepository repository;

  Future<SplashOutcome> call(SplashProgressCallback onProgress) async {
    final totalWeight = steps.fold<double>(0, (sum, step) => sum + step.weight);
    final divisor = totalWeight <= 0 ? 1.0 : totalWeight;

    var completedWeight = 0.0;
    for (final step in steps) {
      await step.run();
      completedWeight += step.weight;
      onProgress((completedWeight / divisor).clamp(0.0, 1.0), step.label);
    }

    return SplashOutcome(
      destination: await _resolveDestination(),
      progress: 1.0,
    );
  }

  /// A first launch always needs onboarding. Afterwards an existing session
  /// goes straight to the app, while a signed out user has to authenticate.
  Future<SplashDestination> _resolveDestination() async {
    if (await repository.isFirstRun()) return SplashDestination.onboarding;
    return await repository.hasSession()
        ? SplashDestination.home
        : SplashDestination.login;
  }
}