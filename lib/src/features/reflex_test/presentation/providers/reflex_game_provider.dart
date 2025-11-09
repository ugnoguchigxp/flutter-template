import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_template/src/features/reflex_test/domain/models/difficulty.dart';
import 'package:flutter_template/src/features/reflex_test/domain/models/falling_bar.dart';
import 'package:flutter_template/src/features/reflex_test/domain/models/reflex_game_state.dart';

class ReflexGameNotifier extends StateNotifier<ReflexGameState> {
  ReflexGameNotifier() : super(const ReflexGameState());

  Timer? _gameLoopTimer;
  Timer? _spawnTimer;
  Timer? _gameTimer;
  Size? _canvasSize;
  int _lastIntervalPhase = 0; // 出現間隔の段階を追跡

  /// ゲーム開始
  void startGame(ReflexDifficulty difficulty, Size canvasSize) {
    _canvasSize = canvasSize;
    
    state = ReflexGameState(
      status: ReflexGameStatus.playing,
      difficulty: difficulty,
      gameStartTime: DateTime.now(),
      lastFrameTime: DateTime.now(),
    );

    // ゲームループ開始
    _startGameLoop();
    
    // 棒の生成開始
    _startSpawning();
    
    // ゲームタイマー開始（15秒）
    _startGameTimer();
  }

  /// ゲームループ開始
  void _startGameLoop() {
    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 16), (_) { // 60FPS
      final now = DateTime.now();
      final deltaTime = state.lastFrameTime != null
          ? now.difference(state.lastFrameTime!).inMilliseconds / 1000.0
          : 0.0;
      
      state = state.copyWith(lastFrameTime: now);
      
      _updatePhysics(deltaTime);
      _checkAndUpdateSpawnInterval();
    });
  }

  /// 物理演算更新
  void _updatePhysics(double deltaTime) {
    final gravity = state.difficulty.gravity;
    final updatedBars = state.bars.map((bar) {
      if (bar.isTapped) return bar;

      // 速度更新: v = v0 + g*t
      final newVelocity = bar.velocity + gravity * deltaTime;

      // 位置更新: y = y + v*t
      final newY = bar.y + newVelocity * deltaTime;

      return bar.copyWith(
        y: newY,
        velocity: newVelocity,
      );
    }).toList();

    // 画面外に出た棒を削除（フルスクリーン対応）
    final activeBars = updatedBars.where((bar) {
      return bar.y < (_canvasSize?.height ?? 1000) + FallingBar.height;
    }).toList();

    state = state.copyWith(bars: activeBars);
  }

  /// 棒の生成開始
  void _startSpawning() {
    _spawnBar(); // 最初の棒を即座に生成
    _updateSpawnInterval();
  }

  /// 出現間隔を更新
  void _updateSpawnInterval() {
    _spawnTimer?.cancel();
    _spawnTimer = Timer.periodic(state.currentSpawnInterval, (_) {
      _spawnBar();
    });
  }

  /// 出現間隔のチェックと更新
  void _checkAndUpdateSpawnInterval() {
    final elapsed = state.elapsedSeconds;
    int currentPhase = 0;

    // 経過時間に応じてフェーズを判定
    if (elapsed >= 10) {
      currentPhase = 2; // 10-15秒: 高速
    } else if (elapsed >= 5) {
      currentPhase = 1; // 5-10秒: 標準
    }

    // フェーズが変わった時のみ更新
    if (currentPhase != _lastIntervalPhase) {
      _lastIntervalPhase = currentPhase;
      _updateSpawnInterval();
    }
  }

  /// 棒を生成
  void _spawnBar() {
    if (_canvasSize == null) return;
    
    final random = Random();
    final screenWidth = _canvasSize!.width;

    // 画面幅の5%〜95%の範囲でランダム生成（フルスクリーン対応）
    final x = screenWidth * (0.05 + random.nextDouble() * 0.9);

    final bar = FallingBar(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      x: x,
      y: -FallingBar.height, // 画面上部外から開始
      velocity: 50.0, // 初期速度を少し設定してゆっくり開始
      spawnTime: DateTime.now(),
    );

    state = state.copyWith(
      bars: [...state.bars, bar],
    );
  }

  /// ゲームタイマー開始
  void _startGameTimer() {
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final elapsed = state.elapsedSeconds;
      final remaining = (15.0 - elapsed).clamp(0.0, 15.0);
      
      state = state.copyWith(remainingTime: remaining);
      
      if (remaining <= 0) {
        _endGame();
      }
    });
  }

  /// タップ処理
  void onTapDown(TapDownDetails details) {
    if (state.status != ReflexGameStatus.playing) return;
    
    final tapPosition = details.localPosition;

    // タップ位置と棒の当たり判定
    for (final bar in state.bars) {
      if (!bar.isTapped && bar.contains(tapPosition)) {
        _handleSuccessTap(bar);
        return;
      }
    }
  }

  /// タップ成功処理
  void _handleSuccessTap(FallingBar bar) {
    final reactionTime = DateTime.now().difference(bar.spawnTime);
    final reactionMs = reactionTime.inMilliseconds;

    // スコア計算
    int points = 10; // 基本点
    points += state.calculateSpeedBonus(reactionMs);

    // 触覚フィードバック
    unawaited(HapticFeedback.mediumImpact());

    // 棒を削除して状態更新
    final updatedBars = state.bars.where((b) => b.id != bar.id).toList();

    state = state.copyWith(
      bars: updatedBars,
      score: state.score + points,
      successCount: state.successCount + 1,
      reactionTimes: [...state.reactionTimes, reactionMs.toDouble()],
    );
  }

  /// ゲーム終了
  void _endGame() {
    _gameLoopTimer?.cancel();
    _spawnTimer?.cancel();
    _gameTimer?.cancel();

    state = state.copyWith(
      status: ReflexGameStatus.gameOver,
    );
  }

  /// ゲームリセット
  void resetGame() {
    _gameLoopTimer?.cancel();
    _spawnTimer?.cancel();
    _gameTimer?.cancel();
    _canvasSize = null;
    _lastIntervalPhase = 0; // フラグもリセット

    state = const ReflexGameState();
  }

  @override
  void dispose() {
    _gameLoopTimer?.cancel();
    _spawnTimer?.cancel();
    _gameTimer?.cancel();
    super.dispose();
  }
}

final reflexGameProvider = StateNotifierProvider<ReflexGameNotifier, ReflexGameState>((ref) {
  return ReflexGameNotifier();
});
