import 'package:flutter/material.dart';

import 'tetromino.dart';

enum TetrisGameStatus { idle, playing, paused, gameOver }

class TetrisGameState {
  const TetrisGameState({
    this.status = TetrisGameStatus.idle,
    this.board = const [],
    this.currentTetromino,
    this.nextTetromino,
    this.score = 0,
    this.level = 1,
    this.linesCleared = 0,
  });

  final TetrisGameStatus status;
  final List<List<Color?>> board;
  final Tetromino? currentTetromino;
  final Tetromino? nextTetromino;
  final int score;
  final int level;
  final int linesCleared;

  TetrisGameState copyWith({
    TetrisGameStatus? status,
    List<List<Color?>>? board,
    Tetromino? currentTetromino,
    Tetromino? nextTetromino,
    int? score,
    int? level,
    int? linesCleared,
  }) {
    return TetrisGameState(
      status: status ?? this.status,
      board: board ?? this.board,
      currentTetromino: currentTetromino ?? this.currentTetromino,
      nextTetromino: nextTetromino ?? this.nextTetromino,
      score: score ?? this.score,
      level: level ?? this.level,
      linesCleared: linesCleared ?? this.linesCleared,
    );
  }
}
