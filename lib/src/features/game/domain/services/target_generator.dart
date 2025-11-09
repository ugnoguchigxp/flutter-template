import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/position.dart';

class TargetGenerator {
  final Random _random = Random();

  /// ターゲット位置を生成
  Position generateTarget({
    required Size canvasSize,
    Position? previousTarget,
  }) {
    final center = Position(x: canvasSize.width / 2, y: canvasSize.height / 2);

    final radius = min(canvasSize.width, canvasSize.height) / 2 * 0.8;

    if (previousTarget == null) {
      // 初回：ランダムな位置
      return _generateRandomTarget(center, radius);
    } else {
      // 2回目以降：十分に離れたランダムな位置
      return _generateRandomTargetWithDistance(center, radius, previousTarget);
    }
  }

  /// ランダムなターゲット位置を生成
  Position _generateRandomTarget(Position center, double maxRadius) {
    final angle = _random.nextDouble() * 2 * pi;
    final distance =
        maxRadius * (0.7 + _random.nextDouble() * 0.25); // 70%〜95%（長距離移動）

    return Position(
      x: center.x + distance * cos(angle),
      y: center.y + distance * sin(angle),
    );
  }

  /// 前回位置から十分に離れたランダムなターゲット位置を生成
  Position _generateRandomTargetWithDistance(
    Position center,
    double maxRadius,
    Position previous,
  ) {
    const maxAttempts = 10;

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final angle = _random.nextDouble() * 2 * pi;
      final distance =
          maxRadius * (0.6 + _random.nextDouble() * 0.35); // 60%〜95%

      final candidate = Position(
        x: center.x + distance * cos(angle),
        y: center.y + distance * sin(angle),
      );

      // 前回位置からの距離を計算
      final distanceFromPrevious = previous.distanceTo(candidate);
      final minRequiredDistance = maxRadius * 0.8; // 80%以上離れている必要あり

      if (distanceFromPrevious >= minRequiredDistance) {
        return candidate;
      }
    }

    // 万が一見つからない場合は、従来の反対側ロジックを使用
    return _generateOppositeTarget(center, maxRadius, previous);
  }

  /// 前回位置の反対側にターゲット位置を生成
  Position _generateOppositeTarget(
    Position center,
    double maxRadius,
    Position previous,
  ) {
    // 前回位置から中心への角度
    final prevAngle = previous.angleFrom(center);

    // 反対側の角度（180° + ランダム変動 -30°〜+30°）
    final oppositeAngle =
        prevAngle + pi + (_random.nextDouble() - 0.5) * (pi / 3);

    // ランダムな距離（70%〜95%）長距離移動を要求
    final distance = maxRadius * (0.7 + _random.nextDouble() * 0.25);

    return Position(
      x: center.x + distance * cos(oppositeAngle),
      y: center.y + distance * sin(oppositeAngle),
    );
  }
}

final targetGeneratorProvider = Provider<TargetGenerator>((ref) {
  return TargetGenerator();
});
