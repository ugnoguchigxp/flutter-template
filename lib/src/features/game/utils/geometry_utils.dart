import 'dart:math';

import '../domain/models/position.dart';

/// 幾何計算ユーティリティクラス
class GeometryUtils {
  const GeometryUtils._();

  /// 2点間の距離を計算
  static double distance(Position a, Position b) {
    return a.distanceTo(b);
  }

  /// 指定された位置から中心までの角度（ラジアン）を計算
  static double angleFromCenter(Position position, Position center) {
    return position.angleFrom(center);
  }

  /// 指定された角度と距離から新しい位置を計算
  static Position positionFromAngleAndDistance(
    Position center,
    double angle,
    double distance,
  ) {
    return Position(
      x: center.x + distance * cos(angle),
      y: center.y + distance * sin(angle),
    );
  }

  /// 角度を度からラジアンに変換
  static double degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  /// 角度をラジアンから度に変換
  static double radiansToDegrees(double radians) {
    return radians * 180.0 / pi;
  }
}
