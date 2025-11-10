import 'package:freezed_annotation/freezed_annotation.dart';
import 'position.dart';

part 'trial_result.freezed.dart';

@freezed
class TrialResult with _$TrialResult {
  const factory TrialResult({
    required int trialNumber,
    required double timeInSeconds,
    required Position startPos,
    required Position targetPos,
    required double traveledDistance, // 実際の移動距離
    required double optimalDistance, // 最短距離（直線距離）
    required double efficiencyScore, // 効率スコア（100点満点）
  }) = _TrialResult;

  const TrialResult._();

  /// 効率率（0.0〜1.0、1.0が最高効率）
  double get efficiency => optimalDistance / traveledDistance;

  /// 無駄な移動距離
  double get wastedDistance => traveledDistance - optimalDistance;
}
