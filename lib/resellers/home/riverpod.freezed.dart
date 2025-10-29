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
mixin _$BookingDetailsDataFetch {
  User? get resellerUser;
  ResellerData? get resellerData;
  ResellerSettings? get resellerSettings;
  AccountAndDiscount? get accountToResell;

  /// Create a copy of BookingDetailsDataFetch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookingDetailsDataFetchCopyWith<BookingDetailsDataFetch> get copyWith =>
      _$BookingDetailsDataFetchCopyWithImpl<BookingDetailsDataFetch>(
          this as BookingDetailsDataFetch, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookingDetailsDataFetch &&
            (identical(other.resellerUser, resellerUser) ||
                other.resellerUser == resellerUser) &&
            (identical(other.resellerData, resellerData) ||
                other.resellerData == resellerData) &&
            (identical(other.resellerSettings, resellerSettings) ||
                other.resellerSettings == resellerSettings) &&
            (identical(other.accountToResell, accountToResell) ||
                other.accountToResell == accountToResell));
  }

  @override
  int get hashCode => Object.hash(runtimeType, resellerUser, resellerData,
      resellerSettings, accountToResell);

  @override
  String toString() {
    return 'BookingDetailsDataFetch(resellerUser: $resellerUser, resellerData: $resellerData, resellerSettings: $resellerSettings, accountToResell: $accountToResell)';
  }
}

/// @nodoc
abstract mixin class $BookingDetailsDataFetchCopyWith<$Res> {
  factory $BookingDetailsDataFetchCopyWith(BookingDetailsDataFetch value,
          $Res Function(BookingDetailsDataFetch) _then) =
      _$BookingDetailsDataFetchCopyWithImpl;
  @useResult
  $Res call(
      {User? resellerUser,
      ResellerData? resellerData,
      ResellerSettings? resellerSettings,
      AccountAndDiscount? accountToResell});

  $ResellerDataCopyWith<$Res>? get resellerData;
  $ResellerSettingsCopyWith<$Res>? get resellerSettings;
  $AccountAndDiscountCopyWith<$Res>? get accountToResell;
}

/// @nodoc
class _$BookingDetailsDataFetchCopyWithImpl<$Res>
    implements $BookingDetailsDataFetchCopyWith<$Res> {
  _$BookingDetailsDataFetchCopyWithImpl(this._self, this._then);

  final BookingDetailsDataFetch _self;
  final $Res Function(BookingDetailsDataFetch) _then;

  /// Create a copy of BookingDetailsDataFetch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resellerUser = freezed,
    Object? resellerData = freezed,
    Object? resellerSettings = freezed,
    Object? accountToResell = freezed,
  }) {
    return _then(_self.copyWith(
      resellerUser: freezed == resellerUser
          ? _self.resellerUser
          : resellerUser // ignore: cast_nullable_to_non_nullable
              as User?,
      resellerData: freezed == resellerData
          ? _self.resellerData
          : resellerData // ignore: cast_nullable_to_non_nullable
              as ResellerData?,
      resellerSettings: freezed == resellerSettings
          ? _self.resellerSettings
          : resellerSettings // ignore: cast_nullable_to_non_nullable
              as ResellerSettings?,
      accountToResell: freezed == accountToResell
          ? _self.accountToResell
          : accountToResell // ignore: cast_nullable_to_non_nullable
              as AccountAndDiscount?,
    ));
  }

  /// Create a copy of BookingDetailsDataFetch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResellerDataCopyWith<$Res>? get resellerData {
    if (_self.resellerData == null) {
      return null;
    }

    return $ResellerDataCopyWith<$Res>(_self.resellerData!, (value) {
      return _then(_self.copyWith(resellerData: value));
    });
  }

  /// Create a copy of BookingDetailsDataFetch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResellerSettingsCopyWith<$Res>? get resellerSettings {
    if (_self.resellerSettings == null) {
      return null;
    }

    return $ResellerSettingsCopyWith<$Res>(_self.resellerSettings!, (value) {
      return _then(_self.copyWith(resellerSettings: value));
    });
  }

  /// Create a copy of BookingDetailsDataFetch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountAndDiscountCopyWith<$Res>? get accountToResell {
    if (_self.accountToResell == null) {
      return null;
    }

    return $AccountAndDiscountCopyWith<$Res>(_self.accountToResell!, (value) {
      return _then(_self.copyWith(accountToResell: value));
    });
  }
}

