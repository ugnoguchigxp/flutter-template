import 'package:flutter/material.dart';

import 'package:flutter_template/src/features/reflex_test/domain/models/falling_bar.dart';
import 'package:flutter_template/src/features/reflex_test/domain/models/reflex_game_state.dart';

class GameCanvas extends StatelessWidget {
  const GameCanvas({
    required this.gameState,
    required this.onTapDown,
    super.key,
  });

  final ReflexGameState gameState;
  final void Function(TapDownDetails) onTapDown;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: GameCanvasPainter(bars: gameState.bars),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class GameCanvasPainter extends CustomPainter {
  const GameCanvasPainter({required this.bars});

  final List<FallingBar> bars;

  @override
  void paint(Canvas canvas, Size size) {
    // 背景を描画
    _drawBackground(canvas, size);
    
    // 各棒を描画
    for (final bar in bars) {
      _drawBar(canvas, bar);
    }
    
    // 地面を描画
    _drawGround(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  void _drawBar(Canvas canvas, FallingBar bar) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(bar.x, bar.y, FallingBar.width, FallingBar.height),
      const Radius.circular(4),
    );

    // 棒の本体
    final barPaint = Paint()
      ..color = bar.isTapped ? Colors.green : Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rect, barPaint);

    // 影の描画（立体感）
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawRRect(
      rect.shift(const Offset(2, 2)),
      shadowPaint,
    );

    // 枠線
    final borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(rect, borderPaint);
  }

  void _drawGround(Canvas canvas, Size size) {
    final groundHeight = 30.0; // 地面の高さを少し増やす
    final groundPaint = Paint()
      ..color = Colors.brown.shade300
      ..style = PaintingStyle.fill;

    final groundRect = Rect.fromLTWH(0, size.height - groundHeight, size.width, groundHeight);
    canvas.drawRect(groundRect, groundPaint);

    // 地面のテクスチャ（簡単な線）
    final linePaint = Paint()
      ..color = Colors.brown.shade400
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(
        Offset(x, size.height - groundHeight),
        Offset(x + 10, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(GameCanvasPainter oldDelegate) {
    return bars != oldDelegate.bars;
  }
}
