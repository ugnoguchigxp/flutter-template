import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/game/domain/models/position.dart';
import 'package:flutter_template/src/features/game/domain/services/target_generator.dart';

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

    test('2回目のターゲットは前回位置から十分に離れている', () {
      final firstTarget = generator.generateTarget(canvasSize: canvasSize);
      final secondTarget = generator.generateTarget(
        canvasSize: canvasSize,
        previousTarget: firstTarget,
      );

      // 前回位置からの距離が十分離れていることを確認
      final distanceFromPrevious = firstTarget.distanceTo(secondTarget);
      final maxRadius = 200 * 0.8; // canvasSizeの半分 * 0.8
      final minRequiredDistance = maxRadius * 0.8; // 80%以上離れている

      expect(
        distanceFromPrevious,
        greaterThanOrEqualTo(minRequiredDistance),
        reason:
            'Second target should be at least 80% of max radius away from first target',
      );

      // 両方のターゲットが円内に収まっていることを確認
      final center = Position(x: 200, y: 200);
      final distance1 = firstTarget.distanceTo(center);
      final distance2 = secondTarget.distanceTo(center);

      expect(distance1, lessThanOrEqualTo(maxRadius));
      expect(distance2, lessThanOrEqualTo(maxRadius));
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
