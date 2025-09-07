// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'riverpod.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DogDistanceWarning {
  /// The dog that has this warning.
  Dog get dog;

  /// The distance warning that triggered this dog warning.
  DistanceWarning get distanceWarning;

  /// How many km this dog has run in the distanceWarning period (must be > distance warning km).
  double get distanceRan;

  /// Create a copy of DogDistanceWarning
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DogDistanceWarningCopyWith<DogDistanceWarning> get copyWith =>
      _$DogDistanceWarningCopyWithImpl<DogDistanceWarning>(
          this as DogDistanceWarning, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DogDistanceWarning &&
            (identical(other.dog, dog) || other.dog == dog) &&
            (identical(other.distanceWarning, distanceWarning) ||
                other.distanceWarning == distanceWarning) &&
            (identical(other.distanceRan, distanceRan) ||
                other.distanceRan == distanceRan));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, dog, distanceWarning, distanceRan);

  @override
  String toString() {
    return 'DogDistanceWarning(dog: $dog, distanceWarning: $distanceWarning, distanceRan: $distanceRan)';
  }
}

/// @nodoc
abstract mixin class $DogDistanceWarningCopyWith<$Res> {
  factory $DogDistanceWarningCopyWith(
          DogDistanceWarning value, $Res Function(DogDistanceWarning) _then) =
      _$DogDistanceWarningCopyWithImpl;
  @useResult
  $Res call({Dog dog, DistanceWarning distanceWarning, double distanceRan});

  $DogCopyWith<$Res> get dog;
  $DistanceWarningCopyWith<$Res> get distanceWarning;
}

/// @nodoc
class _$DogDistanceWarningCopyWithImpl<$Res>
    implements $DogDistanceWarningCopyWith<$Res> {
  _$DogDistanceWarningCopyWithImpl(this._self, this._then);

  final DogDistanceWarning _self;
  final $Res Function(DogDistanceWarning) _then;

  /// Create a copy of DogDistanceWarning
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dog = null,
    Object? distanceWarning = null,
    Object? distanceRan = null,
  }) {
    return _then(_self.copyWith(
      dog: null == dog
          ? _self.dog
          : dog // ignore: cast_nullable_to_non_nullable
              as Dog,
      distanceWarning: null == distanceWarning
          ? _self.distanceWarning
          : distanceWarning // ignore: cast_nullable_to_non_nullable
              as DistanceWarning,
      distanceRan: null == distanceRan
          ? _self.distanceRan
          : distanceRan // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of DogDistanceWarning
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DogCopyWith<$Res> get dog {
    return $DogCopyWith<$Res>(_self.dog, (value) {
      return _then(_self.copyWith(dog: value));
    });
  }

  /// Create a copy of DogDistanceWarning
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DistanceWarningCopyWith<$Res> get distanceWarning {
    return $DistanceWarningCopyWith<$Res>(_self.distanceWarning, (value) {
      return _then(_self.copyWith(distanceWarning: value));
    });
  }
}

/// Adds pattern-matching-related methods to [DogDistanceWarning].
extension DogDistanceWarningPatterns on DogDistanceWarning {
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
    TResult Function(_DogDistanceWarning value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DogDistanceWarning() when $default != null:
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
    TResult Function(_DogDistanceWarning value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogDistanceWarning():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(_DogDistanceWarning value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogDistanceWarning() when $default != null:
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
            Dog dog, DistanceWarning distanceWarning, double distanceRan)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DogDistanceWarning() when $default != null:
        return $default(_that.dog, _that.distanceWarning, _that.distanceRan);
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
            Dog dog, DistanceWarning distanceWarning, double distanceRan)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogDistanceWarning():
        return $default(_that.dog, _that.distanceWarning, _that.distanceRan);
      case _:
        throw StateError('Unexpected subclass');
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
            Dog dog, DistanceWarning distanceWarning, double distanceRan)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DogDistanceWarning() when $default != null:
        return $default(_that.dog, _that.distanceWarning, _that.distanceRan);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DogDistanceWarning implements DogDistanceWarning {
  const _DogDistanceWarning(
      {required this.dog,
      required this.distanceWarning,
      required this.distanceRan});

  /// The dog that has this warning.
  @override
  final Dog dog;

  /// The distance warning that triggered this dog warning.
  @override
  final DistanceWarning distanceWarning;

  /// How many km this dog has run in the distanceWarning period (must be > distance warning km).
  @override
  final double distanceRan;

  /// Create a copy of DogDistanceWarning
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DogDistanceWarningCopyWith<_DogDistanceWarning> get copyWith =>
      __$DogDistanceWarningCopyWithImpl<_DogDistanceWarning>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DogDistanceWarning &&
            (identical(other.dog, dog) || other.dog == dog) &&
            (identical(other.distanceWarning, distanceWarning) ||
                other.distanceWarning == distanceWarning) &&
            (identical(other.distanceRan, distanceRan) ||
                other.distanceRan == distanceRan));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, dog, distanceWarning, distanceRan);

  @override
  String toString() {
    return 'DogDistanceWarning(dog: $dog, distanceWarning: $distanceWarning, distanceRan: $distanceRan)';
  }
}

/// @nodoc
abstract mixin class _$DogDistanceWarningCopyWith<$Res>
    implements $DogDistanceWarningCopyWith<$Res> {
  factory _$DogDistanceWarningCopyWith(
          _DogDistanceWarning value, $Res Function(_DogDistanceWarning) _then) =
      __$DogDistanceWarningCopyWithImpl;
  @override
  @useResult
  $Res call({Dog dog, DistanceWarning distanceWarning, double distanceRan});

  @override
  $DogCopyWith<$Res> get dog;
  @override
  $DistanceWarningCopyWith<$Res> get distanceWarning;
}

/// @nodoc
class __$DogDistanceWarningCopyWithImpl<$Res>
    implements _$DogDistanceWarningCopyWith<$Res> {
  __$DogDistanceWarningCopyWithImpl(this._self, this._then);

  final _DogDistanceWarning _self;
  final $Res Function(_DogDistanceWarning) _then;

  /// Create a copy of DogDistanceWarning
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dog = null,
    Object? distanceWarning = null,
    Object? distanceRan = null,
  }) {
    return _then(_DogDistanceWarning(
      dog: null == dog
          ? _self.dog
          : dog // ignore: cast_nullable_to_non_nullable
              as Dog,
      distanceWarning: null == distanceWarning
          ? _self.distanceWarning
          : distanceWarning // ignore: cast_nullable_to_non_nullable
              as DistanceWarning,
      distanceRan: null == distanceRan
          ? _self.distanceRan
          : distanceRan // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of DogDistanceWarning
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DogCopyWith<$Res> get dog {
    return $DogCopyWith<$Res>(_self.dog, (value) {
      return _then(_self.copyWith(dog: value));
    });
  }

  /// Create a copy of DogDistanceWarning
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DistanceWarningCopyWith<$Res> get distanceWarning {
    return $DistanceWarningCopyWith<$Res>(_self.distanceWarning, (value) {
      return _then(_self.copyWith(distanceWarning: value));
    });
  }
}

// dart format on
