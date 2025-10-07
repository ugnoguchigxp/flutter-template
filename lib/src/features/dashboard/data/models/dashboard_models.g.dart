// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RevenuePointImpl _$$RevenuePointImplFromJson(Map<String, dynamic> json) =>
    _$RevenuePointImpl(
      date: DateTime.parse(json['date'] as String),
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$$RevenuePointImplToJson(_$RevenuePointImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'revenue': instance.revenue,
    };

_$PipelineStageImpl _$$PipelineStageImplFromJson(Map<String, dynamic> json) =>
    _$PipelineStageImpl(
      stage: json['stage'] as String,
      leads: (json['leads'] as num).toInt(),
      conversionRate: (json['conversionRate'] as num).toDouble(),
    );

Map<String, dynamic> _$$PipelineStageImplToJson(_$PipelineStageImpl instance) =>
    <String, dynamic>{
      'stage': instance.stage,
      'leads': instance.leads,
      'conversionRate': instance.conversionRate,
    };

_$KpiMetricImpl _$$KpiMetricImplFromJson(Map<String, dynamic> json) =>
    _$KpiMetricImpl(
      label: json['label'] as String,
      value: json['value'] as String,
      trend: json['trend'] as String?,
      delta: (json['delta'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$KpiMetricImplToJson(_$KpiMetricImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'trend': instance.trend,
      'delta': instance.delta,
    };
