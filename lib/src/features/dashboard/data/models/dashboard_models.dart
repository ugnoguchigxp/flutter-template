import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_models.freezed.dart';
part 'dashboard_models.g.dart';

@freezed
class RevenuePoint with _$RevenuePoint {
  const factory RevenuePoint({
    required DateTime date,
    required double revenue,
  }) = _RevenuePoint;

  factory RevenuePoint.fromJson(Map<String, dynamic> json) =>
      _$RevenuePointFromJson(json);
}

@freezed
class PipelineStage with _$PipelineStage {
  const factory PipelineStage({
    required String stage,
    required int leads,
    required double conversionRate,
  }) = _PipelineStage;

  factory PipelineStage.fromJson(Map<String, dynamic> json) =>
      _$PipelineStageFromJson(json);
}

@freezed
class KpiMetric with _$KpiMetric {
  const factory KpiMetric({
    required String label,
    required String value,
    String? trend,
    double? delta,
  }) = _KpiMetric;

  factory KpiMetric.fromJson(Map<String, dynamic> json) =>
      _$KpiMetricFromJson(json);
}
