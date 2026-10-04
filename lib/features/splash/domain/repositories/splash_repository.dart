abstract class SplashRepository {
  Future<bool> hasSession();
  Future<bool> isFirstRun();
  Future<void> markFirstRunComplete();
}
