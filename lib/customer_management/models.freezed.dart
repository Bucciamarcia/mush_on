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
  String get id;

  /// The booking Id this customer is part of.
  ///
  /// Must always exist, because customers need a booking to book a tour!
  String get bookingId;

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

  /// The team Id this customer will go on.
  String? get teamId;

  /// The ID of the pricing for this customer.
  String? get pricingId;

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
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.isSingleDriver, isSingleDriver) ||
                other.isSingleDriver == isSingleDriver) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.isDriving, isDriving) ||
                other.isDriving == isDriving) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.pricingId, pricingId) ||
                other.pricingId == pricingId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, bookingId, name, email, age,
      isSingleDriver, weight, isDriving, teamId, pricingId);

  @override
  String toString() {
    return 'Customer(id: $id, bookingId: $bookingId, name: $name, email: $email, age: $age, isSingleDriver: $isSingleDriver, weight: $weight, isDriving: $isDriving, teamId: $teamId, pricingId: $pricingId)';
  }
}

/// @nodoc
abstract mixin class $CustomerCopyWith<$Res> {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) _then) =
      _$CustomerCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String bookingId,
      String name,
      String? email,
      int? age,
      bool isSingleDriver,
      int? weight,
      bool isDriving,
      String? teamId,
      String? pricingId});
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
    Object? id = null,
    Object? bookingId = null,
    Object? name = null,
    Object? email = freezed,
    Object? age = freezed,
    Object? isSingleDriver = null,
    Object? weight = freezed,
    Object? isDriving = null,
    Object? teamId = freezed,
    Object? pricingId = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
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
      teamId: freezed == teamId
          ? _self.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String?,
      pricingId: freezed == pricingId
          ? _self.pricingId
          : pricingId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Customer implements Customer {
  const _Customer(
      {required this.id,
      required this.bookingId,
      this.name = "",
      this.email,
      this.age,
      this.isSingleDriver = false,
      this.weight,
      this.isDriving = true,
      this.teamId,
      this.pricingId});
  factory _Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  @override
  final String id;

  /// The booking Id this customer is part of.
  ///
  /// Must always exist, because customers need a booking to book a tour!
  @override
  final String bookingId;

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

  /// The team Id this customer will go on.
  @override
  final String? teamId;

  /// The ID of the pricing for this customer.
  @override
  final String? pricingId;

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
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.isSingleDriver, isSingleDriver) ||
                other.isSingleDriver == isSingleDriver) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.isDriving, isDriving) ||
                other.isDriving == isDriving) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.pricingId, pricingId) ||
                other.pricingId == pricingId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, bookingId, name, email, age,
      isSingleDriver, weight, isDriving, teamId, pricingId);

  @override
  String toString() {
    return 'Customer(id: $id, bookingId: $bookingId, name: $name, email: $email, age: $age, isSingleDriver: $isSingleDriver, weight: $weight, isDriving: $isDriving, teamId: $teamId, pricingId: $pricingId)';
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
      {String id,
      String bookingId,
      String name,
      String? email,
      int? age,
      bool isSingleDriver,
      int? weight,
      bool isDriving,
      String? teamId,
      String? pricingId});
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
    Object? id = null,
    Object? bookingId = null,
    Object? name = null,
    Object? email = freezed,
    Object? age = freezed,
    Object? isSingleDriver = null,
    Object? weight = freezed,
    Object? isDriving = null,
    Object? teamId = freezed,
    Object? pricingId = freezed,
  }) {
    return _then(_Customer(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookingId: null == bookingId
          ? _self.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
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
      teamId: freezed == teamId
          ? _self.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String?,
      pricingId: freezed == pricingId
          ? _self.pricingId
          : pricingId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$Booking {
  String get id;

  /// The internal user friendly name of this group.
  String get name;

  /// The date and time of the booking
  @NonNullableTimestampConverter()
  DateTime get date;

  /// The ID of the CustomerGroup this booking is part of.
  ///
  /// Nullable because bookings when they're created they may not be assigned yet.
  String? get customerGroupId;

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
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.customerGroupId, customerGroupId) ||
                other.customerGroupId == customerGroupId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, date, customerGroupId);

  @override
  String toString() {
    return 'Booking(id: $id, name: $name, date: $date, customerGroupId: $customerGroupId)';
  }
}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) =
      _$BookingCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      @NonNullableTimestampConverter() DateTime date,
      String? customerGroupId});
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
    Object? id = null,
    Object? name = null,
    Object? date = null,
    Object? customerGroupId = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      customerGroupId: freezed == customerGroupId
          ? _self.customerGroupId
          : customerGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Booking implements Booking {
  const _Booking(
      {required this.id,
      this.name = "",
      @NonNullableTimestampConverter() required this.date,
      this.customerGroupId});
  factory _Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  @override
  final String id;

  /// The internal user friendly name of this group.
  @override
  @JsonKey()
  final String name;

  /// The date and time of the booking
  @override
  @NonNullableTimestampConverter()
  final DateTime date;

  /// The ID of the CustomerGroup this booking is part of.
  ///
  /// Nullable because bookings when they're created they may not be assigned yet.
  @override
  final String? customerGroupId;

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
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.customerGroupId, customerGroupId) ||
                other.customerGroupId == customerGroupId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, date, customerGroupId);

  @override
  String toString() {
    return 'Booking(id: $id, name: $name, date: $date, customerGroupId: $customerGroupId)';
  }
}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) =
      __$BookingCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @NonNullableTimestampConverter() DateTime date,
      String? customerGroupId});
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
    Object? id = null,
    Object? name = null,
    Object? date = null,
    Object? customerGroupId = freezed,
  }) {
    return _then(_Booking(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      customerGroupId: freezed == customerGroupId
          ? _self.customerGroupId
          : customerGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$CustomerGroup {
  String get id;

  /// The ID of the tour type this customergroup is assigned to.
  String? get tourTypeId;

  /// The internal user friendly name of the customer group
  String get name;
  @NonNullableTimestampConverter()
  DateTime get datetime;

  /// The ID of the teamGroup this customerGroup is assigned to.
  /// Null if it has not been assigned to a teamgroup yet.
  ///
  /// Logic: customer groups are assigned 1=1 to teamGroups, they're very similar:
  /// The teamGroup handles the dogs, the customerGroup handles the humans.
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
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tourTypeId, tourTypeId) ||
                other.tourTypeId == tourTypeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.datetime, datetime) ||
                other.datetime == datetime) &&
            (identical(other.teamGroupId, teamGroupId) ||
                other.teamGroupId == teamGroupId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, tourTypeId, name, datetime, teamGroupId);

  @override
  String toString() {
    return 'CustomerGroup(id: $id, tourTypeId: $tourTypeId, name: $name, datetime: $datetime, teamGroupId: $teamGroupId)';
  }
}

