// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameState {
  GameStatus get status => throw _privateConstructorUsedError;
  Difficulty get difficulty => throw _privateConstructorUsedError;
  int get currentTrial => throw _privateConstructorUsedError;
  List<TrialResult> get results => throw _privateConstructorUsedError;
  Position? get targetPos => throw _privateConstructorUsedError;
  Position? get playerPos => throw _privateConstructorUsedError;
  Position? get prevTargetPos => throw _privateConstructorUsedError;
  DateTime? get trialStartTime => throw _privateConstructorUsedError;
  List<Position> get currentPath =>
      throw _privateConstructorUsedError; // 現在のトライアルの移動経路
  double get currentTraveledDistance => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({
    GameStatus status,
    Difficulty difficulty,
    int currentTrial,
    List<TrialResult> results,
    Position? targetPos,
    Position? playerPos,
    Position? prevTargetPos,
    DateTime? trialStartTime,
    List<Position> currentPath,
    double currentTraveledDistance,
  });

  $PositionCopyWith<$Res>? get targetPos;
  $PositionCopyWith<$Res>? get playerPos;
  $PositionCopyWith<$Res>? get prevTargetPos;
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? difficulty = null,
    Object? currentTrial = null,
    Object? results = null,
    Object? targetPos = freezed,
    Object? playerPos = freezed,
    Object? prevTargetPos = freezed,
    Object? trialStartTime = freezed,
    Object? currentPath = null,
    Object? currentTraveledDistance = null,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as GameStatus,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as Difficulty,
            currentTrial: null == currentTrial
                ? _value.currentTrial
                : currentTrial // ignore: cast_nullable_to_non_nullable
                      as int,
            results: null == results
                ? _value.results
                : results // ignore: cast_nullable_to_non_nullable
                      as List<TrialResult>,
            targetPos: freezed == targetPos
                ? _value.targetPos
                : targetPos // ignore: cast_nullable_to_non_nullable
                      as Position?,
            playerPos: freezed == playerPos
                ? _value.playerPos
                : playerPos // ignore: cast_nullable_to_non_nullable
                      as Position?,
            prevTargetPos: freezed == prevTargetPos
                ? _value.prevTargetPos
                : prevTargetPos // ignore: cast_nullable_to_non_nullable
                      as Position?,
            trialStartTime: freezed == trialStartTime
                ? _value.trialStartTime
                : trialStartTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            currentPath: null == currentPath
                ? _value.currentPath
                : currentPath // ignore: cast_nullable_to_non_nullable
                      as List<Position>,
            currentTraveledDistance: null == currentTraveledDistance
                ? _value.currentTraveledDistance
                : currentTraveledDistance // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res>? get targetPos {
    if (_value.targetPos == null) {
      return null;
    }

    return $PositionCopyWith<$Res>(_value.targetPos!, (value) {
      return _then(_value.copyWith(targetPos: value) as $Val);
    });
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res>? get playerPos {
    if (_value.playerPos == null) {
      return null;
    }

    return $PositionCopyWith<$Res>(_value.playerPos!, (value) {
      return _then(_value.copyWith(playerPos: value) as $Val);
    });
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res>? get prevTargetPos {
    if (_value.prevTargetPos == null) {
      return null;
    }

    return $PositionCopyWith<$Res>(_value.prevTargetPos!, (value) {
      return _then(_value.copyWith(prevTargetPos: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
    _$GameStateImpl value,
    $Res Function(_$GameStateImpl) then,
  ) = __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    GameStatus status,
    Difficulty difficulty,
    int currentTrial,
    List<TrialResult> results,
    Position? targetPos,
    Position? playerPos,
    Position? prevTargetPos,
    DateTime? trialStartTime,
    List<Position> currentPath,
    double currentTraveledDistance,
  });

  @override
  $PositionCopyWith<$Res>? get targetPos;
  @override
  $PositionCopyWith<$Res>? get playerPos;
  @override
  $PositionCopyWith<$Res>? get prevTargetPos;
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
    _$GameStateImpl _value,
    $Res Function(_$GameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? difficulty = null,
    Object? currentTrial = null,
    Object? results = null,
    Object? targetPos = freezed,
    Object? playerPos = freezed,
    Object? prevTargetPos = freezed,
    Object? trialStartTime = freezed,
    Object? currentPath = null,
    Object? currentTraveledDistance = null,
  }) {
    return _then(
      _$GameStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as GameStatus,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as Difficulty,
        currentTrial: null == currentTrial
            ? _value.currentTrial
            : currentTrial // ignore: cast_nullable_to_non_nullable
                  as int,
        results: null == results
            ? _value._results
            : results // ignore: cast_nullable_to_non_nullable
                  as List<TrialResult>,
        targetPos: freezed == targetPos
            ? _value.targetPos
            : targetPos // ignore: cast_nullable_to_non_nullable
                  as Position?,
        playerPos: freezed == playerPos
            ? _value.playerPos
            : playerPos // ignore: cast_nullable_to_non_nullable
                  as Position?,
        prevTargetPos: freezed == prevTargetPos
            ? _value.prevTargetPos
            : prevTargetPos // ignore: cast_nullable_to_non_nullable
                  as Position?,
        trialStartTime: freezed == trialStartTime
            ? _value.trialStartTime
            : trialStartTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        currentPath: null == currentPath
            ? _value._currentPath
            : currentPath // ignore: cast_nullable_to_non_nullable
                  as List<Position>,
        currentTraveledDistance: null == currentTraveledDistance
            ? _value.currentTraveledDistance
            : currentTraveledDistance // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$GameStateImpl extends _GameState {
  const _$GameStateImpl({
    this.status = GameStatus.idle,
    this.difficulty = Difficulty.normal,
    this.currentTrial = 1,
    final List<TrialResult> results = const [],
    this.targetPos,
    this.playerPos,
    this.prevTargetPos,
    this.trialStartTime,
    final List<Position> currentPath = const [],
    this.currentTraveledDistance = 0.0,
  }) : _results = results,
       _currentPath = currentPath,
       super._();

  @override
  @JsonKey()
  final GameStatus status;
  @override
  @JsonKey()
  final Difficulty difficulty;
  @override
  @JsonKey()
  final int currentTrial;
  final List<TrialResult> _results;
  @override
  @JsonKey()
  List<TrialResult> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  final Position? targetPos;
  @override
  final Position? playerPos;
  @override
  final Position? prevTargetPos;
  @override
  final DateTime? trialStartTime;
  final List<Position> _currentPath;
  @override
  @JsonKey()
  List<Position> get currentPath {
    if (_currentPath is EqualUnmodifiableListView) return _currentPath;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentPath);
  }

  // 現在のトライアルの移動経路
  @override
  @JsonKey()
  final double currentTraveledDistance;

  @override
  String toString() {
    return 'GameState(status: $status, difficulty: $difficulty, currentTrial: $currentTrial, results: $results, targetPos: $targetPos, playerPos: $playerPos, prevTargetPos: $prevTargetPos, trialStartTime: $trialStartTime, currentPath: $currentPath, currentTraveledDistance: $currentTraveledDistance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.currentTrial, currentTrial) ||
                other.currentTrial == currentTrial) &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.targetPos, targetPos) ||
                other.targetPos == targetPos) &&
            (identical(other.playerPos, playerPos) ||
                other.playerPos == playerPos) &&
            (identical(other.prevTargetPos, prevTargetPos) ||
                other.prevTargetPos == prevTargetPos) &&
            (identical(other.trialStartTime, trialStartTime) ||
                other.trialStartTime == trialStartTime) &&
            const DeepCollectionEquality().equals(
              other._currentPath,
              _currentPath,
            ) &&
            (identical(
                  other.currentTraveledDistance,
                  currentTraveledDistance,
                ) ||
                other.currentTraveledDistance == currentTraveledDistance));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    difficulty,
    currentTrial,
    const DeepCollectionEquality().hash(_results),
    targetPos,
    playerPos,
    prevTargetPos,
    trialStartTime,
    const DeepCollectionEquality().hash(_currentPath),
    currentTraveledDistance,
  );

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);
}

abstract class _GameState extends GameState {
  const factory _GameState({
    final GameStatus status,
    final Difficulty difficulty,
    final int currentTrial,
    final List<TrialResult> results,
    final Position? targetPos,
    final Position? playerPos,
    final Position? prevTargetPos,
    final DateTime? trialStartTime,
    final List<Position> currentPath,
    final double currentTraveledDistance,
  }) = _$GameStateImpl;
  const _GameState._() : super._();

  @override
  GameStatus get status;
  @override
  Difficulty get difficulty;
  @override
  int get currentTrial;
  @override
  List<TrialResult> get results;
  @override
  Position? get targetPos;
  @override
  Position? get playerPos;
  @override
  Position? get prevTargetPos;
  @override
  DateTime? get trialStartTime;
  @override
  List<Position> get currentPath; // 現在のトライアルの移動経路
  @override
  double get currentTraveledDistance;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
