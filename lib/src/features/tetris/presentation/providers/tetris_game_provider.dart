import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/tetris_game_state.dart';
import '../../domain/models/tetromino.dart';

const int boardWidth = 10;
const int boardHeight = 20;

class TetrisGameNotifier extends StateNotifier<TetrisGameState> {
  TetrisGameNotifier() : super(const TetrisGameState());

  Timer? _gameTimer;
  final Random _random = Random();

  void startGame() {
    final board = List.generate(
      boardHeight,
      (_) => List<Color?>.filled(boardWidth, null),
    );

    final firstTetromino = _generateRandomTetromino();
    final secondTetromino = _generateRandomTetromino();

    state = TetrisGameState(
      status: TetrisGameStatus.playing,
      board: board,
      currentTetromino: firstTetromino,
      nextTetromino: secondTetromino,
      score: 0,
      level: 1,
      linesCleared: 0,
    );

    _startGameLoop();
  }

  void _startGameLoop() {
    _gameTimer?.cancel();
    final speed = 1000 - (state.level - 1) * 100;
    _gameTimer = Timer.periodic(
      Duration(milliseconds: speed.clamp(100, 1000)),
      (_) => moveDown(),
    );
  }

  void moveLeft() {
    if (state.status != TetrisGameStatus.playing) return;
    if (state.currentTetromino == null) return;

    final newTetromino = state.currentTetromino!.copyWith(
      position: state.currentTetromino!.position.copyWith(
        x: state.currentTetromino!.position.x - 1,
      ),
    );

    if (_isValidPosition(newTetromino)) {
      state = state.copyWith(currentTetromino: newTetromino);
    }
  }

  void moveRight() {
    if (state.status != TetrisGameStatus.playing) return;
    if (state.currentTetromino == null) return;

    final newTetromino = state.currentTetromino!.copyWith(
      position: state.currentTetromino!.position.copyWith(
        x: state.currentTetromino!.position.x + 1,
      ),
    );

    if (_isValidPosition(newTetromino)) {
      state = state.copyWith(currentTetromino: newTetromino);
    }
  }

  void moveDown() {
    if (state.status != TetrisGameStatus.playing) return;
    if (state.currentTetromino == null) return;

    final newTetromino = state.currentTetromino!.copyWith(
      position: state.currentTetromino!.position.copyWith(
        y: state.currentTetromino!.position.y + 1,
      ),
    );

    if (_isValidPosition(newTetromino)) {
      state = state.copyWith(currentTetromino: newTetromino);
    } else {
      _lockTetromino();
    }
  }

  // ハードドロップ（一気に落とす）
  void hardDrop() {
    if (state.status != TetrisGameStatus.playing) return;
    if (state.currentTetromino == null) return;

    var currentY = state.currentTetromino!.position.y;

    // 落とせる最大位置まで移動
    while (true) {
      final testTetromino = state.currentTetromino!.copyWith(
        position: state.currentTetromino!.position.copyWith(y: currentY + 1),
      );

      if (_isValidPosition(testTetromino)) {
        currentY++;
      } else {
        break;
      }
    }

    // 最終位置にセット
    state = state.copyWith(
      currentTetromino: state.currentTetromino!.copyWith(
        position: state.currentTetromino!.position.copyWith(y: currentY),
      ),
    );

    // 即座にロック
    _lockTetromino();
  }

  void rotateClockwise() {
    if (state.status != TetrisGameStatus.playing) return;
    if (state.currentTetromino == null) return;

    final newTetromino = state.currentTetromino!.copyWith(
      rotation: state.currentTetromino!.rotation + 1,
    );

    if (_isValidPosition(newTetromino)) {
      state = state.copyWith(currentTetromino: newTetromino);
    }
  }

  void rotateCounterClockwise() {
    if (state.status != TetrisGameStatus.playing) return;
    if (state.currentTetromino == null) return;

    final newTetromino = state.currentTetromino!.copyWith(
      rotation: state.currentTetromino!.rotation - 1,
    );

    if (_isValidPosition(newTetromino)) {
      state = state.copyWith(currentTetromino: newTetromino);
    }
  }

