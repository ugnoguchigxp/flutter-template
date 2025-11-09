import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';

@freezed
class Position with _$Position {
  const factory Position({required double x, required double y}) = _Position;

  const Position._();

  /// 2点間の距離を計算
  double distanceTo(Position other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }

  /// 原点からの角度（ラジアン）
  double angleFrom(Position origin) {
    return atan2(y - origin.y, x - origin.x);
  }
}
