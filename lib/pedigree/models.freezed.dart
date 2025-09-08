// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DogLayout {
  Dog get dog;
  int get rank;

  /// Create a copy of DogLayout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DogLayoutCopyWith<DogLayout> get copyWith =>
      _$DogLayoutCopyWithImpl<DogLayout>(this as DogLayout, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DogLayout &&
            (identical(other.dog, dog) || other.dog == dog) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dog, rank);

  @override
  String toString() {
    return 'DogLayout(dog: $dog, rank: $rank)';
  }
}

/// @nodoc
abstract mixin class $DogLayoutCopyWith<$Res> {
  factory $DogLayoutCopyWith(DogLayout value, $Res Function(DogLayout) _then) =
      _$DogLayoutCopyWithImpl;
  @useResult
  $Res call({Dog dog, int rank});

  $DogCopyWith<$Res> get dog;
}

/// @nodoc
class _$DogLayoutCopyWithImpl<$Res> implements $DogLayoutCopyWith<$Res> {
  _$DogLayoutCopyWithImpl(this._self, this._then);

  final DogLayout _self;
  final $Res Function(DogLayout) _then;

  /// Create a copy of DogLayout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dog = null,
    Object? rank = null,
  }) {
    return _then(_self.copyWith(
      dog: null == dog
          ? _self.dog
          : dog // ignore: cast_nullable_to_non_nullable
              as Dog,
      rank: null == rank
          ? _self.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of DogLayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DogCopyWith<$Res> get dog {
    return $DogCopyWith<$Res>(_self.dog, (value) {
      return _then(_self.copyWith(dog: value));
    });
  }
}

/// Adds pattern-matching-related methods to [DogLayout].
extension DogLayoutPatterns on DogLayout {
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
    TResult Function(_DogLayout value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DogLayout() when $default != null:
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
    TResult Function(_DogLayout value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogLayout():
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
    TResult? Function(_DogLayout value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogLayout() when $default != null:
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
    TResult Function(Dog dog, int rank)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DogLayout() when $default != null:
        return $default(_that.dog, _that.rank);
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
    TResult Function(Dog dog, int rank) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogLayout():
        return $default(_that.dog, _that.rank);
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
    TResult? Function(Dog dog, int rank)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogLayout() when $default != null:
        return $default(_that.dog, _that.rank);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DogLayout implements DogLayout {
  const _DogLayout({required this.dog, required this.rank});

  @override
  final Dog dog;
  @override
  final int rank;

  /// Create a copy of DogLayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DogLayoutCopyWith<_DogLayout> get copyWith =>
      __$DogLayoutCopyWithImpl<_DogLayout>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DogLayout &&
            (identical(other.dog, dog) || other.dog == dog) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dog, rank);

  @override
  String toString() {
    return 'DogLayout(dog: $dog, rank: $rank)';
  }
}

/// @nodoc
abstract mixin class _$DogLayoutCopyWith<$Res>
    implements $DogLayoutCopyWith<$Res> {
  factory _$DogLayoutCopyWith(
          _DogLayout value, $Res Function(_DogLayout) _then) =
      __$DogLayoutCopyWithImpl;
  @override
  @useResult
  $Res call({Dog dog, int rank});

  @override
  $DogCopyWith<$Res> get dog;
}

/// @nodoc
class __$DogLayoutCopyWithImpl<$Res> implements _$DogLayoutCopyWith<$Res> {
  __$DogLayoutCopyWithImpl(this._self, this._then);

  final _DogLayout _self;
  final $Res Function(_DogLayout) _then;

  /// Create a copy of DogLayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dog = null,
    Object? rank = null,
  }) {
    return _then(_DogLayout(
      dog: null == dog
          ? _self.dog
          : dog // ignore: cast_nullable_to_non_nullable
              as Dog,
      rank: null == rank
          ? _self.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of DogLayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DogCopyWith<$Res> get dog {
    return $DogCopyWith<$Res>(_self.dog, (value) {
      return _then(_self.copyWith(dog: value));
    });
  }
}

// dart format on
