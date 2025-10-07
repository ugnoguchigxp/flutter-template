// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RevenuePoint _$RevenuePointFromJson(Map<String, dynamic> json) {
  return _RevenuePoint.fromJson(json);
}

/// @nodoc
mixin _$RevenuePoint {
  DateTime get date => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;

  /// Serializes this RevenuePoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RevenuePoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RevenuePointCopyWith<RevenuePoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevenuePointCopyWith<$Res> {
  factory $RevenuePointCopyWith(
    RevenuePoint value,
    $Res Function(RevenuePoint) then,
  ) = _$RevenuePointCopyWithImpl<$Res, RevenuePoint>;
  @useResult
  $Res call({DateTime date, double revenue});
}

/// @nodoc
class _$RevenuePointCopyWithImpl<$Res, $Val extends RevenuePoint>
    implements $RevenuePointCopyWith<$Res> {
  _$RevenuePointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RevenuePoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? revenue = null}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RevenuePointImplCopyWith<$Res>
    implements $RevenuePointCopyWith<$Res> {
  factory _$$RevenuePointImplCopyWith(
    _$RevenuePointImpl value,
    $Res Function(_$RevenuePointImpl) then,
  ) = __$$RevenuePointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double revenue});
}

/// @nodoc
class __$$RevenuePointImplCopyWithImpl<$Res>
    extends _$RevenuePointCopyWithImpl<$Res, _$RevenuePointImpl>
    implements _$$RevenuePointImplCopyWith<$Res> {
  __$$RevenuePointImplCopyWithImpl(
    _$RevenuePointImpl _value,
    $Res Function(_$RevenuePointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RevenuePoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? revenue = null}) {
    return _then(
      _$RevenuePointImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RevenuePointImpl implements _RevenuePoint {
  const _$RevenuePointImpl({required this.date, required this.revenue});

  factory _$RevenuePointImpl.fromJson(Map<String, dynamic> json) =>
      _$$RevenuePointImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double revenue;

  @override
  String toString() {
    return 'RevenuePoint(date: $date, revenue: $revenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevenuePointImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, revenue);

  /// Create a copy of RevenuePoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RevenuePointImplCopyWith<_$RevenuePointImpl> get copyWith =>
      __$$RevenuePointImplCopyWithImpl<_$RevenuePointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RevenuePointImplToJson(this);
  }
}

abstract class _RevenuePoint implements RevenuePoint {
  const factory _RevenuePoint({
    required final DateTime date,
    required final double revenue,
  }) = _$RevenuePointImpl;

  factory _RevenuePoint.fromJson(Map<String, dynamic> json) =
      _$RevenuePointImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get revenue;

  /// Create a copy of RevenuePoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RevenuePointImplCopyWith<_$RevenuePointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PipelineStage _$PipelineStageFromJson(Map<String, dynamic> json) {
  return _PipelineStage.fromJson(json);
}

/// @nodoc
mixin _$PipelineStage {
  String get stage => throw _privateConstructorUsedError;
  int get leads => throw _privateConstructorUsedError;
  double get conversionRate => throw _privateConstructorUsedError;

  /// Serializes this PipelineStage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PipelineStage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PipelineStageCopyWith<PipelineStage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PipelineStageCopyWith<$Res> {
  factory $PipelineStageCopyWith(
    PipelineStage value,
    $Res Function(PipelineStage) then,
  ) = _$PipelineStageCopyWithImpl<$Res, PipelineStage>;
  @useResult
  $Res call({String stage, int leads, double conversionRate});
}

/// @nodoc
class _$PipelineStageCopyWithImpl<$Res, $Val extends PipelineStage>
    implements $PipelineStageCopyWith<$Res> {
  _$PipelineStageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PipelineStage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stage = null,
    Object? leads = null,
    Object? conversionRate = null,
  }) {
    return _then(
      _value.copyWith(
            stage: null == stage
                ? _value.stage
                : stage // ignore: cast_nullable_to_non_nullable
                      as String,
            leads: null == leads
                ? _value.leads
                : leads // ignore: cast_nullable_to_non_nullable
                      as int,
            conversionRate: null == conversionRate
                ? _value.conversionRate
                : conversionRate // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PipelineStageImplCopyWith<$Res>
    implements $PipelineStageCopyWith<$Res> {
  factory _$$PipelineStageImplCopyWith(
    _$PipelineStageImpl value,
    $Res Function(_$PipelineStageImpl) then,
  ) = __$$PipelineStageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String stage, int leads, double conversionRate});
}

/// @nodoc
class __$$PipelineStageImplCopyWithImpl<$Res>
    extends _$PipelineStageCopyWithImpl<$Res, _$PipelineStageImpl>
    implements _$$PipelineStageImplCopyWith<$Res> {
  __$$PipelineStageImplCopyWithImpl(
    _$PipelineStageImpl _value,
    $Res Function(_$PipelineStageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PipelineStage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stage = null,
    Object? leads = null,
    Object? conversionRate = null,
  }) {
    return _then(
      _$PipelineStageImpl(
        stage: null == stage
            ? _value.stage
            : stage // ignore: cast_nullable_to_non_nullable
                  as String,
        leads: null == leads
            ? _value.leads
            : leads // ignore: cast_nullable_to_non_nullable
                  as int,
        conversionRate: null == conversionRate
            ? _value.conversionRate
            : conversionRate // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PipelineStageImpl implements _PipelineStage {
  const _$PipelineStageImpl({
    required this.stage,
    required this.leads,
    required this.conversionRate,
  });

  factory _$PipelineStageImpl.fromJson(Map<String, dynamic> json) =>
      _$$PipelineStageImplFromJson(json);

  @override
  final String stage;
  @override
  final int leads;
  @override
  final double conversionRate;

  @override
  String toString() {
    return 'PipelineStage(stage: $stage, leads: $leads, conversionRate: $conversionRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PipelineStageImpl &&
            (identical(other.stage, stage) || other.stage == stage) &&
            (identical(other.leads, leads) || other.leads == leads) &&
            (identical(other.conversionRate, conversionRate) ||
                other.conversionRate == conversionRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, stage, leads, conversionRate);

  /// Create a copy of PipelineStage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PipelineStageImplCopyWith<_$PipelineStageImpl> get copyWith =>
      __$$PipelineStageImplCopyWithImpl<_$PipelineStageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PipelineStageImplToJson(this);
  }
}

abstract class _PipelineStage implements PipelineStage {
  const factory _PipelineStage({
    required final String stage,
    required final int leads,
    required final double conversionRate,
  }) = _$PipelineStageImpl;

  factory _PipelineStage.fromJson(Map<String, dynamic> json) =
      _$PipelineStageImpl.fromJson;

  @override
  String get stage;
  @override
  int get leads;
  @override
  double get conversionRate;

  /// Create a copy of PipelineStage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PipelineStageImplCopyWith<_$PipelineStageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KpiMetric _$KpiMetricFromJson(Map<String, dynamic> json) {
  return _KpiMetric.fromJson(json);
}

/// @nodoc
mixin _$KpiMetric {
  String get label => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String? get trend => throw _privateConstructorUsedError;
  double? get delta => throw _privateConstructorUsedError;

  /// Serializes this KpiMetric to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KpiMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KpiMetricCopyWith<KpiMetric> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KpiMetricCopyWith<$Res> {
  factory $KpiMetricCopyWith(KpiMetric value, $Res Function(KpiMetric) then) =
      _$KpiMetricCopyWithImpl<$Res, KpiMetric>;
  @useResult
  $Res call({String label, String value, String? trend, double? delta});
}

/// @nodoc
class _$KpiMetricCopyWithImpl<$Res, $Val extends KpiMetric>
    implements $KpiMetricCopyWith<$Res> {
  _$KpiMetricCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KpiMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? trend = freezed,
    Object? delta = freezed,
  }) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
            trend: freezed == trend
                ? _value.trend
                : trend // ignore: cast_nullable_to_non_nullable
                      as String?,
            delta: freezed == delta
                ? _value.delta
                : delta // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KpiMetricImplCopyWith<$Res>
    implements $KpiMetricCopyWith<$Res> {
  factory _$$KpiMetricImplCopyWith(
    _$KpiMetricImpl value,
    $Res Function(_$KpiMetricImpl) then,
  ) = __$$KpiMetricImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, String value, String? trend, double? delta});
}

/// @nodoc
class __$$KpiMetricImplCopyWithImpl<$Res>
    extends _$KpiMetricCopyWithImpl<$Res, _$KpiMetricImpl>
    implements _$$KpiMetricImplCopyWith<$Res> {
  __$$KpiMetricImplCopyWithImpl(
    _$KpiMetricImpl _value,
    $Res Function(_$KpiMetricImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KpiMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? trend = freezed,
    Object? delta = freezed,
  }) {
    return _then(
      _$KpiMetricImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
        trend: freezed == trend
            ? _value.trend
            : trend // ignore: cast_nullable_to_non_nullable
                  as String?,
        delta: freezed == delta
            ? _value.delta
            : delta // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KpiMetricImpl implements _KpiMetric {
  const _$KpiMetricImpl({
    required this.label,
    required this.value,
    this.trend,
    this.delta,
  });

  factory _$KpiMetricImpl.fromJson(Map<String, dynamic> json) =>
      _$$KpiMetricImplFromJson(json);

  @override
  final String label;
  @override
  final String value;
  @override
  final String? trend;
  @override
  final double? delta;

  @override
  String toString() {
    return 'KpiMetric(label: $label, value: $value, trend: $trend, delta: $delta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KpiMetricImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.trend, trend) || other.trend == trend) &&
            (identical(other.delta, delta) || other.delta == delta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, value, trend, delta);

  /// Create a copy of KpiMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KpiMetricImplCopyWith<_$KpiMetricImpl> get copyWith =>
      __$$KpiMetricImplCopyWithImpl<_$KpiMetricImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KpiMetricImplToJson(this);
  }
}

abstract class _KpiMetric implements KpiMetric {
  const factory _KpiMetric({
    required final String label,
    required final String value,
    final String? trend,
    final double? delta,
  }) = _$KpiMetricImpl;

  factory _KpiMetric.fromJson(Map<String, dynamic> json) =
      _$KpiMetricImpl.fromJson;

  @override
  String get label;
  @override
  String get value;
  @override
  String? get trend;
  @override
  double? get delta;

  /// Create a copy of KpiMetric
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KpiMetricImplCopyWith<_$KpiMetricImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
