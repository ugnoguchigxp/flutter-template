// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reflex_game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReflexGameState {
  ReflexGameStatus get status => throw _privateConstructorUsedError;
  List<FallingBar> get bars => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  int get successCount => throw _privateConstructorUsedError;
  double get remainingTime => throw _privateConstructorUsedError;
  ReflexDifficulty get difficulty => throw _privateConstructorUsedError;
  List<double> get reactionTimes => throw _privateConstructorUsedError;
  DateTime? get gameStartTime => throw _privateConstructorUsedError;
  DateTime? get lastFrameTime => throw _privateConstructorUsedError;

  /// Create a copy of ReflexGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReflexGameStateCopyWith<ReflexGameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReflexGameStateCopyWith<$Res> {
  factory $ReflexGameStateCopyWith(
    ReflexGameState value,
    $Res Function(ReflexGameState) then,
  ) = _$ReflexGameStateCopyWithImpl<$Res, ReflexGameState>;
  @useResult
  $Res call({
    ReflexGameStatus status,
    List<FallingBar> bars,
    int score,
    int successCount,
    double remainingTime,
    ReflexDifficulty difficulty,
    List<double> reactionTimes,
    DateTime? gameStartTime,
    DateTime? lastFrameTime,
  });
}

/// @nodoc
class _$ReflexGameStateCopyWithImpl<$Res, $Val extends ReflexGameState>
    implements $ReflexGameStateCopyWith<$Res> {
  _$ReflexGameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReflexGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? bars = null,
    Object? score = null,
    Object? successCount = null,
    Object? remainingTime = null,
    Object? difficulty = null,
    Object? reactionTimes = null,
    Object? gameStartTime = freezed,
    Object? lastFrameTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ReflexGameStatus,
            bars: null == bars
                ? _value.bars
                : bars // ignore: cast_nullable_to_non_nullable
                      as List<FallingBar>,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            successCount: null == successCount
                ? _value.successCount
                : successCount // ignore: cast_nullable_to_non_nullable
                      as int,
            remainingTime: null == remainingTime
                ? _value.remainingTime
                : remainingTime // ignore: cast_nullable_to_non_nullable
                      as double,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as ReflexDifficulty,
            reactionTimes: null == reactionTimes
                ? _value.reactionTimes
                : reactionTimes // ignore: cast_nullable_to_non_nullable
                      as List<double>,
            gameStartTime: freezed == gameStartTime
                ? _value.gameStartTime
                : gameStartTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastFrameTime: freezed == lastFrameTime
                ? _value.lastFrameTime
                : lastFrameTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReflexGameStateImplCopyWith<$Res>
    implements $ReflexGameStateCopyWith<$Res> {
  factory _$$ReflexGameStateImplCopyWith(
    _$ReflexGameStateImpl value,
    $Res Function(_$ReflexGameStateImpl) then,
  ) = __$$ReflexGameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ReflexGameStatus status,
    List<FallingBar> bars,
    int score,
    int successCount,
    double remainingTime,
    ReflexDifficulty difficulty,
    List<double> reactionTimes,
    DateTime? gameStartTime,
    DateTime? lastFrameTime,
  });
}

