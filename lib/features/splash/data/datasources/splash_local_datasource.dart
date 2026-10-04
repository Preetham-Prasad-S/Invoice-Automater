import '../../../../core/storage/local_storage.dart';

abstract class SplashLocalDatasource {
  Future<bool> isFirstRun();

  Future<void> setFirstRunComplete();
}

class SplashLocalDatasourceImpl implements SplashLocalDatasource {
  SplashLocalDatasourceImpl(this._storage);

  final LocalStorage _storage;

  /// Persisted once onboarding has been completed. Absent means first run.
  static const String firstRunCompleteKey = 'splash.first_run_complete';

  @override
  Future<bool> isFirstRun() async {
    final completed = await _storage.getBool(firstRunCompleteKey);
    return completed != true;
  }

  @override
  Future<void> setFirstRunComplete() =>
      _storage.setBool(firstRunCompleteKey, value: true);
}
