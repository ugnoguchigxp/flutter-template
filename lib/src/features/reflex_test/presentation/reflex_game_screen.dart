import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_template/src/features/reflex_test/domain/models/difficulty.dart';
import 'package:flutter_template/src/features/reflex_test/domain/models/game_result.dart';
import 'package:flutter_template/src/features/reflex_test/domain/models/reflex_game_state.dart';
import 'package:flutter_template/src/features/reflex_test/presentation/providers/reflex_game_provider.dart';
import 'package:flutter_template/src/features/reflex_test/presentation/widgets/game_canvas.dart';
import 'package:flutter_template/src/features/reflex_test/presentation/widgets/game_stats_panel.dart';
import 'package:flutter_template/src/features/reflex_test/presentation/widgets/result_screen.dart';
import 'package:flutter_template/src/features/reflex_test/presentation/widgets/start_screen.dart';

class ReflexGameScreen extends ConsumerStatefulWidget {
  const ReflexGameScreen({super.key});

  @override
  ConsumerState<ReflexGameScreen> createState() => _ReflexGameScreenState();
}

class _ReflexGameScreenState extends ConsumerState<ReflexGameScreen> {
  ReflexDifficulty? _pendingDifficulty;

  @override
  void dispose() {
    // ゲーム一覧に戻る時にゲームをリセット
    ref.read(reflexGameProvider.notifier).resetGame();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ReflexGameState gameState = ref.watch(reflexGameProvider);
    final ReflexGameNotifier gameNotifier = ref.read(reflexGameProvider.notifier);

    // ゲーム開始処理（idle状態でpendingDifficultyがある場合）
    if (gameState.status == ReflexGameStatus.idle && _pendingDifficulty != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final difficulty = _pendingDifficulty!;
        _pendingDifficulty = null;

        // 画面サイズを取得
        final size = MediaQuery.of(context).size;
        final canvasSize = Size(
          size.width - 32, // マージンを引く
          size.height - 200, // UI要素の分を引く
        );
        gameNotifier.startGame(difficulty, canvasSize);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: gameState.status == ReflexGameStatus.idle
          ? StartScreen(
              onStart: (ReflexDifficulty difficulty) {
                // 難易度を保存して次のフレームで開始
                setState(() {
                  _pendingDifficulty = difficulty;
                });
              },
            )
          : gameState.status == ReflexGameStatus.gameOver
              ? ResultScreen(
                  result: _createGameResult(gameState),
                  onPlayAgain: gameNotifier.resetGame,
                  onChangeDifficulty: gameNotifier.resetGame,
                  onBack: () {
                    gameNotifier.resetGame();
                    Navigator.of(context).pop();
                  },
                )
              : Column(
                  children: [
                    // ゲーム統計パネル
                    const GameStatsPanel(),

                    // ゲームキャンバス
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: GameCanvas(
                          gameState: gameState,
                          onTapDown: gameNotifier.onTapDown,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  GameResult _createGameResult(ReflexGameState gameState) {
    return GameResult(
      score: gameState.score,
      successCount: gameState.successCount,
      difficulty: gameState.difficulty,
      reactionTimes: gameState.reactionTimes,
      playedAt: DateTime.now(),
    );
  }
}
