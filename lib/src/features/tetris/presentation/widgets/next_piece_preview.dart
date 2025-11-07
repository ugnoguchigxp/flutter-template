import 'package:flutter/material.dart';

import '../../domain/models/tetromino.dart';

class NextPiecePreview extends StatelessWidget {
  const NextPiecePreview({
    required this.nextTetromino,
    this.size = 80,
    super.key,
  });

  final Tetromino? nextTetromino;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'NEXT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: size,
            height: size,
            child: nextTetromino != null
                ? CustomPaint(
                    painter: NextPiecePainter(tetromino: nextTetromino!),
                    child: const SizedBox.expand(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class NextPiecePainter extends CustomPainter {
  const NextPiecePainter({required this.tetromino});

  final Tetromino tetromino;

  @override
  void paint(Canvas canvas, Size size) {
    final shape = tetromino.shape;
    final shapeSize = shape.length;

    // セルのサイズを計算
    final cellSize = size.width / 4; // 4x4グリッド

    // 中央に配置するためのオフセット
    final offsetX = (4 - shapeSize) * cellSize / 2;
    final offsetY = (4 - shapeSize) * cellSize / 2;

    for (int y = 0; y < shape.length; y++) {
      for (int x = 0; x < shape[y].length; x++) {
        if (shape[y][x] == 0) continue;

        final rect = Rect.fromLTWH(
          offsetX + x * cellSize,
          offsetY + y * cellSize,
          cellSize,
          cellSize,
        );

        final paint = Paint()..color = tetromino.color;
        canvas.drawRect(rect, paint);

        // 内側のハイライト
        final highlightPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

        canvas.drawRect(
          rect.deflate(0.5),
          highlightPaint,
        );

        // 影
        final shadowPaint = Paint()
          ..color = Colors.black.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

        canvas.drawLine(
          Offset(rect.left + 1, rect.bottom - 1),
          Offset(rect.right - 1, rect.bottom - 1),
          shadowPaint,
        );
        canvas.drawLine(
          Offset(rect.right - 1, rect.top + 1),
          Offset(rect.right - 1, rect.bottom - 1),
          shadowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(NextPiecePainter oldDelegate) {
    return tetromino != oldDelegate.tetromino;
  }
}
