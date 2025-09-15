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
mixin _$BookingPricingNumberBooked implements DiagnosticableTreeMixin {
  String get tourTypePricingId;
  int get numberBooked;

  /// Create a copy of BookingPricingNumberBooked
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookingPricingNumberBookedCopyWith<BookingPricingNumberBooked>
      get copyWith =>
          _$BookingPricingNumberBookedCopyWithImpl<BookingPricingNumberBooked>(
              this as BookingPricingNumberBooked, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'BookingPricingNumberBooked'))
      ..add(DiagnosticsProperty('tourTypePricingId', tourTypePricingId))
      ..add(DiagnosticsProperty('numberBooked', numberBooked));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookingPricingNumberBooked &&
            (identical(other.tourTypePricingId, tourTypePricingId) ||
                other.tourTypePricingId == tourTypePricingId) &&
            (identical(other.numberBooked, numberBooked) ||
                other.numberBooked == numberBooked));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tourTypePricingId, numberBooked);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'BookingPricingNumberBooked(tourTypePricingId: $tourTypePricingId, numberBooked: $numberBooked)';
  }
}

/// @nodoc
abstract mixin class $BookingPricingNumberBookedCopyWith<$Res> {
  factory $BookingPricingNumberBookedCopyWith(BookingPricingNumberBooked value,
          $Res Function(BookingPricingNumberBooked) _then) =
      _$BookingPricingNumberBookedCopyWithImpl;
  @useResult
  $Res call({String tourTypePricingId, int numberBooked});
}

/// @nodoc
class _$BookingPricingNumberBookedCopyWithImpl<$Res>
    implements $BookingPricingNumberBookedCopyWith<$Res> {
  _$BookingPricingNumberBookedCopyWithImpl(this._self, this._then);

  final BookingPricingNumberBooked _self;
  final $Res Function(BookingPricingNumberBooked) _then;

  /// Create a copy of BookingPricingNumberBooked
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tourTypePricingId = null,
    Object? numberBooked = null,
  }) {
    return _then(_self.copyWith(
      tourTypePricingId: null == tourTypePricingId
          ? _self.tourTypePricingId
          : tourTypePricingId // ignore: cast_nullable_to_non_nullable
              as String,
      numberBooked: null == numberBooked
          ? _self.numberBooked
          : numberBooked // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [BookingPricingNumberBooked].
extension BookingPricingNumberBookedPatterns on BookingPricingNumberBooked {
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
    TResult Function(_BookingPricingNumberBooked value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookingPricingNumberBooked() when $default != null:
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
    TResult Function(_BookingPricingNumberBooked value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingPricingNumberBooked():
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
    TResult? Function(_BookingPricingNumberBooked value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingPricingNumberBooked() when $default != null:
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
    TResult Function(String tourTypePricingId, int numberBooked)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookingPricingNumberBooked() when $default != null:
        return $default(_that.tourTypePricingId, _that.numberBooked);
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
    TResult Function(String tourTypePricingId, int numberBooked) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingPricingNumberBooked():
        return $default(_that.tourTypePricingId, _that.numberBooked);
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
    TResult? Function(String tourTypePricingId, int numberBooked)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingPricingNumberBooked() when $default != null:
        return $default(_that.tourTypePricingId, _that.numberBooked);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _BookingPricingNumberBooked
    with DiagnosticableTreeMixin
    implements BookingPricingNumberBooked {
  const _BookingPricingNumberBooked(
      {required this.tourTypePricingId, this.numberBooked = 0});

  @override
  final String tourTypePricingId;
  @override
  @JsonKey()
  final int numberBooked;

  /// Create a copy of BookingPricingNumberBooked
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookingPricingNumberBookedCopyWith<_BookingPricingNumberBooked>
      get copyWith => __$BookingPricingNumberBookedCopyWithImpl<
          _BookingPricingNumberBooked>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'BookingPricingNumberBooked'))
      ..add(DiagnosticsProperty('tourTypePricingId', tourTypePricingId))
      ..add(DiagnosticsProperty('numberBooked', numberBooked));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BookingPricingNumberBooked &&
            (identical(other.tourTypePricingId, tourTypePricingId) ||
                other.tourTypePricingId == tourTypePricingId) &&
            (identical(other.numberBooked, numberBooked) ||
                other.numberBooked == numberBooked));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tourTypePricingId, numberBooked);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'BookingPricingNumberBooked(tourTypePricingId: $tourTypePricingId, numberBooked: $numberBooked)';
  }
}

/// @nodoc
abstract mixin class _$BookingPricingNumberBookedCopyWith<$Res>
    implements $BookingPricingNumberBookedCopyWith<$Res> {
  factory _$BookingPricingNumberBookedCopyWith(
          _BookingPricingNumberBooked value,
          $Res Function(_BookingPricingNumberBooked) _then) =
      __$BookingPricingNumberBookedCopyWithImpl;
  @override
  @useResult
  $Res call({String tourTypePricingId, int numberBooked});
}

/// @nodoc
class __$BookingPricingNumberBookedCopyWithImpl<$Res>
    implements _$BookingPricingNumberBookedCopyWith<$Res> {
  __$BookingPricingNumberBookedCopyWithImpl(this._self, this._then);

  final _BookingPricingNumberBooked _self;
  final $Res Function(_BookingPricingNumberBooked) _then;

  /// Create a copy of BookingPricingNumberBooked
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tourTypePricingId = null,
    Object? numberBooked = null,
  }) {
    return _then(_BookingPricingNumberBooked(
      tourTypePricingId: null == tourTypePricingId
          ? _self.tourTypePricingId
          : tourTypePricingId // ignore: cast_nullable_to_non_nullable
              as String,
      numberBooked: null == numberBooked
          ? _self.numberBooked
          : numberBooked // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
