import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';

@freezed
class Position with _$Position {
  const factory Position({required int row, required int col}) = _Position;

  const Position._();

  bool get isValid => row >= 0 && row < 8 && col >= 0 && col < 8;

  Position move(int deltaRow, int deltaCol) {
    return Position(row: row + deltaRow, col: col + deltaCol);
  }

  static const List<Position> directions = [
    Position(row: -1, col: -1), // 左上
    Position(row: -1, col: 0), // 上
    Position(row: -1, col: 1), // 右上
    Position(row: 0, col: -1), // 左
    Position(row: 0, col: 1), // 右
    Position(row: 1, col: -1), // 左下
    Position(row: 1, col: 0), // 下
    Position(row: 1, col: 1), // 右下
  ];
}
