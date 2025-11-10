// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trial_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TrialResult {
  int get trialNumber => throw _privateConstructorUsedError;
  double get timeInSeconds => throw _privateConstructorUsedError;
  Position get startPos => throw _privateConstructorUsedError;
  Position get targetPos => throw _privateConstructorUsedError;
  double get traveledDistance => throw _privateConstructorUsedError; // 実際の移動距離
  double get optimalDistance =>
      throw _privateConstructorUsedError; // 最短距離（直線距離）
  double get efficiencyScore => throw _privateConstructorUsedError;

  /// Create a copy of TrialResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrialResultCopyWith<TrialResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrialResultCopyWith<$Res> {
  factory $TrialResultCopyWith(
    TrialResult value,
    $Res Function(TrialResult) then,
  ) = _$TrialResultCopyWithImpl<$Res, TrialResult>;
  @useResult
  $Res call({
    int trialNumber,
    double timeInSeconds,
    Position startPos,
    Position targetPos,
    double traveledDistance,
    double optimalDistance,
    double efficiencyScore,
  });

  $PositionCopyWith<$Res> get startPos;
  $PositionCopyWith<$Res> get targetPos;
}

/// @nodoc
class _$TrialResultCopyWithImpl<$Res, $Val extends TrialResult>
    implements $TrialResultCopyWith<$Res> {
  _$TrialResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrialResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trialNumber = null,
    Object? timeInSeconds = null,
    Object? startPos = null,
    Object? targetPos = null,
    Object? traveledDistance = null,
    Object? optimalDistance = null,
    Object? efficiencyScore = null,
  }) {
    return _then(
      _value.copyWith(
            trialNumber: null == trialNumber
                ? _value.trialNumber
                : trialNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            timeInSeconds: null == timeInSeconds
                ? _value.timeInSeconds
                : timeInSeconds // ignore: cast_nullable_to_non_nullable
                      as double,
            startPos: null == startPos
                ? _value.startPos
                : startPos // ignore: cast_nullable_to_non_nullable
                      as Position,
            targetPos: null == targetPos
                ? _value.targetPos
                : targetPos // ignore: cast_nullable_to_non_nullable
                      as Position,
            traveledDistance: null == traveledDistance
                ? _value.traveledDistance
                : traveledDistance // ignore: cast_nullable_to_non_nullable
                      as double,
            optimalDistance: null == optimalDistance
                ? _value.optimalDistance
                : optimalDistance // ignore: cast_nullable_to_non_nullable
                      as double,
            efficiencyScore: null == efficiencyScore
                ? _value.efficiencyScore
                : efficiencyScore // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }

  /// Create a copy of TrialResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res> get startPos {
    return $PositionCopyWith<$Res>(_value.startPos, (value) {
      return _then(_value.copyWith(startPos: value) as $Val);
    });
  }

  /// Create a copy of TrialResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res> get targetPos {
    return $PositionCopyWith<$Res>(_value.targetPos, (value) {
      return _then(_value.copyWith(targetPos: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TrialResultImplCopyWith<$Res>
    implements $TrialResultCopyWith<$Res> {
  factory _$$TrialResultImplCopyWith(
    _$TrialResultImpl value,
    $Res Function(_$TrialResultImpl) then,
  ) = __$$TrialResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int trialNumber,
    double timeInSeconds,
    Position startPos,
    Position targetPos,
    double traveledDistance,
    double optimalDistance,
    double efficiencyScore,
  });

  @override
  $PositionCopyWith<$Res> get startPos;
  @override
  $PositionCopyWith<$Res> get targetPos;
}

/// @nodoc
class __$$TrialResultImplCopyWithImpl<$Res>
    extends _$TrialResultCopyWithImpl<$Res, _$TrialResultImpl>
    implements _$$TrialResultImplCopyWith<$Res> {
  __$$TrialResultImplCopyWithImpl(
    _$TrialResultImpl _value,
    $Res Function(_$TrialResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrialResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trialNumber = null,
    Object? timeInSeconds = null,
    Object? startPos = null,
    Object? targetPos = null,
    Object? traveledDistance = null,
    Object? optimalDistance = null,
    Object? efficiencyScore = null,
  }) {
    return _then(
      _$TrialResultImpl(
        trialNumber: null == trialNumber
            ? _value.trialNumber
            : trialNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        timeInSeconds: null == timeInSeconds
            ? _value.timeInSeconds
            : timeInSeconds // ignore: cast_nullable_to_non_nullable
                  as double,
        startPos: null == startPos
            ? _value.startPos
            : startPos // ignore: cast_nullable_to_non_nullable
                  as Position,
        targetPos: null == targetPos
            ? _value.targetPos
            : targetPos // ignore: cast_nullable_to_non_nullable
                  as Position,
        traveledDistance: null == traveledDistance
            ? _value.traveledDistance
            : traveledDistance // ignore: cast_nullable_to_non_nullable
                  as double,
        optimalDistance: null == optimalDistance
            ? _value.optimalDistance
            : optimalDistance // ignore: cast_nullable_to_non_nullable
                  as double,
        efficiencyScore: null == efficiencyScore
            ? _value.efficiencyScore
            : efficiencyScore // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$TrialResultImpl extends _TrialResult {
  const _$TrialResultImpl({
    required this.trialNumber,
    required this.timeInSeconds,
    required this.startPos,
    required this.targetPos,
    required this.traveledDistance,
    required this.optimalDistance,
    required this.efficiencyScore,
  }) : super._();

  @override
  final int trialNumber;
  @override
  final double timeInSeconds;
  @override
  final Position startPos;
  @override
  final Position targetPos;
  @override
  final double traveledDistance;
  // 実際の移動距離
  @override
  final double optimalDistance;
  // 最短距離（直線距離）
  @override
  final double efficiencyScore;

  @override
  String toString() {
    return 'TrialResult(trialNumber: $trialNumber, timeInSeconds: $timeInSeconds, startPos: $startPos, targetPos: $targetPos, traveledDistance: $traveledDistance, optimalDistance: $optimalDistance, efficiencyScore: $efficiencyScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrialResultImpl &&
            (identical(other.trialNumber, trialNumber) ||
                other.trialNumber == trialNumber) &&
            (identical(other.timeInSeconds, timeInSeconds) ||
                other.timeInSeconds == timeInSeconds) &&
            (identical(other.startPos, startPos) ||
                other.startPos == startPos) &&
            (identical(other.targetPos, targetPos) ||
                other.targetPos == targetPos) &&
            (identical(other.traveledDistance, traveledDistance) ||
                other.traveledDistance == traveledDistance) &&
            (identical(other.optimalDistance, optimalDistance) ||
                other.optimalDistance == optimalDistance) &&
            (identical(other.efficiencyScore, efficiencyScore) ||
                other.efficiencyScore == efficiencyScore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    trialNumber,
    timeInSeconds,
    startPos,
    targetPos,
    traveledDistance,
    optimalDistance,
    efficiencyScore,
  );

  /// Create a copy of TrialResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrialResultImplCopyWith<_$TrialResultImpl> get copyWith =>
      __$$TrialResultImplCopyWithImpl<_$TrialResultImpl>(this, _$identity);
}

abstract class _TrialResult extends TrialResult {
  const factory _TrialResult({
    required final int trialNumber,
    required final double timeInSeconds,
    required final Position startPos,
    required final Position targetPos,
    required final double traveledDistance,
    required final double optimalDistance,
    required final double efficiencyScore,
  }) = _$TrialResultImpl;
  const _TrialResult._() : super._();

  @override
  int get trialNumber;
  @override
  double get timeInSeconds;
  @override
  Position get startPos;
  @override
  Position get targetPos;
  @override
  double get traveledDistance; // 実際の移動距離
  @override
  double get optimalDistance; // 最短距離（直線距離）
  @override
  double get efficiencyScore;

  /// Create a copy of TrialResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrialResultImplCopyWith<_$TrialResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