/// @nodoc
abstract mixin class $CustomerGroupCopyWith<$Res> {
  factory $CustomerGroupCopyWith(
          CustomerGroup value, $Res Function(CustomerGroup) _then) =
      _$CustomerGroupCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? tourTypeId,
      String name,
      @NonNullableTimestampConverter() DateTime datetime,
      String? teamGroupId});
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
    Object? id = null,
    Object? tourTypeId = freezed,
    Object? name = null,
    Object? datetime = null,
    Object? teamGroupId = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tourTypeId: freezed == tourTypeId
          ? _self.tourTypeId
          : tourTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      datetime: null == datetime
          ? _self.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      {required this.id,
      this.tourTypeId,
      this.name = "",
      @NonNullableTimestampConverter() required this.datetime,
      this.teamGroupId});
  factory _CustomerGroup.fromJson(Map<String, dynamic> json) =>
      _$CustomerGroupFromJson(json);

  @override
  final String id;

  /// The ID of the tour type this customergroup is assigned to.
  @override
  final String? tourTypeId;

  /// The internal user friendly name of the customer group
  @override
  @JsonKey()
  final String name;
  @override
  @NonNullableTimestampConverter()
  final DateTime datetime;

  /// The ID of the teamGroup this customerGroup is assigned to.
  /// Null if it has not been assigned to a teamgroup yet.
  ///
  /// Logic: customer groups are assigned 1=1 to teamGroups, they're very similar:
  /// The teamGroup handles the dogs, the customerGroup handles the humans.
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
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tourTypeId, tourTypeId) ||
                other.tourTypeId == tourTypeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.datetime, datetime) ||
                other.datetime == datetime) &&
            (identical(other.teamGroupId, teamGroupId) ||
                other.teamGroupId == teamGroupId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, tourTypeId, name, datetime, teamGroupId);

  @override
  String toString() {
    return 'CustomerGroup(id: $id, tourTypeId: $tourTypeId, name: $name, datetime: $datetime, teamGroupId: $teamGroupId)';
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
  $Res call(
      {String id,
      String? tourTypeId,
      String name,
      @NonNullableTimestampConverter() DateTime datetime,
      String? teamGroupId});
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
    Object? id = null,
    Object? tourTypeId = freezed,
    Object? name = null,
    Object? datetime = null,
    Object? teamGroupId = freezed,
  }) {
    return _then(_CustomerGroup(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tourTypeId: freezed == tourTypeId
          ? _self.tourTypeId
          : tourTypeId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      datetime: null == datetime
          ? _self.datetime
          : datetime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      teamGroupId: freezed == teamGroupId
          ? _self.teamGroupId
          : teamGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
