import 'package:flutter/material.dart';

import 'package:flutter_template/src/features/reflex_test/domain/models/difficulty.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({
    required this.onStart,
    super.key,
  });

  final void Function(ReflexDifficulty) onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reflex Test'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // ゲームタイトルと説明
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.speed,
                      size: 48,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Reflex Test',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '落ちてくる棒をタップして反応速度を測定！',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '15秒間でできるだけ多くの棒をタップしよう',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 難易度選択ボタン
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildDifficultyButton(
                      context,
                      ReflexDifficulty.easy,
                      'イージー',
                      'ゆっくり落下',
                      '初心者向け',
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildDifficultyButton(
                      context,
                      ReflexDifficulty.normal,
                      'ノーマル',
                      '標準速度',
                      'バランス型',
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildDifficultyButton(
                      context,
                      ReflexDifficulty.hard,
                      'ハード',
                      '高速落下',
                      '上級者向け',
                      Colors.red,
                    ),
                  ],
                ),
              ),

              // ルール説明
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Text(
                      'ゲームルール',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• 画面上部から棒が落ちてきます\n'
                      '• 棒をタップして得点を獲得\n'
                      '• 早くタップするほど高得点\n'
                      '• 時間経過で出現頻度が増加\n'
                      '• 15秒間でハイスコアを目指そう',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(
    BuildContext context,
    ReflexDifficulty difficulty,
    String title,
    String description,
    String target,
    Color color,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        onPressed: () => onStart(difficulty),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Row(
          children: [
            // アイコン
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getDifficultyIcon(difficulty),
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // テキスト
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // ターゲット
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                target,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDifficultyIcon(ReflexDifficulty difficulty) {
    switch (difficulty) {
      case ReflexDifficulty.easy:
        return Icons.trending_down;
      case ReflexDifficulty.normal:
        return Icons.trending_flat;
      case ReflexDifficulty.hard:
        return Icons.trending_up;
    }
  }
}
