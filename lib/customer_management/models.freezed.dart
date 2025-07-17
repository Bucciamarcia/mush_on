// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Customer {
  /// The full name of the customer.
  String get name;

  /// The email address of the customer.
  String? get email;

  /// The age of the customer (to check if child).
  int? get age;

  /// If the customer is going on a single sled. If false, double sled usually.
  bool get isSingleDriver;

  /// The weight of the individual. Useful for distributing weight or assigning strong dogs.
  int? get weight;

  /// Does this customer want to drive the sled? Must be false for minors.
  bool get isDriving;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomerCopyWith<Customer> get copyWith =>
      _$CustomerCopyWithImpl<Customer>(this as Customer, _$identity);

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Customer &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.isSingleDriver, isSingleDriver) ||
                other.isSingleDriver == isSingleDriver) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.isDriving, isDriving) ||
                other.isDriving == isDriving));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, email, age, isSingleDriver, weight, isDriving);

  @override
  String toString() {
    return 'Customer(name: $name, email: $email, age: $age, isSingleDriver: $isSingleDriver, weight: $weight, isDriving: $isDriving)';
  }
}

/// @nodoc
abstract mixin class $CustomerCopyWith<$Res> {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) _then) =
      _$CustomerCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      String? email,
      int? age,
      bool isSingleDriver,
      int? weight,
      bool isDriving});
}

/// @nodoc
class _$CustomerCopyWithImpl<$Res> implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._self, this._then);

  final Customer _self;
  final $Res Function(Customer) _then;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = freezed,
    Object? age = freezed,
    Object? isSingleDriver = null,
    Object? weight = freezed,
    Object? isDriving = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _self.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      isSingleDriver: null == isSingleDriver
          ? _self.isSingleDriver
          : isSingleDriver // ignore: cast_nullable_to_non_nullable
              as bool,
      weight: freezed == weight
          ? _self.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as int?,
      isDriving: null == isDriving
          ? _self.isDriving
          : isDriving // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Customer implements Customer {
  const _Customer(
      {this.name = "",
      this.email,
      this.age,
      this.isSingleDriver = false,
      this.weight,
      this.isDriving = true});
  factory _Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  /// The full name of the customer.
  @override
  @JsonKey()
  final String name;

  /// The email address of the customer.
  @override
  final String? email;

  /// The age of the customer (to check if child).
  @override
  final int? age;

  /// If the customer is going on a single sled. If false, double sled usually.
  @override
  @JsonKey()
  final bool isSingleDriver;

  /// The weight of the individual. Useful for distributing weight or assigning strong dogs.
  @override
  final int? weight;

  /// Does this customer want to drive the sled? Must be false for minors.
  @override
  @JsonKey()
  final bool isDriving;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CustomerCopyWith<_Customer> get copyWith =>
      __$CustomerCopyWithImpl<_Customer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CustomerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Customer &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.isSingleDriver, isSingleDriver) ||
                other.isSingleDriver == isSingleDriver) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.isDriving, isDriving) ||
                other.isDriving == isDriving));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, email, age, isSingleDriver, weight, isDriving);

  @override
  String toString() {
    return 'Customer(name: $name, email: $email, age: $age, isSingleDriver: $isSingleDriver, weight: $weight, isDriving: $isDriving)';
  }
}

/// @nodoc
abstract mixin class _$CustomerCopyWith<$Res>
    implements $CustomerCopyWith<$Res> {
  factory _$CustomerCopyWith(_Customer value, $Res Function(_Customer) _then) =
      __$CustomerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      String? email,
      int? age,
      bool isSingleDriver,
      int? weight,
      bool isDriving});
}

/// @nodoc
class __$CustomerCopyWithImpl<$Res> implements _$CustomerCopyWith<$Res> {
  __$CustomerCopyWithImpl(this._self, this._then);

  final _Customer _self;
  final $Res Function(_Customer) _then;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? email = freezed,
    Object? age = freezed,
    Object? isSingleDriver = null,
    Object? weight = freezed,
    Object? isDriving = null,
  }) {
    return _then(_Customer(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _self.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      isSingleDriver: null == isSingleDriver
          ? _self.isSingleDriver
          : isSingleDriver // ignore: cast_nullable_to_non_nullable
              as bool,
      weight: freezed == weight
          ? _self.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as int?,
      isDriving: null == isDriving
          ? _self.isDriving
          : isDriving // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$Booking {
  List<Customer> get customers;

  /// How much this group has paid
  double get price;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookingCopyWith<Booking> get copyWith =>
      _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Booking &&
            const DeepCollectionEquality().equals(other.customers, customers) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(customers), price);

  @override
  String toString() {
    return 'Booking(customers: $customers, price: $price)';
  }
}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) =
      _$BookingCopyWithImpl;
  @useResult
  $Res call({List<Customer> customers, double price});
}

