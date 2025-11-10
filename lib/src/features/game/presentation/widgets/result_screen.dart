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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: const Text(
              '🎮 ゲーム終了',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 各トライアルの結果
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '各トライアルの結果:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(right: 12),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final result = results[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${result.timeInSeconds.toStringAsFixed(3)}s',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'Score: ${result.efficiencyScore.toStringAsFixed(1)}pts',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _getScoreColor(
                                          result.efficiencyScore,
                                        ),
                                      ),
                                    ),
                                  ],
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

          const SizedBox(height: 12),

          // 統計情報
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '統計:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                _buildStatRow('平均タイム:', _calculateAverageTime()),
                _buildStatRow('最速タイム:', _calculateBestTime()),
                _buildStatRow('最遅タイム:', _calculateWorstTime()),
                _buildStatRow('合計タイム:', _calculateTotalTime()),
                const Divider(height: 16),
                _buildStatRow('平均効率スコア:', _calculateAverageEfficiency()),
                _buildStatRow('最高スコア:', _calculateBestScore()),
                _buildStatRow('平均移動距離:', _calculateAverageDistance()),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ボタン
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onPlayAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'もう一度プレイ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '戻る',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
            style: const TextStyle(fontSize: 14, color: Colors.black54),
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
    final best = results
        .map((r) => r.timeInSeconds)
        .reduce((a, b) => a < b ? a : b);
    final bestTrial = results.firstWhere((r) => r.timeInSeconds == best);
    return '${best.toStringAsFixed(3)}s (Trial ${bestTrial.trialNumber})';
  }

  String _calculateWorstTime() {
    if (results.isEmpty) return '0.000s';
    final worst = results
        .map((r) => r.timeInSeconds)
        .reduce((a, b) => a > b ? a : b);
    final worstTrial = results.firstWhere((r) => r.timeInSeconds == worst);
    return '${worst.toStringAsFixed(3)}s (Trial ${worstTrial.trialNumber})';
  }

  String _calculateTotalTime() {
    if (results.isEmpty) return '0.000s';
    final total = results.fold<double>(0.0, (sum, r) => sum + r.timeInSeconds);
    return '${total.toStringAsFixed(3)}s';
  }

  String _calculateAverageEfficiency() {
    if (results.isEmpty) return '0.0pts';
    final sum = results.fold<double>(0.0, (sum, r) => sum + r.efficiencyScore);
    return '${(sum / results.length).toStringAsFixed(1)}pts';
  }

  String _calculateBestScore() {
    if (results.isEmpty) return '0.0pts';
    final best = results
        .map((r) => r.efficiencyScore)
        .reduce((a, b) => a > b ? a : b);
    final bestTrial = results.firstWhere((r) => r.efficiencyScore == best);
    return '${best.toStringAsFixed(1)}pts (Trial ${bestTrial.trialNumber})';
  }

  String _calculateAverageDistance() {
    if (results.isEmpty) return '0.0px';
    final sum = results.fold<double>(0.0, (sum, r) => sum + r.traveledDistance);
    return '${(sum / results.length).toStringAsFixed(1)}px';
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.green.shade700;
    if (score >= 75) return Colors.lightGreen.shade700;
    if (score >= 60) return Colors.orange.shade700;
    return Colors.red.shade700;
  }
}
