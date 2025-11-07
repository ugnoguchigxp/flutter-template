import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/models/game_state.dart';
import '../../domain/models/position.dart';
import '../../utils/constants.dart';

class GameCanvas extends StatefulWidget {
  const GameCanvas({
    required this.gameState,
    required this.onDragUpdate,
    super.key,
  });

  final GameState gameState;
  final ValueChanged<Offset> onDragUpdate;

  @override
  State<GameCanvas> createState() => _GameCanvasState();
}

class _GameCanvasState extends State<GameCanvas> {
  Offset? _localDragPosition;
  int _updateCounter = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        // ローカル状態を即座に更新（スムーズな描画）
        setState(() {
          _localDragPosition = details.localPosition;
        });

        // 親への通知は間引く（3フレームに1回 = 約20Hz）
        _updateCounter++;
        if (_updateCounter >= 3) {
          _updateCounter = 0;
          widget.onDragUpdate(details.localPosition);
        }
      },
      onPanEnd: (_) {
        // ドラッグ終了時に最終位置を確定
        if (_localDragPosition != null) {
          widget.onDragUpdate(_localDragPosition!);
        }
        setState(() {
          _localDragPosition = null;
          _updateCounter = 0;
        });
      },
      child: RepaintBoundary(
        child: CustomPaint(
          painter: GamePainter(
            gameState: widget.gameState,
            localDragPosition: _localDragPosition,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  const GamePainter({
    required this.gameState,
    this.localDragPosition,
  });

  final GameState gameState;
  final Offset? localDragPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.8;

    // 1. 円形プレイエリアを描画
    _drawCircleArea(canvas, center, radius);

    // 2. ターゲットスポットを描画
    if (gameState.targetPos != null) {
      _drawTarget(canvas, gameState.targetPos!.toOffset());
    }

    // 3. 自キャラ（スペードマーク）を描画
    // ドラッグ中はローカル位置、それ以外はgameStateの位置
    final playerPosition = localDragPosition ?? gameState.playerPos?.toOffset();
    if (playerPosition != null) {
      _drawPlayer(canvas, playerPosition);
    }
  }

  void _drawCircleArea(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    // 境界線
    final borderPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, borderPaint);
  }

  void _drawTarget(Canvas canvas, Offset position) {
    // ターゲットスポット：ボーダーのみのスペードマーク（♠）
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = Colors.red;

    final textPainter = TextPainter(
      text: TextSpan(
        text: '♠',
        style: TextStyle(
          fontSize: 52,
          foreground: strokePaint,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  void _drawPlayer(Canvas canvas, Offset position) {
    // プレーヤー：塗りつぶしの黒スペードマーク（♠）
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '♠',
        style: TextStyle(
          fontSize: 52,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) {
    return localDragPosition != oldDelegate.localDragPosition ||
        gameState.playerPos != oldDelegate.gameState.playerPos ||
        gameState.targetPos != oldDelegate.gameState.targetPos ||
        gameState.status != oldDelegate.gameState.status;
  }
}

extension PositionExtension on Position {
  Offset toOffset() => Offset(x, y);
}
