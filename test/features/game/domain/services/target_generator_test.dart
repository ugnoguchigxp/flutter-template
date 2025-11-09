import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../lib/src/features/game/domain/models/position.dart';
import '../../../../../lib/src/features/game/domain/services/target_generator.dart';

void main() {
  group('TargetGenerator', () {
    late TargetGenerator generator;
    late Size canvasSize;

    setUp(() {
      generator = TargetGenerator();
      canvasSize = const Size(400, 400);
    });

    test('最初のターゲットは円内に生成される', () {
      final target = generator.generateTarget(canvasSize: canvasSize);

      // 中心からの距離が円の半径内にあることを確認
      final center = Position(x: 200, y: 200);
      final distance = target.distanceTo(center);
      final maxRadius = 200 * 0.8; // canvasSizeの半分 * 0.8

      expect(distance, lessThanOrEqualTo(maxRadius));
      expect(distance, greaterThanOrEqualTo(maxRadius * 0.7)); // 70%〜95%の範囲
    });

    test('2回目のターゲットは前回位置の反対側に生成される', () {
      final firstTarget = generator.generateTarget(canvasSize: canvasSize);
      final secondTarget = generator.generateTarget(
        canvasSize: canvasSize,
        previousTarget: firstTarget,
      );

      final center = Position(x: 200, y: 200);

      // 2つのターゲットの角度差が150°〜210°の範囲にあることを確認
      final angle1 = firstTarget.angleFrom(center);
      final angle2 = secondTarget.angleFrom(center);

      double normalizeAngle(double angle) {
        while (angle < 0) angle += 2 * 3.14159265359;
        while (angle > 2 * 3.14159265359) angle -= 2 * 3.14159265359;
        return angle;
      }

      final angleDiff = normalizeAngle((angle2 - angle1).abs());
      final minDiff = 150 * 3.14159265359 / 180; // 150° in radians
      final maxDiff = 210 * 3.14159265359 / 180; // 210° in radians

      expect(
        angleDiff >= minDiff && angleDiff <= maxDiff,
        true,
        reason: 'Angle difference should be between 150° and 210°',
      );
    });

    test('複数回生成しても常に円内に収まる', () {
      for (int i = 0; i < 10; i++) {
        final target = generator.generateTarget(canvasSize: canvasSize);

        // 中心からの距離が円の半径内にあることを確認
        final center = Position(x: 200, y: 200);
        final distance = target.distanceTo(center);
        final maxRadius = 200 * 0.8;

        expect(distance, lessThanOrEqualTo(maxRadius));
        expect(distance, greaterThanOrEqualTo(maxRadius * 0.7));
      }
    });
  });
}
