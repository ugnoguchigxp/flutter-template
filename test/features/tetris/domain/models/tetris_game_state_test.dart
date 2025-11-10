import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/src/features/tetris/domain/models/tetris_game_state.dart';
import 'package:flutter_template/src/features/tetris/domain/models/tetromino.dart';

void main() {
  group('TetrisGameStatus', () {
    test('has correct enum values', () {
      expect(TetrisGameStatus.values, [
        TetrisGameStatus.idle,
        TetrisGameStatus.playing,
        TetrisGameStatus.paused,
        TetrisGameStatus.gameOver,
      ]);
    });

    test('has 4 statuses', () {
      expect(TetrisGameStatus.values.length, 4);
    });
  });

  group('TetrisGameState', () {
    group('default values', () {
      test('creates with default values', () {
        const state = TetrisGameState();

        expect(state.status, TetrisGameStatus.idle);
        expect(state.board, isEmpty);
        expect(state.currentTetromino, null);
        expect(state.nextTetromino, null);
        expect(state.score, 0);
        expect(state.level, 1);
        expect(state.linesCleared, 0);
      });

      test('default board is empty list', () {
        const state = TetrisGameState();

        expect(state.board, const []);
      });

      test('default level starts at 1', () {
        const state = TetrisGameState();

        expect(state.level, 1);
      });
    });

    group('creation with custom values', () {
      test('creates with custom status', () {
        const state = TetrisGameState(status: TetrisGameStatus.playing);

        expect(state.status, TetrisGameStatus.playing);
      });

      test('creates with custom score', () {
        const state = TetrisGameState(score: 1000);

        expect(state.score, 1000);
      });

      test('creates with custom level', () {
        const state = TetrisGameState(level: 5);

        expect(state.level, 5);
      });

      test('creates with custom lines cleared', () {
        const state = TetrisGameState(linesCleared: 20);

        expect(state.linesCleared, 20);
      });

      test('creates with current tetromino', () {
        const tetromino = Tetromino(
          type: TetrominoType.i,
          rotation: 0,
          position: Position(x: 3, y: 0),
        );
        const state = TetrisGameState(currentTetromino: tetromino);

        expect(state.currentTetromino, tetromino);
        expect(state.currentTetromino?.type, TetrominoType.i);
      });

      test('creates with next tetromino', () {
        const tetromino = Tetromino(
          type: TetrominoType.t,
          rotation: 0,
          position: Position(x: 3, y: 0),
        );
        const state = TetrisGameState(nextTetromino: tetromino);

        expect(state.nextTetromino, tetromino);
        expect(state.nextTetromino?.type, TetrominoType.t);
      });

      test('creates with custom board', () {
        final board = List<List<Color?>>.generate(
          20,
          (_) => List<Color?>.generate(10, (_) => null),
        );
        board[19][0] = Colors.cyan;
        board[19][1] = Colors.yellow;

        final state = TetrisGameState(board: board);

        expect(state.board.length, 20);
        expect(state.board[0].length, 10);
        expect(state.board[19][0], Colors.cyan);
        expect(state.board[19][1], Colors.yellow);
      });
    });

    group('copyWith', () {
      test('updates status', () {
        const state = TetrisGameState(status: TetrisGameStatus.idle);
        final updated = state.copyWith(status: TetrisGameStatus.playing);

        expect(updated.status, TetrisGameStatus.playing);
        expect(updated.score, state.score);
        expect(updated.level, state.level);
      });

      test('updates score', () {
        const state = TetrisGameState(score: 0);
        final updated = state.copyWith(score: 500);

        expect(updated.score, 500);
        expect(updated.status, state.status);
      });

      test('updates level', () {
        const state = TetrisGameState(level: 1);
        final updated = state.copyWith(level: 3);

        expect(updated.level, 3);
        expect(updated.score, state.score);
      });

      test('updates lines cleared', () {
        const state = TetrisGameState(linesCleared: 5);
        final updated = state.copyWith(linesCleared: 10);

        expect(updated.linesCleared, 10);
        expect(updated.level, state.level);
      });

      test('updates current tetromino', () {
        const tetromino1 = Tetromino(
          type: TetrominoType.i,
          rotation: 0,
          position: Position(x: 3, y: 0),
        );
        const tetromino2 = Tetromino(
          type: TetrominoType.t,
          rotation: 1,
          position: Position(x: 4, y: 2),
        );

        const state = TetrisGameState(currentTetromino: tetromino1);
        final updated = state.copyWith(currentTetromino: tetromino2);

        expect(updated.currentTetromino, tetromino2);
        expect(updated.currentTetromino?.type, TetrominoType.t);
      });

      test('updates next tetromino', () {
        const tetromino1 = Tetromino(
          type: TetrominoType.i,
          rotation: 0,
          position: Position(x: 3, y: 0),
        );
        const tetromino2 = Tetromino(
          type: TetrominoType.l,
          rotation: 0,
          position: Position(x: 3, y: 0),
        );

        const state = TetrisGameState(nextTetromino: tetromino1);
        final updated = state.copyWith(nextTetromino: tetromino2);

        expect(updated.nextTetromino, tetromino2);
        expect(updated.nextTetromino?.type, TetrominoType.l);
      });

      test('updates board', () {
        final board1 = List<List<Color?>>.generate(
          20,
          (_) => List<Color?>.generate(10, (_) => null),
        );
        final board2 = List<List<Color?>>.generate(
          20,
          (_) => List<Color?>.generate(10, (_) => null),
        );
        board2[0][0] = Colors.red;

        final state = TetrisGameState(board: board1);
        final updated = state.copyWith(board: board2);

        expect(updated.board[0][0], Colors.red);
      });

      test('updates multiple properties', () {
        const state = TetrisGameState(
          status: TetrisGameStatus.idle,
          score: 0,
          level: 1,
        );

        final updated = state.copyWith(
          status: TetrisGameStatus.playing,
          score: 1000,
          level: 5,
        );

        expect(updated.status, TetrisGameStatus.playing);
        expect(updated.score, 1000);
        expect(updated.level, 5);
      });

      test('returns state with no changes when no parameters', () {
        const state = TetrisGameState(
          status: TetrisGameStatus.playing,
          score: 500,
          level: 3,
        );

        final updated = state.copyWith();

        expect(updated.status, state.status);
        expect(updated.score, state.score);
        expect(updated.level, state.level);
      });
    });

    group('game flow', () {
      test('typical game start flow', () {
        const initial = TetrisGameState();
        expect(initial.status, TetrisGameStatus.idle);
        expect(initial.score, 0);

        final playing = initial.copyWith(
          status: TetrisGameStatus.playing,
          currentTetromino: const Tetromino(
            type: TetrominoType.i,
            rotation: 0,
            position: Position(x: 3, y: 0),
          ),
        );

        expect(playing.status, TetrisGameStatus.playing);
        expect(playing.currentTetromino, isNotNull);
      });

      test('pause and resume flow', () {
        final state = TetrisGameState(
          status: TetrisGameStatus.playing,
          score: 500,
          currentTetromino: const Tetromino(
            type: TetrominoType.t,
            rotation: 0,
            position: Position(x: 4, y: 5),
          ),
        );

        final paused = state.copyWith(status: TetrisGameStatus.paused);
        expect(paused.status, TetrisGameStatus.paused);
        expect(paused.score, 500);

        final resumed = paused.copyWith(status: TetrisGameStatus.playing);
        expect(resumed.status, TetrisGameStatus.playing);
        expect(resumed.score, 500);
      });

      test('game over flow', () {
        final state = TetrisGameState(
          status: TetrisGameStatus.playing,
          score: 2000,
          level: 4,
          linesCleared: 15,
        );

        final gameOver = state.copyWith(status: TetrisGameStatus.gameOver);

        expect(gameOver.status, TetrisGameStatus.gameOver);
        expect(gameOver.score, state.score);
        expect(gameOver.level, state.level);
        expect(gameOver.linesCleared, state.linesCleared);
      });

      test('level progression', () {
        const initial = TetrisGameState(level: 1, linesCleared: 5);

        final levelUp = initial.copyWith(level: 2, linesCleared: 10);

        expect(levelUp.level, 2);
        expect(levelUp.linesCleared, 10);
      });

      test('score accumulation', () {
        const state1 = TetrisGameState(score: 0);
        final state2 = state1.copyWith(score: 100);
        final state3 = state2.copyWith(score: 300);

        expect(state1.score, 0);
        expect(state2.score, 100);
        expect(state3.score, 300);
      });
    });

    group('tetromino handling', () {
      test('moving tetromino updates position', () {
        const initial = Tetromino(
          type: TetrominoType.i,
          rotation: 0,
          position: Position(x: 3, y: 0),
        );

        const state = TetrisGameState(currentTetromino: initial);

        final movedDown = state.currentTetromino?.copyWith(
          position: const Position(x: 3, y: 1),
        );

        final updated = state.copyWith(currentTetromino: movedDown);

        expect(updated.currentTetromino?.position.y, 1);
        expect(updated.currentTetromino?.position.x, 3);
      });

      test('rotating tetromino updates rotation', () {
        const initial = Tetromino(
          type: TetrominoType.t,
          rotation: 0,
          position: Position(x: 4, y: 0),
        );

        const state = TetrisGameState(currentTetromino: initial);

        final rotated = state.currentTetromino?.copyWith(rotation: 1);
        final updated = state.copyWith(currentTetromino: rotated);

        expect(updated.currentTetromino?.rotation, 1);
        expect(updated.currentTetromino?.type, TetrominoType.t);
      });

      test('swapping current and next tetromino', () {
        const current = Tetromino(
          type: TetrominoType.i,
          rotation: 0,
          position: Position(x: 3, y: 5),
        );
        const next = Tetromino(
          type: TetrominoType.o,
          rotation: 0,
          position: Position(x: 3, y: 0),
        );

        const state = TetrisGameState(
          currentTetromino: current,
          nextTetromino: next,
        );

        final swapped = state.copyWith(
          currentTetromino: next,
          nextTetromino: current,
        );

        expect(swapped.currentTetromino?.type, TetrominoType.o);
        expect(swapped.nextTetromino?.type, TetrominoType.i);
      });
    });

    group('board state', () {
      test('empty board has no filled cells', () {
        final board = List<List<Color?>>.generate(
          20,
          (_) => List<Color?>.generate(10, (_) => null),
        );

        final state = TetrisGameState(board: board);

        for (final row in state.board) {
          for (final cell in row) {
            expect(cell, null);
          }
        }
      });

      test('partially filled board retains colors', () {
        final board = List<List<Color?>>.generate(
          20,
          (_) => List<Color?>.generate(10, (_) => null),
        );

        // Add some filled cells
        board[19][0] = Colors.cyan;
        board[19][1] = Colors.yellow;
        board[18][0] = Colors.purple;

        final state = TetrisGameState(board: board);

        expect(state.board[19][0], Colors.cyan);
        expect(state.board[19][1], Colors.yellow);
        expect(state.board[18][0], Colors.purple);
      });

      test('full row can be represented', () {
        final board = List<List<Color?>>.generate(
          20,
          (_) => List<Color?>.generate(10, (_) => null),
        );

        // Fill entire bottom row
        for (var i = 0; i < 10; i++) {
          board[19][i] = Colors.red;
        }

        final state = TetrisGameState(board: board);

        for (var i = 0; i < 10; i++) {
          expect(state.board[19][i], Colors.red);
        }
      });
    });

    group('score and level tracking', () {
      test('score increases correctly', () {
        const state = TetrisGameState(score: 500);
        final updated = state.copyWith(score: 700);

        expect(updated.score, 700);
        expect(updated.score > state.score, true);
      });

      test('level increases independently of score', () {
        const state = TetrisGameState(level: 2, score: 500);
        final levelUp = state.copyWith(level: 3);
        final scoreUp = levelUp.copyWith(score: 800);

        expect(scoreUp.level, 3);
        expect(scoreUp.score, 800);
      });

      test('lines cleared accumulates', () {
        const state = TetrisGameState(linesCleared: 10);
        final cleared4 = state.copyWith(linesCleared: 14);

        expect(cleared4.linesCleared, 14);
      });

      test('high score state', () {
        const state = TetrisGameState(
          score: 999999,
          level: 99,
          linesCleared: 1000,
        );

        expect(state.score, 999999);
        expect(state.level, 99);
        expect(state.linesCleared, 1000);
      });
    });

    group('state transitions', () {
      test('idle to playing transition', () {
        const idle = TetrisGameState(status: TetrisGameStatus.idle);
        final playing = idle.copyWith(status: TetrisGameStatus.playing);

        expect(idle.status, TetrisGameStatus.idle);
        expect(playing.status, TetrisGameStatus.playing);
      });

      test('playing to paused transition', () {
        const playing = TetrisGameState(status: TetrisGameStatus.playing);
        final paused = playing.copyWith(status: TetrisGameStatus.paused);

        expect(playing.status, TetrisGameStatus.playing);
        expect(paused.status, TetrisGameStatus.paused);
      });

      test('playing to game over transition', () {
        const playing = TetrisGameState(status: TetrisGameStatus.playing);
        final gameOver = playing.copyWith(status: TetrisGameStatus.gameOver);

        expect(playing.status, TetrisGameStatus.playing);
        expect(gameOver.status, TetrisGameStatus.gameOver);
      });

      test('paused to playing transition', () {
        const paused = TetrisGameState(status: TetrisGameStatus.paused);
        final playing = paused.copyWith(status: TetrisGameStatus.playing);

        expect(paused.status, TetrisGameStatus.paused);
        expect(playing.status, TetrisGameStatus.playing);
      });
    });
  });
}
