import 'package:flutter/material.dart';

import 'package:flutter_template/src/features/reflex_test/domain/models/game_result.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    required this.result,
    required this.onPlayAgain,
    required this.onChangeDifficulty,
    required this.onBack,
    super.key,
  });

  final GameResult result;
  final VoidCallback onPlayAgain;
  final VoidCallback onChangeDifficulty;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ゲーム結果'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // スコアと評価を横並び
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    // スコア
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            '最終スコア',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${result.score}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 評価
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: _getGradeColor(),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                result.performanceGrade,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getGradeMessage(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 詳細統計
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '詳細統計',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildStatRow('成功数', '${result.successCount} 回'),
                      _buildStatRow('難易度', result.difficulty.label),
                      _buildStatRow(
                        '平均反応速度',
                        '${result.averageReactionTime.toStringAsFixed(0)} ms',
                      ),
                      _buildStatRow(
                        '最速反応速度',
                        '${result.bestReactionTime?.toStringAsFixed(0) ?? '-'} ms',
                      ),
                      _buildStatRow(
                        '最遅反応速度',
                        '${result.worstReactionTime?.toStringAsFixed(0) ?? '-'} ms',
                      ),
                      _buildStatRow(
                        '成功率',
                        '${(result.successRate * 100).toStringAsFixed(1)} %',
                      ),

                      const SizedBox(height: 12),

                      // 反応時間リスト
                      if (result.reactionTimes.isNotEmpty) ...[
                        const Text(
                          '各回の反応時間',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: ListView.builder(
                              itemCount: result.reactionTimes.length,
                              itemBuilder: (context, index) {
                                final time = result.reactionTimes[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 1,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${index + 1}回目',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '${time.toStringAsFixed(0)} ms',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _getTimeColor(time),
                                          fontWeight: FontWeight.w500,
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
                    ],
                  ),
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
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onChangeDifficulty,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '難易度変更',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor() {
    switch (result.performanceGrade) {
      case 'S':
        return Colors.purple;
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getGradeMessage() {
    switch (result.performanceGrade) {
      case 'S':
        return '素晴らしい！';
      case 'A':
        return 'とても良い！';
      case 'B':
        return '良い成績！';
      case 'C':
        return '頑張りました！';
      default:
        return '練習あるのみ！';
    }
  }

  Color _getTimeColor(double time) {
    if (time <= 500) return Colors.green;
    if (time <= 1000) return Colors.blue;
    if (time <= 1500) return Colors.orange;
    return Colors.red;
  }
}
