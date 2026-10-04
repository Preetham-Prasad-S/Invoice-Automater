import 'package:app_prototype/features/splash/data/datasources/session_remote_datasource.dart';
import 'package:app_prototype/features/splash/data/datasources/splash_local_datasource.dart';
import 'package:app_prototype/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLocalDatasource implements SplashLocalDatasource {
  bool firstRun = true;
  int completeCalls = 0;

  @override
  Future<bool> isFirstRun() async => firstRun;

  @override
  Future<void> setFirstRunComplete() async {
    completeCalls++;
    firstRun = false;
  }
}

class _FakeSessionDatasource implements SessionRemoteDatasource {
  bool session = false;

  @override
  Future<bool> hasSession() async => session;
}

void main() {
  late _FakeLocalDatasource local;
  late _FakeSessionDatasource remote;
  late SplashRepositoryImpl repository;

  setUp(() {
    local = _FakeLocalDatasource();
    remote = _FakeSessionDatasource();
    repository = SplashRepositoryImpl(local: local, remote: remote);
  });

  test('isFirstRun delegates to the local datasource', () async {
    expect(await repository.isFirstRun(), isTrue);

    local.firstRun = false;

    expect(await repository.isFirstRun(), isFalse);
  });

  test('hasSession delegates to the remote datasource', () async {
    expect(await repository.hasSession(), isFalse);

    remote.session = true;

    expect(await repository.hasSession(), isTrue);
  });

  test('markFirstRunComplete delegates to the local datasource', () async {
    expect(local.completeCalls, 0);

    await repository.markFirstRunComplete();

    expect(local.completeCalls, 1);
    expect(await repository.isFirstRun(), isFalse);
  });
}