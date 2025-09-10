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
mixin _$DateRangeSelectedValues {
  DateTime? get initialDay;
  DateTime? get finalDay;

  /// Create a copy of DateRangeSelectedValues
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DateRangeSelectedValuesCopyWith<DateRangeSelectedValues> get copyWith =>
      _$DateRangeSelectedValuesCopyWithImpl<DateRangeSelectedValues>(
          this as DateRangeSelectedValues, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DateRangeSelectedValues &&
            (identical(other.initialDay, initialDay) ||
                other.initialDay == initialDay) &&
            (identical(other.finalDay, finalDay) ||
                other.finalDay == finalDay));
  }

  @override
  int get hashCode => Object.hash(runtimeType, initialDay, finalDay);

  @override
  String toString() {
    return 'DateRangeSelectedValues(initialDay: $initialDay, finalDay: $finalDay)';
  }
}

/// @nodoc
abstract mixin class $DateRangeSelectedValuesCopyWith<$Res> {
  factory $DateRangeSelectedValuesCopyWith(DateRangeSelectedValues value,
          $Res Function(DateRangeSelectedValues) _then) =
      _$DateRangeSelectedValuesCopyWithImpl;
  @useResult
  $Res call({DateTime? initialDay, DateTime? finalDay});
}

/// @nodoc
class _$DateRangeSelectedValuesCopyWithImpl<$Res>
    implements $DateRangeSelectedValuesCopyWith<$Res> {
  _$DateRangeSelectedValuesCopyWithImpl(this._self, this._then);

  final DateRangeSelectedValues _self;
  final $Res Function(DateRangeSelectedValues) _then;

  /// Create a copy of DateRangeSelectedValues
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initialDay = freezed,
    Object? finalDay = freezed,
  }) {
    return _then(_self.copyWith(
      initialDay: freezed == initialDay
          ? _self.initialDay
          : initialDay // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      finalDay: freezed == finalDay
          ? _self.finalDay
          : finalDay // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [DateRangeSelectedValues].
extension DateRangeSelectedValuesPatterns on DateRangeSelectedValues {
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
    TResult Function(_DateRangeSelectedValues value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DateRangeSelectedValues() when $default != null:
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
    TResult Function(_DateRangeSelectedValues value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DateRangeSelectedValues():
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
    TResult? Function(_DateRangeSelectedValues value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DateRangeSelectedValues() when $default != null:
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
    TResult Function(DateTime? initialDay, DateTime? finalDay)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DateRangeSelectedValues() when $default != null:
        return $default(_that.initialDay, _that.finalDay);
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
    TResult Function(DateTime? initialDay, DateTime? finalDay) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DateRangeSelectedValues():
        return $default(_that.initialDay, _that.finalDay);
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
    TResult? Function(DateTime? initialDay, DateTime? finalDay)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DateRangeSelectedValues() when $default != null:
        return $default(_that.initialDay, _that.finalDay);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DateRangeSelectedValues implements DateRangeSelectedValues {
  const _DateRangeSelectedValues(
      {required this.initialDay, required this.finalDay});

  @override
  final DateTime? initialDay;
  @override
  final DateTime? finalDay;

  /// Create a copy of DateRangeSelectedValues
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DateRangeSelectedValuesCopyWith<_DateRangeSelectedValues> get copyWith =>
      __$DateRangeSelectedValuesCopyWithImpl<_DateRangeSelectedValues>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DateRangeSelectedValues &&
            (identical(other.initialDay, initialDay) ||
                other.initialDay == initialDay) &&
            (identical(other.finalDay, finalDay) ||
                other.finalDay == finalDay));
  }

  @override
  int get hashCode => Object.hash(runtimeType, initialDay, finalDay);

  @override
  String toString() {
    return 'DateRangeSelectedValues(initialDay: $initialDay, finalDay: $finalDay)';
  }
}

/// @nodoc
abstract mixin class _$DateRangeSelectedValuesCopyWith<$Res>
    implements $DateRangeSelectedValuesCopyWith<$Res> {
  factory _$DateRangeSelectedValuesCopyWith(_DateRangeSelectedValues value,
          $Res Function(_DateRangeSelectedValues) _then) =
      __$DateRangeSelectedValuesCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime? initialDay, DateTime? finalDay});
}

/// @nodoc
class __$DateRangeSelectedValuesCopyWithImpl<$Res>
    implements _$DateRangeSelectedValuesCopyWith<$Res> {
  __$DateRangeSelectedValuesCopyWithImpl(this._self, this._then);

  final _DateRangeSelectedValues _self;
  final $Res Function(_DateRangeSelectedValues) _then;

  /// Create a copy of DateRangeSelectedValues
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? initialDay = freezed,
    Object? finalDay = freezed,
  }) {
    return _then(_DateRangeSelectedValues(
      initialDay: freezed == initialDay
          ? _self.initialDay
          : initialDay // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      finalDay: freezed == finalDay
          ? _self.finalDay
          : finalDay // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
