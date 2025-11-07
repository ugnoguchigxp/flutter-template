import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'falling_bar.freezed.dart';

@freezed
class FallingBar with _$FallingBar {
  const factory FallingBar({
    required String id,
    required double x, // X座標
    required double y, // Y座標
    required double velocity, // 速度 (pixels/s)
    required DateTime spawnTime, // 出現時刻
    @Default(false) bool isTapped,
  }) = _FallingBar;

  const FallingBar._();

  /// バーの幅
  static const double width = 40.0;

  /// バーの高さ
  static const double height = 160.0;

  /// 指定された位置がバーの範囲内かチェック
  bool contains(Offset position) {
    return position.dx >= x &&
        position.dx <= x + width &&
        position.dy >= y &&
        position.dy <= y + height;
  }

  /// 反応時間を計算（ミリ秒）
  int get reactionTimeMs {
    return DateTime.now().difference(spawnTime).inMilliseconds;
  }
}
