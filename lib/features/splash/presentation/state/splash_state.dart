import 'package:equatable/equatable.dart';

import '../../domain/entities/splash_destination.dart';

enum SplashStatus { idle, running, failed, completed }

/// Single source of truth for the splash screen: how far the bootstrap has
/// progressed, which phase it is in, and where it ended up.
class SplashState extends Equatable {
  const SplashState({
    this.status = SplashStatus.idle,
    this.progress = 0.0,
    this.phase,
    this.destination,
    this.error,
  });

  const SplashState.idle() : this();

  final SplashStatus status;

  /// Cumulative bootstrap progress in the 0.0..1.0 range.
  final double progress;

  /// Label of the most recently completed step.
  final String? phase;

  /// Set once the bootstrap has resolved where to navigate.
  final SplashDestination? destination;

  /// User-facing failure message, set when [status] is [SplashStatus.failed].
  final String? error;

  bool get isFailed => status == SplashStatus.failed;

  bool get isCompleted => status == SplashStatus.completed;

  SplashState copyWith({
    SplashStatus? status,
    double? progress,
    String? phase,
    SplashDestination? destination,
    String? error,
    bool clearError = false,
  }) {
    return SplashState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      phase: phase ?? this.phase,
      destination: destination ?? this.destination,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, progress, phase, destination, error];
}