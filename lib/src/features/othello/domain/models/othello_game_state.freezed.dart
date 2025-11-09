// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'othello_game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OthelloGameState {
  GameStatus get status => throw _privateConstructorUsedError;
  Board get board => throw _privateConstructorUsedError;
  Player get currentPlayer => throw _privateConstructorUsedError;
  Player get humanPlayer => throw _privateConstructorUsedError;
  bool get isThinking => throw _privateConstructorUsedError; // CPUが思考中
  Player? get winner => throw _privateConstructorUsedError;
  Position? get lastMove => throw _privateConstructorUsedError;

  /// Create a copy of OthelloGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OthelloGameStateCopyWith<OthelloGameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OthelloGameStateCopyWith<$Res> {
  factory $OthelloGameStateCopyWith(
    OthelloGameState value,
    $Res Function(OthelloGameState) then,
  ) = _$OthelloGameStateCopyWithImpl<$Res, OthelloGameState>;
  @useResult
  $Res call({
    GameStatus status,
    Board board,
    Player currentPlayer,
    Player humanPlayer,
    bool isThinking,
    Player? winner,
    Position? lastMove,
  });

  $BoardCopyWith<$Res> get board;
  $PositionCopyWith<$Res>? get lastMove;
}

/// @nodoc
class _$OthelloGameStateCopyWithImpl<$Res, $Val extends OthelloGameState>
    implements $OthelloGameStateCopyWith<$Res> {
  _$OthelloGameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OthelloGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? board = null,
    Object? currentPlayer = null,
    Object? humanPlayer = null,
    Object? isThinking = null,
    Object? winner = freezed,
    Object? lastMove = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as GameStatus,
            board: null == board
                ? _value.board
                : board // ignore: cast_nullable_to_non_nullable
                      as Board,
            currentPlayer: null == currentPlayer
                ? _value.currentPlayer
                : currentPlayer // ignore: cast_nullable_to_non_nullable
                      as Player,
            humanPlayer: null == humanPlayer
                ? _value.humanPlayer
                : humanPlayer // ignore: cast_nullable_to_non_nullable
                      as Player,
            isThinking: null == isThinking
                ? _value.isThinking
                : isThinking // ignore: cast_nullable_to_non_nullable
                      as bool,
            winner: freezed == winner
                ? _value.winner
                : winner // ignore: cast_nullable_to_non_nullable
                      as Player?,
            lastMove: freezed == lastMove
                ? _value.lastMove
                : lastMove // ignore: cast_nullable_to_non_nullable
                      as Position?,
          )
          as $Val,
    );
  }

  /// Create a copy of OthelloGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoardCopyWith<$Res> get board {
    return $BoardCopyWith<$Res>(_value.board, (value) {
      return _then(_value.copyWith(board: value) as $Val);
    });
  }

  /// Create a copy of OthelloGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res>? get lastMove {
    if (_value.lastMove == null) {
      return null;
    }

    return $PositionCopyWith<$Res>(_value.lastMove!, (value) {
      return _then(_value.copyWith(lastMove: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OthelloGameStateImplCopyWith<$Res>
    implements $OthelloGameStateCopyWith<$Res> {
  factory _$$OthelloGameStateImplCopyWith(
    _$OthelloGameStateImpl value,
    $Res Function(_$OthelloGameStateImpl) then,
  ) = __$$OthelloGameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    GameStatus status,
    Board board,
    Player currentPlayer,
    Player humanPlayer,
    bool isThinking,
    Player? winner,
    Position? lastMove,
  });

  @override
  $BoardCopyWith<$Res> get board;
  @override
  $PositionCopyWith<$Res>? get lastMove;
}

/// @nodoc
class __$$OthelloGameStateImplCopyWithImpl<$Res>
    extends _$OthelloGameStateCopyWithImpl<$Res, _$OthelloGameStateImpl>
    implements _$$OthelloGameStateImplCopyWith<$Res> {
  __$$OthelloGameStateImplCopyWithImpl(
    _$OthelloGameStateImpl _value,
    $Res Function(_$OthelloGameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OthelloGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? board = null,
    Object? currentPlayer = null,
    Object? humanPlayer = null,
    Object? isThinking = null,
    Object? winner = freezed,
    Object? lastMove = freezed,
  }) {
    return _then(
      _$OthelloGameStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as GameStatus,
        board: null == board
            ? _value.board
            : board // ignore: cast_nullable_to_non_nullable
                  as Board,
        currentPlayer: null == currentPlayer
            ? _value.currentPlayer
            : currentPlayer // ignore: cast_nullable_to_non_nullable
                  as Player,
        humanPlayer: null == humanPlayer
            ? _value.humanPlayer
            : humanPlayer // ignore: cast_nullable_to_non_nullable
                  as Player,
        isThinking: null == isThinking
            ? _value.isThinking
            : isThinking // ignore: cast_nullable_to_non_nullable
                  as bool,
        winner: freezed == winner
            ? _value.winner
            : winner // ignore: cast_nullable_to_non_nullable
                  as Player?,
        lastMove: freezed == lastMove
            ? _value.lastMove
            : lastMove // ignore: cast_nullable_to_non_nullable
                  as Position?,
      ),
    );
  }
}

/// @nodoc

class _$OthelloGameStateImpl extends _OthelloGameState {
  const _$OthelloGameStateImpl({
    this.status = GameStatus.selectingPlayer,
    this.board = const Board(cells: []),
    this.currentPlayer = Player.black,
    this.humanPlayer = Player.black,
    this.isThinking = false,
    this.winner,
    this.lastMove,
  }) : super._();

  @override
  @JsonKey()
  final GameStatus status;
  @override
  @JsonKey()
  final Board board;
  @override
  @JsonKey()
  final Player currentPlayer;
  @override
  @JsonKey()
  final Player humanPlayer;
  @override
  @JsonKey()
  final bool isThinking;
  // CPUが思考中
  @override
  final Player? winner;
  @override
  final Position? lastMove;

  @override
  String toString() {
    return 'OthelloGameState(status: $status, board: $board, currentPlayer: $currentPlayer, humanPlayer: $humanPlayer, isThinking: $isThinking, winner: $winner, lastMove: $lastMove)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OthelloGameStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.board, board) || other.board == board) &&
            (identical(other.currentPlayer, currentPlayer) ||
                other.currentPlayer == currentPlayer) &&
            (identical(other.humanPlayer, humanPlayer) ||
                other.humanPlayer == humanPlayer) &&
            (identical(other.isThinking, isThinking) ||
                other.isThinking == isThinking) &&
            (identical(other.winner, winner) || other.winner == winner) &&
            (identical(other.lastMove, lastMove) ||
                other.lastMove == lastMove));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    board,
    currentPlayer,
    humanPlayer,
    isThinking,
    winner,
    lastMove,
  );

  /// Create a copy of OthelloGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OthelloGameStateImplCopyWith<_$OthelloGameStateImpl> get copyWith =>
      __$$OthelloGameStateImplCopyWithImpl<_$OthelloGameStateImpl>(
        this,
        _$identity,
      );
}

abstract class _OthelloGameState extends OthelloGameState {
  const factory _OthelloGameState({
    final GameStatus status,
    final Board board,
    final Player currentPlayer,
    final Player humanPlayer,
    final bool isThinking,
    final Player? winner,
    final Position? lastMove,
  }) = _$OthelloGameStateImpl;
  const _OthelloGameState._() : super._();

  @override
  GameStatus get status;
  @override
  Board get board;
  @override
  Player get currentPlayer;
  @override
  Player get humanPlayer;
  @override
  bool get isThinking; // CPUが思考中
  @override
  Player? get winner;
  @override
  Position? get lastMove;

  /// Create a copy of OthelloGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OthelloGameStateImplCopyWith<_$OthelloGameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
