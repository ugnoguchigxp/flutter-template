import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../../domain/models/game_state.dart';
import '../../domain/models/position.dart';

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
    const size = 48.0;

    // 1. 白で塗りつぶし（背景）
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(_createSpadePath(position, size), fillPaint);

    // 2. 赤いボーダー
    final strokePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(_createSpadePath(position, size), strokePaint);
  }

  void _drawPlayer(Canvas canvas, Offset position) {
    // プレーヤー：塗りつぶしの黒スペードマーク（♠）
    const size = 48.0;

    final fillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawPath(_createSpadePath(position, size), fillPaint);
  }

  Path _createSpadePath(Offset center, double size) {
    // SVGパスデータ（viewBox: 0 0 40.679 40.679）
    const svgPath = 'M34.592,20.101c1.006,1.808,2.146,3.854,1.892,7.08c-0.298,3.947-2.771,6.509-6.785,7.023 '
        'c-1.688,0.223-3.075,0.096-4.066-0.394c-0.666-0.326-1.243-0.768-1.76-1.26c0.55,2.049,1.516,3.729,2.46,5.371 '
        'c0.224,0.391,0.445,0.775,0.66,1.163c0.167,0.303,0.167,0.67-0.002,0.972c-0.169,0.303-0.48,0.496-0.826,0.512 '
        'c-1.631,0.076-3.376,0.11-5.496,0.11c-1.595,0-3.21-0.021-4.851-0.04l-1.082-0.013c-0.32-0.005-0.618-0.16-0.804-0.421 '
        'c-0.185-0.262-0.234-0.594-0.133-0.897c0.175-0.521,0.456-0.964,0.703-1.354c0.081-0.128,0.162-0.255,0.238-0.384l0.14-0.254 '
        'c0.23-0.41,0.46-0.822,0.671-1.271l0.216-0.474c0.428-0.928,0.87-1.888,1.12-2.897c0.01-0.042,0.02-0.083,0.03-0.125 '
        'c-0.935,0.938-2.134,1.735-3.778,1.819c-2.358,0.1-4.16-0.604-4.813-0.896c-2.51-1.153-3.902-3.391-4.145-6.653 '
        'c-0.098-1.347,0.145-2.904,0.666-4.278c0.705-1.886,1.973-3.858,3.092-5.602c0.569-0.869,1.188-1.697,1.785-2.498 '
        'c0.309-0.408,2.857-3.774,3.25-4.259c1.899-2.346,3.56-5.104,5.166-7.774c0.389-0.646,0.776-1.291,1.168-1.93 '
        'C19.488,0.182,19.811,0,20.158,0c0,0,0,0,0.001,0c0.348,0,0.67,0.181,0.852,0.477c0.838,1.364,1.722,2.698,2.656,4.11l1.039,1.574 '
        'c1.256,1.929,2.707,3.8,4.108,5.608c1.983,2.56,4.034,5.204,5.689,8.177L34.592,20.101z';

    // SVGパスをFlutter Pathに変換
    final path = parseSvgPathData(svgPath);

    // SVGの元のサイズ（viewBox）
    const originalSize = 40.679;

    // スケールと位置調整
    final scale = size / originalSize;
    final matrix = Matrix4.identity()
      // ignore: deprecated_member_use
      ..translate(center.dx, center.dy)
      // ignore: deprecated_member_use
      ..scale(scale, scale)
      // ignore: deprecated_member_use
      ..translate(-originalSize / 2, -originalSize / 2);

    return path.transform(matrix.storage);
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
