// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dogpair.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DogPair {
  String? get firstDogId;
  String? get secondDogId;
  String get id;
  int get rank;

  /// Create a copy of DogPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DogPairCopyWith<DogPair> get copyWith =>
      _$DogPairCopyWithImpl<DogPair>(this as DogPair, _$identity);

  /// Serializes this DogPair to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DogPair &&
            (identical(other.firstDogId, firstDogId) ||
                other.firstDogId == firstDogId) &&
            (identical(other.secondDogId, secondDogId) ||
                other.secondDogId == secondDogId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, firstDogId, secondDogId, id, rank);

  @override
  String toString() {
    return 'DogPair(firstDogId: $firstDogId, secondDogId: $secondDogId, id: $id, rank: $rank)';
  }
}

/// @nodoc
abstract mixin class $DogPairCopyWith<$Res> {
  factory $DogPairCopyWith(DogPair value, $Res Function(DogPair) _then) =
      _$DogPairCopyWithImpl;
  @useResult
  $Res call({String? firstDogId, String? secondDogId, String id, int rank});
}

/// @nodoc
class _$DogPairCopyWithImpl<$Res> implements $DogPairCopyWith<$Res> {
  _$DogPairCopyWithImpl(this._self, this._then);

  final DogPair _self;
  final $Res Function(DogPair) _then;

  /// Create a copy of DogPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstDogId = freezed,
    Object? secondDogId = freezed,
    Object? id = null,
    Object? rank = null,
  }) {
    return _then(_self.copyWith(
      firstDogId: freezed == firstDogId
          ? _self.firstDogId
          : firstDogId // ignore: cast_nullable_to_non_nullable
              as String?,
      secondDogId: freezed == secondDogId
          ? _self.secondDogId
          : secondDogId // ignore: cast_nullable_to_non_nullable
              as String?,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _self.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [DogPair].
extension DogPairPatterns on DogPair {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DogPair value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DogPair() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_DogPair value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogPair():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DogPair value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogPair() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String? firstDogId, String? secondDogId, String id, int rank)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DogPair() when $default != null:
        return $default(
            _that.firstDogId, _that.secondDogId, _that.id, _that.rank);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String? firstDogId, String? secondDogId, String id, int rank)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogPair():
        return $default(
            _that.firstDogId, _that.secondDogId, _that.id, _that.rank);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String? firstDogId, String? secondDogId, String id, int rank)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogPair() when $default != null:
        return $default(
            _that.firstDogId, _that.secondDogId, _that.id, _that.rank);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DogPair extends DogPair {
  const _DogPair(
      {this.firstDogId, this.secondDogId, required this.id, required this.rank})
      : super._();
  factory _DogPair.fromJson(Map<String, dynamic> json) =>
      _$DogPairFromJson(json);

  @override
  final String? firstDogId;
  @override
  final String? secondDogId;
  @override
  final String id;
  @override
  final int rank;

  /// Create a copy of DogPair
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DogPairCopyWith<_DogPair> get copyWith =>
      __$DogPairCopyWithImpl<_DogPair>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DogPairToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DogPair &&
            (identical(other.firstDogId, firstDogId) ||
                other.firstDogId == firstDogId) &&
            (identical(other.secondDogId, secondDogId) ||
                other.secondDogId == secondDogId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, firstDogId, secondDogId, id, rank);

  @override
  String toString() {
    return 'DogPair(firstDogId: $firstDogId, secondDogId: $secondDogId, id: $id, rank: $rank)';
  }
}

/// @nodoc
abstract mixin class _$DogPairCopyWith<$Res> implements $DogPairCopyWith<$Res> {
  factory _$DogPairCopyWith(_DogPair value, $Res Function(_DogPair) _then) =
      __$DogPairCopyWithImpl;
  @override
  @useResult
  $Res call({String? firstDogId, String? secondDogId, String id, int rank});
}

/// @nodoc
class __$DogPairCopyWithImpl<$Res> implements _$DogPairCopyWith<$Res> {
  __$DogPairCopyWithImpl(this._self, this._then);

  final _DogPair _self;
  final $Res Function(_DogPair) _then;

  /// Create a copy of DogPair
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? firstDogId = freezed,
    Object? secondDogId = freezed,
    Object? id = null,
    Object? rank = null,
  }) {
    return _then(_DogPair(
      firstDogId: freezed == firstDogId
          ? _self.firstDogId
          : firstDogId // ignore: cast_nullable_to_non_nullable
              as String?,
      secondDogId: freezed == secondDogId
          ? _self.secondDogId
          : secondDogId // ignore: cast_nullable_to_non_nullable
              as String?,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _self.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
