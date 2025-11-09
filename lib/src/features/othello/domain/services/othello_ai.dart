import 'dart:math';

import '../models/board.dart';
import '../models/player.dart';
import '../models/position.dart';

class OthelloAI {
  final int maxDepth;
  final Random _random = Random();

  OthelloAI({this.maxDepth = 4}); // デフォルト深度4

  // 最良の手を取得
  Position? getBestMove(Board board, Player player) {
    final validMoves = board.getValidMoves(player);

    if (validMoves.isEmpty) return null;

    // 序盤（最初の10手まで）はランダム性を持たせる
    final totalStones = board.countStones(Player.black) + board.countStones(Player.white);
    if (totalStones <= 8) {
      // 序盤は評価値が高い手を複数から選択
      final moveScores = <Position, int>{};
      for (final move in validMoves) {
        final newBoard = board.makeMove(move, player);
        moveScores[move] = newBoard.evaluate(player);
      }

      // 上位の手からランダムに選択
      final sortedMoves = moveScores.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final topMoves = sortedMoves.take(min(3, sortedMoves.length)).toList();
      return topMoves[_random.nextInt(topMoves.length)].key;
    }

    // 中盤以降はMinimaxで最良手を探索
    var bestMove = validMoves.first;
    var bestScore = double.negativeInfinity;

    for (final move in validMoves) {
      final newBoard = board.makeMove(move, player);
      final score = _minimax(
        newBoard,
        maxDepth - 1,
        false,
        player,
        double.negativeInfinity,
        double.infinity,
      );

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove;
  }

  // Minimax アルゴリズム（Alpha-Beta pruning付き）
  double _minimax(
    Board board,
    int depth,
    bool isMaximizing,
    Player aiPlayer,
    double alpha,
    double beta,
  ) {
    // 終了条件
    if (depth == 0 || board.isGameOver()) {
      return board.evaluate(aiPlayer).toDouble();
    }

    final currentPlayer = isMaximizing ? aiPlayer : aiPlayer.opponent;
    final validMoves = board.getValidMoves(currentPlayer);

    // パスの場合
    if (validMoves.isEmpty) {
      // 相手もパスならゲーム終了
      if (board.getValidMoves(currentPlayer.opponent).isEmpty) {
        return board.evaluate(aiPlayer).toDouble();
      }
      // 相手に手番を渡す
      return _minimax(board, depth - 1, !isMaximizing, aiPlayer, alpha, beta);
    }

    if (isMaximizing) {
      var maxEval = double.negativeInfinity;

      for (final move in validMoves) {
        final newBoard = board.makeMove(move, currentPlayer);
        final eval = _minimax(newBoard, depth - 1, false, aiPlayer, alpha, beta);

        maxEval = max(maxEval, eval);
        alpha = max(alpha, eval);

        if (beta <= alpha) {
          break; // Beta cutoff
        }
      }

      return maxEval;
    } else {
      var minEval = double.infinity;

      for (final move in validMoves) {
        final newBoard = board.makeMove(move, currentPlayer);
        final eval = _minimax(newBoard, depth - 1, true, aiPlayer, alpha, beta);

        minEval = min(minEval, eval);
        beta = min(beta, eval);

        if (beta <= alpha) {
          break; // Alpha cutoff
        }
      }

      return minEval;
    }
  }
}
