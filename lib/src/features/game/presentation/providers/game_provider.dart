import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/difficulty.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/position.dart';
import '../../domain/models/trial_result.dart';
import '../../domain/services/target_generator.dart';
import '../../utils/constants.dart';

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier(this._ref) : super(const GameState());

  final Ref _ref;
  Size? _canvasSize;

  /// ゲーム開始
  void startGame(Size canvasSize, Difficulty difficulty) {
    _canvasSize = canvasSize;

    final centerPos = Position(
      x: canvasSize.width / 2,
      y: canvasSize.height / 2,
    );

    state = GameState(
      status: GameStatus.ready,
      difficulty: difficulty,
      currentTrial: 1,
      playerPos: centerPos,
      results: const [],
    );

    // 最初のターゲットを生成
    _generateNextTarget();
  }

  /// プレイヤー位置を更新（ドラッグ中）
  void updatePlayerPosition(Position newPos) {
    if (state.status != GameStatus.playing) return;

    // 前の位置からの距離を計算
    double additionalDistance = 0.0;
    if (state.playerPos != null) {
      additionalDistance = state.playerPos!.distanceTo(newPos);
    }

    // 経路に追加
    final newPath = [...state.currentPath, newPos];

    state = state.copyWith(
      playerPos: newPos,
      currentPath: newPath,
      currentTraveledDistance:
          state.currentTraveledDistance + additionalDistance,
    );

    // 到達判定
    _checkTargetReached();
  }

  /// ターゲット到達判定
  void _checkTargetReached() {
    if (state.targetPos == null || state.playerPos == null) return;

    final distance = state.playerPos!.distanceTo(state.targetPos!);

    // 難易度に応じた判定範囲を使用
    if (distance <= state.difficulty.hitRadius) {
      _completeCurrentTrial();
    }
  }

  /// 現在のトライアルを完了
  void _completeCurrentTrial() {
    if (state.trialStartTime == null) return;

    final endTime = DateTime.now();
    final duration = endTime.difference(state.trialStartTime!);
    final timeInSeconds = duration.inMilliseconds / 1000.0;

    // 最短距離（直線距離）を計算
    final startPos = state.currentPath.isNotEmpty
        ? state.currentPath.first
        : state.playerPos!;
    final optimalDistance = startPos.distanceTo(state.targetPos!);

    // 効率スコアを計算（100点満点）
    // 効率率をべき乗して緩やかなカーブを作成
    // 1.8乗により、100点はより厳密に、0点はより寛容に
    // - 完璧（efficiency=1.0）で100点
    // - 99%の効率（efficiency=0.99）で約98点
    // - 5倍の距離（efficiency=0.2）でも約6点残る
    final efficiency = optimalDistance / state.currentTraveledDistance;
    final efficiencyScore =
        (math.pow(efficiency, 1.8) * 100).clamp(0.0, 100.0);

    final result = TrialResult(
      trialNumber: state.currentTrial,
      timeInSeconds: timeInSeconds,
      startPos: startPos,
      targetPos: state.targetPos!,
      traveledDistance: state.currentTraveledDistance,
      optimalDistance: optimalDistance,
      efficiencyScore: efficiencyScore,
    );

    final newResults = [...state.results, result];

    if (state.currentTrial >= GameConstants.totalTrials) {
      // ゲーム完了
      state = state.copyWith(
        status: GameStatus.gameComplete,
        results: newResults,
      );
    } else {
      // 次のトライアルへ
      state = state.copyWith(
        status: GameStatus.trialComplete,
        currentTrial: state.currentTrial + 1,
        results: newResults,
        prevTargetPos: state.targetPos,
        playerPos: state.targetPos, // 次の開始位置は前回の到達位置
      );

      // 次のターゲットを生成（遅延後）
      Timer(GameConstants.trialDelay, _generateNextTarget);
    }
  }

  /// 次のターゲットを生成
  void _generateNextTarget() {
    if (_canvasSize == null) return;

    final generator = _ref.read(targetGeneratorProvider);
    final newTarget = generator.generateTarget(
      canvasSize: _canvasSize!,
      previousTarget: state.prevTargetPos,
    );

    state = state.copyWith(
      targetPos: newTarget,
      status: GameStatus.playing,
      trialStartTime: DateTime.now(),
      currentPath: [], // 経路をリセット
      currentTraveledDistance: 0.0, // 移動距離をリセット
    );
  }

  /// ゲームリセット
  void resetGame() {
    state = const GameState();
    _canvasSize = null;
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier(ref);
});
