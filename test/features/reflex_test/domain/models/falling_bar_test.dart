import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/reflex_test/domain/models/falling_bar.dart';

void main() {
  group('FallingBar', () {
    group('constants', () {
      test('has correct width', () {
        expect(FallingBar.width, 40.0);
      });

      test('has correct height', () {
        expect(FallingBar.height, 160.0);
      });
    });

    group('creation', () {
      test('creates with required fields', () {
        final spawnTime = DateTime.now();
        final bar = FallingBar(
          id: 'test-1',
          x: 100.0,
          y: 0.0,
          velocity: 500.0,
          spawnTime: spawnTime,
        );

        expect(bar.id, 'test-1');
        expect(bar.x, 100.0);
        expect(bar.y, 0.0);
        expect(bar.velocity, 500.0);
        expect(bar.spawnTime, spawnTime);
        expect(bar.isTapped, false);
      });

      test('creates with isTapped flag', () {
        final bar = FallingBar(
          id: 'test-1',
          x: 100.0,
          y: 0.0,
          velocity: 500.0,
          spawnTime: DateTime.now(),
          isTapped: true,
        );

        expect(bar.isTapped, true);
      });
    });

    group('contains', () {
      late FallingBar bar;

      setUp(() {
        bar = FallingBar(
          id: 'test-1',
          x: 100.0,
          y: 200.0,
          velocity: 500.0,
          spawnTime: DateTime.now(),
        );
      });

      test('returns true for position inside bar', () {
        // Center of the bar
        final position = Offset(
          bar.x + FallingBar.width / 2,
          bar.y + FallingBar.height / 2,
        );

        expect(bar.contains(position), true);
      });

      test('returns true for position at top-left corner', () {
        final position = Offset(bar.x, bar.y);

        expect(bar.contains(position), true);
      });

      test('returns true for position at bottom-right corner', () {
        final position = Offset(
          bar.x + FallingBar.width,
          bar.y + FallingBar.height,
        );

        expect(bar.contains(position), true);
      });

      test('returns false for position to the left of bar', () {
        final position = Offset(bar.x - 1, bar.y + 50);

        expect(bar.contains(position), false);
      });

      test('returns false for position to the right of bar', () {
        final position = Offset(bar.x + FallingBar.width + 1, bar.y + 50);

        expect(bar.contains(position), false);
      });

      test('returns false for position above bar', () {
        final position = Offset(bar.x + 20, bar.y - 1);

        expect(bar.contains(position), false);
      });

      test('returns false for position below bar', () {
        final position = Offset(bar.x + 20, bar.y + FallingBar.height + 1);

        expect(bar.contains(position), false);
      });

      test('returns false for position at (0,0) when bar is elsewhere', () {
        final position = const Offset(0, 0);

        expect(bar.contains(position), false);
      });
    });

    group('reactionTimeMs', () {
      test('calculates reaction time', () async {
        final spawnTime = DateTime.now();
        final bar = FallingBar(
          id: 'test-1',
          x: 100.0,
          y: 0.0,
          velocity: 500.0,
          spawnTime: spawnTime,
        );

        // Wait a short time
        await Future.delayed(const Duration(milliseconds: 50));

        final reactionTime = bar.reactionTimeMs;

        expect(reactionTime, greaterThanOrEqualTo(50));
        expect(reactionTime, lessThan(200)); // Should not be too large
      });

      test('reaction time increases over time', () async {
        final spawnTime = DateTime.now();
        final bar = FallingBar(
          id: 'test-1',
          x: 100.0,
          y: 0.0,
          velocity: 500.0,
          spawnTime: spawnTime,
        );

        final firstReactionTime = bar.reactionTimeMs;
        await Future.delayed(const Duration(milliseconds: 30));
        final secondReactionTime = bar.reactionTimeMs;

        expect(secondReactionTime, greaterThan(firstReactionTime));
      });
    });

    group('copyWith', () {
      test('updates x coordinate', () {
        final bar = FallingBar(
          id: 'test-1',
          x: 100.0,
          y: 200.0,
          velocity: 500.0,
          spawnTime: DateTime.now(),
        );

        final updated = bar.copyWith(x: 150.0);

        expect(updated.x, 150.0);
        expect(updated.y, bar.y);
        expect(updated.id, bar.id);
      });

      test('updates y coordinate', () {
        final bar = FallingBar(
          id: 'test-1',
          x: 100.0,
          y: 200.0,
          velocity: 500.0,
          spawnTime: DateTime.now(),
        );

        final updated = bar.copyWith(y: 300.0);

        expect(updated.y, 300.0);
        expect(updated.x, bar.x);
      });

      test('updates isTapped flag', () {
        final bar = FallingBar(
          id: 'test-1',
          x: 100.0,
          y: 200.0,
          velocity: 500.0,
          spawnTime: DateTime.now(),
          isTapped: false,
        );

        final updated = bar.copyWith(isTapped: true);

        expect(updated.isTapped, true);
        expect(updated.x, bar.x);
        expect(updated.y, bar.y);
      });
    });

    group('equality', () {
      test('bars with same values are equal', () {
        final spawnTime = DateTime.now();
        final bar1 = FallingBar(
          id: 'test-1',
          x: 100.0,
          y: 200.0,
          velocity: 500.0,
          spawnTime: spawnTime,
        );

        final bar2 = FallingBar(
          id: 'test-1',
          x: 100.0,
          y: 200.0,
          velocity: 500.0,
          spawnTime: spawnTime,
        );

        expect(bar1, equals(bar2));
      });

      test('bars with different ids are not equal', () {
        final spawnTime = DateTime.now();
        final bar1 = FallingBar(
          id: 'test-1',
          x: 100.0,
          y: 200.0,
          velocity: 500.0,
          spawnTime: spawnTime,
        );

        final bar2 = FallingBar(
          id: 'test-2',
          x: 100.0,
          y: 200.0,
          velocity: 500.0,
          spawnTime: spawnTime,
        );

        expect(bar1, isNot(equals(bar2)));
      });

      test('bars with different positions are not equal', () {
        final spawnTime = DateTime.now();
        final bar1 = FallingBar(
          id: 'test-1',
          x: 100.0,
          y: 200.0,
          velocity: 500.0,
          spawnTime: spawnTime,
        );

        final bar2 = FallingBar(
          id: 'test-1',
          x: 150.0,
          y: 200.0,
          velocity: 500.0,
          spawnTime: spawnTime,
        );

        expect(bar1, isNot(equals(bar2)));
      });
    });
  });
}
