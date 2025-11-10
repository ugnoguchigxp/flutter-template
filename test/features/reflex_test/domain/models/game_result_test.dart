import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/reflex_test/domain/models/difficulty.dart';
import 'package:flutter_template/src/features/reflex_test/domain/models/game_result.dart';

void main() {
  group('GameResult', () {
    group('creation', () {
      test('creates with all fields', () {
        final playedAt = DateTime.now();
        final reactionTimes = [100.0, 200.0, 300.0];

        final result = GameResult(
          score: 1000,
          successCount: 15,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: reactionTimes,
          playedAt: playedAt,
        );

        expect(result.score, 1000);
        expect(result.successCount, 15);
        expect(result.difficulty, ReflexDifficulty.normal);
        expect(result.reactionTimes, reactionTimes);
        expect(result.playedAt, playedAt);
      });
    });

    group('averageReactionTime', () {
      test('calculates average correctly', () {
        final result = GameResult(
          score: 1000,
          successCount: 3,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [100.0, 200.0, 300.0],
          playedAt: DateTime.now(),
        );

        expect(result.averageReactionTime, 200.0);
      });

      test('returns 0 when reaction times is empty', () {
        final result = GameResult(
          score: 0,
          successCount: 0,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: DateTime.now(),
        );

        expect(result.averageReactionTime, 0.0);
      });

      test('calculates average with single value', () {
        final result = GameResult(
          score: 100,
          successCount: 1,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [150.0],
          playedAt: DateTime.now(),
        );

        expect(result.averageReactionTime, 150.0);
      });

      test('calculates average with decimal values', () {
        final result = GameResult(
          score: 500,
          successCount: 3,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [100.5, 200.3, 300.2],
          playedAt: DateTime.now(),
        );

        expect(result.averageReactionTime, closeTo(200.33, 0.01));
      });
    });

    group('bestReactionTime', () {
      test('returns fastest time', () {
        final result = GameResult(
          score: 1000,
          successCount: 4,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [300.0, 100.0, 200.0, 150.0],
          playedAt: DateTime.now(),
        );

        expect(result.bestReactionTime, 100.0);
      });

      test('returns null when reaction times is empty', () {
        final result = GameResult(
          score: 0,
          successCount: 0,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: DateTime.now(),
        );

        expect(result.bestReactionTime, null);
      });

      test('returns single value when only one time', () {
        final result = GameResult(
          score: 100,
          successCount: 1,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [250.0],
          playedAt: DateTime.now(),
        );

        expect(result.bestReactionTime, 250.0);
      });
    });

    group('worstReactionTime', () {
      test('returns slowest time', () {
        final result = GameResult(
          score: 1000,
          successCount: 4,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [300.0, 100.0, 200.0, 150.0],
          playedAt: DateTime.now(),
        );

        expect(result.worstReactionTime, 300.0);
      });

      test('returns null when reaction times is empty', () {
        final result = GameResult(
          score: 0,
          successCount: 0,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: DateTime.now(),
        );

        expect(result.worstReactionTime, null);
      });

      test('returns single value when only one time', () {
        final result = GameResult(
          score: 100,
          successCount: 1,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [250.0],
          playedAt: DateTime.now(),
        );

        expect(result.worstReactionTime, 250.0);
      });
    });

    group('successRate', () {
      test('calculates success rate correctly', () {
        final result = GameResult(
          score: 1000,
          successCount: 11,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [100.0],
          playedAt: DateTime.now(),
        );

        // 11 / 22 = 0.5
        expect(result.successRate, 0.5);
      });

      test('returns 0 when successCount is 0', () {
        final result = GameResult(
          score: 0,
          successCount: 0,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: DateTime.now(),
        );

        expect(result.successRate, 0.0);
      });

      test('clamps to 1.0 for perfect score', () {
        final result = GameResult(
          score: 2000,
          successCount: 22,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: List.generate(22, (_) => 100.0),
          playedAt: DateTime.now(),
        );

        expect(result.successRate, 1.0);
      });

      test('clamps to 1.0 when exceeds max', () {
        final result = GameResult(
          score: 3000,
          successCount: 30,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: List.generate(30, (_) => 100.0),
          playedAt: DateTime.now(),
        );

        expect(result.successRate, 1.0);
      });

      test('calculates fractional success rate', () {
        final result = GameResult(
          score: 500,
          successCount: 5,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [100.0],
          playedAt: DateTime.now(),
        );

        // 5 / 22 ≈ 0.227
        expect(result.successRate, closeTo(0.227, 0.001));
      });
    });

    group('performanceGrade', () {
      test('returns S for 20+ successes', () {
        final result = GameResult(
          score: 2000,
          successCount: 20,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: DateTime.now(),
        );

        expect(result.performanceGrade, 'S');
      });

      test('returns A for 15-19 successes', () {
        final result = GameResult(
          score: 1500,
          successCount: 15,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: DateTime.now(),
        );

        expect(result.performanceGrade, 'A');
      });

      test('returns B for 10-14 successes', () {
        final result = GameResult(
          score: 1000,
          successCount: 10,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: DateTime.now(),
        );

        expect(result.performanceGrade, 'B');
      });

      test('returns C for 5-9 successes', () {
        final result = GameResult(
          score: 500,
          successCount: 5,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: DateTime.now(),
        );

        expect(result.performanceGrade, 'C');
      });

      test('returns D for less than 5 successes', () {
        final result = GameResult(
          score: 400,
          successCount: 4,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: DateTime.now(),
        );

        expect(result.performanceGrade, 'D');
      });

      test('returns D for 0 successes', () {
        final result = GameResult(
          score: 0,
          successCount: 0,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: DateTime.now(),
        );

        expect(result.performanceGrade, 'D');
      });

      test('grade boundaries work correctly', () {
        expect(
          GameResult(
            score: 0,
            successCount: 4,
            difficulty: ReflexDifficulty.normal,
            reactionTimes: [],
            playedAt: DateTime.now(),
          ).performanceGrade,
          'D',
        );

        expect(
          GameResult(
            score: 0,
            successCount: 9,
            difficulty: ReflexDifficulty.normal,
            reactionTimes: [],
            playedAt: DateTime.now(),
          ).performanceGrade,
          'C',
        );

        expect(
          GameResult(
            score: 0,
            successCount: 14,
            difficulty: ReflexDifficulty.normal,
            reactionTimes: [],
            playedAt: DateTime.now(),
          ).performanceGrade,
          'B',
        );

        expect(
          GameResult(
            score: 0,
            successCount: 19,
            difficulty: ReflexDifficulty.normal,
            reactionTimes: [],
            playedAt: DateTime.now(),
          ).performanceGrade,
          'A',
        );

        expect(
          GameResult(
            score: 0,
            successCount: 25,
            difficulty: ReflexDifficulty.normal,
            reactionTimes: [],
            playedAt: DateTime.now(),
          ).performanceGrade,
          'S',
        );
      });
    });

    group('copyWith', () {
      test('updates score', () {
        final result = GameResult(
          score: 1000,
          successCount: 10,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: DateTime.now(),
        );

        final updated = result.copyWith(score: 2000);

        expect(updated.score, 2000);
        expect(updated.successCount, result.successCount);
      });

      test('updates difficulty', () {
        final result = GameResult(
          score: 1000,
          successCount: 10,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: DateTime.now(),
        );

        final updated = result.copyWith(difficulty: ReflexDifficulty.hard);

        expect(updated.difficulty, ReflexDifficulty.hard);
        expect(updated.score, result.score);
      });
    });

    group('equality', () {
      test('results with same values are equal', () {
        final playedAt = DateTime.now();
        final reactionTimes = [100.0, 200.0];

        final result1 = GameResult(
          score: 1000,
          successCount: 10,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: reactionTimes,
          playedAt: playedAt,
        );

        final result2 = GameResult(
          score: 1000,
          successCount: 10,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: reactionTimes,
          playedAt: playedAt,
        );

        expect(result1, equals(result2));
      });

      test('results with different scores are not equal', () {
        final playedAt = DateTime.now();

        final result1 = GameResult(
          score: 1000,
          successCount: 10,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: playedAt,
        );

        final result2 = GameResult(
          score: 2000,
          successCount: 10,
          difficulty: ReflexDifficulty.normal,
          reactionTimes: [],
          playedAt: playedAt,
        );

        expect(result1, isNot(equals(result2)));
      });
    });
  });
}
