enum Difficulty {
  easy,
  normal,
  hard;

  String get label {
    switch (this) {
      case Difficulty.easy:
        return 'イージー';
      case Difficulty.normal:
        return 'ノーマル';
      case Difficulty.hard:
        return 'ハード';
    }
  }

  String get description {
    switch (this) {
      case Difficulty.easy:
        return '大きめの判定範囲（初心者向け）';
      case Difficulty.normal:
        return '標準的な判定範囲（バランス型）';
      case Difficulty.hard:
        return 'かなりシビアな判定範囲（上級者向け）';
    }
  }

  double get hitRadius {
    switch (this) {
      case Difficulty.easy:
        return 8.0;
      case Difficulty.normal:
        return 5.0;
      case Difficulty.hard:
        return 3.0;
    }
  }
}
