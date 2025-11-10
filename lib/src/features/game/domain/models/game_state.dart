import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'difficulty.dart';
import 'position.dart';
import 'trial_result.dart';

part 'game_state.freezed.dart';

enum GameStatus {
  idle, // 初期状態
  ready, // 開始準備
  playing, // トライアル進行中
  trialComplete, // 1トライアル完了
  gameComplete, // 全トライアル完了
}

@freezed
class GameState with _$GameState {
  const factory GameState({
    @Default(GameStatus.idle) GameStatus status,
    @Default(Difficulty.normal) Difficulty difficulty,
    @Default(1) int currentTrial,
    @Default([]) List<TrialResult> results,
    Position? targetPos,
    Position? playerPos,
    Position? prevTargetPos,
    DateTime? trialStartTime,
    @Default([]) List<Position> currentPath, // 現在のトライアルの移動経路
    @Default(0.0) double currentTraveledDistance, // 現在のトライアルの移動距離
  }) = _GameState;

  const GameState._();

  /// 現在のトライアルの経過時間（秒）
  double? get currentElapsedTime {
    if (trialStartTime == null) return null;
    return DateTime.now().difference(trialStartTime!).inMilliseconds / 1000.0;
  }

  /// 統計: 平均タイム
  double get averageTime {
    if (results.isEmpty) return 0.0;
    final sum = results.fold<double>(0.0, (sum, r) => sum + r.timeInSeconds);
    return sum / results.length;
  }

  /// 統計: 最速タイム
  double? get bestTime {
    if (results.isEmpty) return null;
    return results.map((r) => r.timeInSeconds).reduce(min);
  }

  /// 統計: 最遅タイム
  double? get worstTime {
    if (results.isEmpty) return null;
    return results.map((r) => r.timeInSeconds).reduce(max);
  }

  /// 統計: 合計タイム
  double get totalTime {
    return results.fold<double>(0.0, (sum, r) => sum + r.timeInSeconds);
  }

  /// 統計: 平均効率スコア
  double get averageEfficiencyScore {
    if (results.isEmpty) return 0.0;
    final sum = results.fold<double>(0.0, (sum, r) => sum + r.efficiencyScore);
    return sum / results.length;
  }

  /// 統計: 最高効率スコア
  double? get bestEfficiencyScore {
    if (results.isEmpty) return null;
    return results.map((r) => r.efficiencyScore).reduce(max);
  }

  /// 統計: 平均移動距離
  double get averageTraveledDistance {
    if (results.isEmpty) return 0.0;
    final sum = results.fold<double>(0.0, (sum, r) => sum + r.traveledDistance);
    return sum / results.length;
  }

  /// 統計: 平均効率率
  double get averageEfficiency {
    if (results.isEmpty) return 0.0;
    final sum = results.fold<double>(0.0, (sum, r) => sum + r.efficiency);
    return sum / results.length;
  }
}
