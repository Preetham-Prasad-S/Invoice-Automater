abstract class SplashStep {
  String get id;
  String get label;
  double get weight;
  Future<void> run();
}
