// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'distance_warning.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DistanceWarning {
  String get id;
  int get daysInterval;
  int get distance;
  DistanceWarningType get distanceWarningType;

  /// Create a copy of DistanceWarning
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DistanceWarningCopyWith<DistanceWarning> get copyWith =>
      _$DistanceWarningCopyWithImpl<DistanceWarning>(
          this as DistanceWarning, _$identity);

  /// Serializes this DistanceWarning to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DistanceWarning &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.daysInterval, daysInterval) ||
                other.daysInterval == daysInterval) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.distanceWarningType, distanceWarningType) ||
                other.distanceWarningType == distanceWarningType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, daysInterval, distance, distanceWarningType);

  @override
  String toString() {
    return 'DistanceWarning(id: $id, daysInterval: $daysInterval, distance: $distance, distanceWarningType: $distanceWarningType)';
  }
}

/// @nodoc
abstract mixin class $DistanceWarningCopyWith<$Res> {
  factory $DistanceWarningCopyWith(
          DistanceWarning value, $Res Function(DistanceWarning) _then) =
      _$DistanceWarningCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      int daysInterval,
      int distance,
      DistanceWarningType distanceWarningType});
}

/// @nodoc
class _$DistanceWarningCopyWithImpl<$Res>
    implements $DistanceWarningCopyWith<$Res> {
  _$DistanceWarningCopyWithImpl(this._self, this._then);

  final DistanceWarning _self;
  final $Res Function(DistanceWarning) _then;

  /// Create a copy of DistanceWarning
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? daysInterval = null,
    Object? distance = null,
    Object? distanceWarningType = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      daysInterval: null == daysInterval
          ? _self.daysInterval
          : daysInterval // ignore: cast_nullable_to_non_nullable
              as int,
      distance: null == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as int,
      distanceWarningType: null == distanceWarningType
          ? _self.distanceWarningType
          : distanceWarningType // ignore: cast_nullable_to_non_nullable
              as DistanceWarningType,
    ));
  }
}

/// Adds pattern-matching-related methods to [DistanceWarning].
extension DistanceWarningPatterns on DistanceWarning {
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
    TResult Function(_DistanceWarning value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DistanceWarning() when $default != null:
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
    TResult Function(_DistanceWarning value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DistanceWarning():
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
    TResult? Function(_DistanceWarning value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DistanceWarning() when $default != null:
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
    TResult Function(String id, int daysInterval, int distance,
            DistanceWarningType distanceWarningType)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DistanceWarning() when $default != null:
        return $default(_that.id, _that.daysInterval, _that.distance,
            _that.distanceWarningType);
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
    TResult Function(String id, int daysInterval, int distance,
            DistanceWarningType distanceWarningType)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DistanceWarning():
        return $default(_that.id, _that.daysInterval, _that.distance,
            _that.distanceWarningType);
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
    TResult? Function(String id, int daysInterval, int distance,
            DistanceWarningType distanceWarningType)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DistanceWarning() when $default != null:
        return $default(_that.id, _that.daysInterval, _that.distance,
            _that.distanceWarningType);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DistanceWarning implements DistanceWarning {
  const _DistanceWarning(
      {this.id = "",
      this.daysInterval = 9,
      this.distance = 0,
      this.distanceWarningType = DistanceWarningType.soft});
  factory _DistanceWarning.fromJson(Map<String, dynamic> json) =>
      _$DistanceWarningFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final int daysInterval;
  @override
  @JsonKey()
  final int distance;
  @override
  @JsonKey()
  final DistanceWarningType distanceWarningType;

  /// Create a copy of DistanceWarning
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DistanceWarningCopyWith<_DistanceWarning> get copyWith =>
      __$DistanceWarningCopyWithImpl<_DistanceWarning>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DistanceWarningToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DistanceWarning &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.daysInterval, daysInterval) ||
                other.daysInterval == daysInterval) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.distanceWarningType, distanceWarningType) ||
                other.distanceWarningType == distanceWarningType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, daysInterval, distance, distanceWarningType);

  @override
  String toString() {
    return 'DistanceWarning(id: $id, daysInterval: $daysInterval, distance: $distance, distanceWarningType: $distanceWarningType)';
  }
}

/// @nodoc
abstract mixin class _$DistanceWarningCopyWith<$Res>
    implements $DistanceWarningCopyWith<$Res> {
  factory _$DistanceWarningCopyWith(
          _DistanceWarning value, $Res Function(_DistanceWarning) _then) =
      __$DistanceWarningCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      int daysInterval,
      int distance,
      DistanceWarningType distanceWarningType});
}

/// @nodoc
class __$DistanceWarningCopyWithImpl<$Res>
    implements _$DistanceWarningCopyWith<$Res> {
  __$DistanceWarningCopyWithImpl(this._self, this._then);

  final _DistanceWarning _self;
  final $Res Function(_DistanceWarning) _then;

  /// Create a copy of DistanceWarning
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? daysInterval = null,
    Object? distance = null,
    Object? distanceWarningType = null,
  }) {
    return _then(_DistanceWarning(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      daysInterval: null == daysInterval
          ? _self.daysInterval
          : daysInterval // ignore: cast_nullable_to_non_nullable
              as int,
      distance: null == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as int,
      distanceWarningType: null == distanceWarningType
          ? _self.distanceWarningType
          : distanceWarningType // ignore: cast_nullable_to_non_nullable
              as DistanceWarningType,
    ));
  }
}

// dart format on
