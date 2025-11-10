import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/reflex_test/domain/models/difficulty.dart';

void main() {
  group('ReflexDifficulty', () {
    group('enum values', () {
      test('has correct enum values', () {
        expect(ReflexDifficulty.values, [
          ReflexDifficulty.easy,
          ReflexDifficulty.normal,
          ReflexDifficulty.hard,
        ]);
      });

      test('has 3 difficulty levels', () {
        expect(ReflexDifficulty.values.length, 3);
      });
    });

    group('label', () {
      test('easy has correct label', () {
        expect(ReflexDifficulty.easy.label, 'イージー');
      });

      test('normal has correct label', () {
        expect(ReflexDifficulty.normal.label, 'ノーマル');
      });

      test('hard has correct label', () {
        expect(ReflexDifficulty.hard.label, 'ハード');
      });
    });

    group('description', () {
      test('easy has correct description', () {
        expect(ReflexDifficulty.easy.description, 'ゆっくり落下');
      });

      test('normal has correct description', () {
        expect(ReflexDifficulty.normal.description, '標準速度');
      });

      test('hard has correct description', () {
        expect(ReflexDifficulty.hard.description, '高速落下');
      });
    });

    group('gravity', () {
      test('easy has lowest gravity', () {
        expect(ReflexDifficulty.easy.gravity, 600.0);
      });

      test('normal has medium gravity', () {
        expect(ReflexDifficulty.normal.gravity, 2000.0);
      });

      test('hard has highest gravity', () {
        expect(ReflexDifficulty.hard.gravity, 4000.0);
      });

      test('difficulties are ordered by gravity', () {
        expect(
          ReflexDifficulty.easy.gravity < ReflexDifficulty.normal.gravity,
          true,
        );
        expect(
          ReflexDifficulty.normal.gravity < ReflexDifficulty.hard.gravity,
          true,
        );
      });
    });

    group('buttonColor', () {
      test('easy has green color', () {
        expect(ReflexDifficulty.easy.buttonColor, Colors.green);
      });

      test('normal has blue color', () {
        expect(ReflexDifficulty.normal.buttonColor, Colors.blue);
      });

      test('hard has red color', () {
        expect(ReflexDifficulty.hard.buttonColor, Colors.red);
      });
    });
  });
}
