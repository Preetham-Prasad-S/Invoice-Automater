import 'package:shared_preferences/shared_preferences.dart';

/// Narrow persistence contract owned by core. Features depend on this
/// abstraction and never on SharedPreferences directly, which keeps them
/// testable with an in-memory fake and swappable for another backend.
abstract class LocalStorage {
  Future<String?> getString(String key);

  Future<void> setString(String key, String value);

  Future<bool?> getBool(String key);

  Future<void> setBool(String key, {required bool value});

  Future<void> remove(String key);
}

class SharedPreferencesLocalStorage implements LocalStorage {
  SharedPreferencesLocalStorage({SharedPreferencesAsync? preferences})
      : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> getString(String key) => _preferences.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _preferences.setString(key, value);

  @override
  Future<bool?> getBool(String key) => _preferences.getBool(key);

  @override
  Future<void> setBool(String key, {required bool value}) =>
      _preferences.setBool(key, value);

  @override
  Future<void> remove(String key) => _preferences.remove(key);
}
