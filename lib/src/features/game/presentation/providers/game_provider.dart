import 'dart:async';

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

    state = state.copyWith(playerPos: newPos);

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

    final result = TrialResult(
      trialNumber: state.currentTrial,
      timeInSeconds: timeInSeconds,
      startPos: state.playerPos!,
      targetPos: state.targetPos!,
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
