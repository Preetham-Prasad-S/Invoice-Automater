import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Composition root helper: ensures bindings, builds the widget tree and runs
/// the app under a single [ProviderScope].
///
/// Deliberately does no heavy initialisation. Loading config and connecting to
/// the backend are bootstrap steps owned by the splash feature, so the app can
/// render immediately and report progress instead of blocking on a black screen.
Future<void> bootstrap(Future<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  final app = await builder();

  runApp(ProviderScope(child: app));
}