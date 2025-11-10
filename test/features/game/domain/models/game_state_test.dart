import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/game/domain/models/game_state.dart';
import 'package:flutter_template/src/features/game/domain/models/position.dart';
import 'package:flutter_template/src/features/game/domain/models/trial_result.dart';
import 'package:flutter_template/src/features/game/domain/models/difficulty.dart';

void main() {
  group('GameState', () {
    test('初期状態の確認', () {
      final state = const GameState();

      expect(state.status, GameStatus.idle);
      expect(state.difficulty, Difficulty.normal);
      expect(state.currentTrial, 1);
      expect(state.results, isEmpty);
      expect(state.targetPos, isNull);
      expect(state.playerPos, isNull);
      expect(state.prevTargetPos, isNull);
      expect(state.trialStartTime, isNull);
      expect(state.averageTime, 0.0);
      expect(state.bestTime, isNull);
      expect(state.worstTime, isNull);
      expect(state.totalTime, 0.0);
    });

    test('統計計算のテスト', () {
      final results = [
        const TrialResult(
          trialNumber: 1,
          timeInSeconds: 0.5,
          startPos: Position(x: 0, y: 0),
          targetPos: Position(x: 100, y: 100),
          traveledDistance: 141.42, // 直線距離
          optimalDistance: 141.42,
          efficiencyScore: 100.0,
        ),
        const TrialResult(
          trialNumber: 2,
          timeInSeconds: 0.3,
          startPos: Position(x: 100, y: 100),
          targetPos: Position(x: 50, y: 50),
          traveledDistance: 70.71, // 直線距離
          optimalDistance: 70.71,
          efficiencyScore: 100.0,
        ),
        const TrialResult(
          trialNumber: 3,
          timeInSeconds: 0.7,
          startPos: Position(x: 50, y: 50),
          targetPos: Position(x: 150, y: 150),
          traveledDistance: 141.42, // 直線距離
          optimalDistance: 141.42,
          efficiencyScore: 100.0,
        ),
      ];

      final state = GameState(results: results);

      expect(state.averageTime, 0.5); // (0.5 + 0.3 + 0.7) / 3
      expect(state.bestTime, 0.3);
      expect(state.worstTime, 0.7);
      expect(state.totalTime, 1.5); // 0.5 + 0.3 + 0.7
    });

    test('currentElapsedTimeのテスト', () {
      final startTime = DateTime.now().subtract(const Duration(seconds: 2));

      final state = GameState(
        status: GameStatus.playing,
        trialStartTime: startTime,
      );

      final elapsedTime = state.currentElapsedTime;

      expect(elapsedTime, isNotNull);
      expect(elapsedTime!, greaterThan(1.9)); // 約2秒経過
      expect(elapsedTime, lessThan(2.1));
    });

    test('結果がない場合の統計テスト', () {
      final state = const GameState();

      expect(state.averageTime, 0.0);
      expect(state.bestTime, isNull);
      expect(state.worstTime, isNull);
      expect(state.totalTime, 0.0);
    });

    test('状態遷移のテスト', () {
      final state = const GameState().copyWith(
        status: GameStatus.ready,
        difficulty: Difficulty.hard,
        currentTrial: 2,
        playerPos: const Position(x: 100, y: 100),
      );

      expect(state.status, GameStatus.ready);
      expect(state.difficulty, Difficulty.hard);
      expect(state.currentTrial, 2);
      expect(state.playerPos, const Position(x: 100, y: 100));
    });

    test('難易度別のテスト', () {
      final easyState = GameState(difficulty: Difficulty.easy);
      final normalState = GameState(difficulty: Difficulty.normal);
      final hardState = GameState(difficulty: Difficulty.hard);

      expect(easyState.difficulty, Difficulty.easy);
      expect(normalState.difficulty, Difficulty.normal);
      expect(hardState.difficulty, Difficulty.hard);
    });

    test('効率スコア統計のテスト', () {
      final results = [
        const TrialResult(
          trialNumber: 1,
          timeInSeconds: 0.5,
          startPos: Position(x: 0, y: 0),
          targetPos: Position(x: 100, y: 0),
          traveledDistance: 100.0, // 最適距離と同じ
          optimalDistance: 100.0,
          efficiencyScore: 100.0,
        ),
        const TrialResult(
          trialNumber: 2,
          timeInSeconds: 0.6,
          startPos: Position(x: 100, y: 0),
          targetPos: Position(x: 200, y: 0),
          traveledDistance: 150.0, // 1.5倍の距離
          optimalDistance: 100.0,
          efficiencyScore: 50.0,
        ),
        const TrialResult(
          trialNumber: 3,
          timeInSeconds: 0.7,
          startPos: Position(x: 200, y: 0),
          targetPos: Position(x: 300, y: 0),
          traveledDistance: 200.0, // 2倍の距離
          optimalDistance: 100.0,
          efficiencyScore: 25.0,
        ),
      ];

      final state = GameState(results: results);

      // 平均効率スコア: (100 + 50 + 25) / 3 = 58.33...
      expect(state.averageEfficiencyScore, closeTo(58.33, 0.01));

      // 最高効率スコア
      expect(state.bestEfficiencyScore, 100.0);

      // 平均移動距離: (100 + 150 + 200) / 3 = 150
      expect(state.averageTraveledDistance, 150.0);

      // 平均効率率: ((100/100) + (100/150) + (100/200)) / 3
      // = (1.0 + 0.667 + 0.5) / 3 = 0.722...
      expect(state.averageEfficiency, closeTo(0.722, 0.001));
    });

    test('効率スコア統計（結果なし）のテスト', () {
      const state = GameState();

      expect(state.averageEfficiencyScore, 0.0);
      expect(state.bestEfficiencyScore, isNull);
      expect(state.averageTraveledDistance, 0.0);
      expect(state.averageEfficiency, 0.0);
    });
  });
}