/// @nodoc
class __$$ReflexGameStateImplCopyWithImpl<$Res>
    extends _$ReflexGameStateCopyWithImpl<$Res, _$ReflexGameStateImpl>
    implements _$$ReflexGameStateImplCopyWith<$Res> {
  __$$ReflexGameStateImplCopyWithImpl(
    _$ReflexGameStateImpl _value,
    $Res Function(_$ReflexGameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReflexGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? bars = null,
    Object? score = null,
    Object? successCount = null,
    Object? remainingTime = null,
    Object? difficulty = null,
    Object? reactionTimes = null,
    Object? gameStartTime = freezed,
    Object? lastFrameTime = freezed,
  }) {
    return _then(
      _$ReflexGameStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ReflexGameStatus,
        bars: null == bars
            ? _value._bars
            : bars // ignore: cast_nullable_to_non_nullable
                  as List<FallingBar>,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        successCount: null == successCount
            ? _value.successCount
            : successCount // ignore: cast_nullable_to_non_nullable
                  as int,
        remainingTime: null == remainingTime
            ? _value.remainingTime
            : remainingTime // ignore: cast_nullable_to_non_nullable
                  as double,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as ReflexDifficulty,
        reactionTimes: null == reactionTimes
            ? _value._reactionTimes
            : reactionTimes // ignore: cast_nullable_to_non_nullable
                  as List<double>,
        gameStartTime: freezed == gameStartTime
            ? _value.gameStartTime
            : gameStartTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastFrameTime: freezed == lastFrameTime
            ? _value.lastFrameTime
            : lastFrameTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$ReflexGameStateImpl extends _ReflexGameState {
  const _$ReflexGameStateImpl({
    this.status = ReflexGameStatus.idle,
    final List<FallingBar> bars = const [],
    this.score = 0,
    this.successCount = 0,
    this.remainingTime = 15.0,
    this.difficulty = ReflexDifficulty.normal,
    final List<double> reactionTimes = const [],
    this.gameStartTime,
    this.lastFrameTime,
  }) : _bars = bars,
       _reactionTimes = reactionTimes,
       super._();

  @override
  @JsonKey()
  final ReflexGameStatus status;
  final List<FallingBar> _bars;
  @override
  @JsonKey()
  List<FallingBar> get bars {
    if (_bars is EqualUnmodifiableListView) return _bars;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bars);
  }

  @override
  @JsonKey()
  final int score;
  @override
  @JsonKey()
  final int successCount;
  @override
  @JsonKey()
  final double remainingTime;
  @override
  @JsonKey()
  final ReflexDifficulty difficulty;
  final List<double> _reactionTimes;
  @override
  @JsonKey()
  List<double> get reactionTimes {
    if (_reactionTimes is EqualUnmodifiableListView) return _reactionTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reactionTimes);
  }

  @override
  final DateTime? gameStartTime;
  @override
  final DateTime? lastFrameTime;

  @override
  String toString() {
    return 'ReflexGameState(status: $status, bars: $bars, score: $score, successCount: $successCount, remainingTime: $remainingTime, difficulty: $difficulty, reactionTimes: $reactionTimes, gameStartTime: $gameStartTime, lastFrameTime: $lastFrameTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReflexGameStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._bars, _bars) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.successCount, successCount) ||
                other.successCount == successCount) &&
            (identical(other.remainingTime, remainingTime) ||
                other.remainingTime == remainingTime) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality().equals(
              other._reactionTimes,
              _reactionTimes,
            ) &&
            (identical(other.gameStartTime, gameStartTime) ||
                other.gameStartTime == gameStartTime) &&
            (identical(other.lastFrameTime, lastFrameTime) ||
                other.lastFrameTime == lastFrameTime));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    const DeepCollectionEquality().hash(_bars),
    score,
    successCount,
    remainingTime,
    difficulty,
    const DeepCollectionEquality().hash(_reactionTimes),
    gameStartTime,
    lastFrameTime,
  );

  /// Create a copy of ReflexGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReflexGameStateImplCopyWith<_$ReflexGameStateImpl> get copyWith =>
      __$$ReflexGameStateImplCopyWithImpl<_$ReflexGameStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ReflexGameState extends ReflexGameState {
  const factory _ReflexGameState({
    final ReflexGameStatus status,
    final List<FallingBar> bars,
    final int score,
    final int successCount,
    final double remainingTime,
    final ReflexDifficulty difficulty,
    final List<double> reactionTimes,
    final DateTime? gameStartTime,
    final DateTime? lastFrameTime,
  }) = _$ReflexGameStateImpl;
  const _ReflexGameState._() : super._();

  @override
  ReflexGameStatus get status;
  @override
  List<FallingBar> get bars;
  @override
  int get score;
  @override
  int get successCount;
  @override
  double get remainingTime;
  @override
  ReflexDifficulty get difficulty;
  @override
  List<double> get reactionTimes;
  @override
  DateTime? get gameStartTime;
  @override
  DateTime? get lastFrameTime;

  /// Create a copy of ReflexGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReflexGameStateImplCopyWith<_$ReflexGameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
