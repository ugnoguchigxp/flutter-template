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
  }) = _TrialResult;
}
