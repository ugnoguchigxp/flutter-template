import 'package:flutter/material.dart';

import '../../domain/models/trial_result.dart';
import '../../utils/constants.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    required this.results,
    required this.onPlayAgain,
    required this.onBack,
    super.key,
  });

  final List<TrialResult> results;
  final VoidCallback onPlayAgain;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // タイトル
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                const Text(
                  '🎮 ゲーム終了！',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${GameConstants.totalTrials} トライアル完了',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 各トライアルの結果
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '各トライアルの結果:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(right: 12),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final result = results[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Trial ${result.trialNumber.toString().padLeft(2, '0')}:',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  '${result.timeInSeconds.toStringAsFixed(3)}s',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 統計情報
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '統計:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildStatRow('平均タイム:', _calculateAverageTime()),
                _buildStatRow('最速タイム:', _calculateBestTime()),
                _buildStatRow('最遅タイム:', _calculateWorstTime()),
                _buildStatRow('合計タイム:', _calculateTotalTime()),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ボタン
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onPlayAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'もう一度プレイ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '戻る',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateAverageTime() {
    if (results.isEmpty) return '0.000s';
    final sum = results.fold<double>(0.0, (sum, r) => sum + r.timeInSeconds);
    return '${(sum / results.length).toStringAsFixed(3)}s';
  }

  String _calculateBestTime() {
    if (results.isEmpty) return '0.000s';
    final best = results.map((r) => r.timeInSeconds).reduce((a, b) => a < b ? a : b);
    final bestTrial = results.firstWhere((r) => r.timeInSeconds == best);
    return '${best.toStringAsFixed(3)}s (Trial ${bestTrial.trialNumber})';
  }

  String _calculateWorstTime() {
    if (results.isEmpty) return '0.000s';
    final worst = results.map((r) => r.timeInSeconds).reduce((a, b) => a > b ? a : b);
    final worstTrial = results.firstWhere((r) => r.timeInSeconds == worst);
    return '${worst.toStringAsFixed(3)}s (Trial ${worstTrial.trialNumber})';
  }

  String _calculateTotalTime() {
    if (results.isEmpty) return '0.000s';
    final total = results.fold<double>(0.0, (sum, r) => sum + r.timeInSeconds);
    return '${total.toStringAsFixed(3)}s';
  }
}
