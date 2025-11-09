import 'package:flutter/material.dart';

enum Player {
  black,
  white,
  none;

  Player get opponent {
    switch (this) {
      case Player.black:
        return Player.white;
      case Player.white:
        return Player.black;
      case Player.none:
        return Player.none;
    }
  }

  String get label {
    switch (this) {
      case Player.black:
        return '黒';
      case Player.white:
        return '白';
      case Player.none:
        return '';
    }
  }

  Color get color {
    switch (this) {
      case Player.black:
        return Colors.black;
      case Player.white:
        return Colors.white;
      case Player.none:
        return Colors.transparent;
    }
  }
}
