// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'falling_bar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FallingBar {
  String get id => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError; // X座標
  double get y => throw _privateConstructorUsedError; // Y座標
  double get velocity => throw _privateConstructorUsedError; // 速度 (pixels/s)
  DateTime get spawnTime => throw _privateConstructorUsedError; // 出現時刻
  bool get isTapped => throw _privateConstructorUsedError;

  /// Create a copy of FallingBar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FallingBarCopyWith<FallingBar> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FallingBarCopyWith<$Res> {
  factory $FallingBarCopyWith(
    FallingBar value,
    $Res Function(FallingBar) then,
  ) = _$FallingBarCopyWithImpl<$Res, FallingBar>;
  @useResult
  $Res call({
    String id,
    double x,
    double y,
    double velocity,
    DateTime spawnTime,
    bool isTapped,
  });
}

/// @nodoc
class _$FallingBarCopyWithImpl<$Res, $Val extends FallingBar>
    implements $FallingBarCopyWith<$Res> {
  _$FallingBarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FallingBar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? x = null,
    Object? y = null,
    Object? velocity = null,
    Object? spawnTime = null,
    Object? isTapped = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            x: null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                      as double,
            y: null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                      as double,
            velocity: null == velocity
                ? _value.velocity
                : velocity // ignore: cast_nullable_to_non_nullable
                      as double,
            spawnTime: null == spawnTime
                ? _value.spawnTime
                : spawnTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isTapped: null == isTapped
                ? _value.isTapped
                : isTapped // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FallingBarImplCopyWith<$Res>
    implements $FallingBarCopyWith<$Res> {
  factory _$$FallingBarImplCopyWith(
    _$FallingBarImpl value,
    $Res Function(_$FallingBarImpl) then,
  ) = __$$FallingBarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    double x,
    double y,
    double velocity,
    DateTime spawnTime,
    bool isTapped,
  });
}

/// @nodoc
class __$$FallingBarImplCopyWithImpl<$Res>
    extends _$FallingBarCopyWithImpl<$Res, _$FallingBarImpl>
    implements _$$FallingBarImplCopyWith<$Res> {
  __$$FallingBarImplCopyWithImpl(
    _$FallingBarImpl _value,
    $Res Function(_$FallingBarImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FallingBar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? x = null,
    Object? y = null,
    Object? velocity = null,
    Object? spawnTime = null,
    Object? isTapped = null,
  }) {
    return _then(
      _$FallingBarImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        x: null == x
            ? _value.x
            : x // ignore: cast_nullable_to_non_nullable
                  as double,
        y: null == y
            ? _value.y
            : y // ignore: cast_nullable_to_non_nullable
                  as double,
        velocity: null == velocity
            ? _value.velocity
            : velocity // ignore: cast_nullable_to_non_nullable
                  as double,
        spawnTime: null == spawnTime
            ? _value.spawnTime
            : spawnTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isTapped: null == isTapped
            ? _value.isTapped
            : isTapped // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$FallingBarImpl extends _FallingBar {
  const _$FallingBarImpl({
    required this.id,
    required this.x,
    required this.y,
    required this.velocity,
    required this.spawnTime,
    this.isTapped = false,
  }) : super._();

  @override
  final String id;
  @override
  final double x;
  // X座標
  @override
  final double y;
  // Y座標
  @override
  final double velocity;
  // 速度 (pixels/s)
  @override
  final DateTime spawnTime;
  // 出現時刻
  @override
  @JsonKey()
  final bool isTapped;

  @override
  String toString() {
    return 'FallingBar(id: $id, x: $x, y: $y, velocity: $velocity, spawnTime: $spawnTime, isTapped: $isTapped)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FallingBarImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.velocity, velocity) ||
                other.velocity == velocity) &&
            (identical(other.spawnTime, spawnTime) ||
                other.spawnTime == spawnTime) &&
            (identical(other.isTapped, isTapped) ||
                other.isTapped == isTapped));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, x, y, velocity, spawnTime, isTapped);

  /// Create a copy of FallingBar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FallingBarImplCopyWith<_$FallingBarImpl> get copyWith =>
      __$$FallingBarImplCopyWithImpl<_$FallingBarImpl>(this, _$identity);
}

abstract class _FallingBar extends FallingBar {
  const factory _FallingBar({
    required final String id,
    required final double x,
    required final double y,
    required final double velocity,
    required final DateTime spawnTime,
    final bool isTapped,
  }) = _$FallingBarImpl;
  const _FallingBar._() : super._();

  @override
  String get id;
  @override
  double get x; // X座標
  @override
  double get y; // Y座標
  @override
  double get velocity; // 速度 (pixels/s)
  @override
  DateTime get spawnTime; // 出現時刻
  @override
  bool get isTapped;

  /// Create a copy of FallingBar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FallingBarImplCopyWith<_$FallingBarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
