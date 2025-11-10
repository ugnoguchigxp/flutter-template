import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/game/domain/models/position.dart';
import 'package:flutter_template/src/features/game/utils/geometry_utils.dart';

void main() {
  group('GeometryUtils', () {
    group('distance', () {
      test('calculates distance between two positions correctly', () {
        final p1 = Position(x: 0, y: 0);
        final p2 = Position(x: 3, y: 4);

        final result = GeometryUtils.distance(p1, p2);

        expect(result, 5.0);
      });

      test('distance is zero for same position', () {
        final p1 = Position(x: 10, y: 20);
        final p2 = Position(x: 10, y: 20);

        final result = GeometryUtils.distance(p1, p2);

        expect(result, 0.0);
      });

      test('distance works with negative coordinates', () {
        final p1 = Position(x: -3, y: -4);
        final p2 = Position(x: 0, y: 0);

        final result = GeometryUtils.distance(p1, p2);

        expect(result, 5.0);
      });
    });

    group('angleFromCenter', () {
      test('calculates angle from center correctly', () {
        final center = Position(x: 0, y: 0);
        final position = Position(x: 1, y: 0);

        final result = GeometryUtils.angleFromCenter(position, center);

        expect(result, 0.0);
      });

      test('calculates 90 degree angle correctly', () {
        final center = Position(x: 0, y: 0);
        final position = Position(x: 0, y: 1);

        final result = GeometryUtils.angleFromCenter(position, center);

        expect(result, closeTo(pi / 2, 0.0001));
      });
    });

    group('positionFromAngleAndDistance', () {
      test('calculates position from 0 degree angle', () {
        final center = Position(x: 0, y: 0);
        const angle = 0.0;
        const distance = 10.0;

        final result =
            GeometryUtils.positionFromAngleAndDistance(center, angle, distance);

        expect(result.x, closeTo(10.0, 0.0001));
        expect(result.y, closeTo(0.0, 0.0001));
      });

      test('calculates position from 90 degree angle', () {
        final center = Position(x: 0, y: 0);
        final angle = pi / 2;
        const distance = 10.0;

        final result =
            GeometryUtils.positionFromAngleAndDistance(center, angle, distance);

        expect(result.x, closeTo(0.0, 0.0001));
        expect(result.y, closeTo(10.0, 0.0001));
      });

      test('works with non-zero center', () {
        final center = Position(x: 5, y: 5);
        const angle = 0.0;
        const distance = 3.0;

        final result =
            GeometryUtils.positionFromAngleAndDistance(center, angle, distance);

        expect(result.x, closeTo(8.0, 0.0001));
        expect(result.y, closeTo(5.0, 0.0001));
      });
    });

    group('degreesToRadians', () {
      test('converts 0 degrees to 0 radians', () {
        final result = GeometryUtils.degreesToRadians(0);

        expect(result, 0.0);
      });

      test('converts 180 degrees to pi radians', () {
        final result = GeometryUtils.degreesToRadians(180);

        expect(result, closeTo(pi, 0.0001));
      });

      test('converts 90 degrees to pi/2 radians', () {
        final result = GeometryUtils.degreesToRadians(90);

        expect(result, closeTo(pi / 2, 0.0001));
      });

      test('converts 360 degrees to 2*pi radians', () {
        final result = GeometryUtils.degreesToRadians(360);

        expect(result, closeTo(2 * pi, 0.0001));
      });

      test('handles negative degrees', () {
        final result = GeometryUtils.degreesToRadians(-90);

        expect(result, closeTo(-pi / 2, 0.0001));
      });
    });

    group('radiansToDegrees', () {
      test('converts 0 radians to 0 degrees', () {
        final result = GeometryUtils.radiansToDegrees(0);

        expect(result, 0.0);
      });

      test('converts pi radians to 180 degrees', () {
        final result = GeometryUtils.radiansToDegrees(pi);

        expect(result, closeTo(180, 0.0001));
      });

      test('converts pi/2 radians to 90 degrees', () {
        final result = GeometryUtils.radiansToDegrees(pi / 2);

        expect(result, closeTo(90, 0.0001));
      });

      test('converts 2*pi radians to 360 degrees', () {
        final result = GeometryUtils.radiansToDegrees(2 * pi);

        expect(result, closeTo(360, 0.0001));
      });

      test('handles negative radians', () {
        final result = GeometryUtils.radiansToDegrees(-pi / 2);

        expect(result, closeTo(-90, 0.0001));
      });
    });

    group('angle conversion round trip', () {
      test('degrees -> radians -> degrees returns original value', () {
        const original = 45.0;

        final radians = GeometryUtils.degreesToRadians(original);
        final result = GeometryUtils.radiansToDegrees(radians);

        expect(result, closeTo(original, 0.0001));
      });

      test('radians -> degrees -> radians returns original value', () {
        const original = pi / 4;

        final degrees = GeometryUtils.radiansToDegrees(original);
        final result = GeometryUtils.degreesToRadians(degrees);

        expect(result, closeTo(original, 0.0001));
      });
    });
  });
}
