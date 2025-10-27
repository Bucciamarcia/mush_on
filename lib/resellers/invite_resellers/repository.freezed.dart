// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reseller {
  String get uid;
  String get email;

  /// The account names associated with this reseller
  List<AccountAndDiscount> get resellerAccounts;

  /// Create a copy of Reseller
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResellerCopyWith<Reseller> get copyWith =>
      _$ResellerCopyWithImpl<Reseller>(this as Reseller, _$identity);

  /// Serializes this Reseller to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Reseller &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            const DeepCollectionEquality()
                .equals(other.resellerAccounts, resellerAccounts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, email,
      const DeepCollectionEquality().hash(resellerAccounts));

  @override
  String toString() {
    return 'Reseller(uid: $uid, email: $email, resellerAccounts: $resellerAccounts)';
  }
}

/// @nodoc
abstract mixin class $ResellerCopyWith<$Res> {
  factory $ResellerCopyWith(Reseller value, $Res Function(Reseller) _then) =
      _$ResellerCopyWithImpl;
  @useResult
  $Res call(
      {String uid, String email, List<AccountAndDiscount> resellerAccounts});
}

/// @nodoc
class _$ResellerCopyWithImpl<$Res> implements $ResellerCopyWith<$Res> {
  _$ResellerCopyWithImpl(this._self, this._then);

  final Reseller _self;
  final $Res Function(Reseller) _then;

  /// Create a copy of Reseller
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? resellerAccounts = null,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      resellerAccounts: null == resellerAccounts
          ? _self.resellerAccounts
          : resellerAccounts // ignore: cast_nullable_to_non_nullable
              as List<AccountAndDiscount>,
    ));
  }
}

/// Adds pattern-matching-related methods to [Reseller].
extension ResellerPatterns on Reseller {
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
    TResult Function(_Reseller value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Reseller() when $default != null:
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
    TResult Function(_Reseller value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Reseller():
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
    TResult? Function(_Reseller value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Reseller() when $default != null:
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
    TResult Function(String uid, String email,
            List<AccountAndDiscount> resellerAccounts)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Reseller() when $default != null:
        return $default(_that.uid, _that.email, _that.resellerAccounts);
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
            String uid, String email, List<AccountAndDiscount> resellerAccounts)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Reseller():
        return $default(_that.uid, _that.email, _that.resellerAccounts);
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
    TResult? Function(String uid, String email,
            List<AccountAndDiscount> resellerAccounts)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Reseller() when $default != null:
        return $default(_that.uid, _that.email, _that.resellerAccounts);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Reseller implements Reseller {
  const _Reseller(
      {required this.uid,
      required this.email,
      required final List<AccountAndDiscount> resellerAccounts})
      : _resellerAccounts = resellerAccounts;
  factory _Reseller.fromJson(Map<String, dynamic> json) =>
      _$ResellerFromJson(json);

  @override
  final String uid;
  @override
  final String email;

  /// The account names associated with this reseller
  final List<AccountAndDiscount> _resellerAccounts;

  /// The account names associated with this reseller
  @override
  List<AccountAndDiscount> get resellerAccounts {
    if (_resellerAccounts is EqualUnmodifiableListView)
      return _resellerAccounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_resellerAccounts);
  }

  /// Create a copy of Reseller
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ResellerCopyWith<_Reseller> get copyWith =>
      __$ResellerCopyWithImpl<_Reseller>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ResellerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Reseller &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            const DeepCollectionEquality()
                .equals(other._resellerAccounts, _resellerAccounts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, email,
      const DeepCollectionEquality().hash(_resellerAccounts));

  @override
  String toString() {
    return 'Reseller(uid: $uid, email: $email, resellerAccounts: $resellerAccounts)';
  }
}

/// @nodoc
abstract mixin class _$ResellerCopyWith<$Res>
    implements $ResellerCopyWith<$Res> {
  factory _$ResellerCopyWith(_Reseller value, $Res Function(_Reseller) _then) =
      __$ResellerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uid, String email, List<AccountAndDiscount> resellerAccounts});
}

/// @nodoc
class __$ResellerCopyWithImpl<$Res> implements _$ResellerCopyWith<$Res> {
  __$ResellerCopyWithImpl(this._self, this._then);

  final _Reseller _self;
  final $Res Function(_Reseller) _then;

  /// Create a copy of Reseller
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? resellerAccounts = null,
  }) {
    return _then(_Reseller(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      resellerAccounts: null == resellerAccounts
          ? _self._resellerAccounts
          : resellerAccounts // ignore: cast_nullable_to_non_nullable
              as List<AccountAndDiscount>,
    ));
  }
}

