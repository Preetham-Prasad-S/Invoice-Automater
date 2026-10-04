import '../../../domain/entities/splash_step.dart';
import '../../../domain/repositories/splash_repository.dart';

class FirstRunCheckStep implements SplashStep {
  final SplashRepository repository;

  FirstRunCheckStep(this.repository);

  @override
  String get id => 'first_run_check';
  @override
  String get label => 'Checking first run';
  @override
  double get weight => 0.25;

  @override
  Future<void> run() async {
    await repository.isFirstRun();
  }
}
