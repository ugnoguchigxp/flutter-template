import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/reflex_test/domain/models/difficulty.dart';
import 'package:flutter_template/src/features/reflex_test/domain/models/falling_bar.dart';
import 'package:flutter_template/src/features/reflex_test/domain/models/reflex_game_state.dart';

void main() {
  group('ReflexGameStatus', () {
    test('has correct enum values', () {
      expect(ReflexGameStatus.values, [
        ReflexGameStatus.idle,
        ReflexGameStatus.playing,
        ReflexGameStatus.gameOver,
      ]);
    });
  });

  group('ReflexGameState', () {
    group('default values', () {
      test('creates with default values', () {
        const state = ReflexGameState();

        expect(state.status, ReflexGameStatus.idle);
        expect(state.bars, isEmpty);
        expect(state.score, 0);
        expect(state.successCount, 0);
        expect(state.remainingTime, 15.0);
        expect(state.difficulty, ReflexDifficulty.normal);
        expect(state.reactionTimes, isEmpty);
        expect(state.gameStartTime, null);
        expect(state.lastFrameTime, null);
      });
    });

    group('copyWith', () {
      test('updates status', () {
        const state = ReflexGameState();
        final updated = state.copyWith(status: ReflexGameStatus.playing);

        expect(updated.status, ReflexGameStatus.playing);
        expect(updated.score, state.score);
      });

      test('updates score', () {
        const state = ReflexGameState();
        final updated = state.copyWith(score: 500);

        expect(updated.score, 500);
        expect(updated.status, state.status);
      });

      test('updates bars', () {
        const state = ReflexGameState();
        final bars = [
          FallingBar(
            id: 'bar-1',
            x: 100,
            y: 0,
            velocity: 500,
            spawnTime: DateTime.now(),
          ),
        ];

        final updated = state.copyWith(bars: bars);

        expect(updated.bars.length, 1);
        expect(updated.bars.first.id, 'bar-1');
      });

      test('updates difficulty', () {
        const state = ReflexGameState();
        final updated = state.copyWith(difficulty: ReflexDifficulty.hard);

        expect(updated.difficulty, ReflexDifficulty.hard);
        expect(updated.score, state.score);
      });

      test('updates gameStartTime', () {
        const state = ReflexGameState();
        final startTime = DateTime.now();
        final updated = state.copyWith(gameStartTime: startTime);

        expect(updated.gameStartTime, startTime);
      });
    });

    group('elapsedSeconds', () {
      test('returns 0 when gameStartTime is null', () {
        const state = ReflexGameState();

        expect(state.elapsedSeconds, 0.0);
      });

      test('calculates elapsed time when gameStartTime is set', () async {
        final startTime = DateTime.now();
        final state = ReflexGameState(gameStartTime: startTime);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(state.elapsedSeconds, greaterThanOrEqualTo(0.1));
        expect(state.elapsedSeconds, lessThan(1.0));
      });
    });

    group('currentSpawnInterval', () {
      test('returns 2 seconds for first 5 seconds', () {
        final startTime = DateTime.now().subtract(const Duration(seconds: 3));
        final state = ReflexGameState(gameStartTime: startTime);

        expect(state.currentSpawnInterval, const Duration(seconds: 2));
      });

      test('returns 1 second for 5-10 seconds', () {
        final startTime = DateTime.now().subtract(const Duration(seconds: 7));
        final state = ReflexGameState(gameStartTime: startTime);

        expect(state.currentSpawnInterval, const Duration(seconds: 1));
      });

      test('returns 333ms for 10+ seconds', () {
        final startTime = DateTime.now().subtract(const Duration(seconds: 12));
        final state = ReflexGameState(gameStartTime: startTime);

        expect(state.currentSpawnInterval, const Duration(milliseconds: 333));
      });

      test('transitions correctly at 5 second boundary', () {
        final startTime = DateTime.now().subtract(const Duration(seconds: 4, milliseconds: 900));
        final state = ReflexGameState(gameStartTime: startTime);

        expect(state.currentSpawnInterval, const Duration(seconds: 2));
      });

      test('transitions correctly at 10 second boundary', () {
        final startTime = DateTime.now().subtract(const Duration(seconds: 9, milliseconds: 900));
        final state = ReflexGameState(gameStartTime: startTime);

        expect(state.currentSpawnInterval, const Duration(seconds: 1));
      });
    });

    group('averageReactionTime', () {
      test('returns 0 when no reaction times', () {
        const state = ReflexGameState();

        expect(state.averageReactionTime, 0.0);
      });

      test('calculates average of reaction times', () {
        const state = ReflexGameState(
          reactionTimes: [100.0, 200.0, 300.0],
        );

        expect(state.averageReactionTime, 200.0);
      });

      test('handles single reaction time', () {
        const state = ReflexGameState(
          reactionTimes: [150.0],
        );

        expect(state.averageReactionTime, 150.0);
      });
    });

    group('bestReactionTime', () {
      test('returns null when no reaction times', () {
        const state = ReflexGameState();

        expect(state.bestReactionTime, null);
      });

      test('returns fastest time', () {
        const state = ReflexGameState(
          reactionTimes: [300.0, 100.0, 200.0],
        );

        expect(state.bestReactionTime, 100.0);
      });

      test('handles single reaction time', () {
        const state = ReflexGameState(
          reactionTimes: [250.0],
        );

        expect(state.bestReactionTime, 250.0);
      });
    });

    group('worstReactionTime', () {
      test('returns null when no reaction times', () {
        const state = ReflexGameState();

        expect(state.worstReactionTime, null);
      });

      test('returns slowest time', () {
        const state = ReflexGameState(
          reactionTimes: [300.0, 100.0, 200.0],
        );

        expect(state.worstReactionTime, 300.0);
      });

      test('handles single reaction time', () {
        const state = ReflexGameState(
          reactionTimes: [250.0],
        );

        expect(state.worstReactionTime, 250.0);
      });
    });

    group('calculateSpeedBonus', () {
      test('returns 20 for ultra-fast reaction (<=500ms)', () {
        const state = ReflexGameState();

        expect(state.calculateSpeedBonus(500), 20);
        expect(state.calculateSpeedBonus(300), 20);
        expect(state.calculateSpeedBonus(100), 20);
      });

      test('returns 10 for fast reaction (501-1000ms)', () {
        const state = ReflexGameState();

        expect(state.calculateSpeedBonus(501), 10);
        expect(state.calculateSpeedBonus(750), 10);
        expect(state.calculateSpeedBonus(1000), 10);
      });

      test('returns 5 for standard reaction (1001-1500ms)', () {
        const state = ReflexGameState();

        expect(state.calculateSpeedBonus(1001), 5);
        expect(state.calculateSpeedBonus(1250), 5);
        expect(state.calculateSpeedBonus(1500), 5);
      });

      test('returns 0 for slow reaction (>1500ms)', () {
        const state = ReflexGameState();

        expect(state.calculateSpeedBonus(1501), 0);
        expect(state.calculateSpeedBonus(2000), 0);
        expect(state.calculateSpeedBonus(5000), 0);
      });
    });

    group('game flow', () {
      test('typical game start flow', () {
        const initial = ReflexGameState();
        expect(initial.status, ReflexGameStatus.idle);

        final playing = initial.copyWith(
          status: ReflexGameStatus.playing,
          gameStartTime: DateTime.now(),
        );

        expect(playing.status, ReflexGameStatus.playing);
        expect(playing.gameStartTime, isNotNull);
      });

      test('game over flow', () {
        final state = ReflexGameState(
          status: ReflexGameStatus.playing,
          score: 1000,
          successCount: 15,
          gameStartTime: DateTime.now(),
        );

        final gameOver = state.copyWith(
          status: ReflexGameStatus.gameOver,
          remainingTime: 0,
        );

        expect(gameOver.status, ReflexGameStatus.gameOver);
        expect(gameOver.remainingTime, 0);
        expect(gameOver.score, state.score);
      });

      test('accumulates reaction times', () {
        const initial = ReflexGameState();

        final afterFirstTap = initial.copyWith(
          reactionTimes: [150.0],
          successCount: 1,
          score: 100,
        );

        expect(afterFirstTap.reactionTimes.length, 1);
        expect(afterFirstTap.successCount, 1);

        final afterSecondTap = afterFirstTap.copyWith(
          reactionTimes: [...afterFirstTap.reactionTimes, 200.0],
          successCount: 2,
          score: 200,
        );

        expect(afterSecondTap.reactionTimes.length, 2);
        expect(afterSecondTap.successCount, 2);
      });
    });

    group('equality', () {
      test('states with same values are equal', () {
        final startTime = DateTime.now();

        final state1 = ReflexGameState(
          status: ReflexGameStatus.playing,
          score: 1000,
          gameStartTime: startTime,
        );

        final state2 = ReflexGameState(
          status: ReflexGameStatus.playing,
          score: 1000,
          gameStartTime: startTime,
        );

        expect(state1, equals(state2));
      });

      test('states with different values are not equal', () {
        final state1 = const ReflexGameState(
          status: ReflexGameStatus.playing,
        );

        final state2 = const ReflexGameState(
          status: ReflexGameStatus.gameOver,
        );

        expect(state1, isNot(equals(state2)));
      });
    });
  });
}
