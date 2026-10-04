import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/local_storage.dart';

/// Single shared persistence adapter for the whole app.
final localStorageProvider = Provider<LocalStorage>((ref) {
  return SharedPreferencesLocalStorage();
});
