import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/game/domain/models/difficulty.dart';

void main() {
  group('Difficulty', () {
    test('難易度プロパティの確認', () {
      expect(Difficulty.easy.name, 'easy');
      expect(Difficulty.normal.name, 'normal');
      expect(Difficulty.hard.name, 'hard');
    });

    test('難易度別のヒット半径', () {
      expect(Difficulty.easy.hitRadius, 8.0);
      expect(Difficulty.normal.hitRadius, 5.0);
      expect(Difficulty.hard.hitRadius, 3.0);
    });

    test('難易度別の表示名', () {
      expect(Difficulty.easy.label, 'イージー');
      expect(Difficulty.normal.label, 'ノーマル');
      expect(Difficulty.hard.label, 'ハード');
    });

    test('難易度別の説明', () {
      expect(Difficulty.easy.description, '大きめの判定範囲（初心者向け）');
      expect(Difficulty.normal.description, '標準的な判定範囲（バランス型）');
      expect(Difficulty.hard.description, 'かなりシビアな判定範囲（上級者向け）');
    });

    test('難易度列挙の全確認', () {
      final allDifficulties = Difficulty.values;
      expect(allDifficulties.length, 3);
      expect(allDifficulties, contains(Difficulty.easy));
      expect(allDifficulties, contains(Difficulty.normal));
      expect(allDifficulties, contains(Difficulty.hard));
    });

    test('難易度の大小比較', () {
      // Easy < Normal < Hard の順に難易度が高い
      expect(Difficulty.easy.index, lessThan(Difficulty.normal.index));
      expect(Difficulty.normal.index, lessThan(Difficulty.hard.index));
    });
  });
}
