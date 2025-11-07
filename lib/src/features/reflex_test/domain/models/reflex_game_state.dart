import 'package:freezed_annotation/freezed_annotation.dart';

import 'difficulty.dart';
import 'falling_bar.dart';

part 'reflex_game_state.freezed.dart';

enum ReflexGameStatus {
  idle,     // 初期状態
  playing,  // プレイ中
  gameOver, // ゲーム終了
}

@freezed
class ReflexGameState with _$ReflexGameState {
  const factory ReflexGameState({
    @Default(ReflexGameStatus.idle) ReflexGameStatus status,
    @Default([]) List<FallingBar> bars,
    @Default(0) int score,
    @Default(0) int successCount,
    @Default(15.0) double remainingTime,
    @Default(ReflexDifficulty.normal) ReflexDifficulty difficulty,
    @Default([]) List<double> reactionTimes,
    DateTime? gameStartTime,
    DateTime? lastFrameTime,
  }) = _ReflexGameState;

  const ReflexGameState._();

  /// ゲーム経過時間（秒）
  double get elapsedSeconds {
    if (gameStartTime == null) return 0.0;
    return DateTime.now().difference(gameStartTime!).inMilliseconds / 1000.0;
  }

  /// 現在の出現間隔を取得
  Duration get currentSpawnInterval {
    final elapsed = elapsedSeconds;
    
    if (elapsed < 5) {
      return const Duration(seconds: 2); // 0-5秒: ゆっくり
    } else if (elapsed < 10) {
      return const Duration(seconds: 1); // 5-10秒: 標準
    } else {
      return const Duration(milliseconds: 333); // 10-15秒: 高速
    }
  }

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

  /// スコア計算用の速度ボーナス
  int calculateSpeedBonus(int reactionMs) {
    if (reactionMs <= 500) {
      return 20; // 超高速反応
    } else if (reactionMs <= 1000) {
      return 10; // 高速反応
    } else if (reactionMs <= 1500) {
      return 5; // 標準反応
    }
    return 0; // ボーナスなし
  }
}
