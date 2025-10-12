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
mixin _$UrlAndAmount {
  String get url;
  int get amount;

  /// Create a copy of UrlAndAmount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UrlAndAmountCopyWith<UrlAndAmount> get copyWith =>
      _$UrlAndAmountCopyWithImpl<UrlAndAmount>(
          this as UrlAndAmount, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UrlAndAmount &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, url, amount);

  @override
  String toString() {
    return 'UrlAndAmount(url: $url, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class $UrlAndAmountCopyWith<$Res> {
  factory $UrlAndAmountCopyWith(
          UrlAndAmount value, $Res Function(UrlAndAmount) _then) =
      _$UrlAndAmountCopyWithImpl;
  @useResult
  $Res call({String url, int amount});
}

/// @nodoc
class _$UrlAndAmountCopyWithImpl<$Res> implements $UrlAndAmountCopyWith<$Res> {
  _$UrlAndAmountCopyWithImpl(this._self, this._then);

  final UrlAndAmount _self;
  final $Res Function(UrlAndAmount) _then;

  /// Create a copy of UrlAndAmount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? amount = null,
  }) {
    return _then(_self.copyWith(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [UrlAndAmount].
extension UrlAndAmountPatterns on UrlAndAmount {
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
    TResult Function(_UrlAndAmount value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UrlAndAmount() when $default != null:
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
    TResult Function(_UrlAndAmount value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UrlAndAmount():
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
    TResult? Function(_UrlAndAmount value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UrlAndAmount() when $default != null:
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
    TResult Function(String url, int amount)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UrlAndAmount() when $default != null:
        return $default(_that.url, _that.amount);
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
    TResult Function(String url, int amount) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UrlAndAmount():
        return $default(_that.url, _that.amount);
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
    TResult? Function(String url, int amount)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UrlAndAmount() when $default != null:
        return $default(_that.url, _that.amount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _UrlAndAmount implements UrlAndAmount {
  const _UrlAndAmount({required this.url, required this.amount});

  @override
  final String url;
  @override
  final int amount;

  /// Create a copy of UrlAndAmount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UrlAndAmountCopyWith<_UrlAndAmount> get copyWith =>
      __$UrlAndAmountCopyWithImpl<_UrlAndAmount>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UrlAndAmount &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, url, amount);

  @override
  String toString() {
    return 'UrlAndAmount(url: $url, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class _$UrlAndAmountCopyWith<$Res>
    implements $UrlAndAmountCopyWith<$Res> {
  factory _$UrlAndAmountCopyWith(
          _UrlAndAmount value, $Res Function(_UrlAndAmount) _then) =
      __$UrlAndAmountCopyWithImpl;
  @override
  @useResult
  $Res call({String url, int amount});
}

/// @nodoc
class __$UrlAndAmountCopyWithImpl<$Res>
    implements _$UrlAndAmountCopyWith<$Res> {
  __$UrlAndAmountCopyWithImpl(this._self, this._then);

  final _UrlAndAmount _self;
  final $Res Function(_UrlAndAmount) _then;

  /// Create a copy of UrlAndAmount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? url = null,
    Object? amount = null,
  }) {
    return _then(_UrlAndAmount(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
