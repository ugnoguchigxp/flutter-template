import 'package:freezed_annotation/freezed_annotation.dart';

import 'difficulty.dart';

part 'game_result.freezed.dart';

@freezed
class GameResult with _$GameResult {
  const factory GameResult({
    required int score,
    required int successCount,
    required ReflexDifficulty difficulty,
    required List<double> reactionTimes,
    required DateTime playedAt,
  }) = _GameResult;

  const GameResult._();

  /// 平均反応速度（ミリ秒）
  double get averageReactionTime {
    if (reactionTimes.isEmpty) return 0.0;
    final sum = reactionTimes.fold<double>(0.0, (sum, time) => sum + time);
    return sum / reactionTimes.length;
  }

  /// 最速反応速度（ミリ秒）
  double? get bestReactionTime {
    if (reactionTimes.isEmpty) return null;
    return reactionTimes.reduce((a, b) => a < b ? a : b);
  }

  /// 最遅反応速度（ミリ秒）
  double? get worstReactionTime {
    if (reactionTimes.isEmpty) return null;
    return reactionTimes.reduce((a, b) => a > b ? a : b);
  }

  /// 成功率（バープレイ時間15秒を基準）
  double get successRate {
    if (successCount == 0) return 0.0;
    // 理論上の最大出現数を計算（難易度と時間による）
    final maxPossibleBars = _calculateMaxPossibleBars();
    return (successCount / maxPossibleBars).clamp(0.0, 1.0);
  }

  /// 理論上の最大出現数を計算
  int _calculateMaxPossibleBars() {
    // 15秒間の出現パターン:
    // 0-5秒: 2秒間隔 → 2.5個
    // 5-10秒: 1秒間隔 → 5個
    // 10-15秒: 0.33秒間隔 → 15個
    // 合計: 約22.5個 → 切り捨てて22個
    return 22;
  }

  /// パフォーマンス評価
  String get performanceGrade {
    if (successCount >= 20) return 'S';
    if (successCount >= 15) return 'A';
    if (successCount >= 10) return 'B';
    if (successCount >= 5) return 'C';
    return 'D';
  }
}
