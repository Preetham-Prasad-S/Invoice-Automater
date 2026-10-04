import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_paths.dart';
import '../../domain/entities/splash_destination.dart';
import '../../../../core/widgets/error_view.dart';
import '../providers/splash_providers.dart';
import '../widgets/splash_logo.dart';
import '../widgets/splash_hero_text.dart';
import '../widgets/splash_feature_pill.dart';
import '../widgets/splash_progress_bar.dart';
import '../widgets/splash_footer.dart';
import '../../../../app/theme/app_colors.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleOffset;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleOffset;
  late final Animation<double> _pill1Fade;
  late final Animation<Offset> _pill1Offset;
  late final Animation<double> _pill2Fade;
  late final Animation<Offset> _pill2Offset;
  late final Animation<double> _barFade;
  late final Animation<double> _footerFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.5, curve: Curves.easeOut),
      ),
    );
    _titleOffset = Tween<Offset>(
      begin: const Offset(0, 12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.5, curve: Curves.easeOut),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.58, curve: Curves.easeOut),
      ),
    );
    _subtitleOffset = Tween<Offset>(
      begin: const Offset(0, 10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.58, curve: Curves.easeOut),
      ),
    );

    _pill1Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.52, 0.72, curve: Curves.easeOut),
      ),
    );
    _pill1Offset = Tween<Offset>(
      begin: const Offset(0, 8),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.52, 0.72, curve: Curves.easeOut),
      ),
    );
    _pill2Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.58, 0.78, curve: Curves.easeOut),
      ),
    );
    _pill2Offset = Tween<Offset>(
      begin: const Offset(0, 8),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.58, 0.78, curve: Curves.easeOut),
      ),
    );

    _barFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 0.9, curve: Curves.easeOut),
      ),
    );
    _footerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 0.95, curve: Curves.easeOut),
      ),
    );

    Future.microtask(() async {
      final media = MediaQuery.maybeOf(context);
      final reduce = media?.disableAnimations ?? false;
      if (mounted && !reduce) {
        await _controller.forward();
      } else if (mounted) {
        _controller.value = 1.0;
      }
      if (!mounted) return;
      await ref.read(splashControllerProvider.notifier).run();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Maps a bootstrap outcome onto its destination route.
  ///
  /// Temporary: every destination currently resolves to Home while onboarding
  /// and login are still placeholders. The resolved [destination] is kept in
  /// the signature so the real mapping can be restored by deleting this
  /// override — the domain logic in `RunBootstrap` is unchanged and still
  /// decides correctly.
  static String _pathFor(SplashDestination destination) => RoutePaths.home;

  @override
  Widget build(BuildContext context) {
    ref.listen(splashControllerProvider, (previous, next) {
      final destination = next.destination;
      if (destination == null) return;
      // Only navigate once the bootstrap has actually resolved, so a failed
      // run stays on the splash instead of routing to an unusable screen.
      if (previous?.isCompleted ?? false) return;
      context.go(_pathFor(destination));
    });

    final state = ref.watch(splashControllerProvider);
    final progress = state.progress.clamp(0.0, 1.0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundStart, AppColors.backgroundEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 3),
                FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: const SplashLogo(),
                  ),
                ),
                const SizedBox(height: 28),
                FadeTransition(
                  opacity: _titleFade,
                  child: SlideTransition(
                    position: _titleOffset,
                    child: FadeTransition(
                    opacity: _subtitleFade,
                    child: SlideTransition(
                      position: _subtitleOffset,
                      child: const SplashHeroText(),
                    ),
                  ),
                  ),
                ),
                const SizedBox(height: 22),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: _pill1Fade,
                        child: SlideTransition(
                          position: _pill1Offset,
                          child: const SplashFeaturePill(
                            label: 'Instant Billing',
                            dotColor: AppColors.success,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FadeTransition(
                        opacity: _pill2Fade,
                        child: SlideTransition(
                          position: _pill2Offset,
                          child: const SplashFeaturePill(
                            label: 'Zero Transaction Fee',
                            dotColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                if (state.isFailed)
                  _SplashFailure(
                    message: state.error ?? 'Something went wrong.',
                    onRetry: () =>
                        ref.read(splashControllerProvider.notifier).retry(),
                  )
                else ...[
                  FadeTransition(
                    opacity: _barFade,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.62,
                      child: SplashProgressBar(
                        progress: progress,
                        semanticsLabel: state.phase ?? 'Loading',
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  FadeTransition(
                    opacity: _footerFade,
                    child: const SplashFooter(),
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown in place of the progress bar when a bootstrap step fails, with a way
/// to try again.
class _SplashFailure extends StatelessWidget {
  const _SplashFailure({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ErrorView(message: message, onRetry: onRetry),
    );
  }
}
