class GameConstants {
  const GameConstants._();

  static const int totalTrials = 10;
  static const double targetRadius = 30.0;
  static const double targetHitRadius = 10.0; // 到達判定範囲（かなりシビア）
  static const Duration trialDelay = Duration(milliseconds: 500);
}
