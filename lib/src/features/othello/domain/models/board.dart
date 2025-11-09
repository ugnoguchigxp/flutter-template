import 'package:freezed_annotation/freezed_annotation.dart';

import 'player.dart';
import 'position.dart';

part 'board.freezed.dart';

@freezed
class Board with _$Board {
  const factory Board({@Default([]) List<List<Player>> cells}) = _Board;

  const Board._();

  // 定数定義
  static const int boardSize = 8;
  static const int gameOverScore = 10000;
  static const int cornerWeight = 100;
  static const int edgeWeight = 10;
  static const int mobilityWeight = 5;
  static const int endgameThreshold = 50;
  static const int endgameStoneWeight = 2;

  factory Board.initial() {
    final cells = List.generate(8, (_) => List.generate(8, (_) => Player.none));

    // 初期配置
    cells[3][3] = Player.white;
    cells[3][4] = Player.black;
    cells[4][3] = Player.black;
    cells[4][4] = Player.white;

    return Board(cells: cells);
  }

  Player getCell(Position pos) {
    if (!pos.isValid) return Player.none;
    return cells[pos.row][pos.col];
  }

  // 有効な手かどうかを判定
  bool isValidMove(Position pos, Player player) {
    if (!pos.isValid) return false;
    if (getCell(pos) != Player.none) return false;
    if (player == Player.none) return false;

    // 少なくとも1方向でひっくり返せる石があるか
    return Position.directions.any(
      (dir) => _canFlipInDirection(pos, player, dir),
    );
  }

  // 特定方向にひっくり返せる石があるか
  bool _canFlipInDirection(Position start, Player player, Position direction) {
    var current = start.move(direction.row, direction.col);
    var hasOpponent = false;

    while (current.isValid) {
      final cell = getCell(current);

      if (cell == Player.none) return false;
      if (cell == player) return hasOpponent;

      hasOpponent = true;
      current = current.move(direction.row, direction.col);
    }

    return false;
  }

  // 有効な手のリストを取得
  List<Position> getValidMoves(Player player) {
    final moves = <Position>[];

    for (var row = 0; row < 8; row++) {
      for (var col = 0; col < 8; col++) {
        final pos = Position(row: row, col: col);
        if (isValidMove(pos, player)) {
          moves.add(pos);
        }
      }
    }

    return moves;
  }

  // 石を置いてひっくり返す
  Board makeMove(Position pos, Player player) {
    if (!isValidMove(pos, player)) return this;

    final newCells = List.generate(
      8,
      (row) => List.generate(8, (col) => cells[row][col]),
    );

    // 石を置く
    newCells[pos.row][pos.col] = player;

    // 全方向でひっくり返す
    for (final direction in Position.directions) {
      if (_canFlipInDirection(pos, player, direction)) {
        _flipInDirection(newCells, pos, player, direction);
      }
    }

    return Board(cells: newCells);
  }

  // 特定方向の石をひっくり返す
  void _flipInDirection(
    List<List<Player>> cells,
    Position start,
    Player player,
    Position direction,
  ) {
    var current = start.move(direction.row, direction.col);

    while (current.isValid) {
      final cell = cells[current.row][current.col];

      if (cell == player) break;
      if (cell == Player.none) break;

      cells[current.row][current.col] = player;
      current = current.move(direction.row, direction.col);
    }
  }

  // 石の数を数える
  int countStones(Player player) {
    var count = 0;
    for (final row in cells) {
      for (final cell in row) {
        if (cell == player) count++;
      }
    }
    return count;
  }

  // 勝者を判定
  Player? getWinner() {
    final blackCount = countStones(Player.black);
    final whiteCount = countStones(Player.white);

    if (blackCount > whiteCount) return Player.black;
    if (whiteCount > blackCount) return Player.white;
    return null; // 引き分け
  }

  // ゲーム終了判定
  bool isGameOver() {
    return getValidMoves(Player.black).isEmpty &&
        getValidMoves(Player.white).isEmpty;
  }

  // 盤面評価（AI用）
  int evaluate(Player player) {
    if (isGameOver()) {
      final winner = getWinner();
      if (winner == player) return gameOverScore;
      if (winner == player.opponent) return -gameOverScore;
      return 0;
    }

    var score = 0;

    // 角の重み（最も重要）
    final corners = [
      const Position(row: 0, col: 0),
      const Position(row: 0, col: boardSize - 1),
      const Position(row: boardSize - 1, col: 0),
      const Position(row: boardSize - 1, col: boardSize - 1),
    ];

    for (final corner in corners) {
      final cell = getCell(corner);
      if (cell == player) {
        score += cornerWeight;
      } else if (cell == player.opponent) {
        score -= cornerWeight;
      }
    }

    // 辺の重み
    for (var i = 0; i < boardSize; i++) {
      // 上辺
      if (getCell(Position(row: 0, col: i)) == player) score += edgeWeight;
      if (getCell(Position(row: 0, col: i)) == player.opponent)
        score -= edgeWeight;
      // 下辺
      if (getCell(Position(row: boardSize - 1, col: i)) == player)
        score += edgeWeight;
      if (getCell(Position(row: boardSize - 1, col: i)) == player.opponent)
        score -= edgeWeight;
      // 左辺
      if (getCell(Position(row: i, col: 0)) == player) score += edgeWeight;
      if (getCell(Position(row: i, col: 0)) == player.opponent)
        score -= edgeWeight;
      // 右辺
      if (getCell(Position(row: i, col: boardSize - 1)) == player)
        score += edgeWeight;
      if (getCell(Position(row: i, col: boardSize - 1)) == player.opponent)
        score -= edgeWeight;
    }

    // 着手可能数の差
    final myMoves = getValidMoves(player).length;
    final opponentMoves = getValidMoves(player.opponent).length;
    score += (myMoves - opponentMoves) * mobilityWeight;

    // 石の数の差（終盤重視）
    final totalStones = countStones(Player.black) + countStones(Player.white);
    if (totalStones > endgameThreshold) {
      score +=
          (countStones(player) - countStones(player.opponent)) *
          endgameStoneWeight;
    }

    return score;
  }
}
