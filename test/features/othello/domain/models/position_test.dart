import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/othello/domain/models/position.dart';

void main() {
  group('Position', () {
    group('isValid', () {
      test('position (0,0) is valid', () {
        const position = Position(row: 0, col: 0);
        expect(position.isValid, true);
      });

      test('position (7,7) is valid', () {
        const position = Position(row: 7, col: 7);
        expect(position.isValid, true);
      });

      test('position (3,4) is valid', () {
        const position = Position(row: 3, col: 4);
        expect(position.isValid, true);
      });

      test('position (-1,0) is invalid', () {
        const position = Position(row: -1, col: 0);
        expect(position.isValid, false);
      });

      test('position (0,-1) is invalid', () {
        const position = Position(row: 0, col: -1);
        expect(position.isValid, false);
      });

      test('position (8,0) is invalid', () {
        const position = Position(row: 8, col: 0);
        expect(position.isValid, false);
      });

      test('position (0,8) is invalid', () {
        const position = Position(row: 0, col: 8);
        expect(position.isValid, false);
      });

      test('position (8,8) is invalid', () {
        const position = Position(row: 8, col: 8);
        expect(position.isValid, false);
      });

      test('position (-1,-1) is invalid', () {
        const position = Position(row: -1, col: -1);
        expect(position.isValid, false);
      });
    });

    group('move', () {
      test('move up decreases row', () {
        const position = Position(row: 3, col: 4);
        final result = position.move(-1, 0);
        expect(result.row, 2);
        expect(result.col, 4);
      });

      test('move down increases row', () {
        const position = Position(row: 3, col: 4);
        final result = position.move(1, 0);
        expect(result.row, 4);
        expect(result.col, 4);
      });

      test('move left decreases col', () {
        const position = Position(row: 3, col: 4);
        final result = position.move(0, -1);
        expect(result.row, 3);
        expect(result.col, 3);
      });

      test('move right increases col', () {
        const position = Position(row: 3, col: 4);
        final result = position.move(0, 1);
        expect(result.row, 3);
        expect(result.col, 5);
      });

      test('diagonal move works correctly', () {
        const position = Position(row: 3, col: 4);
        final result = position.move(1, 1);
        expect(result.row, 4);
        expect(result.col, 5);
      });

      test('move can result in invalid position', () {
        const position = Position(row: 0, col: 0);
        final result = position.move(-1, -1);
        expect(result.isValid, false);
      });
    });

    group('directions', () {
      test('has 8 directions', () {
        expect(Position.directions.length, 8);
      });

      test('contains all 8 cardinal and diagonal directions', () {
        final directions = Position.directions;

        expect(directions, contains(const Position(row: -1, col: -1))); // 左上
        expect(directions, contains(const Position(row: -1, col: 0))); // 上
        expect(directions, contains(const Position(row: -1, col: 1))); // 右上
        expect(directions, contains(const Position(row: 0, col: -1))); // 左
        expect(directions, contains(const Position(row: 0, col: 1))); // 右
        expect(directions, contains(const Position(row: 1, col: -1))); // 左下
        expect(directions, contains(const Position(row: 1, col: 0))); // 下
        expect(directions, contains(const Position(row: 1, col: 1))); // 右下
      });
    });

    group('equality', () {
      test('positions with same row and col are equal', () {
        const pos1 = Position(row: 3, col: 4);
        const pos2 = Position(row: 3, col: 4);
        expect(pos1, equals(pos2));
      });

      test('positions with different row are not equal', () {
        const pos1 = Position(row: 3, col: 4);
        const pos2 = Position(row: 4, col: 4);
        expect(pos1, isNot(equals(pos2)));
      });

      test('positions with different col are not equal', () {
        const pos1 = Position(row: 3, col: 4);
        const pos2 = Position(row: 3, col: 5);
        expect(pos1, isNot(equals(pos2)));
      });
    });

    group('copyWith', () {
      test('copyWith creates new instance with updated values', () {
        const original = Position(row: 3, col: 4);
        final updated = original.copyWith(row: 5);

        expect(updated.row, 5);
        expect(updated.col, 4);
        expect(original.row, 3); // Original unchanged
      });

      test('copyWith updates both row and col', () {
        const original = Position(row: 3, col: 4);
        final updated = original.copyWith(row: 1, col: 2);

        expect(updated.row, 1);
        expect(updated.col, 2);
        expect(original.row, 3);
        expect(original.col, 4);
      });

      test('copyWith with null values preserves original', () {
        const original = Position(row: 3, col: 4);
        final updated = original.copyWith();

        expect(updated.row, 3);
        expect(updated.col, 4);
        expect(updated, equals(original));
      });
    });
  });
}
