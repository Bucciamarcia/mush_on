// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stripe_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StripeConnection {
  String get accountId;
  bool get isActive;

  /// Create a copy of StripeConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StripeConnectionCopyWith<StripeConnection> get copyWith =>
      _$StripeConnectionCopyWithImpl<StripeConnection>(
          this as StripeConnection, _$identity);

  /// Serializes this StripeConnection to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StripeConnection &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accountId, isActive);

  @override
  String toString() {
    return 'StripeConnection(accountId: $accountId, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class $StripeConnectionCopyWith<$Res> {
  factory $StripeConnectionCopyWith(
          StripeConnection value, $Res Function(StripeConnection) _then) =
      _$StripeConnectionCopyWithImpl;
  @useResult
  $Res call({String accountId, bool isActive});
}

/// @nodoc
class _$StripeConnectionCopyWithImpl<$Res>
    implements $StripeConnectionCopyWith<$Res> {
  _$StripeConnectionCopyWithImpl(this._self, this._then);

  final StripeConnection _self;
  final $Res Function(StripeConnection) _then;

  /// Create a copy of StripeConnection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? isActive = null,
  }) {
    return _then(_self.copyWith(
      accountId: null == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [StripeConnection].
extension StripeConnectionPatterns on StripeConnection {
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
    TResult Function(_StripeConnection value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StripeConnection() when $default != null:
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
    TResult Function(_StripeConnection value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StripeConnection():
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
    TResult? Function(_StripeConnection value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StripeConnection() when $default != null:
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
    TResult Function(String accountId, bool isActive)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StripeConnection() when $default != null:
        return $default(_that.accountId, _that.isActive);
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
    TResult Function(String accountId, bool isActive) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StripeConnection():
        return $default(_that.accountId, _that.isActive);
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
    TResult? Function(String accountId, bool isActive)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StripeConnection() when $default != null:
        return $default(_that.accountId, _that.isActive);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _StripeConnection implements StripeConnection {
  const _StripeConnection({required this.accountId, this.isActive = false});
  factory _StripeConnection.fromJson(Map<String, dynamic> json) =>
      _$StripeConnectionFromJson(json);

  @override
  final String accountId;
  @override
  @JsonKey()
  final bool isActive;

  /// Create a copy of StripeConnection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StripeConnectionCopyWith<_StripeConnection> get copyWith =>
      __$StripeConnectionCopyWithImpl<_StripeConnection>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StripeConnectionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StripeConnection &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accountId, isActive);

  @override
  String toString() {
    return 'StripeConnection(accountId: $accountId, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class _$StripeConnectionCopyWith<$Res>
    implements $StripeConnectionCopyWith<$Res> {
  factory _$StripeConnectionCopyWith(
          _StripeConnection value, $Res Function(_StripeConnection) _then) =
      __$StripeConnectionCopyWithImpl;
  @override
  @useResult
  $Res call({String accountId, bool isActive});
}

/// @nodoc
class __$StripeConnectionCopyWithImpl<$Res>
    implements _$StripeConnectionCopyWith<$Res> {
  __$StripeConnectionCopyWithImpl(this._self, this._then);

  final _StripeConnection _self;
  final $Res Function(_StripeConnection) _then;

  /// Create a copy of StripeConnection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accountId = null,
    Object? isActive = null,
  }) {
    return _then(_StripeConnection(
      accountId: null == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$CheckoutSession {
  String get checkoutSessionId;

  /// The name of the account that this payment goes to.
  String get account;

  /// The ID of the booking
  String get bookingId;

  /// The Stripe ID of the account.
  String get stripeId;
  @NonNullableTimestampConverter()
  DateTime get createdAt;
  bool get webhookProcessed;

  /// Create a copy of CheckoutSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CheckoutSessionCopyWith<CheckoutSession> get copyWith =>
      _$CheckoutSessionCopyWithImpl<CheckoutSession>(
          this as CheckoutSession, _$identity);

  /// Serializes this CheckoutSession to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CheckoutSession &&
            (identical(other.checkoutSessionId, checkoutSessionId) ||
                other.checkoutSessionId == checkoutSessionId) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.stripeId, stripeId) ||
                other.stripeId == stripeId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.webhookProcessed, webhookProcessed) ||
                other.webhookProcessed == webhookProcessed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, checkoutSessionId, account,
      bookingId, stripeId, createdAt, webhookProcessed);

  @override
  String toString() {
    return 'CheckoutSession(checkoutSessionId: $checkoutSessionId, account: $account, bookingId: $bookingId, stripeId: $stripeId, createdAt: $createdAt, webhookProcessed: $webhookProcessed)';
  }
}

/// @nodoc
abstract mixin class $CheckoutSessionCopyWith<$Res> {
  factory $CheckoutSessionCopyWith(
          CheckoutSession value, $Res Function(CheckoutSession) _then) =
      _$CheckoutSessionCopyWithImpl;
  @useResult
  $Res call(
      {String checkoutSessionId,
      String account,
      String bookingId,
      String stripeId,
      @NonNullableTimestampConverter() DateTime createdAt,
      bool webhookProcessed});
}

/// @nodoc
class _$CheckoutSessionCopyWithImpl<$Res>
    implements $CheckoutSessionCopyWith<$Res> {
  _$CheckoutSessionCopyWithImpl(this._self, this._then);

  final CheckoutSession _self;
  final $Res Function(CheckoutSession) _then;

  /// Create a copy of CheckoutSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkoutSessionId = null,
    Object? account = null,
    Object? bookingId = null,
    Object? stripeId = null,
    Object? createdAt = null,
    Object? webhookProcessed = null,
  }) {
    return _then(_self.copyWith(
      checkoutSessionId: null == checkoutSessionId
          ? _self.checkoutSessionId
          : checkoutSessionId // ignore: cast_nullable_to_non_nullable
              as String,
      account: null == account
          ? _self.account
          : account // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      stripeId: null == stripeId
          ? _self.stripeId
          : stripeId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      webhookProcessed: null == webhookProcessed
          ? _self.webhookProcessed
          : webhookProcessed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [CheckoutSession].
extension CheckoutSessionPatterns on CheckoutSession {
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
    TResult Function(_CheckoutSession value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CheckoutSession() when $default != null:
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
    TResult Function(_CheckoutSession value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutSession():
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
    TResult? Function(_CheckoutSession value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutSession() when $default != null:
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
            String checkoutSessionId,
            String account,
            String bookingId,
            String stripeId,
            @NonNullableTimestampConverter() DateTime createdAt,
            bool webhookProcessed)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CheckoutSession() when $default != null:
        return $default(_that.checkoutSessionId, _that.account, _that.bookingId,
            _that.stripeId, _that.createdAt, _that.webhookProcessed);
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
            String checkoutSessionId,
            String account,
            String bookingId,
            String stripeId,
            @NonNullableTimestampConverter() DateTime createdAt,
            bool webhookProcessed)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutSession():
        return $default(_that.checkoutSessionId, _that.account, _that.bookingId,
            _that.stripeId, _that.createdAt, _that.webhookProcessed);
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
            String checkoutSessionId,
            String account,
            String bookingId,
            String stripeId,
            @NonNullableTimestampConverter() DateTime createdAt,
            bool webhookProcessed)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CheckoutSession() when $default != null:
        return $default(_that.checkoutSessionId, _that.account, _that.bookingId,
            _that.stripeId, _that.createdAt, _that.webhookProcessed);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CheckoutSession implements CheckoutSession {
  const _CheckoutSession(
      {required this.checkoutSessionId,
      required this.account,
      required this.bookingId,
      required this.stripeId,
      @NonNullableTimestampConverter() required this.createdAt,
      required this.webhookProcessed});
  factory _CheckoutSession.fromJson(Map<String, dynamic> json) =>
      _$CheckoutSessionFromJson(json);

  @override
  final String checkoutSessionId;

  /// The name of the account that this payment goes to.
  @override
  final String account;

  /// The ID of the booking
  @override
  final String bookingId;

  /// The Stripe ID of the account.
  @override
  final String stripeId;
  @override
  @NonNullableTimestampConverter()
  final DateTime createdAt;
  @override
  final bool webhookProcessed;

  /// Create a copy of CheckoutSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CheckoutSessionCopyWith<_CheckoutSession> get copyWith =>
      __$CheckoutSessionCopyWithImpl<_CheckoutSession>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CheckoutSessionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CheckoutSession &&
            (identical(other.checkoutSessionId, checkoutSessionId) ||
                other.checkoutSessionId == checkoutSessionId) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.stripeId, stripeId) ||
                other.stripeId == stripeId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.webhookProcessed, webhookProcessed) ||
                other.webhookProcessed == webhookProcessed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, checkoutSessionId, account,
      bookingId, stripeId, createdAt, webhookProcessed);

  @override
  String toString() {
    return 'CheckoutSession(checkoutSessionId: $checkoutSessionId, account: $account, bookingId: $bookingId, stripeId: $stripeId, createdAt: $createdAt, webhookProcessed: $webhookProcessed)';
  }
}

/// @nodoc
abstract mixin class _$CheckoutSessionCopyWith<$Res>
    implements $CheckoutSessionCopyWith<$Res> {
  factory _$CheckoutSessionCopyWith(
          _CheckoutSession value, $Res Function(_CheckoutSession) _then) =
      __$CheckoutSessionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String checkoutSessionId,
      String account,
      String bookingId,
      String stripeId,
      @NonNullableTimestampConverter() DateTime createdAt,
      bool webhookProcessed});
}

/// @nodoc
class __$CheckoutSessionCopyWithImpl<$Res>
    implements _$CheckoutSessionCopyWith<$Res> {
  __$CheckoutSessionCopyWithImpl(this._self, this._then);

  final _CheckoutSession _self;
  final $Res Function(_CheckoutSession) _then;

  /// Create a copy of CheckoutSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? checkoutSessionId = null,
    Object? account = null,
    Object? bookingId = null,
    Object? stripeId = null,
    Object? createdAt = null,
    Object? webhookProcessed = null,
  }) {
    return _then(_CheckoutSession(
      checkoutSessionId: null == checkoutSessionId
          ? _self.checkoutSessionId
          : checkoutSessionId // ignore: cast_nullable_to_non_nullable
              as String,
      account: null == account
          ? _self.account
          : account // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      stripeId: null == stripeId
          ? _self.stripeId
          : stripeId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      webhookProcessed: null == webhookProcessed
          ? _self.webhookProcessed
          : webhookProcessed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$BookingManagerKennelInfo {
  String get name;
  String get url;
  String get email;
  String get cancellationPolicy;

  /// The vat rate to apply to the platform commission. 0 (reverse charged) unless in Finland, then 0.255.
  double get vatRate;

  /// The commission rate of the platform on payments. Defaults to 3.5%.
  double get commissionRate;

  /// Create a copy of BookingManagerKennelInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookingManagerKennelInfoCopyWith<BookingManagerKennelInfo> get copyWith =>
      _$BookingManagerKennelInfoCopyWithImpl<BookingManagerKennelInfo>(
          this as BookingManagerKennelInfo, _$identity);

  /// Serializes this BookingManagerKennelInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookingManagerKennelInfo &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.cancellationPolicy, cancellationPolicy) ||
                other.cancellationPolicy == cancellationPolicy) &&
            (identical(other.vatRate, vatRate) || other.vatRate == vatRate) &&
            (identical(other.commissionRate, commissionRate) ||
                other.commissionRate == commissionRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, url, email,
      cancellationPolicy, vatRate, commissionRate);

  @override
  String toString() {
    return 'BookingManagerKennelInfo(name: $name, url: $url, email: $email, cancellationPolicy: $cancellationPolicy, vatRate: $vatRate, commissionRate: $commissionRate)';
  }
}

/// @nodoc
abstract mixin class $BookingManagerKennelInfoCopyWith<$Res> {
  factory $BookingManagerKennelInfoCopyWith(BookingManagerKennelInfo value,
          $Res Function(BookingManagerKennelInfo) _then) =
      _$BookingManagerKennelInfoCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      String url,
      String email,
      String cancellationPolicy,
      double vatRate,
      double commissionRate});
}

/// @nodoc
class _$BookingManagerKennelInfoCopyWithImpl<$Res>
    implements $BookingManagerKennelInfoCopyWith<$Res> {
  _$BookingManagerKennelInfoCopyWithImpl(this._self, this._then);

  final BookingManagerKennelInfo _self;
  final $Res Function(BookingManagerKennelInfo) _then;

  /// Create a copy of BookingManagerKennelInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? url = null,
    Object? email = null,
    Object? cancellationPolicy = null,
    Object? vatRate = null,
    Object? commissionRate = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      cancellationPolicy: null == cancellationPolicy
          ? _self.cancellationPolicy
          : cancellationPolicy // ignore: cast_nullable_to_non_nullable
              as String,
      vatRate: null == vatRate
          ? _self.vatRate
          : vatRate // ignore: cast_nullable_to_non_nullable
              as double,
      commissionRate: null == commissionRate
          ? _self.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [BookingManagerKennelInfo].
extension BookingManagerKennelInfoPatterns on BookingManagerKennelInfo {
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
    TResult Function(_BookingManagerKennelInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookingManagerKennelInfo() when $default != null:
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
    TResult Function(_BookingManagerKennelInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingManagerKennelInfo():
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
    TResult? Function(_BookingManagerKennelInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingManagerKennelInfo() when $default != null:
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
    TResult Function(String name, String url, String email,
            String cancellationPolicy, double vatRate, double commissionRate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookingManagerKennelInfo() when $default != null:
        return $default(_that.name, _that.url, _that.email,
            _that.cancellationPolicy, _that.vatRate, _that.commissionRate);
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
    TResult Function(String name, String url, String email,
            String cancellationPolicy, double vatRate, double commissionRate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingManagerKennelInfo():
        return $default(_that.name, _that.url, _that.email,
            _that.cancellationPolicy, _that.vatRate, _that.commissionRate);
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
    TResult? Function(String name, String url, String email,
            String cancellationPolicy, double vatRate, double commissionRate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookingManagerKennelInfo() when $default != null:
        return $default(_that.name, _that.url, _that.email,
            _that.cancellationPolicy, _that.vatRate, _that.commissionRate);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BookingManagerKennelInfo implements BookingManagerKennelInfo {
  const _BookingManagerKennelInfo(
      {required this.name,
      required this.url,
      required this.email,
      required this.cancellationPolicy,
      this.vatRate = 0,
      this.commissionRate = 0.035});
  factory _BookingManagerKennelInfo.fromJson(Map<String, dynamic> json) =>
      _$BookingManagerKennelInfoFromJson(json);

  @override
  final String name;
  @override
  final String url;
  @override
  final String email;
  @override
  final String cancellationPolicy;

  /// The vat rate to apply to the platform commission. 0 (reverse charged) unless in Finland, then 0.255.
  @override
  @JsonKey()
  final double vatRate;

  /// The commission rate of the platform on payments. Defaults to 3.5%.
  @override
  @JsonKey()
  final double commissionRate;

  /// Create a copy of BookingManagerKennelInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookingManagerKennelInfoCopyWith<_BookingManagerKennelInfo> get copyWith =>
      __$BookingManagerKennelInfoCopyWithImpl<_BookingManagerKennelInfo>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BookingManagerKennelInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BookingManagerKennelInfo &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.cancellationPolicy, cancellationPolicy) ||
                other.cancellationPolicy == cancellationPolicy) &&
            (identical(other.vatRate, vatRate) || other.vatRate == vatRate) &&
            (identical(other.commissionRate, commissionRate) ||
                other.commissionRate == commissionRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, url, email,
      cancellationPolicy, vatRate, commissionRate);

  @override
  String toString() {
    return 'BookingManagerKennelInfo(name: $name, url: $url, email: $email, cancellationPolicy: $cancellationPolicy, vatRate: $vatRate, commissionRate: $commissionRate)';
  }
}

/// @nodoc
abstract mixin class _$BookingManagerKennelInfoCopyWith<$Res>
    implements $BookingManagerKennelInfoCopyWith<$Res> {
  factory _$BookingManagerKennelInfoCopyWith(_BookingManagerKennelInfo value,
          $Res Function(_BookingManagerKennelInfo) _then) =
      __$BookingManagerKennelInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      String url,
      String email,
      String cancellationPolicy,
      double vatRate,
      double commissionRate});
}

/// @nodoc
class __$BookingManagerKennelInfoCopyWithImpl<$Res>
    implements _$BookingManagerKennelInfoCopyWith<$Res> {
  __$BookingManagerKennelInfoCopyWithImpl(this._self, this._then);

  final _BookingManagerKennelInfo _self;
  final $Res Function(_BookingManagerKennelInfo) _then;

  /// Create a copy of BookingManagerKennelInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? url = null,
    Object? email = null,
    Object? cancellationPolicy = null,
    Object? vatRate = null,
    Object? commissionRate = null,
  }) {
    return _then(_BookingManagerKennelInfo(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      cancellationPolicy: null == cancellationPolicy
          ? _self.cancellationPolicy
          : cancellationPolicy // ignore: cast_nullable_to_non_nullable
              as String,
      vatRate: null == vatRate
          ? _self.vatRate
          : vatRate // ignore: cast_nullable_to_non_nullable
              as double,
      commissionRate: null == commissionRate
          ? _self.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
