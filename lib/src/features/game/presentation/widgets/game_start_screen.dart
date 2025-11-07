import 'package:flutter/material.dart';

import '../../domain/models/difficulty.dart';

class GameStartScreen extends StatelessWidget {
  const GameStartScreen({
    required this.onStart,
    super.key,
  });

  final ValueChanged<Difficulty> onStart;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // タイトル
            const Text(
              'Drag Speed Game',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ターゲットまで素早くドラッグしよう！',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 48),

            // 難易度選択
            const Text(
              '難易度を選択',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // 難易度ボタン
            ...Difficulty.values.map((difficulty) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _DifficultyButton(
                  difficulty: difficulty,
                  onPressed: () => onStart(difficulty),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({
    required this.difficulty,
    required this.onPressed,
  });

  final Difficulty difficulty;
  final VoidCallback onPressed;

  Color get _color {
    switch (difficulty) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.normal:
        return Colors.blue;
      case Difficulty.hard:
        return Colors.red;
    }
  }

  IconData get _icon {
    switch (difficulty) {
      case Difficulty.easy:
        return Icons.sentiment_satisfied;
      case Difficulty.normal:
        return Icons.sentiment_neutral;
      case Difficulty.hard:
        return Icons.whatshot;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_icon, size: 28),
                const SizedBox(width: 12),
                Text(
                  difficulty.label,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              difficulty.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
