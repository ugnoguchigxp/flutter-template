import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/tetris/domain/models/tetromino.dart';

void main() {
  group('TetrominoType', () {
    test('has 7 types', () {
      expect(TetrominoType.values.length, 7);
    });

    test('has correct enum values', () {
      expect(TetrominoType.values, [
        TetrominoType.i,
        TetrominoType.o,
        TetrominoType.t,
        TetrominoType.s,
        TetrominoType.z,
        TetrominoType.j,
        TetrominoType.l,
      ]);
    });
  });

  group('Position', () {
    group('creation', () {
      test('creates with x and y coordinates', () {
        const position = Position(x: 5, y: 10);

        expect(position.x, 5);
        expect(position.y, 10);
      });

      test('accepts negative coordinates', () {
        const position = Position(x: -3, y: -7);

        expect(position.x, -3);
        expect(position.y, -7);
      });

      test('accepts zero coordinates', () {
        const position = Position(x: 0, y: 0);

        expect(position.x, 0);
        expect(position.y, 0);
      });
    });

    group('copyWith', () {
      test('updates x coordinate', () {
        const position = Position(x: 5, y: 10);
        final updated = position.copyWith(x: 7);

        expect(updated.x, 7);
        expect(updated.y, 10);
      });

      test('updates y coordinate', () {
        const position = Position(x: 5, y: 10);
        final updated = position.copyWith(y: 15);

        expect(updated.x, 5);
        expect(updated.y, 15);
      });

      test('updates both coordinates', () {
        const position = Position(x: 5, y: 10);
        final updated = position.copyWith(x: 7, y: 15);

        expect(updated.x, 7);
        expect(updated.y, 15);
      });

      test('returns new instance with no changes', () {
        const position = Position(x: 5, y: 10);
        final updated = position.copyWith();

        expect(updated.x, 5);
        expect(updated.y, 10);
      });
    });
  });

  group('Tetromino', () {
    group('color', () {
      test('I tetromino has cyan color', () {
        const tetromino = Tetromino(
          type: TetrominoType.i,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.color, Colors.cyan);
      });

      test('O tetromino has yellow color', () {
        const tetromino = Tetromino(
          type: TetrominoType.o,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.color, Colors.yellow);
      });

      test('T tetromino has purple color', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.color, Colors.purple);
      });

      test('S tetromino has green color', () {
        const tetromino = Tetromino(
          type: TetrominoType.s,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.color, Colors.green);
      });

      test('Z tetromino has red color', () {
        const tetromino = Tetromino(
          type: TetrominoType.z,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.color, Colors.red);
      });

      test('J tetromino has blue color', () {
        const tetromino = Tetromino(
          type: TetrominoType.j,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.color, Colors.blue);
      });

      test('L tetromino has orange color', () {
        const tetromino = Tetromino(
          type: TetrominoType.l,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.color, Colors.orange);
      });
    });

    group('shape - I tetromino', () {
      test('rotation 0 has horizontal shape', () {
        const tetromino = Tetromino(
          type: TetrominoType.i,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 0, 0, 0],
          [1, 1, 1, 1],
          [0, 0, 0, 0],
          [0, 0, 0, 0],
        ]);
      });

      test('rotation 1 has vertical shape', () {
        const tetromino = Tetromino(
          type: TetrominoType.i,
          rotation: 1,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 0, 1, 0],
          [0, 0, 1, 0],
          [0, 0, 1, 0],
          [0, 0, 1, 0],
        ]);
      });

      test('rotation 2 cycles back to rotation 0', () {
        const tetromino = Tetromino(
          type: TetrominoType.i,
          rotation: 2,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 0, 0, 0],
          [1, 1, 1, 1],
          [0, 0, 0, 0],
          [0, 0, 0, 0],
        ]);
      });

      test('negative rotation works correctly', () {
        const tetromino = Tetromino(
          type: TetrominoType.i,
          rotation: -1,
          position: Position(x: 0, y: 0),
        );

        // -1 should map to last rotation (1)
        expect(tetromino.shape, [
          [0, 0, 1, 0],
          [0, 0, 1, 0],
          [0, 0, 1, 0],
          [0, 0, 1, 0],
        ]);
      });
    });

    group('shape - O tetromino', () {
      test('rotation 0 has square shape', () {
        const tetromino = Tetromino(
          type: TetrominoType.o,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [1, 1],
          [1, 1],
        ]);
      });

      test('rotation does not change O shape', () {
        const tetromino1 = Tetromino(
          type: TetrominoType.o,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );
        const tetromino2 = Tetromino(
          type: TetrominoType.o,
          rotation: 1,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino1.shape, tetromino2.shape);
      });
    });

    group('shape - T tetromino', () {
      test('rotation 0 has T-up shape', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 1, 0],
          [1, 1, 1],
          [0, 0, 0],
        ]);
      });

      test('rotation 1 has T-right shape', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          rotation: 1,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 1, 0],
          [0, 1, 1],
          [0, 1, 0],
        ]);
      });

      test('rotation 2 has T-down shape', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          rotation: 2,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 0, 0],
          [1, 1, 1],
          [0, 1, 0],
        ]);
      });

      test('rotation 3 has T-left shape', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          rotation: 3,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 1, 0],
          [1, 1, 0],
          [0, 1, 0],
        ]);
      });

      test('rotation 4 cycles back to rotation 0', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          rotation: 4,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 1, 0],
          [1, 1, 1],
          [0, 0, 0],
        ]);
      });
    });

    group('shape - S tetromino', () {
      test('rotation 0 has S-horizontal shape', () {
        const tetromino = Tetromino(
          type: TetrominoType.s,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 1, 1],
          [1, 1, 0],
          [0, 0, 0],
        ]);
      });

      test('rotation 1 has S-vertical shape', () {
        const tetromino = Tetromino(
          type: TetrominoType.s,
          rotation: 1,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 1, 0],
          [0, 1, 1],
          [0, 0, 1],
        ]);
      });
    });

    group('shape - Z tetromino', () {
      test('rotation 0 has Z-horizontal shape', () {
        const tetromino = Tetromino(
          type: TetrominoType.z,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [1, 1, 0],
          [0, 1, 1],
          [0, 0, 0],
        ]);
      });

      test('rotation 1 has Z-vertical shape', () {
        const tetromino = Tetromino(
          type: TetrominoType.z,
          rotation: 1,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 0, 1],
          [0, 1, 1],
          [0, 1, 0],
        ]);
      });
    });

    group('shape - J tetromino', () {
      test('rotation 0 has J shape', () {
        const tetromino = Tetromino(
          type: TetrominoType.j,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [1, 0, 0],
          [1, 1, 1],
          [0, 0, 0],
        ]);
      });

      test('rotation 1 rotates J 90 degrees', () {
        const tetromino = Tetromino(
          type: TetrominoType.j,
          rotation: 1,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 1, 1],
          [0, 1, 0],
          [0, 1, 0],
        ]);
      });

      test('rotation 2 rotates J 180 degrees', () {
        const tetromino = Tetromino(
          type: TetrominoType.j,
          rotation: 2,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 0, 0],
          [1, 1, 1],
          [0, 0, 1],
        ]);
      });

      test('rotation 3 rotates J 270 degrees', () {
        const tetromino = Tetromino(
          type: TetrominoType.j,
          rotation: 3,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 1, 0],
          [0, 1, 0],
          [1, 1, 0],
        ]);
      });
    });

    group('shape - L tetromino', () {
      test('rotation 0 has L shape', () {
        const tetromino = Tetromino(
          type: TetrominoType.l,
          rotation: 0,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 0, 1],
          [1, 1, 1],
          [0, 0, 0],
        ]);
      });

      test('rotation 1 rotates L 90 degrees', () {
        const tetromino = Tetromino(
          type: TetrominoType.l,
          rotation: 1,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 1, 0],
          [0, 1, 0],
          [0, 1, 1],
        ]);
      });

      test('rotation 2 rotates L 180 degrees', () {
        const tetromino = Tetromino(
          type: TetrominoType.l,
          rotation: 2,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 0, 0],
          [1, 1, 1],
          [1, 0, 0],
        ]);
      });

      test('rotation 3 rotates L 270 degrees', () {
        const tetromino = Tetromino(
          type: TetrominoType.l,
          rotation: 3,
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [1, 1, 0],
          [0, 1, 0],
          [0, 1, 0],
        ]);
      });
    });

    group('copyWith', () {
      test('updates type', () {
        const tetromino = Tetromino(
          type: TetrominoType.i,
          rotation: 0,
          position: Position(x: 5, y: 10),
        );

        final updated = tetromino.copyWith(type: TetrominoType.t);

        expect(updated.type, TetrominoType.t);
        expect(updated.rotation, 0);
        expect(updated.position.x, 5);
        expect(updated.position.y, 10);
      });

      test('updates rotation', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          rotation: 0,
          position: Position(x: 5, y: 10),
        );

        final updated = tetromino.copyWith(rotation: 2);

        expect(updated.type, TetrominoType.t);
        expect(updated.rotation, 2);
        expect(updated.position.x, 5);
        expect(updated.position.y, 10);
      });

      test('updates position', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          rotation: 0,
          position: Position(x: 5, y: 10),
        );

        final updated = tetromino.copyWith(
          position: const Position(x: 7, y: 15),
        );

        expect(updated.type, TetrominoType.t);
        expect(updated.rotation, 0);
        expect(updated.position.x, 7);
        expect(updated.position.y, 15);
      });

      test('updates all properties', () {
        const tetromino = Tetromino(
          type: TetrominoType.i,
          rotation: 0,
          position: Position(x: 5, y: 10),
        );

        final updated = tetromino.copyWith(
          type: TetrominoType.l,
          rotation: 3,
          position: const Position(x: 2, y: 8),
        );

        expect(updated.type, TetrominoType.l);
        expect(updated.rotation, 3);
        expect(updated.position.x, 2);
        expect(updated.position.y, 8);
      });

      test('returns tetromino with no changes', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          rotation: 1,
          position: Position(x: 5, y: 10),
        );

        final updated = tetromino.copyWith();

        expect(updated.type, TetrominoType.t);
        expect(updated.rotation, 1);
        expect(updated.position.x, 5);
        expect(updated.position.y, 10);
      });
    });

    group('rotation normalization', () {
      test('large positive rotation wraps correctly', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          rotation: 8, // 8 % 4 = 0
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 1, 0],
          [1, 1, 1],
          [0, 0, 0],
        ]);
      });

      test('negative rotation wraps correctly for T piece', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          rotation: -1,
          position: Position(x: 0, y: 0),
        );

        // -1 should map to rotation 3
        expect(tetromino.shape, [
          [0, 1, 0],
          [1, 1, 0],
          [0, 1, 0],
        ]);
      });

      test('large negative rotation wraps correctly', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          rotation: -5, // Should map to rotation 3
          position: Position(x: 0, y: 0),
        );

        expect(tetromino.shape, [
          [0, 1, 0],
          [1, 1, 0],
          [0, 1, 0],
        ]);
      });
    });

    group('all tetrominoes coverage', () {
      test('all 7 types can be created', () {
        for (final type in TetrominoType.values) {
          final tetromino = Tetromino(
            type: type,
            rotation: 0,
            position: const Position(x: 0, y: 0),
          );

          expect(tetromino.type, type);
          expect(tetromino.shape, isNotEmpty);
          expect(tetromino.color, isNotNull);
        }
      });

      test('all types have valid shapes', () {
        for (final type in TetrominoType.values) {
          final tetromino = Tetromino(
            type: type,
            rotation: 0,
            position: const Position(x: 0, y: 0),
          );

          final shape = tetromino.shape;
          expect(shape, isNotEmpty);
          expect(shape.first, isNotEmpty);

          // Verify all rows have same length
          final rowLength = shape.first.length;
          for (final row in shape) {
            expect(row.length, rowLength);
          }
        }
      });

      test('all types have distinct colors', () {
        final colors = <Color>{};

        for (final type in TetrominoType.values) {
          final tetromino = Tetromino(
            type: type,
            rotation: 0,
            position: const Position(x: 0, y: 0),
          );
          colors.add(tetromino.color);
        }

        // All 7 types should have distinct colors
        expect(colors.length, 7);
      });
    });
  });
}
