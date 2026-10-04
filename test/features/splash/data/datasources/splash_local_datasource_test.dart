import 'package:flutter_test/flutter_test.dart';
import 'package:app_prototype/core/storage/local_storage.dart';
import 'package:app_prototype/features/splash/data/datasources/splash_local_datasource.dart';

class _InMemoryLocalStorage implements LocalStorage {
  final Map<String, Object> _values = {};

  @override
  Future<String?> getString(String key) async => _values[key] as String?;

  @override
  Future<void> setString(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async => _values[key] as bool?;

  @override
  Future<void> setBool(String key, {required bool value}) async {
    _values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }
}

void main() {
  late _InMemoryLocalStorage storage;
  late SplashLocalDatasourceImpl datasource;

  setUp(() {
    storage = _InMemoryLocalStorage();
    datasource = SplashLocalDatasourceImpl(storage);
  });

  test('is first run when no flag has been written', () async {
    expect(await datasource.isFirstRun(), isTrue);
  });

  test('is not first run once onboarding is marked complete', () async {
    await datasource.setFirstRunComplete();

    expect(await datasource.isFirstRun(), isFalse);
  });

  test('writes the flag under a namespaced key', () async {
    await datasource.setFirstRunComplete();

    expect(
      await storage.getBool(SplashLocalDatasourceImpl.firstRunCompleteKey),
      isTrue,
    );
  });

  test('flag survives across datasource instances', () async {
    await datasource.setFirstRunComplete();
    final nextLaunch = SplashLocalDatasourceImpl(storage);

    expect(await nextLaunch.isFirstRun(), isFalse);
  });

  test('explicit false still counts as first run', () async {
    await storage.setBool(
      SplashLocalDatasourceImpl.firstRunCompleteKey,
      value: false,
    );

    expect(await datasource.isFirstRun(), isTrue);
  });
}
