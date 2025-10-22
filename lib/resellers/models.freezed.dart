// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reseller {
  /// Contact email for all the business stuff
  String get email;
  ResellerBusinessInfo get businessInfo;

  /// The list of accounts this entity is a reseller of.
  /// Useful for operators that work with multiple kennels.
  List<String> get accountsAssigned;

  /// Discout to apply to this business off of the regular price.
  ///
  /// Must be a fraction, eg: 0.15 = 15% discount.
  double get discount;

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
            (identical(other.email, email) || other.email == email) &&
            (identical(other.businessInfo, businessInfo) ||
                other.businessInfo == businessInfo) &&
            const DeepCollectionEquality()
                .equals(other.accountsAssigned, accountsAssigned) &&
            (identical(other.discount, discount) ||
                other.discount == discount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, businessInfo,
      const DeepCollectionEquality().hash(accountsAssigned), discount);

  @override
  String toString() {
    return 'Reseller(email: $email, businessInfo: $businessInfo, accountsAssigned: $accountsAssigned, discount: $discount)';
  }
}

/// @nodoc
abstract mixin class $ResellerCopyWith<$Res> {
  factory $ResellerCopyWith(Reseller value, $Res Function(Reseller) _then) =
      _$ResellerCopyWithImpl;
  @useResult
  $Res call(
      {String email,
      ResellerBusinessInfo businessInfo,
      List<String> accountsAssigned,
      double discount});

  $ResellerBusinessInfoCopyWith<$Res> get businessInfo;
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
    Object? email = null,
    Object? businessInfo = null,
    Object? accountsAssigned = null,
    Object? discount = null,
  }) {
    return _then(_self.copyWith(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      businessInfo: null == businessInfo
          ? _self.businessInfo
          : businessInfo // ignore: cast_nullable_to_non_nullable
              as ResellerBusinessInfo,
      accountsAssigned: null == accountsAssigned
          ? _self.accountsAssigned
          : accountsAssigned // ignore: cast_nullable_to_non_nullable
              as List<String>,
      discount: null == discount
          ? _self.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of Reseller
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResellerBusinessInfoCopyWith<$Res> get businessInfo {
    return $ResellerBusinessInfoCopyWith<$Res>(_self.businessInfo, (value) {
      return _then(_self.copyWith(businessInfo: value));
    });
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
    TResult Function(String email, ResellerBusinessInfo businessInfo,
            List<String> accountsAssigned, double discount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Reseller() when $default != null:
        return $default(_that.email, _that.businessInfo, _that.accountsAssigned,
            _that.discount);
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
    TResult Function(String email, ResellerBusinessInfo businessInfo,
            List<String> accountsAssigned, double discount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Reseller():
        return $default(_that.email, _that.businessInfo, _that.accountsAssigned,
            _that.discount);
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
    TResult? Function(String email, ResellerBusinessInfo businessInfo,
            List<String> accountsAssigned, double discount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Reseller() when $default != null:
        return $default(_that.email, _that.businessInfo, _that.accountsAssigned,
            _that.discount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Reseller implements Reseller {
  const _Reseller(
      {required this.email,
      required this.businessInfo,
      final List<String> accountsAssigned = const <String>[],
      this.discount = 0})
      : _accountsAssigned = accountsAssigned;
  factory _Reseller.fromJson(Map<String, dynamic> json) =>
      _$ResellerFromJson(json);

  /// Contact email for all the business stuff
  @override
  final String email;
  @override
  final ResellerBusinessInfo businessInfo;

  /// The list of accounts this entity is a reseller of.
  /// Useful for operators that work with multiple kennels.
  final List<String> _accountsAssigned;

  /// The list of accounts this entity is a reseller of.
  /// Useful for operators that work with multiple kennels.
  @override
  @JsonKey()
  List<String> get accountsAssigned {
    if (_accountsAssigned is EqualUnmodifiableListView)
      return _accountsAssigned;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accountsAssigned);
  }

  /// Discout to apply to this business off of the regular price.
  ///
  /// Must be a fraction, eg: 0.15 = 15% discount.
  @override
  @JsonKey()
  final double discount;

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
            (identical(other.email, email) || other.email == email) &&
            (identical(other.businessInfo, businessInfo) ||
                other.businessInfo == businessInfo) &&
            const DeepCollectionEquality()
                .equals(other._accountsAssigned, _accountsAssigned) &&
            (identical(other.discount, discount) ||
                other.discount == discount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, businessInfo,
      const DeepCollectionEquality().hash(_accountsAssigned), discount);

  @override
  String toString() {
    return 'Reseller(email: $email, businessInfo: $businessInfo, accountsAssigned: $accountsAssigned, discount: $discount)';
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
      {String email,
      ResellerBusinessInfo businessInfo,
      List<String> accountsAssigned,
      double discount});

  @override
  $ResellerBusinessInfoCopyWith<$Res> get businessInfo;
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
    Object? email = null,
    Object? businessInfo = null,
    Object? accountsAssigned = null,
    Object? discount = null,
  }) {
    return _then(_Reseller(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      businessInfo: null == businessInfo
          ? _self.businessInfo
          : businessInfo // ignore: cast_nullable_to_non_nullable
              as ResellerBusinessInfo,
      accountsAssigned: null == accountsAssigned
          ? _self._accountsAssigned
          : accountsAssigned // ignore: cast_nullable_to_non_nullable
              as List<String>,
      discount: null == discount
          ? _self.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  /// Create a copy of Reseller
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResellerBusinessInfoCopyWith<$Res> get businessInfo {
    return $ResellerBusinessInfoCopyWith<$Res>(_self.businessInfo, (value) {
      return _then(_self.copyWith(businessInfo: value));
    });
  }
}

/// @nodoc
mixin _$ResellerBusinessInfo {
  /// Legal name of the address
  String get legalName;

  /// Line 1 of the business address
  String get addressLineOne;

  /// Second (optional) line of the address
  String? get addressLineTwo;
  String get zipCode;
  String get city;
  String get country;

  /// Business id or VAT number of the business to put on invoice.
  String get businessId;

  /// Create a copy of ResellerBusinessInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResellerBusinessInfoCopyWith<ResellerBusinessInfo> get copyWith =>
      _$ResellerBusinessInfoCopyWithImpl<ResellerBusinessInfo>(
          this as ResellerBusinessInfo, _$identity);

  /// Serializes this ResellerBusinessInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResellerBusinessInfo &&
            (identical(other.legalName, legalName) ||
                other.legalName == legalName) &&
            (identical(other.addressLineOne, addressLineOne) ||
                other.addressLineOne == addressLineOne) &&
            (identical(other.addressLineTwo, addressLineTwo) ||
                other.addressLineTwo == addressLineTwo) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, legalName, addressLineOne,
      addressLineTwo, zipCode, city, country, businessId);

  @override
  String toString() {
    return 'ResellerBusinessInfo(legalName: $legalName, addressLineOne: $addressLineOne, addressLineTwo: $addressLineTwo, zipCode: $zipCode, city: $city, country: $country, businessId: $businessId)';
  }
}

/// @nodoc
abstract mixin class $ResellerBusinessInfoCopyWith<$Res> {
  factory $ResellerBusinessInfoCopyWith(ResellerBusinessInfo value,
          $Res Function(ResellerBusinessInfo) _then) =
      _$ResellerBusinessInfoCopyWithImpl;
  @useResult
  $Res call(
      {String legalName,
      String addressLineOne,
      String? addressLineTwo,
      String zipCode,
      String city,
      String country,
      String businessId});
}

/// @nodoc
class _$ResellerBusinessInfoCopyWithImpl<$Res>
    implements $ResellerBusinessInfoCopyWith<$Res> {
  _$ResellerBusinessInfoCopyWithImpl(this._self, this._then);

  final ResellerBusinessInfo _self;
  final $Res Function(ResellerBusinessInfo) _then;

  /// Create a copy of ResellerBusinessInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? legalName = null,
    Object? addressLineOne = null,
    Object? addressLineTwo = freezed,
    Object? zipCode = null,
    Object? city = null,
    Object? country = null,
    Object? businessId = null,
  }) {
    return _then(_self.copyWith(
      legalName: null == legalName
          ? _self.legalName
          : legalName // ignore: cast_nullable_to_non_nullable
              as String,
      addressLineOne: null == addressLineOne
          ? _self.addressLineOne
          : addressLineOne // ignore: cast_nullable_to_non_nullable
              as String,
      addressLineTwo: freezed == addressLineTwo
          ? _self.addressLineTwo
          : addressLineTwo // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: null == zipCode
          ? _self.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      businessId: null == businessId
          ? _self.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ResellerBusinessInfo].
extension ResellerBusinessInfoPatterns on ResellerBusinessInfo {
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
    TResult Function(_ResellerBusinessInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResellerBusinessInfo() when $default != null:
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
    TResult Function(_ResellerBusinessInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResellerBusinessInfo():
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
    TResult? Function(_ResellerBusinessInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResellerBusinessInfo() when $default != null:
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
            String legalName,
            String addressLineOne,
            String? addressLineTwo,
            String zipCode,
            String city,
            String country,
            String businessId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResellerBusinessInfo() when $default != null:
        return $default(
            _that.legalName,
            _that.addressLineOne,
            _that.addressLineTwo,
            _that.zipCode,
            _that.city,
            _that.country,
            _that.businessId);
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
            String legalName,
            String addressLineOne,
            String? addressLineTwo,
            String zipCode,
            String city,
            String country,
            String businessId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResellerBusinessInfo():
        return $default(
            _that.legalName,
            _that.addressLineOne,
            _that.addressLineTwo,
            _that.zipCode,
            _that.city,
            _that.country,
            _that.businessId);
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
            String legalName,
            String addressLineOne,
            String? addressLineTwo,
            String zipCode,
            String city,
            String country,
            String businessId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResellerBusinessInfo() when $default != null:
        return $default(
            _that.legalName,
            _that.addressLineOne,
            _that.addressLineTwo,
            _that.zipCode,
            _that.city,
            _that.country,
            _that.businessId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ResellerBusinessInfo implements ResellerBusinessInfo {
  const _ResellerBusinessInfo(
      {required this.legalName,
      required this.addressLineOne,
      this.addressLineTwo,
      required this.zipCode,
      required this.city,
      required this.country,
      required this.businessId});
  factory _ResellerBusinessInfo.fromJson(Map<String, dynamic> json) =>
      _$ResellerBusinessInfoFromJson(json);

  /// Legal name of the address
  @override
  final String legalName;

  /// Line 1 of the business address
  @override
  final String addressLineOne;

  /// Second (optional) line of the address
  @override
  final String? addressLineTwo;
  @override
  final String zipCode;
  @override
  final String city;
  @override
  final String country;

  /// Business id or VAT number of the business to put on invoice.
  @override
  final String businessId;

  /// Create a copy of ResellerBusinessInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ResellerBusinessInfoCopyWith<_ResellerBusinessInfo> get copyWith =>
      __$ResellerBusinessInfoCopyWithImpl<_ResellerBusinessInfo>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ResellerBusinessInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResellerBusinessInfo &&
            (identical(other.legalName, legalName) ||
                other.legalName == legalName) &&
            (identical(other.addressLineOne, addressLineOne) ||
                other.addressLineOne == addressLineOne) &&
            (identical(other.addressLineTwo, addressLineTwo) ||
                other.addressLineTwo == addressLineTwo) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, legalName, addressLineOne,
      addressLineTwo, zipCode, city, country, businessId);

  @override
  String toString() {
    return 'ResellerBusinessInfo(legalName: $legalName, addressLineOne: $addressLineOne, addressLineTwo: $addressLineTwo, zipCode: $zipCode, city: $city, country: $country, businessId: $businessId)';
  }
}

/// @nodoc
abstract mixin class _$ResellerBusinessInfoCopyWith<$Res>
    implements $ResellerBusinessInfoCopyWith<$Res> {
  factory _$ResellerBusinessInfoCopyWith(_ResellerBusinessInfo value,
          $Res Function(_ResellerBusinessInfo) _then) =
      __$ResellerBusinessInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String legalName,
      String addressLineOne,
      String? addressLineTwo,
      String zipCode,
      String city,
      String country,
      String businessId});
}

/// @nodoc
class __$ResellerBusinessInfoCopyWithImpl<$Res>
    implements _$ResellerBusinessInfoCopyWith<$Res> {
  __$ResellerBusinessInfoCopyWithImpl(this._self, this._then);

  final _ResellerBusinessInfo _self;
  final $Res Function(_ResellerBusinessInfo) _then;

  /// Create a copy of ResellerBusinessInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? legalName = null,
    Object? addressLineOne = null,
    Object? addressLineTwo = freezed,
    Object? zipCode = null,
    Object? city = null,
    Object? country = null,
    Object? businessId = null,
  }) {
    return _then(_ResellerBusinessInfo(
      legalName: null == legalName
          ? _self.legalName
          : legalName // ignore: cast_nullable_to_non_nullable
              as String,
      addressLineOne: null == addressLineOne
          ? _self.addressLineOne
          : addressLineOne // ignore: cast_nullable_to_non_nullable
              as String,
      addressLineTwo: freezed == addressLineTwo
          ? _self.addressLineTwo
          : addressLineTwo // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: null == zipCode
          ? _self.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      businessId: null == businessId
          ? _self.businessId
          : businessId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$ResellerSettings {
  /// Whether to allow the reseller to pay after making the booking
  bool get allowedDelayedPayment;

  /// How many days before the booking the payment must be completed
  ///
  /// If `allowDelayedPayment` is false, this is ignored.
  int get paymentDelayDays;

  /// Create a copy of ResellerSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResellerSettingsCopyWith<ResellerSettings> get copyWith =>
      _$ResellerSettingsCopyWithImpl<ResellerSettings>(
          this as ResellerSettings, _$identity);

  /// Serializes this ResellerSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResellerSettings &&
            (identical(other.allowedDelayedPayment, allowedDelayedPayment) ||
                other.allowedDelayedPayment == allowedDelayedPayment) &&
            (identical(other.paymentDelayDays, paymentDelayDays) ||
                other.paymentDelayDays == paymentDelayDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, allowedDelayedPayment, paymentDelayDays);

  @override
  String toString() {
    return 'ResellerSettings(allowedDelayedPayment: $allowedDelayedPayment, paymentDelayDays: $paymentDelayDays)';
  }
}

/// @nodoc
abstract mixin class $ResellerSettingsCopyWith<$Res> {
  factory $ResellerSettingsCopyWith(
          ResellerSettings value, $Res Function(ResellerSettings) _then) =
      _$ResellerSettingsCopyWithImpl;
  @useResult
  $Res call({bool allowedDelayedPayment, int paymentDelayDays});
}

/// @nodoc
class _$ResellerSettingsCopyWithImpl<$Res>
    implements $ResellerSettingsCopyWith<$Res> {
  _$ResellerSettingsCopyWithImpl(this._self, this._then);

  final ResellerSettings _self;
  final $Res Function(ResellerSettings) _then;

  /// Create a copy of ResellerSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowedDelayedPayment = null,
    Object? paymentDelayDays = null,
  }) {
    return _then(_self.copyWith(
      allowedDelayedPayment: null == allowedDelayedPayment
          ? _self.allowedDelayedPayment
          : allowedDelayedPayment // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentDelayDays: null == paymentDelayDays
          ? _self.paymentDelayDays
          : paymentDelayDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ResellerSettings].
extension ResellerSettingsPatterns on ResellerSettings {
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
    TResult Function(_ResellerSettings value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResellerSettings() when $default != null:
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
    TResult Function(_ResellerSettings value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResellerSettings():
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
    TResult? Function(_ResellerSettings value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResellerSettings() when $default != null:
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
    TResult Function(bool allowedDelayedPayment, int paymentDelayDays)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResellerSettings() when $default != null:
        return $default(_that.allowedDelayedPayment, _that.paymentDelayDays);
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
    TResult Function(bool allowedDelayedPayment, int paymentDelayDays) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResellerSettings():
        return $default(_that.allowedDelayedPayment, _that.paymentDelayDays);
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
    TResult? Function(bool allowedDelayedPayment, int paymentDelayDays)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResellerSettings() when $default != null:
        return $default(_that.allowedDelayedPayment, _that.paymentDelayDays);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ResellerSettings implements ResellerSettings {
  const _ResellerSettings(
      {this.allowedDelayedPayment = false, this.paymentDelayDays = 28});
  factory _ResellerSettings.fromJson(Map<String, dynamic> json) =>
      _$ResellerSettingsFromJson(json);

  /// Whether to allow the reseller to pay after making the booking
  @override
  @JsonKey()
  final bool allowedDelayedPayment;

  /// How many days before the booking the payment must be completed
  ///
  /// If `allowDelayedPayment` is false, this is ignored.
  @override
  @JsonKey()
  final int paymentDelayDays;

  /// Create a copy of ResellerSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ResellerSettingsCopyWith<_ResellerSettings> get copyWith =>
      __$ResellerSettingsCopyWithImpl<_ResellerSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ResellerSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResellerSettings &&
            (identical(other.allowedDelayedPayment, allowedDelayedPayment) ||
                other.allowedDelayedPayment == allowedDelayedPayment) &&
            (identical(other.paymentDelayDays, paymentDelayDays) ||
                other.paymentDelayDays == paymentDelayDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, allowedDelayedPayment, paymentDelayDays);

  @override
  String toString() {
    return 'ResellerSettings(allowedDelayedPayment: $allowedDelayedPayment, paymentDelayDays: $paymentDelayDays)';
  }
}

/// @nodoc
abstract mixin class _$ResellerSettingsCopyWith<$Res>
    implements $ResellerSettingsCopyWith<$Res> {
  factory _$ResellerSettingsCopyWith(
          _ResellerSettings value, $Res Function(_ResellerSettings) _then) =
      __$ResellerSettingsCopyWithImpl;
  @override
  @useResult
  $Res call({bool allowedDelayedPayment, int paymentDelayDays});
}

/// @nodoc
class __$ResellerSettingsCopyWithImpl<$Res>
    implements _$ResellerSettingsCopyWith<$Res> {
  __$ResellerSettingsCopyWithImpl(this._self, this._then);

  final _ResellerSettings _self;
  final $Res Function(_ResellerSettings) _then;

  /// Create a copy of ResellerSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? allowedDelayedPayment = null,
    Object? paymentDelayDays = null,
  }) {
    return _then(_ResellerSettings(
      allowedDelayedPayment: null == allowedDelayedPayment
          ? _self.allowedDelayedPayment
          : allowedDelayedPayment // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentDelayDays: null == paymentDelayDays
          ? _self.paymentDelayDays
          : paymentDelayDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