/// Adds pattern-matching-related methods to [BookingDetailsDataFetch].
extension BookingDetailsDataFetchPatterns on BookingDetailsDataFetch {
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
    TResult Function(_BookingDetailsDataFetch value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookingDetailsDataFetch() when $default != null:
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
    TResult Function(_BookingDetailsDataFetch value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingDetailsDataFetch():
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
    TResult? Function(_BookingDetailsDataFetch value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingDetailsDataFetch() when $default != null:
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
            User? resellerUser,
            ResellerData? resellerData,
            ResellerSettings? resellerSettings,
            AccountAndDiscount? accountToResell)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookingDetailsDataFetch() when $default != null:
        return $default(_that.resellerUser, _that.resellerData,
            _that.resellerSettings, _that.accountToResell);
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
            User? resellerUser,
            ResellerData? resellerData,
            ResellerSettings? resellerSettings,
            AccountAndDiscount? accountToResell)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingDetailsDataFetch():
        return $default(_that.resellerUser, _that.resellerData,
            _that.resellerSettings, _that.accountToResell);
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
            User? resellerUser,
            ResellerData? resellerData,
            ResellerSettings? resellerSettings,
            AccountAndDiscount? accountToResell)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingDetailsDataFetch() when $default != null:
        return $default(_that.resellerUser, _that.resellerData,
            _that.resellerSettings, _that.accountToResell);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _BookingDetailsDataFetch implements BookingDetailsDataFetch {
  const _BookingDetailsDataFetch(
      {required this.resellerUser,
      required this.resellerData,
      required this.resellerSettings,
      required this.accountToResell});

  @override
  final User? resellerUser;
  @override
  final ResellerData? resellerData;
  @override
  final ResellerSettings? resellerSettings;
  @override
  final AccountAndDiscount? accountToResell;

  /// Create a copy of BookingDetailsDataFetch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookingDetailsDataFetchCopyWith<_BookingDetailsDataFetch> get copyWith =>
      __$BookingDetailsDataFetchCopyWithImpl<_BookingDetailsDataFetch>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BookingDetailsDataFetch &&
            (identical(other.resellerUser, resellerUser) ||
                other.resellerUser == resellerUser) &&
            (identical(other.resellerData, resellerData) ||
                other.resellerData == resellerData) &&
            (identical(other.resellerSettings, resellerSettings) ||
                other.resellerSettings == resellerSettings) &&
            (identical(other.accountToResell, accountToResell) ||
                other.accountToResell == accountToResell));
  }

  @override
  int get hashCode => Object.hash(runtimeType, resellerUser, resellerData,
      resellerSettings, accountToResell);

  @override
  String toString() {
    return 'BookingDetailsDataFetch(resellerUser: $resellerUser, resellerData: $resellerData, resellerSettings: $resellerSettings, accountToResell: $accountToResell)';
  }
}

/// @nodoc
abstract mixin class _$BookingDetailsDataFetchCopyWith<$Res>
    implements $BookingDetailsDataFetchCopyWith<$Res> {
  factory _$BookingDetailsDataFetchCopyWith(_BookingDetailsDataFetch value,
          $Res Function(_BookingDetailsDataFetch) _then) =
      __$BookingDetailsDataFetchCopyWithImpl;
  @override
  @useResult
  $Res call(
      {User? resellerUser,
      ResellerData? resellerData,
      ResellerSettings? resellerSettings,
      AccountAndDiscount? accountToResell});

  @override
  $ResellerDataCopyWith<$Res>? get resellerData;
  @override
  $ResellerSettingsCopyWith<$Res>? get resellerSettings;
  @override
  $AccountAndDiscountCopyWith<$Res>? get accountToResell;
}

/// @nodoc
class __$BookingDetailsDataFetchCopyWithImpl<$Res>
    implements _$BookingDetailsDataFetchCopyWith<$Res> {
  __$BookingDetailsDataFetchCopyWithImpl(this._self, this._then);

  final _BookingDetailsDataFetch _self;
  final $Res Function(_BookingDetailsDataFetch) _then;

  /// Create a copy of BookingDetailsDataFetch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? resellerUser = freezed,
    Object? resellerData = freezed,
    Object? resellerSettings = freezed,
    Object? accountToResell = freezed,
  }) {
    return _then(_BookingDetailsDataFetch(
      resellerUser: freezed == resellerUser
          ? _self.resellerUser
          : resellerUser // ignore: cast_nullable_to_non_nullable
              as User?,
      resellerData: freezed == resellerData
          ? _self.resellerData
          : resellerData // ignore: cast_nullable_to_non_nullable
              as ResellerData?,
      resellerSettings: freezed == resellerSettings
          ? _self.resellerSettings
          : resellerSettings // ignore: cast_nullable_to_non_nullable
              as ResellerSettings?,
      accountToResell: freezed == accountToResell
          ? _self.accountToResell
          : accountToResell // ignore: cast_nullable_to_non_nullable
              as AccountAndDiscount?,
    ));
  }

  /// Create a copy of BookingDetailsDataFetch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResellerDataCopyWith<$Res>? get resellerData {
    if (_self.resellerData == null) {
      return null;
    }

    return $ResellerDataCopyWith<$Res>(_self.resellerData!, (value) {
      return _then(_self.copyWith(resellerData: value));
    });
  }

  /// Create a copy of BookingDetailsDataFetch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResellerSettingsCopyWith<$Res>? get resellerSettings {
    if (_self.resellerSettings == null) {
      return null;
    }

    return $ResellerSettingsCopyWith<$Res>(_self.resellerSettings!, (value) {
      return _then(_self.copyWith(resellerSettings: value));
    });
  }

  /// Create a copy of BookingDetailsDataFetch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountAndDiscountCopyWith<$Res>? get accountToResell {
    if (_self.accountToResell == null) {
      return null;
    }

    return $AccountAndDiscountCopyWith<$Res>(_self.accountToResell!, (value) {
      return _then(_self.copyWith(accountToResell: value));
    });
  }
}

// dart format on
