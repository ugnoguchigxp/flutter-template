import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_template/src/features/reflex_test/domain/models/reflex_game_state.dart';
import 'package:flutter_template/src/features/reflex_test/presentation/providers/reflex_game_provider.dart';

class GameStatsPanel extends ConsumerWidget {
  const GameStatsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(reflexGameProvider);

    if (gameState.status == ReflexGameStatus.idle) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minHeight: 120), // 最小高さを設定
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 最小限のサイズを使用
        children: [
          // スコアと残り時間
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // スコア
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'スコア',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${gameState.score}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              
              // 成功数
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '成功数',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${gameState.successCount}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              // 残り時間
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '残り時間',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${gameState.remainingTime.toStringAsFixed(1)}s',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: gameState.remainingTime <= 5 
                          ? Colors.red 
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // 難易度表示
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: gameState.difficulty.buttonColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: gameState.difficulty.buttonColor.withOpacity(0.3),
              ),
            ),
            child: Text(
              '${gameState.difficulty.label} - ${gameState.difficulty.description}',
              style: TextStyle(
                fontSize: 12,
                color: gameState.difficulty.buttonColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