  bool _isValidPosition(Tetromino tetromino) {
    final shape = tetromino.shape;
    for (int y = 0; y < shape.length; y++) {
      for (int x = 0; x < shape[y].length; x++) {
        if (shape[y][x] == 0) continue;

        final boardX = tetromino.position.x + x;
        final boardY = tetromino.position.y + y;

        // 境界チェック
        if (boardX < 0 || boardX >= boardWidth) return false;
        if (boardY < 0 || boardY >= boardHeight) return false;

        // 衝突チェック
        if (state.board[boardY][boardX] != null) return false;
      }
    }
    return true;
  }

  void _lockTetromino() {
    if (state.currentTetromino == null) return;

    final newBoard = List.generate(
      boardHeight,
      (y) => List<Color?>.from(state.board[y]),
    );

    final tetromino = state.currentTetromino!;
    final shape = tetromino.shape;

    for (int y = 0; y < shape.length; y++) {
      for (int x = 0; x < shape[y].length; x++) {
        if (shape[y][x] == 0) continue;

        final boardX = tetromino.position.x + x;
        final boardY = tetromino.position.y + y;

        if (boardY >= 0 &&
            boardY < boardHeight &&
            boardX >= 0 &&
            boardX < boardWidth) {
          newBoard[boardY][boardX] = tetromino.color;
        }
      }
    }

    state = state.copyWith(board: newBoard);

    // 行の削除チェック
    _clearLines();

    // 次のテトロミノ
    _spawnNextTetromino();
  }

  void _clearLines() {
    final newBoard = <List<Color?>>[];
    int clearedLines = 0;

    for (int y = 0; y < boardHeight; y++) {
      if (state.board[y].every((cell) => cell != null)) {
        clearedLines++;
      } else {
        newBoard.add(List<Color?>.from(state.board[y]));
      }
    }

    // 削除した行の分だけ空行を追加
    while (newBoard.length < boardHeight) {
      newBoard.insert(0, List<Color?>.filled(boardWidth, null));
    }

    if (clearedLines > 0) {
      final points = _calculateScore(clearedLines);
      final newScore = state.score + points;
      final newLinesCleared = state.linesCleared + clearedLines;
      final newLevel = (newLinesCleared ~/ 10) + 1;

      // レベルアップ判定のため、更新前のレベルを保存
      final oldLevel = state.level;

      state = state.copyWith(
        board: newBoard,
        score: newScore,
        linesCleared: newLinesCleared,
        level: newLevel,
      );

      // レベルアップでスピード変更
      if (newLevel > oldLevel) {
        _startGameLoop();
      }
    }
  }

  int _calculateScore(int lines) {
    switch (lines) {
      case 1:
        return 100 * state.level;
      case 2:
        return 300 * state.level;
      case 3:
        return 500 * state.level;
      case 4:
        return 800 * state.level;
      default:
        return 0;
    }
  }

  void _spawnNextTetromino() {
    final nextTetromino = state.nextTetromino ?? _generateRandomTetromino();
    final newNextTetromino = _generateRandomTetromino();

    // ゲームオーバーチェック
    if (!_isValidPosition(nextTetromino)) {
      state = state.copyWith(status: TetrisGameStatus.gameOver);
      _gameTimer?.cancel();
      return;
    }

    state = state.copyWith(
      currentTetromino: nextTetromino,
      nextTetromino: newNextTetromino,
    );
  }

  Tetromino _generateRandomTetromino() {
    const types = TetrominoType.values;
    final type = types[_random.nextInt(types.length)];

    return Tetromino(
      type: type,
      rotation: 0,
      position: Position(x: boardWidth ~/ 2 - 1, y: 0),
    );
  }

  void pauseGame() {
    if (state.status == TetrisGameStatus.playing) {
      _gameTimer?.cancel();
      state = state.copyWith(status: TetrisGameStatus.paused);
    }
  }

  void resumeGame() {
    if (state.status == TetrisGameStatus.paused) {
      state = state.copyWith(status: TetrisGameStatus.playing);
      _startGameLoop();
    }
  }

  void resetGame() {
    _gameTimer?.cancel();
    state = const TetrisGameState();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}

final tetrisGameProvider =
    StateNotifierProvider<TetrisGameNotifier, TetrisGameState>((ref) {
      return TetrisGameNotifier();
    });
