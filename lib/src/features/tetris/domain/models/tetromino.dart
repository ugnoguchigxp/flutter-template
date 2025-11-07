import 'package:flutter/material.dart';

enum TetrominoType {
  i,
  o,
  t,
  s,
  z,
  j,
  l,
}

class Tetromino {
  const Tetromino({
    required this.type,
    required this.rotation,
    required this.position,
  });

  final TetrominoType type;
  final int rotation;
  final Position position;

  Color get color {
    switch (type) {
      case TetrominoType.i:
        return Colors.cyan;
      case TetrominoType.o:
        return Colors.yellow;
      case TetrominoType.t:
        return Colors.purple;
      case TetrominoType.s:
        return Colors.green;
      case TetrominoType.z:
        return Colors.red;
      case TetrominoType.j:
        return Colors.blue;
      case TetrominoType.l:
        return Colors.orange;
    }
  }

  List<List<int>> get shape {
    final shapes = _getShapes(type);
    // 負数を考慮した剰余計算
    final normalizedRotation = rotation % shapes.length;
    final index = normalizedRotation < 0
        ? normalizedRotation + shapes.length
        : normalizedRotation;
    return shapes[index];
  }

  Tetromino copyWith({
    TetrominoType? type,
    int? rotation,
    Position? position,
  }) {
    return Tetromino(
      type: type ?? this.type,
      rotation: rotation ?? this.rotation,
      position: position ?? this.position,
    );
  }

  static List<List<List<int>>> _getShapes(TetrominoType type) {
    switch (type) {
      case TetrominoType.i:
        return [
          [
            [0, 0, 0, 0],
            [1, 1, 1, 1],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
          ],
          [
            [0, 0, 1, 0],
            [0, 0, 1, 0],
            [0, 0, 1, 0],
            [0, 0, 1, 0],
          ],
        ];
      case TetrominoType.o:
        return [
          [
            [1, 1],
            [1, 1],
          ],
        ];
      case TetrominoType.t:
        return [
          [
            [0, 1, 0],
            [1, 1, 1],
            [0, 0, 0],
          ],
          [
            [0, 1, 0],
            [0, 1, 1],
            [0, 1, 0],
          ],
          [
            [0, 0, 0],
            [1, 1, 1],
            [0, 1, 0],
          ],
          [
            [0, 1, 0],
            [1, 1, 0],
            [0, 1, 0],
          ],
        ];
      case TetrominoType.s:
        return [
          [
            [0, 1, 1],
            [1, 1, 0],
            [0, 0, 0],
          ],
          [
            [0, 1, 0],
            [0, 1, 1],
            [0, 0, 1],
          ],
        ];
      case TetrominoType.z:
        return [
          [
            [1, 1, 0],
            [0, 1, 1],
            [0, 0, 0],
          ],
          [
            [0, 0, 1],
            [0, 1, 1],
            [0, 1, 0],
          ],
        ];
      case TetrominoType.j:
        return [
          [
            [1, 0, 0],
            [1, 1, 1],
            [0, 0, 0],
          ],
          [
            [0, 1, 1],
            [0, 1, 0],
            [0, 1, 0],
          ],
          [
            [0, 0, 0],
            [1, 1, 1],
            [0, 0, 1],
          ],
          [
            [0, 1, 0],
            [0, 1, 0],
            [1, 1, 0],
          ],
        ];
      case TetrominoType.l:
        return [
          [
            [0, 0, 1],
            [1, 1, 1],
            [0, 0, 0],
          ],
          [
            [0, 1, 0],
            [0, 1, 0],
            [0, 1, 1],
          ],
          [
            [0, 0, 0],
            [1, 1, 1],
            [1, 0, 0],
          ],
          [
            [1, 1, 0],
            [0, 1, 0],
            [0, 1, 0],
          ],
        ];
    }
  }
}

class Position {
  const Position({required this.x, required this.y});

  final int x;
  final int y;

  Position copyWith({int? x, int? y}) {
    return Position(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
