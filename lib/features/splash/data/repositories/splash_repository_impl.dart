import '../../domain/repositories/splash_repository.dart';
import '../datasources/splash_local_datasource.dart';
import '../datasources/session_remote_datasource.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDatasource local;
  final SessionRemoteDatasource remote;

  SplashRepositoryImpl({required this.local, required this.remote});

  @override
  Future<bool> hasSession() => remote.hasSession();

  @override
  Future<bool> isFirstRun() => local.isFirstRun();

  @override
  Future<void> markFirstRunComplete() => local.setFirstRunComplete();
}
