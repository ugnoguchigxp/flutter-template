import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../../domain/models/board.dart';
import '../../domain/models/othello_game_state.dart';
import '../../domain/models/player.dart';
import '../../domain/models/position.dart';
import '../../domain/services/othello_ai.dart';

final othelloGameProvider =
    StateNotifierProvider<OthelloGameNotifier, OthelloGameState>(
      (ref) => OthelloGameNotifier(),
    );

class OthelloGameNotifier extends StateNotifier<OthelloGameState> {
  OthelloGameNotifier()
    : super(const OthelloGameState(status: GameStatus.selectingPlayer));

  final _ai = OthelloAI(maxDepth: 4);
  final _logger = Logger();

  // プレイヤー選択
  void selectPlayer(Player humanPlayer) {
    state = OthelloGameState(
      status: GameStatus.playing,
      board: Board.initial(),
      currentPlayer: Player.black, // 黒が先攻
      humanPlayer: humanPlayer,
    );

    // CPUが先攻の場合、CPUの手を実行
    if (humanPlayer == Player.white) {
      unawaited(
        Future<void>.delayed(
          const Duration(milliseconds: 500),
        ).then((_) => _executeCpuMove()),
      );
    }
  }

  // 人間が石を置く
  Future<void> makeMove(Position position) async {
    if (state.status != GameStatus.playing) return;
    if (!state.isHumanTurn) return;
    if (!state.board.isValidMove(position, state.currentPlayer)) return;

    // 石を置く
    final newBoard = state.board.makeMove(position, state.currentPlayer);

    state = state.copyWith(board: newBoard, lastMove: position);

    // ゲーム終了判定
    if (_checkGameOver()) return;

    // 次のプレイヤー
    _switchPlayer();

    // CPUの番なら実行
    if (state.isCpuTurn) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await _executeCpuMove();
    }
  }

  // プレイヤー交代
  void _switchPlayer() {
    final nextPlayer = state.currentPlayer.opponent;
    final validMoves = state.board.getValidMoves(nextPlayer);

    if (validMoves.isNotEmpty) {
      // 次のプレイヤーに有効な手がある
      state = state.copyWith(currentPlayer: nextPlayer);
    } else {
      // パス: 現在のプレイヤーに有効な手があるか確認
      final currentValidMoves = state.board.getValidMoves(state.currentPlayer);
      if (currentValidMoves.isEmpty) {
        // 両者とも打てない→ゲーム終了
        _endGame();
      }
      // else: 現在のプレイヤー続行（相手がパス）
    }
  }

  // CPU の手を実行
  Future<void> _executeCpuMove() async {
    if (state.status != GameStatus.playing) return;
    if (!state.isCpuTurn) return;

    try {
      state = state.copyWith(isThinking: true);

      // AI が最良の手を計算（バックグラウンドで）
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final bestMove = _ai.getBestMove(state.board, state.currentPlayer);

      if (bestMove == null) {
        // 有効な手がない（パス）
        state = state.copyWith(isThinking: false);
        _switchPlayer();

        // 人間もパスならゲーム終了
        if (state.validMoves.isEmpty) {
          _endGame();
        } else if (state.isCpuTurn) {
          // まだCPUの番（人間がパスした）
          await Future<void>.delayed(const Duration(milliseconds: 500));
          await _executeCpuMove();
        }
        return;
      }

      // 石を置く
      final newBoard = state.board.makeMove(bestMove, state.currentPlayer);

      state = state.copyWith(
        board: newBoard,
        lastMove: bestMove,
        isThinking: false,
      );

      // ゲーム終了判定
      if (_checkGameOver()) return;

      // 次のプレイヤー
      _switchPlayer();

      // まだCPUの番なら再帰実行
      if (state.isCpuTurn) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        await _executeCpuMove();
      }
    } catch (e, stackTrace) {
      _logger.e('CPU move error', error: e, stackTrace: stackTrace);
      // エラー時は思考中フラグをクリア
      state = state.copyWith(isThinking: false);
    }
  }

  // ゲーム終了判定
  bool _checkGameOver() {
    if (state.board.isGameOver()) {
      _endGame();
      return true;
    }
    return false;
  }

  // ゲーム終了処理
  void _endGame() {
    final winner = state.board.getWinner();

    state = state.copyWith(status: GameStatus.gameOver, winner: winner);
  }

  // ゲームリセット
  void resetGame() {
    state = const OthelloGameState(status: GameStatus.selectingPlayer);
  }
}
