import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/models/game_state.dart';
import '../../utils/constants.dart';
import '../providers/game_provider.dart';

class GameInfoPanel extends HookConsumerWidget {
  const GameInfoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final elapsedTime = useState<double?>(null);

    // 経過時間を更新
    useEffect(() {
      Timer? timer;

      if (gameState.status == GameStatus.playing &&
          gameState.trialStartTime != null) {
        timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
          final now = DateTime.now();
          final duration = now.difference(gameState.trialStartTime!);
          elapsedTime.value = duration.inMilliseconds / 1000.0;
        });
      } else {
        elapsedTime.value = null;
      }

      return () => timer?.cancel();
    }, [gameState.status, gameState.trialStartTime]);

    if (gameState.status == GameStatus.idle) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // トライアル進行状況
          Text(
            'Trial ${gameState.currentTrial}/${GameConstants.totalTrials}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          // 現在の経過時間（常に高さを確保）
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              height: 19, // fontSize 16の行高
              child: elapsedTime.value != null
                  ? Text(
                      'Time: ${elapsedTime.value!.toStringAsFixed(3)}s',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          // 前回の結果（常に高さを確保）
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              height: 17, // fontSize 14の行高
              child: gameState.results.isNotEmpty
                  ? Text(
                      'Last: ${gameState.results.last.timeInSeconds.toStringAsFixed(3)}s',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
