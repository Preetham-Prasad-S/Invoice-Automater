import 'package:flutter_test/flutter_test.dart';
import 'package:app_prototype/features/splash/data/datasources/session_remote_datasource.dart';

void main() {
  // Supabase is not initialized in the unit test host, which exercises the
  // defensive path: the splash must never crash before Supabase is ready.
  const datasource = SessionRemoteDatasourceImpl();

  test('reports no session when Supabase is not initialized', () async {
    expect(await datasource.hasSession(), isFalse);
  });

  test('repeated checks stay stable instead of throwing', () async {
    expect(await datasource.hasSession(), isFalse);
    expect(await datasource.hasSession(), isFalse);
  });
}
