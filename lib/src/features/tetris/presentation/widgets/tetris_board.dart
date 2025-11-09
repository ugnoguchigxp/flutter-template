import 'package:flutter/material.dart';

import '../../domain/models/tetris_game_state.dart';
import '../providers/tetris_game_provider.dart';

class TetrisBoard extends StatelessWidget {
  const TetrisBoard({required this.gameState, super.key});

  final TetrisGameState gameState;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: boardWidth / boardHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.grey.shade700, width: 2),
        ),
        child: CustomPaint(
          painter: TetrisBoardPainter(gameState: gameState),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class TetrisBoardPainter extends CustomPainter {
  const TetrisBoardPainter({required this.gameState});

  final TetrisGameState gameState;

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / boardWidth;
    final cellHeight = size.height / boardHeight;

    // ボードの既存ブロックを描画
    for (int y = 0; y < boardHeight; y++) {
      for (int x = 0; x < boardWidth; x++) {
        final color = gameState.board[y][x];
        if (color != null) {
          _drawCell(canvas, x, y, cellWidth, cellHeight, color);
        }
      }
    }

    // 現在のテトロミノを描画
    if (gameState.currentTetromino != null) {
      final tetromino = gameState.currentTetromino!;
      final shape = tetromino.shape;

      for (int y = 0; y < shape.length; y++) {
        for (int x = 0; x < shape[y].length; x++) {
          if (shape[y][x] == 0) continue;

          final boardX = tetromino.position.x + x;
          final boardY = tetromino.position.y + y;

          if (boardY >= 0 &&
              boardY < boardHeight &&
              boardX >= 0 &&
              boardX < boardWidth) {
            _drawCell(
              canvas,
              boardX,
              boardY,
              cellWidth,
              cellHeight,
              tetromino.color,
            );
          }
        }
      }
    }

    // グリッド線を描画
    _drawGrid(canvas, size, cellWidth, cellHeight);
  }

  void _drawCell(
    Canvas canvas,
    int x,
    int y,
    double cellWidth,
    double cellHeight,
    Color color,
  ) {
    final rect = Rect.fromLTWH(
      x * cellWidth,
      y * cellHeight,
      cellWidth,
      cellHeight,
    );

    final paint = Paint()..color = color;
    canvas.drawRect(rect, paint);

    // 内側のハイライト
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRect(rect.deflate(1), highlightPaint);

    // 影
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset(rect.left + 2, rect.bottom - 2),
      Offset(rect.right - 2, rect.bottom - 2),
      shadowPaint,
    );
    canvas.drawLine(
      Offset(rect.right - 2, rect.top + 2),
      Offset(rect.right - 2, rect.bottom - 2),
      shadowPaint,
    );
  }

  void _drawGrid(
    Canvas canvas,
    Size size,
    double cellWidth,
    double cellHeight,
  ) {
    final gridPaint = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = 0.5;

    // 縦線
    for (int x = 0; x <= boardWidth; x++) {
      canvas.drawLine(
        Offset(x * cellWidth, 0),
        Offset(x * cellWidth, size.height),
        gridPaint,
      );
    }

    // 横線
    for (int y = 0; y <= boardHeight; y++) {
      canvas.drawLine(
        Offset(0, y * cellHeight),
        Offset(size.width, y * cellHeight),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(TetrisBoardPainter oldDelegate) {
    // 描画に影響するフィールドのみを比較
    return gameState.board != oldDelegate.gameState.board ||
        gameState.currentTetromino != oldDelegate.gameState.currentTetromino;
  }
}
