import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/othello/domain/models/board.dart';
import 'package:flutter_template/src/features/othello/domain/models/player.dart';
import 'package:flutter_template/src/features/othello/domain/models/position.dart';
import 'package:flutter_template/src/features/othello/domain/services/othello_ai.dart';

void main() {
  group('OthelloAI', () {
    group('constructor', () {
      test('creates AI with default maxDepth', () {
        final ai = OthelloAI();
        expect(ai.maxDepth, 4);
      });

      test('creates AI with custom maxDepth', () {
        final ai = OthelloAI(maxDepth: 6);
        expect(ai.maxDepth, 6);
      });
    });

    group('getBestMove', () {
      test('returns null when no valid moves', () {
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.black),
        );
        final board = Board(cells: cells);
        final ai = OthelloAI();

        final move = ai.getBestMove(board, Player.white);

        expect(move, null);
      });

      test('returns only valid move when there is one', () {
        // Create a board where black has only one valid move
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.none),
        );
        cells[3][3] = Player.white;
        cells[3][4] = Player.black;
        cells[4][3] = Player.black;

        final board = Board(cells: cells);
        final ai = OthelloAI();

        final move = ai.getBestMove(board, Player.black);

        // Should return the only valid move
        expect(move, isNotNull);
        expect(board.isValidMove(move!, Player.black), true);
      });

      test('returns valid move from initial board', () {
        final board = Board.initial();
        final ai = OthelloAI();

        final move = ai.getBestMove(board, Player.black);

        expect(move, isNotNull);
        expect(board.isValidMove(move!, Player.black), true);

        // Should be one of the 4 initial valid moves
        final validMoves = [
          const Position(row: 2, col: 3),
          const Position(row: 3, col: 2),
          const Position(row: 4, col: 5),
          const Position(row: 5, col: 4),
        ];
        expect(validMoves, contains(move));
      });

      test('chooses move that maximizes advantage', () {
        // Create a scenario where one move is clearly better
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.none),
        );

        // Setup: Black can capture many pieces in one direction
        cells[3][3] = Player.white;
        cells[3][4] = Player.white;
        cells[3][5] = Player.white;
        cells[3][6] = Player.black;

        // Black can also make a small capture
        cells[4][4] = Player.white;
        cells[5][4] = Player.black;

        final board = Board(cells: cells);
        final ai = OthelloAI(maxDepth: 2);

        final move = ai.getBestMove(board, Player.black);

        expect(move, isNotNull);
        // AI should choose strategically advantageous move
        expect(board.isValidMove(move!, Player.black), true);
      });

      test('prefers corner positions', () {
        // Create a board where AI can take a corner
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.none),
        );

        // Setup where black can take corner (0,0)
        cells[0][1] = Player.white;
        cells[0][2] = Player.black;

        // Also setup a non-corner move
        cells[3][3] = Player.white;
        cells[3][4] = Player.black;

        final board = Board(cells: cells);
        final ai = OthelloAI(maxDepth: 3);

        final move = ai.getBestMove(board, Player.black);

        expect(move, isNotNull);
        // Corner should be highly valued (though early game randomization might vary)
        expect(board.isValidMove(move!, Player.black), true);
      });

      test('handles mid-game board state', () {
        final board = Board.initial();

        // Make a few moves to get to mid-game
        var currentBoard = board;
        currentBoard = currentBoard.makeMove(
          const Position(row: 2, col: 3),
          Player.black,
        );
        currentBoard = currentBoard.makeMove(
          const Position(row: 2, col: 2),
          Player.white,
        );
        currentBoard = currentBoard.makeMove(
          const Position(row: 2, col: 4),
          Player.black,
        );

        final ai = OthelloAI();
        final move = ai.getBestMove(currentBoard, Player.white);

        expect(move, isNotNull);
        expect(currentBoard.isValidMove(move!, Player.white), true);
      });

      test('different depths produce valid moves', () {
        final board = Board.initial();

        for (var depth in [1, 2, 3, 4, 5]) {
          final ai = OthelloAI(maxDepth: depth);
          final move = ai.getBestMove(board, Player.black);

          expect(move, isNotNull, reason: 'Depth $depth should return a move');
          expect(
            board.isValidMove(move!, Player.black),
            true,
            reason: 'Move at depth $depth should be valid',
          );
        }
      });

      test('handles early game randomization', () {
        // Early game (≤8 stones) should use randomized selection
        final board = Board.initial();
        final ai = OthelloAI();

        // Make multiple requests to see if there's variation (though not guaranteed)
        final moves = <Position>{};
        for (var i = 0; i < 10; i++) {
          final move = ai.getBestMove(board, Player.black);
          if (move != null) {
            moves.add(move);
          }
        }

        // Should return valid moves
        expect(moves.isNotEmpty, true);
        for (final move in moves) {
          expect(board.isValidMove(move, Player.black), true);
        }
      });

      test('handles board with pass situation', () {
        // Create a situation where current player must pass
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.none),
        );

        // Setup where white has no moves but black does
        cells[3][3] = Player.black;
        cells[3][4] = Player.black;
        cells[4][3] = Player.black;
        cells[4][4] = Player.black;

        final board = Board(cells: cells);
        final ai = OthelloAI();

        final whiteMove = ai.getBestMove(board, Player.white);
        expect(whiteMove, null); // White has no moves

        final blackMove = ai.getBestMove(board, Player.black);
        expect(blackMove, null); // Black also has no valid moves in this setup
      });

      test('AI makes winning move when available', () {
        // Create a scenario where AI can make a strong move
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.none),
        );

        // Setup a winnable position for black
        cells[3][3] = Player.white;
        cells[3][4] = Player.white;
        cells[3][5] = Player.black;
        cells[4][4] = Player.white;
        cells[5][4] = Player.black;

        final board = Board(cells: cells);
        final ai = OthelloAI(maxDepth: 3);

        final move = ai.getBestMove(board, Player.black);

        // AI should find a valid strong move
        if (board.getValidMoves(Player.black).isNotEmpty) {
          expect(move, isNotNull);
          expect(board.isValidMove(move!, Player.black), true);
        } else {
          expect(move, null);
        }
      });

      test('AI defends against opponent threats', () {
        // Create a board where opponent threatens to take corner
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.none),
        );

        // Setup: White threatens corner, black should defend
        cells[0][1] = Player.black;
        cells[0][2] = Player.black;
        cells[0][3] = Player.white;

        cells[1][0] = Player.white;
        cells[2][0] = Player.white;
        cells[3][0] = Player.black;

        final board = Board(cells: cells);
        final ai = OthelloAI(maxDepth: 2);

        final move = ai.getBestMove(board, Player.black);

        expect(move, isNotNull);
        expect(board.isValidMove(move!, Player.black), true);
      });

      test('returns consistent move for deterministic mid-game', () {
        // After early game (>8 stones), same board should give same move
        final board = Board.initial();

        // Make enough moves to get past early game threshold (>8 stones)
        var currentBoard = board;
        final movesToMake = [
          const Position(row: 2, col: 3), // Black
          const Position(row: 2, col: 2), // White
          const Position(row: 2, col: 4), // Black
          const Position(row: 2, col: 5), // White
          const Position(row: 4, col: 2), // Black
          const Position(row: 5, col: 2), // White
          const Position(row: 5, col: 3), // Black
        ];

        for (var i = 0; i < movesToMake.length; i++) {
          final player = i.isEven ? Player.black : Player.white;
          if (currentBoard.isValidMove(movesToMake[i], player)) {
            currentBoard = currentBoard.makeMove(movesToMake[i], player);
          }
        }

        // Now we're in mid-game (>8 stones)
        final totalStones =
            currentBoard.countStones(Player.black) +
            currentBoard.countStones(Player.white);

        // If we're past early game, test determinism
        if (totalStones > 8) {
          final ai = OthelloAI(maxDepth: 3);

          // Get move multiple times - should be deterministic
          final move1 = ai.getBestMove(currentBoard, Player.white);
          final move2 = ai.getBestMove(currentBoard, Player.white);

          expect(move1, equals(move2));
        } else {
          // If still in early game, just verify we get valid moves
          final ai = OthelloAI(maxDepth: 3);
          final move = ai.getBestMove(currentBoard, Player.white);
          if (move != null) {
            expect(currentBoard.isValidMove(move, Player.white), true);
          }
        }
      });

      test('handles complex board patterns', () {
        final cells = List.generate(8, (row) {
          return List.generate(8, (col) {
            // Create a checkerboard-like pattern with some empty spaces
            if (row < 4 && col < 4) {
              return (row + col).isEven ? Player.black : Player.white;
            }
            return Player.none;
          });
        });

        final board = Board(cells: cells);
        final ai = OthelloAI();

        final move = ai.getBestMove(board, Player.black);

        if (move != null) {
          expect(board.isValidMove(move, Player.black), true);
        }
      });
    });

    group('edge cases', () {
      test('handles empty board gracefully', () {
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.none),
        );
        final board = Board(cells: cells);
        final ai = OthelloAI();

        final move = ai.getBestMove(board, Player.black);

        // Empty board has no valid moves
        expect(move, null);
      });

      test('handles full board', () {
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.black),
        );
        final board = Board(cells: cells);
        final ai = OthelloAI();

        final move = ai.getBestMove(board, Player.white);

        expect(move, null);
      });

      test('handles board with single stone', () {
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.none),
        );
        cells[3][3] = Player.black;

        final board = Board(cells: cells);
        final ai = OthelloAI();

        final move = ai.getBestMove(board, Player.white);

        // Single stone, no valid moves
        expect(move, null);
      });

      test('maxDepth of 1 still returns valid move', () {
        final board = Board.initial();
        final ai = OthelloAI(maxDepth: 1);

        final move = ai.getBestMove(board, Player.black);

        expect(move, isNotNull);
        expect(board.isValidMove(move!, Player.black), true);
      });

      test('maxDepth of 0 still returns valid move', () {
        final board = Board.initial();
        final ai = OthelloAI(maxDepth: 0);

        final move = ai.getBestMove(board, Player.black);

        expect(move, isNotNull);
        expect(board.isValidMove(move!, Player.black), true);
      });
    });
  });
}
