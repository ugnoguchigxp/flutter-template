import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/models/tetris_game_state.dart';
import 'providers/tetris_game_provider.dart';
import 'widgets/game_controls.dart';
import 'widgets/next_piece_preview.dart';
import 'widgets/tetris_board.dart';

class TetrisGameScreen extends ConsumerStatefulWidget {
  const TetrisGameScreen({super.key});

  @override
  ConsumerState<TetrisGameScreen> createState() => _TetrisGameScreenState();
}

class _TetrisGameScreenState extends ConsumerState<TetrisGameScreen> {
  @override
  void dispose() {
    // ゲーム一覧に戻る時にゲームをリセット
    ref.read(tetrisGameProvider.notifier).resetGame();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(tetrisGameProvider);
    final gameNotifier = ref.read(tetrisGameProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('Tetris'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (gameState.status == TetrisGameStatus.playing)
            IconButton(
              icon: const Icon(Icons.pause),
              tooltip: '一時停止',
              onPressed: gameNotifier.pauseGame,
            ),
        ],
      ),
      body: SafeArea(
        child: gameState.status == TetrisGameStatus.idle
            ? _buildStartScreen(context, gameNotifier)
            : gameState.status == TetrisGameStatus.gameOver
            ? _buildGameOverScreen(context, gameState, gameNotifier)
            : _buildGameScreen(context, gameState, gameNotifier),
      ),
    );
  }

  Widget _buildStartScreen(BuildContext context, TetrisGameNotifier notifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'TETRIS',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: notifier.startGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'スタート',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen(
    BuildContext context,
    TetrisGameState gameState,
    TetrisGameNotifier notifier,
  ) {
    return Column(
      children: [
        // メインゲーム領域（ボード、情報サイドバー）
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 左側：ゲームボード（最大化、左寄せ）
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TetrisBoard(gameState: gameState),
                  ),
                ),
                const SizedBox(width: 8),
                // 右側：次のブロック＋スコア情報
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NextPiecePreview(
                      nextTetromino: gameState.nextTetromino,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    _buildCompactInfoCard('スコア', gameState.score.toString()),
                    const SizedBox(height: 8),
                    _buildCompactInfoCard('Lv', gameState.level.toString()),
                    const SizedBox(height: 8),
                    _buildCompactInfoCard(
                      'ライン',
                      gameState.linesCleared.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // コントロールボタン
        GameControls(
          onMoveLeft: notifier.moveLeft,
          onMoveRight: notifier.moveRight,
          onMoveDown: notifier.hardDrop,
          onRotateClockwise: notifier.rotateClockwise,
          onRotateCounterClockwise: notifier.rotateCounterClockwise,
        ),
      ],
    );
  }

  Widget _buildGameOverScreen(
    BuildContext context,
    TetrisGameState gameState,
    TetrisGameNotifier notifier,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'GAME OVER',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 32),
          _buildInfoCard('最終スコア', gameState.score.toString()),
          const SizedBox(height: 16),
          _buildInfoCard('レベル', gameState.level.toString()),
          const SizedBox(height: 16),
          _buildInfoCard('削除ライン', gameState.linesCleared.toString()),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              notifier.resetGame();
              notifier.startGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'もう一度プレイ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