/// @nodoc
class _$BookingCopyWithImpl<$Res> implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customers = null,
    Object? price = null,
  }) {
    return _then(_self.copyWith(
      customers: null == customers
          ? _self.customers
          : customers // ignore: cast_nullable_to_non_nullable
              as List<Customer>,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Booking implements Booking {
  const _Booking({final List<Customer> customers = const [], this.price = 0})
      : _customers = customers;
  factory _Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  final List<Customer> _customers;
  @override
  @JsonKey()
  List<Customer> get customers {
    if (_customers is EqualUnmodifiableListView) return _customers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customers);
  }

  /// How much this group has paid
  @override
  @JsonKey()
  final double price;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookingCopyWith<_Booking> get copyWith =>
      __$BookingCopyWithImpl<_Booking>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BookingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Booking &&
            const DeepCollectionEquality()
                .equals(other._customers, _customers) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_customers), price);

  @override
  String toString() {
    return 'Booking(customers: $customers, price: $price)';
  }
}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) =
      __$BookingCopyWithImpl;
  @override
  @useResult
  $Res call({List<Customer> customers, double price});
}

/// @nodoc
class __$BookingCopyWithImpl<$Res> implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? customers = null,
    Object? price = null,
  }) {
    return _then(_Booking(
      customers: null == customers
          ? _self._customers
          : customers // ignore: cast_nullable_to_non_nullable
              as List<Customer>,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
mixin _$CustomerGroup {
  /// A list of bookings that are assigned to this CustomerGroup
  List<Booking> get bookings;

  /// The TeamGroup id this CustomerGroup is assigned to. Must have 1=1 correspondence.
  String? get teamGroupId;

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomerGroupCopyWith<CustomerGroup> get copyWith =>
      _$CustomerGroupCopyWithImpl<CustomerGroup>(
          this as CustomerGroup, _$identity);

  /// Serializes this CustomerGroup to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomerGroup &&
            const DeepCollectionEquality().equals(other.bookings, bookings) &&
            (identical(other.teamGroupId, teamGroupId) ||
                other.teamGroupId == teamGroupId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(bookings), teamGroupId);

  @override
  String toString() {
    return 'CustomerGroup(bookings: $bookings, teamGroupId: $teamGroupId)';
  }
}

/// @nodoc
abstract mixin class $CustomerGroupCopyWith<$Res> {
  factory $CustomerGroupCopyWith(
          CustomerGroup value, $Res Function(CustomerGroup) _then) =
      _$CustomerGroupCopyWithImpl;
  @useResult
  $Res call({List<Booking> bookings, String? teamGroupId});
}

/// @nodoc
class _$CustomerGroupCopyWithImpl<$Res>
    implements $CustomerGroupCopyWith<$Res> {
  _$CustomerGroupCopyWithImpl(this._self, this._then);

  final CustomerGroup _self;
  final $Res Function(CustomerGroup) _then;

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookings = null,
    Object? teamGroupId = freezed,
  }) {
    return _then(_self.copyWith(
      bookings: null == bookings
          ? _self.bookings
          : bookings // ignore: cast_nullable_to_non_nullable
              as List<Booking>,
      teamGroupId: freezed == teamGroupId
          ? _self.teamGroupId
          : teamGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CustomerGroup implements CustomerGroup {
  const _CustomerGroup(
      {final List<Booking> bookings = const [], this.teamGroupId})
      : _bookings = bookings;
  factory _CustomerGroup.fromJson(Map<String, dynamic> json) =>
      _$CustomerGroupFromJson(json);

  /// A list of bookings that are assigned to this CustomerGroup
  final List<Booking> _bookings;

  /// A list of bookings that are assigned to this CustomerGroup
  @override
  @JsonKey()
  List<Booking> get bookings {
    if (_bookings is EqualUnmodifiableListView) return _bookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookings);
  }

  /// The TeamGroup id this CustomerGroup is assigned to. Must have 1=1 correspondence.
  @override
  final String? teamGroupId;

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CustomerGroupCopyWith<_CustomerGroup> get copyWith =>
      __$CustomerGroupCopyWithImpl<_CustomerGroup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CustomerGroupToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CustomerGroup &&
            const DeepCollectionEquality().equals(other._bookings, _bookings) &&
            (identical(other.teamGroupId, teamGroupId) ||
                other.teamGroupId == teamGroupId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_bookings), teamGroupId);

  @override
  String toString() {
    return 'CustomerGroup(bookings: $bookings, teamGroupId: $teamGroupId)';
  }
}

/// @nodoc
abstract mixin class _$CustomerGroupCopyWith<$Res>
    implements $CustomerGroupCopyWith<$Res> {
  factory _$CustomerGroupCopyWith(
          _CustomerGroup value, $Res Function(_CustomerGroup) _then) =
      __$CustomerGroupCopyWithImpl;
  @override
  @useResult
  $Res call({List<Booking> bookings, String? teamGroupId});
}

/// @nodoc
class __$CustomerGroupCopyWithImpl<$Res>
    implements _$CustomerGroupCopyWith<$Res> {
  __$CustomerGroupCopyWithImpl(this._self, this._then);

  final _CustomerGroup _self;
  final $Res Function(_CustomerGroup) _then;

  /// Create a copy of CustomerGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? bookings = null,
    Object? teamGroupId = freezed,
  }) {
    return _then(_CustomerGroup(
      bookings: null == bookings
          ? _self._bookings
          : bookings // ignore: cast_nullable_to_non_nullable
              as List<Booking>,
      teamGroupId: freezed == teamGroupId
          ? _self.teamGroupId
          : teamGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
