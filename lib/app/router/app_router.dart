import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'route_paths.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const Placeholder(
          child: Scaffold(body: Center(child: Text('Onboarding'))),
        ),
      ),
GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const Placeholder(
          child: Scaffold(body: Center(child: Text('Login'))),
        ),
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const Placeholder(
          child: Scaffold(body: Center(child: Text('Home'))),
        ),
      ),
    ],
  );
});
