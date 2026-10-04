import '../../../domain/entities/splash_step.dart';
import '../../../domain/repositories/splash_repository.dart';

class RestoreSessionStep implements SplashStep {
  final SplashRepository repository;

  RestoreSessionStep(this.repository);

  @override
  String get id => 'restore_session';
  @override
  String get label => 'Restoring session';
  @override
  double get weight => 0.25;

  @override
  Future<void> run() async {
    await repository.hasSession();
  }
}
