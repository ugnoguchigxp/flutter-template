import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/models/othello_game_state.dart';
import '../domain/models/player.dart' as othello;
import '../domain/models/position.dart';
import 'providers/othello_game_provider.dart';

class OthelloGameScreen extends ConsumerWidget {
  const OthelloGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(othelloGameProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('オセロ'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(child: _buildContent(context, ref, gameState)),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    OthelloGameState gameState,
  ) {
    switch (gameState.status) {
      case GameStatus.selectingPlayer:
        return _PlayerSelectionView(
          onSelectPlayer: (player) {
            ref.read(othelloGameProvider.notifier).selectPlayer(player);
          },
        );
      case GameStatus.playing:
        return _GamePlayView(gameState: gameState);
      case GameStatus.gameOver:
        return _GameOverView(
          gameState: gameState,
          onPlayAgain: () {
            ref.read(othelloGameProvider.notifier).resetGame();
          },
          onBack: () {
            ref.read(othelloGameProvider.notifier).resetGame();
            Navigator.of(context).pop();
          },
        );
    }
  }
}

// プレイヤー選択画面
class _PlayerSelectionView extends StatelessWidget {
  const _PlayerSelectionView({required this.onSelectPlayer});

  final void Function(othello.Player) onSelectPlayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.grid_on,
            size: 80,
            color: Colors.green,
            semanticLabel: 'オセロゲーム',
          ),
          const SizedBox(height: 16),
          const Text(
            'どちらの色でプレイしますか？',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          _buildPlayerButton(
            label: '黒で先攻',
            color: Colors.black,
            player: othello.Player.black,
          ),
          const SizedBox(height: 16),
          _buildPlayerButton(
            label: '白で後攻',
            color: Colors.white,
            player: othello.Player.white,
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerButton({
    required String label,
    required Color color,
    required othello.Player player,
    Color? textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onSelectPlayer(player),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor ?? Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: color == Colors.white
                ? const BorderSide(color: Colors.black, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

// ゲームプレイ画面
class _GamePlayView extends ConsumerWidget {
  const _GamePlayView({required this.gameState});

  final OthelloGameState gameState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // スコアボード
        ColoredBox(
          color: Colors.green.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScoreCard(
                  '黒',
                  gameState.blackCount,
                  Colors.black,
                  gameState.currentPlayer == othello.Player.black,
                ),
                _buildScoreCard(
                  '白',
                  gameState.whiteCount,
                  Colors.white,
                  gameState.currentPlayer == othello.Player.white,
                  textColor: Colors.black,
                ),
              ],
            ),
          ),
        ),

        // 状態表示
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            _getStatusText(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        // ゲームボード
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _OthelloBoardWidget(gameState: gameState),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusText() {
    if (gameState.isThinking) {
      return 'CPUが思考中...';
    }
    if (gameState.isHumanTurn) {
      return 'あなたの番です';
    }
    return 'CPUの番';
  }

  Widget _buildScoreCard(
    String label,
    int count,
    Color color,
    bool isCurrentPlayer, {
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentPlayer ? Colors.green.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentPlayer ? Colors.green.shade700 : Colors.grey.shade300,
          width: isCurrentPlayer ? 3 : 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: color == Colors.white
                  ? Border.all(color: Colors.black, width: 2)
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: textColor ?? Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// オセロボード
class _OthelloBoardWidget extends ConsumerWidget {
  const _OthelloBoardWidget({required this.gameState});

  final OthelloGameState gameState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validMoves = gameState.validMoves;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(4),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: 64,
        itemBuilder: (context, index) {
          final row = index ~/ 8;
          final col = index % 8;
          final position = Position(row: row, col: col);
          final player = gameState.board.getCell(position);
          final isValidMove = validMoves.contains(position);
          final isLastMove = gameState.lastMove == position;

          return _OthelloCellWidget(
            player: player,
            isValidMove: isValidMove && gameState.isHumanTurn,
            isLastMove: isLastMove,
            onTap: () async {
              if (isValidMove && gameState.isHumanTurn) {
                await ref.read(othelloGameProvider.notifier).makeMove(position);
              }
            },
          );
        },
      ),
    );
  }
}

// オセロのセル
class _OthelloCellWidget extends StatelessWidget {
  const _OthelloCellWidget({
    required this.player,
    required this.isValidMove,
    required this.isLastMove,
    required this.onTap,
  });

  final othello.Player player;
  final bool isValidMove;
  final bool isLastMove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    String getSemanticLabel() {
      if (player != othello.Player.none) {
        return '${player.label}の石';
      } else if (isValidMove) {
        return '空きマス、タップして石を置く';
      } else {
        return '空きマス';
      }
    }

    return Semantics(
      button: isValidMove,
      label: getSemanticLabel(),
      onTap: isValidMove ? onTap : null,
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.green.shade600,
            border: isLastMove
                ? Border.all(color: Colors.yellow.shade700, width: 3)
                : null,
          ),
          child: Center(child: _buildContent()),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (player != othello.Player.none) {
      // 石がある
      return FractionallySizedBox(
        widthFactor: 0.85,
        heightFactor: 0.85,
        child: Container(
          decoration: BoxDecoration(
            color: player.color,
            shape: BoxShape.circle,
            border: player == othello.Player.white
                ? Border.all(color: Colors.black, width: 1)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      );
    } else if (isValidMove) {
      // 有効な手
      return FractionallySizedBox(
        widthFactor: 0.3,
        heightFactor: 0.3,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow.shade700.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// ゲーム終了画面
class _GameOverView extends StatelessWidget {
  const _GameOverView({
    required this.gameState,
    required this.onPlayAgain,
    required this.onBack,
  });

  final OthelloGameState gameState;
  final VoidCallback onPlayAgain;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final winner = gameState.winner;
    final humanWon = winner == gameState.humanPlayer;
    final isDraw = winner == null;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isDraw
                ? Icons.handshake
                : (humanWon ? Icons.celebration : Icons.sentiment_dissatisfied),
            size: 100,
            color: isDraw
                ? Colors.grey
                : (humanWon ? Colors.amber : Colors.blue),
            semanticLabel: isDraw ? '引き分け' : (humanWon ? '勝利' : '敗北'),
          ),
          const SizedBox(height: 24),
          Text(
            _getResultText(winner, humanWon, isDraw),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFinalScore('黒', gameState.blackCount),
                const Text(
                  ':',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                _buildFinalScore('白', gameState.whiteCount),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onPlayAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('もう一度', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('戻る', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getResultText(othello.Player? winner, bool humanWon, bool isDraw) {
    if (isDraw) return '引き分け！';
    if (humanWon) return 'あなたの勝ち！';
    return 'CPUの勝ち';
  }

  Widget _buildFinalScore(String label, int count) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '$count',
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
