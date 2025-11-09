import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/models/difficulty.dart';
import '../domain/models/game_state.dart';
import '../domain/models/position.dart';
import 'providers/game_provider.dart';
import 'widgets/game_canvas.dart';
import 'widgets/game_info_panel.dart';
import 'widgets/game_start_screen.dart';
import 'widgets/result_screen.dart';

class DragSpeedGameScreen extends ConsumerStatefulWidget {
  const DragSpeedGameScreen({super.key});

  @override
  ConsumerState<DragSpeedGameScreen> createState() =>
      _DragSpeedGameScreenState();
}

class _DragSpeedGameScreenState extends ConsumerState<DragSpeedGameScreen> {
  @override
  void dispose() {
    // ゲーム一覧に戻る時にゲームをリセット
    ref.read(gameProvider.notifier).resetGame();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Drag Speed Game'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: gameState.status == GameStatus.idle
            ? LayoutBuilder(
                builder: (context, constraints) {
                  return GameStartScreen(
                    onStart: (difficulty) {
                      // ゲーム開始（キャンバスサイズと難易度を渡す）
                      final size = Size(
                        constraints.maxWidth - 32,
                        constraints.maxWidth - 32,
                      );
                      gameNotifier.startGame(size, difficulty);
                    },
                  );
                },
              )
            : gameState.status == GameStatus.gameComplete
            ? ResultScreen(
                results: gameState.results,
                onPlayAgain: gameNotifier.resetGame,
                onBack: gameNotifier.resetGame,
              )
            : Column(
                children: [
                  // ゲーム情報パネル
                  const GameInfoPanel(),

                  // ゲームキャンバス
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return AspectRatio(
                            aspectRatio: 1.0,
                            child: GameCanvas(
                              gameState: gameState,
                              onDragUpdate: (offset) {
                                final newPos = Position(
                                  x: offset.dx,
                                  y: offset.dy,
                                );
                                gameNotifier.updatePlayerPosition(newPos);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
