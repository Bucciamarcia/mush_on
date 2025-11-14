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
mixin _$DateRangeSelection {
  DateTime get start;
  DateTime get end;

  /// Create a copy of DateRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DateRangeSelectionCopyWith<DateRangeSelection> get copyWith =>
      _$DateRangeSelectionCopyWithImpl<DateRangeSelection>(
          this as DateRangeSelection, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DateRangeSelection &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @override
  int get hashCode => Object.hash(runtimeType, start, end);

  @override
  String toString() {
    return 'DateRangeSelection(start: $start, end: $end)';
  }
}

/// @nodoc
abstract mixin class $DateRangeSelectionCopyWith<$Res> {
  factory $DateRangeSelectionCopyWith(
          DateRangeSelection value, $Res Function(DateRangeSelection) _then) =
      _$DateRangeSelectionCopyWithImpl;
  @useResult
  $Res call({DateTime start, DateTime end});
}

/// @nodoc
class _$DateRangeSelectionCopyWithImpl<$Res>
    implements $DateRangeSelectionCopyWith<$Res> {
  _$DateRangeSelectionCopyWithImpl(this._self, this._then);

  final DateRangeSelection _self;
  final $Res Function(DateRangeSelection) _then;

  /// Create a copy of DateRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_self.copyWith(
      start: null == start
          ? _self.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: null == end
          ? _self.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [DateRangeSelection].
extension DateRangeSelectionPatterns on DateRangeSelection {
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
    TResult Function(_DateRangeSelection value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DateRangeSelection() when $default != null:
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
    TResult Function(_DateRangeSelection value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DateRangeSelection():
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
    TResult? Function(_DateRangeSelection value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DateRangeSelection() when $default != null:
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
    TResult Function(DateTime start, DateTime end)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DateRangeSelection() when $default != null:
        return $default(_that.start, _that.end);
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
    TResult Function(DateTime start, DateTime end) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DateRangeSelection():
        return $default(_that.start, _that.end);
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
    TResult? Function(DateTime start, DateTime end)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DateRangeSelection() when $default != null:
        return $default(_that.start, _that.end);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DateRangeSelection implements DateRangeSelection {
  const _DateRangeSelection({required this.start, required this.end});

  @override
  final DateTime start;
  @override
  final DateTime end;

  /// Create a copy of DateRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DateRangeSelectionCopyWith<_DateRangeSelection> get copyWith =>
      __$DateRangeSelectionCopyWithImpl<_DateRangeSelection>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DateRangeSelection &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @override
  int get hashCode => Object.hash(runtimeType, start, end);

  @override
  String toString() {
    return 'DateRangeSelection(start: $start, end: $end)';
  }
}

/// @nodoc
abstract mixin class _$DateRangeSelectionCopyWith<$Res>
    implements $DateRangeSelectionCopyWith<$Res> {
  factory _$DateRangeSelectionCopyWith(
          _DateRangeSelection value, $Res Function(_DateRangeSelection) _then) =
      __$DateRangeSelectionCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime start, DateTime end});
}

/// @nodoc
class __$DateRangeSelectionCopyWithImpl<$Res>
    implements _$DateRangeSelectionCopyWith<$Res> {
  __$DateRangeSelectionCopyWithImpl(this._self, this._then);

  final _DateRangeSelection _self;
  final $Res Function(_DateRangeSelection) _then;

  /// Create a copy of DateRangeSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_DateRangeSelection(
      start: null == start
          ? _self.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: null == end
          ? _self.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
