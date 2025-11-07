import 'package:flutter_test/flutter_test.dart';

import '../../../../../lib/src/features/game/domain/models/game_state.dart';
import '../../../../../lib/src/features/game/domain/models/position.dart';
import '../../../../../lib/src/features/game/domain/models/trial_result.dart';
import '../../../../../lib/src/features/game/domain/models/difficulty.dart';

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
        TrialResult(
          trialNumber: 1,
          timeInSeconds: 0.5,
          startPos: const Position(x: 0, y: 0),
          targetPos: const Position(x: 100, y: 100),
        ),
        TrialResult(
          trialNumber: 2,
          timeInSeconds: 0.3,
          startPos: const Position(x: 100, y: 100),
          targetPos: const Position(x: 50, y: 50),
        ),
        TrialResult(
          trialNumber: 3,
          timeInSeconds: 0.7,
          startPos: const Position(x: 50, y: 50),
          targetPos: const Position(x: 150, y: 150),
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
  });
}
