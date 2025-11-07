import 'package:flutter/material.dart';

enum ReflexDifficulty {
  easy,
  normal,
  hard;

  String get label {
    switch (this) {
      case ReflexDifficulty.easy:
        return 'イージー';
      case ReflexDifficulty.normal:
        return 'ノーマル';
      case ReflexDifficulty.hard:
        return 'ハード';
    }
  }

  String get description {
    switch (this) {
      case ReflexDifficulty.easy:
        return 'ゆっくり落下';
      case ReflexDifficulty.normal:
        return '標準速度';
      case ReflexDifficulty.hard:
        return '高速落下';
    }
  }

  double get gravity {
    switch (this) {
      case ReflexDifficulty.easy:
        return 600.0; // Normalの30%の重力（ゆっくり落下）
      case ReflexDifficulty.normal:
        return 2000.0; // 2メートル自由落下
      case ReflexDifficulty.hard:
        return 4000.0; // Normalの2倍の重力（高速落下）
    }
  }

  Color get buttonColor {
    switch (this) {
      case ReflexDifficulty.easy:
        return Colors.green;
      case ReflexDifficulty.normal:
        return Colors.blue;
      case ReflexDifficulty.hard:
        return Colors.red;
    }
  }
}
