import 'package:freezed_annotation/freezed_annotation.dart';

import 'board.dart';
import 'player.dart';
import 'position.dart';

part 'othello_game_state.freezed.dart';

enum GameStatus {
  selectingPlayer, // プレイヤー選択中
  playing, // ゲーム中
  gameOver, // ゲーム終了
}

@freezed
class OthelloGameState with _$OthelloGameState {
  const factory OthelloGameState({
    @Default(GameStatus.selectingPlayer) GameStatus status,
    @Default(Board(cells: [])) Board board,
    @Default(Player.black) Player currentPlayer,
    @Default(Player.black) Player humanPlayer,
    @Default(false) bool isThinking, // CPUが思考中
    Player? winner,
    Position? lastMove,
  }) = _OthelloGameState;

  const OthelloGameState._();

  bool get isHumanTurn => currentPlayer == humanPlayer;
  bool get isCpuTurn =>
      currentPlayer != humanPlayer && currentPlayer != Player.none;

  int get blackCount => board.countStones(Player.black);
  int get whiteCount => board.countStones(Player.white);

  List<Position> get validMoves => board.getValidMoves(currentPlayer);
}
