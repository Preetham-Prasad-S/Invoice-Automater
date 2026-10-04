import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SessionRemoteDatasource {
  /// Whether a persisted Supabase session is available on this device.
  ///
  /// Reads the locally restored session rather than hitting the network, so
  /// the splash screen can route without blocking on a round trip.
  Future<bool> hasSession();
}

class SessionRemoteDatasourceImpl implements SessionRemoteDatasource {
  const SessionRemoteDatasourceImpl();

  @override
  Future<bool> hasSession() async => _currentSession != null;

  Session? get _currentSession {
    try {
      return Supabase.instance.client.auth.currentSession;
    } on Object {
      // Supabase reports an uninitialised instance differently per build mode:
      // an AssertionError from the `instance` getter in debug and test builds,
      // or a LateInitializationError from the `late client` field in release.
      // Neither type is catchable by name, and since `currentSession` is a
      // synchronous getter with no IO, an uninitialised client is the only
      // realistic cause here: it simply means there is no session yet.
      return null;
    }
  }
}