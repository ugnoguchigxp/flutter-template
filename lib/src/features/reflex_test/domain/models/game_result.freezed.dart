// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameResult {
  int get score => throw _privateConstructorUsedError;
  int get successCount => throw _privateConstructorUsedError;
  ReflexDifficulty get difficulty => throw _privateConstructorUsedError;
  List<double> get reactionTimes => throw _privateConstructorUsedError;
  DateTime get playedAt => throw _privateConstructorUsedError;

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameResultCopyWith<GameResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameResultCopyWith<$Res> {
  factory $GameResultCopyWith(
    GameResult value,
    $Res Function(GameResult) then,
  ) = _$GameResultCopyWithImpl<$Res, GameResult>;
  @useResult
  $Res call({
    int score,
    int successCount,
    ReflexDifficulty difficulty,
    List<double> reactionTimes,
    DateTime playedAt,
  });
}

/// @nodoc
class _$GameResultCopyWithImpl<$Res, $Val extends GameResult>
    implements $GameResultCopyWith<$Res> {
  _$GameResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? successCount = null,
    Object? difficulty = null,
    Object? reactionTimes = null,
    Object? playedAt = null,
  }) {
    return _then(
      _value.copyWith(
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            successCount: null == successCount
                ? _value.successCount
                : successCount // ignore: cast_nullable_to_non_nullable
                      as int,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as ReflexDifficulty,
            reactionTimes: null == reactionTimes
                ? _value.reactionTimes
                : reactionTimes // ignore: cast_nullable_to_non_nullable
                      as List<double>,
            playedAt: null == playedAt
                ? _value.playedAt
                : playedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameResultImplCopyWith<$Res>
    implements $GameResultCopyWith<$Res> {
  factory _$$GameResultImplCopyWith(
    _$GameResultImpl value,
    $Res Function(_$GameResultImpl) then,
  ) = __$$GameResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int score,
    int successCount,
    ReflexDifficulty difficulty,
    List<double> reactionTimes,
    DateTime playedAt,
  });
}

/// @nodoc
class __$$GameResultImplCopyWithImpl<$Res>
    extends _$GameResultCopyWithImpl<$Res, _$GameResultImpl>
    implements _$$GameResultImplCopyWith<$Res> {
  __$$GameResultImplCopyWithImpl(
    _$GameResultImpl _value,
    $Res Function(_$GameResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? successCount = null,
    Object? difficulty = null,
    Object? reactionTimes = null,
    Object? playedAt = null,
  }) {
    return _then(
      _$GameResultImpl(
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        successCount: null == successCount
            ? _value.successCount
            : successCount // ignore: cast_nullable_to_non_nullable
                  as int,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as ReflexDifficulty,
        reactionTimes: null == reactionTimes
            ? _value._reactionTimes
            : reactionTimes // ignore: cast_nullable_to_non_nullable
                  as List<double>,
        playedAt: null == playedAt
            ? _value.playedAt
            : playedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$GameResultImpl extends _GameResult {
  const _$GameResultImpl({
    required this.score,
    required this.successCount,
    required this.difficulty,
    required final List<double> reactionTimes,
    required this.playedAt,
  }) : _reactionTimes = reactionTimes,
       super._();

  @override
  final int score;
  @override
  final int successCount;
  @override
  final ReflexDifficulty difficulty;
  final List<double> _reactionTimes;
  @override
  List<double> get reactionTimes {
    if (_reactionTimes is EqualUnmodifiableListView) return _reactionTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reactionTimes);
  }

  @override
  final DateTime playedAt;

  @override
  String toString() {
    return 'GameResult(score: $score, successCount: $successCount, difficulty: $difficulty, reactionTimes: $reactionTimes, playedAt: $playedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameResultImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.successCount, successCount) ||
                other.successCount == successCount) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            const DeepCollectionEquality().equals(
              other._reactionTimes,
              _reactionTimes,
            ) &&
            (identical(other.playedAt, playedAt) ||
                other.playedAt == playedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    score,
    successCount,
    difficulty,
    const DeepCollectionEquality().hash(_reactionTimes),
    playedAt,
  );

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameResultImplCopyWith<_$GameResultImpl> get copyWith =>
      __$$GameResultImplCopyWithImpl<_$GameResultImpl>(this, _$identity);
}

abstract class _GameResult extends GameResult {
  const factory _GameResult({
    required final int score,
    required final int successCount,
    required final ReflexDifficulty difficulty,
    required final List<double> reactionTimes,
    required final DateTime playedAt,
  }) = _$GameResultImpl;
  const _GameResult._() : super._();

  @override
  int get score;
  @override
  int get successCount;
  @override
  ReflexDifficulty get difficulty;
  @override
  List<double> get reactionTimes;
  @override
  DateTime get playedAt;

  /// Create a copy of GameResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameResultImplCopyWith<_$GameResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
