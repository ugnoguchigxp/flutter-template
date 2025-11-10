import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/othello/domain/models/player.dart';

void main() {
  group('Player', () {
    group('opponent', () {
      test('black opponent is white', () {
        expect(Player.black.opponent, Player.white);
      });

      test('white opponent is black', () {
        expect(Player.white.opponent, Player.black);
      });

      test('none opponent is none', () {
        expect(Player.none.opponent, Player.none);
      });
    });

    group('label', () {
      test('black label is 黒', () {
        expect(Player.black.label, '黒');
      });

      test('white label is 白', () {
        expect(Player.white.label, '白');
      });

      test('none label is empty', () {
        expect(Player.none.label, '');
      });
    });

    group('color', () {
      test('black color is Colors.black', () {
        expect(Player.black.color, Colors.black);
      });

      test('white color is Colors.white', () {
        expect(Player.white.color, Colors.white);
      });

      test('none color is Colors.transparent', () {
        expect(Player.none.color, Colors.transparent);
      });
    });
  });
}