/// @nodoc
mixin _$AccountAndDiscount {
  /// The name of the account being resold
  String get accountName;

  /// The amount of the discount in %, eg. 0.15 for 15%
  double get discountAmount;

  /// Create a copy of AccountAndDiscount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountAndDiscountCopyWith<AccountAndDiscount> get copyWith =>
      _$AccountAndDiscountCopyWithImpl<AccountAndDiscount>(
          this as AccountAndDiscount, _$identity);

  /// Serializes this AccountAndDiscount to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountAndDiscount &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accountName, discountAmount);

  @override
  String toString() {
    return 'AccountAndDiscount(accountName: $accountName, discountAmount: $discountAmount)';
  }
}

/// @nodoc
abstract mixin class $AccountAndDiscountCopyWith<$Res> {
  factory $AccountAndDiscountCopyWith(
          AccountAndDiscount value, $Res Function(AccountAndDiscount) _then) =
      _$AccountAndDiscountCopyWithImpl;
  @useResult
  $Res call({String accountName, double discountAmount});
}

/// @nodoc
class _$AccountAndDiscountCopyWithImpl<$Res>
    implements $AccountAndDiscountCopyWith<$Res> {
  _$AccountAndDiscountCopyWithImpl(this._self, this._then);

  final AccountAndDiscount _self;
  final $Res Function(AccountAndDiscount) _then;

  /// Create a copy of AccountAndDiscount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountName = null,
    Object? discountAmount = null,
  }) {
    return _then(_self.copyWith(
      accountName: null == accountName
          ? _self.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      discountAmount: null == discountAmount
          ? _self.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [AccountAndDiscount].
extension AccountAndDiscountPatterns on AccountAndDiscount {
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
    TResult Function(_AccountAndDiscount value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountAndDiscount() when $default != null:
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
    TResult Function(_AccountAndDiscount value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountAndDiscount():
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
    TResult? Function(_AccountAndDiscount value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountAndDiscount() when $default != null:
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
    TResult Function(String accountName, double discountAmount)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountAndDiscount() when $default != null:
        return $default(_that.accountName, _that.discountAmount);
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
    TResult Function(String accountName, double discountAmount) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountAndDiscount():
        return $default(_that.accountName, _that.discountAmount);
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
    TResult? Function(String accountName, double discountAmount)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountAndDiscount() when $default != null:
        return $default(_that.accountName, _that.discountAmount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AccountAndDiscount implements AccountAndDiscount {
  const _AccountAndDiscount(
      {required this.accountName, required this.discountAmount});
  factory _AccountAndDiscount.fromJson(Map<String, dynamic> json) =>
      _$AccountAndDiscountFromJson(json);

  /// The name of the account being resold
  @override
  final String accountName;

  /// The amount of the discount in %, eg. 0.15 for 15%
  @override
  final double discountAmount;

  /// Create a copy of AccountAndDiscount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccountAndDiscountCopyWith<_AccountAndDiscount> get copyWith =>
      __$AccountAndDiscountCopyWithImpl<_AccountAndDiscount>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AccountAndDiscountToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountAndDiscount &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accountName, discountAmount);

  @override
  String toString() {
    return 'AccountAndDiscount(accountName: $accountName, discountAmount: $discountAmount)';
  }
}

/// @nodoc
abstract mixin class _$AccountAndDiscountCopyWith<$Res>
    implements $AccountAndDiscountCopyWith<$Res> {
  factory _$AccountAndDiscountCopyWith(
          _AccountAndDiscount value, $Res Function(_AccountAndDiscount) _then) =
      __$AccountAndDiscountCopyWithImpl;
  @override
  @useResult
  $Res call({String accountName, double discountAmount});
}

/// @nodoc
class __$AccountAndDiscountCopyWithImpl<$Res>
    implements _$AccountAndDiscountCopyWith<$Res> {
  __$AccountAndDiscountCopyWithImpl(this._self, this._then);

  final _AccountAndDiscount _self;
  final $Res Function(_AccountAndDiscount) _then;

  /// Create a copy of AccountAndDiscount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accountName = null,
    Object? discountAmount = null,
  }) {
    return _then(_AccountAndDiscount(
      accountName: null == accountName
          ? _self.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      discountAmount: null == discountAmount
          ? _self.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$ResellerInvitation {
  bool get accepted;
  String get account;
  int get discount;
  String get email;
  String get securityCode;

  /// Create a copy of ResellerInvitation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResellerInvitationCopyWith<ResellerInvitation> get copyWith =>
      _$ResellerInvitationCopyWithImpl<ResellerInvitation>(
          this as ResellerInvitation, _$identity);

  /// Serializes this ResellerInvitation to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResellerInvitation &&
            (identical(other.accepted, accepted) ||
                other.accepted == accepted) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.securityCode, securityCode) ||
                other.securityCode == securityCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, accepted, account, discount, email, securityCode);

  @override
  String toString() {
    return 'ResellerInvitation(accepted: $accepted, account: $account, discount: $discount, email: $email, securityCode: $securityCode)';
  }
}

/// @nodoc
abstract mixin class $ResellerInvitationCopyWith<$Res> {
  factory $ResellerInvitationCopyWith(
          ResellerInvitation value, $Res Function(ResellerInvitation) _then) =
      _$ResellerInvitationCopyWithImpl;
  @useResult
  $Res call(
      {bool accepted,
      String account,
      int discount,
      String email,
      String securityCode});
}

/// @nodoc
class _$ResellerInvitationCopyWithImpl<$Res>
    implements $ResellerInvitationCopyWith<$Res> {
  _$ResellerInvitationCopyWithImpl(this._self, this._then);

  final ResellerInvitation _self;
  final $Res Function(ResellerInvitation) _then;

  /// Create a copy of ResellerInvitation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accepted = null,
    Object? account = null,
    Object? discount = null,
    Object? email = null,
    Object? securityCode = null,
  }) {
    return _then(_self.copyWith(
      accepted: null == accepted
          ? _self.accepted
          : accepted // ignore: cast_nullable_to_non_nullable
              as bool,
      account: null == account
          ? _self.account
          : account // ignore: cast_nullable_to_non_nullable
              as String,
      discount: null == discount
          ? _self.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      securityCode: null == securityCode
          ? _self.securityCode
          : securityCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ResellerInvitation].
extension ResellerInvitationPatterns on ResellerInvitation {
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
    TResult Function(_ResellerInvitation value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResellerInvitation() when $default != null:
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
    TResult Function(_ResellerInvitation value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResellerInvitation():
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
    TResult? Function(_ResellerInvitation value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResellerInvitation() when $default != null:
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
    TResult Function(bool accepted, String account, int discount, String email,
            String securityCode)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResellerInvitation() when $default != null:
        return $default(_that.accepted, _that.account, _that.discount,
            _that.email, _that.securityCode);
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
    TResult Function(bool accepted, String account, int discount, String email,
            String securityCode)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResellerInvitation():
        return $default(_that.accepted, _that.account, _that.discount,
            _that.email, _that.securityCode);
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
    TResult? Function(bool accepted, String account, int discount, String email,
            String securityCode)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResellerInvitation() when $default != null:
        return $default(_that.accepted, _that.account, _that.discount,
            _that.email, _that.securityCode);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ResellerInvitation implements ResellerInvitation {
  const _ResellerInvitation(
      {required this.accepted,
      required this.account,
      required this.discount,
      required this.email,
      required this.securityCode});
  factory _ResellerInvitation.fromJson(Map<String, dynamic> json) =>
      _$ResellerInvitationFromJson(json);

  @override
  final bool accepted;
  @override
  final String account;
  @override
  final int discount;
  @override
  final String email;
  @override
  final String securityCode;

  /// Create a copy of ResellerInvitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ResellerInvitationCopyWith<_ResellerInvitation> get copyWith =>
      __$ResellerInvitationCopyWithImpl<_ResellerInvitation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ResellerInvitationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResellerInvitation &&
            (identical(other.accepted, accepted) ||
                other.accepted == accepted) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.securityCode, securityCode) ||
                other.securityCode == securityCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, accepted, account, discount, email, securityCode);

  @override
  String toString() {
    return 'ResellerInvitation(accepted: $accepted, account: $account, discount: $discount, email: $email, securityCode: $securityCode)';
  }
}

/// @nodoc
abstract mixin class _$ResellerInvitationCopyWith<$Res>
    implements $ResellerInvitationCopyWith<$Res> {
  factory _$ResellerInvitationCopyWith(
          _ResellerInvitation value, $Res Function(_ResellerInvitation) _then) =
      __$ResellerInvitationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool accepted,
      String account,
      int discount,
      String email,
      String securityCode});
}

/// @nodoc
class __$ResellerInvitationCopyWithImpl<$Res>
    implements _$ResellerInvitationCopyWith<$Res> {
  __$ResellerInvitationCopyWithImpl(this._self, this._then);

  final _ResellerInvitation _self;
  final $Res Function(_ResellerInvitation) _then;

  /// Create a copy of ResellerInvitation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accepted = null,
    Object? account = null,
    Object? discount = null,
    Object? email = null,
    Object? securityCode = null,
  }) {
    return _then(_ResellerInvitation(
      accepted: null == accepted
          ? _self.accepted
          : accepted // ignore: cast_nullable_to_non_nullable
              as bool,
      account: null == account
          ? _self.account
          : account // ignore: cast_nullable_to_non_nullable
              as String,
      discount: null == discount
          ? _self.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      securityCode: null == securityCode
          ? _self.securityCode
          : securityCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
