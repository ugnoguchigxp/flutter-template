import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/othello/domain/models/board.dart';
import 'package:flutter_template/src/features/othello/domain/models/othello_game_state.dart';
import 'package:flutter_template/src/features/othello/domain/models/player.dart';
import 'package:flutter_template/src/features/othello/domain/models/position.dart';

void main() {
  group('GameStatus', () {
    test('has correct enum values', () {
      expect(GameStatus.values, [
        GameStatus.selectingPlayer,
        GameStatus.playing,
        GameStatus.gameOver,
      ]);
    });
  });

  group('OthelloGameState', () {
    group('default values', () {
      test('creates state with default values', () {
        const state = OthelloGameState();

        expect(state.status, GameStatus.selectingPlayer);
        expect(state.board, const Board(cells: []));
        expect(state.currentPlayer, Player.black);
        expect(state.humanPlayer, Player.black);
        expect(state.isThinking, false);
        expect(state.winner, null);
        expect(state.lastMove, null);
      });
    });

    group('copyWith', () {
      test('updates status', () {
        const state = OthelloGameState();
        final updated = state.copyWith(status: GameStatus.playing);

        expect(updated.status, GameStatus.playing);
        expect(updated.currentPlayer, state.currentPlayer);
      });

      test('updates board', () {
        const state = OthelloGameState();
        final newBoard = Board.initial();
        final updated = state.copyWith(board: newBoard);

        expect(updated.board, newBoard);
        expect(updated.status, state.status);
      });

      test('updates currentPlayer', () {
        const state = OthelloGameState();
        final updated = state.copyWith(currentPlayer: Player.white);

        expect(updated.currentPlayer, Player.white);
        expect(updated.humanPlayer, state.humanPlayer);
      });

      test('updates humanPlayer', () {
        const state = OthelloGameState();
        final updated = state.copyWith(humanPlayer: Player.white);

        expect(updated.humanPlayer, Player.white);
        expect(updated.currentPlayer, state.currentPlayer);
      });

      test('updates isThinking', () {
        const state = OthelloGameState();
        final updated = state.copyWith(isThinking: true);

        expect(updated.isThinking, true);
        expect(updated.status, state.status);
      });

      test('updates winner', () {
        const state = OthelloGameState();
        final updated = state.copyWith(winner: Player.black);

        expect(updated.winner, Player.black);
        expect(updated.status, state.status);
      });

      test('updates lastMove', () {
        const state = OthelloGameState();
        const move = Position(row: 2, col: 3);
        final updated = state.copyWith(lastMove: move);

        expect(updated.lastMove, move);
        expect(updated.status, state.status);
      });

      test('updates multiple fields', () {
        const state = OthelloGameState();
        final newBoard = Board.initial();
        const move = Position(row: 2, col: 3);

        final updated = state.copyWith(
          status: GameStatus.playing,
          board: newBoard,
          currentPlayer: Player.white,
          lastMove: move,
          isThinking: true,
        );

        expect(updated.status, GameStatus.playing);
        expect(updated.board, newBoard);
        expect(updated.currentPlayer, Player.white);
        expect(updated.lastMove, move);
        expect(updated.isThinking, true);
      });
    });

    group('isHumanTurn', () {
      test('returns true when current player is human player', () {
        const state = OthelloGameState(
          currentPlayer: Player.black,
          humanPlayer: Player.black,
        );

        expect(state.isHumanTurn, true);
      });

      test('returns false when current player is not human player', () {
        const state = OthelloGameState(
          currentPlayer: Player.white,
          humanPlayer: Player.black,
        );

        expect(state.isHumanTurn, false);
      });

      test('handles human as white player', () {
        const state = OthelloGameState(
          currentPlayer: Player.white,
          humanPlayer: Player.white,
        );

        expect(state.isHumanTurn, true);
      });
    });

    group('isCpuTurn', () {
      test('returns true when current player is not human and not none', () {
        const state = OthelloGameState(
          currentPlayer: Player.white,
          humanPlayer: Player.black,
        );

        expect(state.isCpuTurn, true);
      });

      test('returns false when current player is human player', () {
        const state = OthelloGameState(
          currentPlayer: Player.black,
          humanPlayer: Player.black,
        );

        expect(state.isCpuTurn, false);
      });

      test('returns false when current player is none', () {
        const state = OthelloGameState(
          currentPlayer: Player.none,
          humanPlayer: Player.black,
        );

        expect(state.isCpuTurn, false);
      });

      test('CPU turn when human is white and current is black', () {
        const state = OthelloGameState(
          currentPlayer: Player.black,
          humanPlayer: Player.white,
        );

        expect(state.isCpuTurn, true);
      });
    });

    group('blackCount', () {
      test('returns count of black stones on board', () {
        final state = OthelloGameState(
          board: Board.initial(),
        );

        expect(state.blackCount, 2);
      });

      test('returns 0 when board is empty', () {
        const state = OthelloGameState(
          board: Board(cells: []),
        );

        expect(state.blackCount, 0);
      });

      test('updates after move', () {
        final initialBoard = Board.initial();
        final state = OthelloGameState(
          board: initialBoard,
        );

        final newBoard =
            initialBoard.makeMove(const Position(row: 2, col: 3), Player.black);
        final updatedState = state.copyWith(board: newBoard);

        expect(updatedState.blackCount, 4);
      });
    });

    group('whiteCount', () {
      test('returns count of white stones on board', () {
        final state = OthelloGameState(
          board: Board.initial(),
        );

        expect(state.whiteCount, 2);
      });

      test('returns 0 when board is empty', () {
        const state = OthelloGameState(
          board: Board(cells: []),
        );

        expect(state.whiteCount, 0);
      });

      test('updates after move', () {
        final initialBoard = Board.initial();
        final state = OthelloGameState(
          board: initialBoard,
        );

        final newBoard =
            initialBoard.makeMove(const Position(row: 2, col: 3), Player.black);
        final updatedState = state.copyWith(board: newBoard);

        // Black move flips white stone, so white count decreases
        expect(updatedState.whiteCount, 1);
      });
    });

    group('validMoves', () {
      test('returns valid moves for current player', () {
        final state = OthelloGameState(
          board: Board.initial(),
          currentPlayer: Player.black,
        );

        final moves = state.validMoves;

        expect(moves.length, 4);
        expect(moves, contains(const Position(row: 2, col: 3)));
        expect(moves, contains(const Position(row: 3, col: 2)));
        expect(moves, contains(const Position(row: 4, col: 5)));
        expect(moves, contains(const Position(row: 5, col: 4)));
      });

      test('returns valid moves for white player', () {
        final state = OthelloGameState(
          board: Board.initial(),
          currentPlayer: Player.white,
        );

        final moves = state.validMoves;

        expect(moves.length, 4);
        expect(moves, contains(const Position(row: 2, col: 4)));
        expect(moves, contains(const Position(row: 3, col: 5)));
        expect(moves, contains(const Position(row: 4, col: 2)));
        expect(moves, contains(const Position(row: 5, col: 3)));
      });

      test('returns empty list when no valid moves', () {
        final cells =
            List.generate(8, (_) => List.generate(8, (_) => Player.black));
        final state = OthelloGameState(
          board: Board(cells: cells),
          currentPlayer: Player.white,
        );

        expect(state.validMoves, isEmpty);
      });

      test('updates when current player changes', () {
        final state = OthelloGameState(
          board: Board.initial(),
          currentPlayer: Player.black,
        );

        final blackMoves = state.validMoves;
        expect(blackMoves.length, 4);

        final updatedState = state.copyWith(currentPlayer: Player.white);
        final whiteMoves = updatedState.validMoves;

        expect(whiteMoves.length, 4);
        expect(whiteMoves, isNot(equals(blackMoves)));
      });
    });

    group('game flow', () {
      test('typical game start flow', () {
        // Start: selecting player
        const initial = OthelloGameState();
        expect(initial.status, GameStatus.selectingPlayer);

        // Player selected, game starts
        final playing = initial.copyWith(
          status: GameStatus.playing,
          board: Board.initial(),
          humanPlayer: Player.black,
          currentPlayer: Player.black,
        );

        expect(playing.status, GameStatus.playing);
        expect(playing.isHumanTurn, true);
        expect(playing.validMoves.length, 4);
      });

      test('game over flow', () {
        final cells =
            List.generate(8, (_) => List.generate(8, (_) => Player.black));
        final state = OthelloGameState(
          status: GameStatus.playing,
          board: Board(cells: cells),
          currentPlayer: Player.black,
        );

        // Game ends
        final gameOver = state.copyWith(
          status: GameStatus.gameOver,
          winner: Player.black,
        );

        expect(gameOver.status, GameStatus.gameOver);
        expect(gameOver.winner, Player.black);
      });

      test('CPU thinking state', () {
        final state = OthelloGameState(
          status: GameStatus.playing,
          board: Board.initial(),
          currentPlayer: Player.white,
          humanPlayer: Player.black,
          isThinking: false,
        );

        expect(state.isCpuTurn, true);
        expect(state.isThinking, false);

        final thinking = state.copyWith(isThinking: true);
        expect(thinking.isThinking, true);
        expect(thinking.isCpuTurn, true);
      });
    });

    group('equality', () {
      test('states with same values are equal', () {
        final state1 = OthelloGameState(
          status: GameStatus.playing,
          board: Board.initial(),
          currentPlayer: Player.black,
        );

        final state2 = OthelloGameState(
          status: GameStatus.playing,
          board: Board.initial(),
          currentPlayer: Player.black,
        );

        expect(state1, equals(state2));
      });

      test('states with different values are not equal', () {
        final state1 = OthelloGameState(
          status: GameStatus.playing,
          board: Board.initial(),
        );

        final state2 = OthelloGameState(
          status: GameStatus.gameOver,
          board: Board.initial(),
        );

        expect(state1, isNot(equals(state2)));
      });
    });
  });
}
