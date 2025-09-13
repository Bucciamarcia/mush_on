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
mixin _$FirstAndLastDateInCalendar {
  DateTime get firstDate;
  DateTime get lastDate;

  /// Create a copy of FirstAndLastDateInCalendar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FirstAndLastDateInCalendarCopyWith<FirstAndLastDateInCalendar>
      get copyWith =>
          _$FirstAndLastDateInCalendarCopyWithImpl<FirstAndLastDateInCalendar>(
              this as FirstAndLastDateInCalendar, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FirstAndLastDateInCalendar &&
            (identical(other.firstDate, firstDate) ||
                other.firstDate == firstDate) &&
            (identical(other.lastDate, lastDate) ||
                other.lastDate == lastDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, firstDate, lastDate);

  @override
  String toString() {
    return 'FirstAndLastDateInCalendar(firstDate: $firstDate, lastDate: $lastDate)';
  }
}

/// @nodoc
abstract mixin class $FirstAndLastDateInCalendarCopyWith<$Res> {
  factory $FirstAndLastDateInCalendarCopyWith(FirstAndLastDateInCalendar value,
          $Res Function(FirstAndLastDateInCalendar) _then) =
      _$FirstAndLastDateInCalendarCopyWithImpl;
  @useResult
  $Res call({DateTime firstDate, DateTime lastDate});
}

/// @nodoc
class _$FirstAndLastDateInCalendarCopyWithImpl<$Res>
    implements $FirstAndLastDateInCalendarCopyWith<$Res> {
  _$FirstAndLastDateInCalendarCopyWithImpl(this._self, this._then);

  final FirstAndLastDateInCalendar _self;
  final $Res Function(FirstAndLastDateInCalendar) _then;

  /// Create a copy of FirstAndLastDateInCalendar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstDate = null,
    Object? lastDate = null,
  }) {
    return _then(_self.copyWith(
      firstDate: null == firstDate
          ? _self.firstDate
          : firstDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastDate: null == lastDate
          ? _self.lastDate
          : lastDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [FirstAndLastDateInCalendar].
extension FirstAndLastDateInCalendarPatterns on FirstAndLastDateInCalendar {
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
    TResult Function(_FirstAndLastDateInCalendar value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FirstAndLastDateInCalendar() when $default != null:
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
    TResult Function(_FirstAndLastDateInCalendar value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FirstAndLastDateInCalendar():
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
    TResult? Function(_FirstAndLastDateInCalendar value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FirstAndLastDateInCalendar() when $default != null:
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
    TResult Function(DateTime firstDate, DateTime lastDate)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FirstAndLastDateInCalendar() when $default != null:
        return $default(_that.firstDate, _that.lastDate);
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
    TResult Function(DateTime firstDate, DateTime lastDate) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FirstAndLastDateInCalendar():
        return $default(_that.firstDate, _that.lastDate);
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
    TResult? Function(DateTime firstDate, DateTime lastDate)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FirstAndLastDateInCalendar() when $default != null:
        return $default(_that.firstDate, _that.lastDate);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FirstAndLastDateInCalendar implements FirstAndLastDateInCalendar {
  const _FirstAndLastDateInCalendar(
      {required this.firstDate, required this.lastDate});

  @override
  final DateTime firstDate;
  @override
  final DateTime lastDate;

  /// Create a copy of FirstAndLastDateInCalendar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FirstAndLastDateInCalendarCopyWith<_FirstAndLastDateInCalendar>
      get copyWith => __$FirstAndLastDateInCalendarCopyWithImpl<
          _FirstAndLastDateInCalendar>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FirstAndLastDateInCalendar &&
            (identical(other.firstDate, firstDate) ||
                other.firstDate == firstDate) &&
            (identical(other.lastDate, lastDate) ||
                other.lastDate == lastDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, firstDate, lastDate);

  @override
  String toString() {
    return 'FirstAndLastDateInCalendar(firstDate: $firstDate, lastDate: $lastDate)';
  }
}

/// @nodoc
abstract mixin class _$FirstAndLastDateInCalendarCopyWith<$Res>
    implements $FirstAndLastDateInCalendarCopyWith<$Res> {
  factory _$FirstAndLastDateInCalendarCopyWith(
          _FirstAndLastDateInCalendar value,
          $Res Function(_FirstAndLastDateInCalendar) _then) =
      __$FirstAndLastDateInCalendarCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime firstDate, DateTime lastDate});
}

/// @nodoc
class __$FirstAndLastDateInCalendarCopyWithImpl<$Res>
    implements _$FirstAndLastDateInCalendarCopyWith<$Res> {
  __$FirstAndLastDateInCalendarCopyWithImpl(this._self, this._then);

  final _FirstAndLastDateInCalendar _self;
  final $Res Function(_FirstAndLastDateInCalendar) _then;

  /// Create a copy of FirstAndLastDateInCalendar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? firstDate = null,
    Object? lastDate = null,
  }) {
    return _then(_FirstAndLastDateInCalendar(
      firstDate: null == firstDate
          ? _self.firstDate
          : firstDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastDate: null == lastDate
          ? _self.lastDate
          : lastDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
