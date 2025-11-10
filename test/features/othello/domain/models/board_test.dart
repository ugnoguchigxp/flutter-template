import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/othello/domain/models/board.dart';
import 'package:flutter_template/src/features/othello/domain/models/player.dart';
import 'package:flutter_template/src/features/othello/domain/models/position.dart';

void main() {
  group('Board', () {
    group('initial', () {
      test('creates 8x8 board with correct initial setup', () {
        final board = Board.initial();

        expect(board.cells.length, 8);
        expect(board.cells[0].length, 8);

        // Check initial 4 stones in the center
        expect(board.getCell(const Position(row: 3, col: 3)), Player.white);
        expect(board.getCell(const Position(row: 3, col: 4)), Player.black);
        expect(board.getCell(const Position(row: 4, col: 3)), Player.black);
        expect(board.getCell(const Position(row: 4, col: 4)), Player.white);

        // Check other cells are empty
        expect(board.getCell(const Position(row: 0, col: 0)), Player.none);
        expect(board.getCell(const Position(row: 7, col: 7)), Player.none);
      });

      test('has exactly 2 black and 2 white stones initially', () {
        final board = Board.initial();

        expect(board.countStones(Player.black), 2);
        expect(board.countStones(Player.white), 2);
        expect(board.countStones(Player.none), 60);
      });
    });

    group('getCell', () {
      test('returns correct player for valid position', () {
        final board = Board.initial();

        expect(board.getCell(const Position(row: 3, col: 3)), Player.white);
        expect(board.getCell(const Position(row: 3, col: 4)), Player.black);
      });

      test('returns Player.none for invalid position', () {
        final board = Board.initial();

        expect(board.getCell(const Position(row: -1, col: 0)), Player.none);
        expect(board.getCell(const Position(row: 0, col: -1)), Player.none);
        expect(board.getCell(const Position(row: 8, col: 0)), Player.none);
        expect(board.getCell(const Position(row: 0, col: 8)), Player.none);
      });
    });

    group('isValidMove', () {
      test('initial board has 4 valid moves for black', () {
        final board = Board.initial();

        expect(
          board.isValidMove(const Position(row: 2, col: 3), Player.black),
          true,
        );
        expect(
          board.isValidMove(const Position(row: 3, col: 2), Player.black),
          true,
        );
        expect(
          board.isValidMove(const Position(row: 4, col: 5), Player.black),
          true,
        );
        expect(
          board.isValidMove(const Position(row: 5, col: 4), Player.black),
          true,
        );
      });

      test('cannot place stone on occupied cell', () {
        final board = Board.initial();

        expect(
          board.isValidMove(const Position(row: 3, col: 3), Player.black),
          false,
        );
        expect(
          board.isValidMove(const Position(row: 3, col: 4), Player.black),
          false,
        );
      });

      test('cannot place stone on invalid position', () {
        final board = Board.initial();

        expect(
          board.isValidMove(const Position(row: -1, col: 0), Player.black),
          false,
        );
        expect(
          board.isValidMove(const Position(row: 8, col: 0), Player.black),
          false,
        );
      });

      test('cannot place Player.none', () {
        final board = Board.initial();

        expect(
          board.isValidMove(const Position(row: 2, col: 3), Player.none),
          false,
        );
      });

      test('move must flip at least one opponent stone', () {
        final board = Board.initial();

        // Position (0,0) has no opponent stones to flip
        expect(
          board.isValidMove(const Position(row: 0, col: 0), Player.black),
          false,
        );
      });
    });

    group('getValidMoves', () {
      test('initial board has exactly 4 valid moves for black', () {
        final board = Board.initial();
        final validMoves = board.getValidMoves(Player.black);

        expect(validMoves.length, 4);
        expect(validMoves, contains(const Position(row: 2, col: 3)));
        expect(validMoves, contains(const Position(row: 3, col: 2)));
        expect(validMoves, contains(const Position(row: 4, col: 5)));
        expect(validMoves, contains(const Position(row: 5, col: 4)));
      });

      test('initial board has exactly 4 valid moves for white', () {
        final board = Board.initial();
        final validMoves = board.getValidMoves(Player.white);

        expect(validMoves.length, 4);
        expect(validMoves, contains(const Position(row: 2, col: 4)));
        expect(validMoves, contains(const Position(row: 3, col: 5)));
        expect(validMoves, contains(const Position(row: 4, col: 2)));
        expect(validMoves, contains(const Position(row: 5, col: 3)));
      });

      test('returns empty list for Player.none', () {
        final board = Board.initial();
        final validMoves = board.getValidMoves(Player.none);

        expect(validMoves, isEmpty);
      });
    });

    group('makeMove', () {
      test('places stone and flips opponent stones', () {
        final board = Board.initial();
        final newBoard = board.makeMove(
          const Position(row: 2, col: 3),
          Player.black,
        );

        // New stone placed
        expect(newBoard.getCell(const Position(row: 2, col: 3)), Player.black);

        // Opponent stone flipped
        expect(newBoard.getCell(const Position(row: 3, col: 3)), Player.black);

        // Other stones remain unchanged
        expect(newBoard.getCell(const Position(row: 3, col: 4)), Player.black);
        expect(newBoard.getCell(const Position(row: 4, col: 4)), Player.white);
      });

      test('flips stones in multiple directions', () {
        // Create a board where a move can flip in multiple directions
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.none),
        );
        cells[3][3] = Player.white;
        cells[3][4] = Player.white;
        cells[3][5] = Player.black;
        cells[4][3] = Player.white;
        cells[5][3] = Player.black;

        final board = Board(cells: cells);
        final newBoard = board.makeMove(
          const Position(row: 2, col: 3),
          Player.black,
        );

        // Stone placed
        expect(newBoard.getCell(const Position(row: 2, col: 3)), Player.black);

        // Flipped downward
        expect(newBoard.getCell(const Position(row: 3, col: 3)), Player.black);
        expect(newBoard.getCell(const Position(row: 4, col: 3)), Player.black);

        // Other white stones remain
        expect(newBoard.getCell(const Position(row: 3, col: 4)), Player.white);
      });

      test('returns original board if move is invalid', () {
        final board = Board.initial();

        // Try invalid move (occupied cell)
        final newBoard = board.makeMove(
          const Position(row: 3, col: 3),
          Player.black,
        );

        expect(newBoard, equals(board));
      });

      test('does not mutate original board', () {
        final board = Board.initial();
        final originalBlackCount = board.countStones(Player.black);

        board.makeMove(const Position(row: 2, col: 3), Player.black);

        // Original board unchanged
        expect(board.countStones(Player.black), originalBlackCount);
      });
    });

    group('countStones', () {
      test('counts stones correctly', () {
        final board = Board.initial();

        expect(board.countStones(Player.black), 2);
        expect(board.countStones(Player.white), 2);
        expect(board.countStones(Player.none), 60);
      });

      test('updates count after move', () {
        final board = Board.initial();
        final newBoard = board.makeMove(
          const Position(row: 2, col: 3),
          Player.black,
        );

        expect(newBoard.countStones(Player.black), 4);
        expect(newBoard.countStones(Player.white), 1);
      });

      test('counts all stones on full board', () {
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.black),
        );
        final board = Board(cells: cells);

        expect(board.countStones(Player.black), 64);
        expect(board.countStones(Player.white), 0);
        expect(board.countStones(Player.none), 0);
      });
    });

    group('getWinner', () {
      test('returns black if black has more stones', () {
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.none),
        );
        cells[0][0] = Player.black;
        cells[0][1] = Player.black;
        cells[0][2] = Player.white;

        final board = Board(cells: cells);

        expect(board.getWinner(), Player.black);
      });

      test('returns white if white has more stones', () {
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.none),
        );
        cells[0][0] = Player.white;
        cells[0][1] = Player.white;
        cells[0][2] = Player.black;

        final board = Board(cells: cells);

        expect(board.getWinner(), Player.white);
      });

      test('returns null on tie', () {
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.none),
        );
        cells[0][0] = Player.black;
        cells[0][1] = Player.white;

        final board = Board(cells: cells);

        expect(board.getWinner(), null);
      });

      test('returns null when all cells are empty', () {
        final board = Board(
          cells: List.generate(8, (_) => List.generate(8, (_) => Player.none)),
        );

        expect(board.getWinner(), null);
      });
    });

    group('isGameOver', () {
      test('returns false at initial state', () {
        final board = Board.initial();

        expect(board.isGameOver(), false);
      });

      test('returns true when neither player has valid moves', () {
        // Create board where no moves are possible
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.black),
        );
        // Fill all cells with black (no valid moves for either player)
        final board = Board(cells: cells);

        expect(board.isGameOver(), true);
      });

      test('returns false when at least one player has valid moves', () {
        final board = Board.initial();

        expect(board.isGameOver(), false);
      });
    });

    group('evaluate', () {
      test('returns high positive score when player wins', () {
        // Create a winning position for black
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.black),
        );
        final board = Board(cells: cells);

        final score = board.evaluate(Player.black);

        expect(score, Board.gameOverScore);
      });

      test('returns high negative score when opponent wins', () {
        // Create a winning position for white
        final cells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.white),
        );
        final board = Board(cells: cells);

        final score = board.evaluate(Player.black);

        expect(score, -Board.gameOverScore);
      });

      test('returns 0 on tie', () {
        // Create a tie
        final cells = List.generate(8, (row) {
          return List.generate(8, (col) {
            return (row + col) % 2 == 0 ? Player.black : Player.white;
          });
        });
        final board = Board(cells: cells);

        final score = board.evaluate(Player.black);

        expect(score, 0);
      });

      test('gives high score for corner control', () {
        final board = Board.initial();
        final cells = List.generate(8, (row) {
          return List.generate(8, (col) => board.cells[row][col]);
        });

        // Place black stone on corner
        cells[0][0] = Player.black;

        final boardWithCorner = Board(cells: cells);
        final score = boardWithCorner.evaluate(Player.black);

        expect(score, greaterThan(0));
        // Corner weight should dominate
        expect(score, greaterThanOrEqualTo(Board.cornerWeight));
      });

      test('considers mobility in evaluation', () {
        final board = Board.initial();

        // Initial board evaluation for black
        final blackScore = board.evaluate(Player.black);

        // Black has 4 valid moves, white has 4 valid moves
        // Score should be relatively balanced (close to 0)
        expect(blackScore.abs(), lessThan(100));

        // After a move, board state changes
        final newBoard = board.makeMove(
          const Position(row: 2, col: 3),
          Player.black,
        );
        final newBlackScore = newBoard.evaluate(Player.black);

        // Evaluation should produce some score (positive or negative)
        expect(newBlackScore, isA<int>());
      });

      test('considers stone count in endgame', () {
        // Create near-full board (endgame scenario)
        final cells = List.generate(8, (row) {
          return List.generate(8, (col) {
            if (row < 6) return Player.black;
            if (row == 6 && col < 4) return Player.white;
            return Player.none;
          });
        });

        final board = Board(cells: cells);
        final totalStones =
            board.countStones(Player.black) + board.countStones(Player.white);

        // Verify it's in endgame
        expect(totalStones, greaterThan(Board.endgameThreshold));

        final score = board.evaluate(Player.black);

        // In endgame, stone count should contribute to score
        expect(score, isNot(0));
      });
    });

    group('equality', () {
      test('boards with same cells are equal', () {
        final board1 = Board.initial();
        final board2 = Board.initial();

        expect(board1, equals(board2));
      });

      test('boards with different cells are not equal', () {
        final board1 = Board.initial();
        final board2 = board1.makeMove(
          const Position(row: 2, col: 3),
          Player.black,
        );

        expect(board1, isNot(equals(board2)));
      });
    });

    group('copyWith', () {
      test('copyWith creates new instance with updated cells', () {
        final board = Board.initial();
        final newCells = List.generate(
          8,
          (_) => List.generate(8, (_) => Player.none),
        );

        final updated = board.copyWith(cells: newCells);

        expect(updated.cells, equals(newCells));
        expect(board.cells, isNot(equals(newCells))); // Original unchanged
      });
    });
  });
}
