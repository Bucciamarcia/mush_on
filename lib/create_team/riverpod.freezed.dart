// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'riverpod.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamGroupWorkspace {
  String get id;

  /// The name of the entire group.
  String get name;
  @NonNullableTimestampConverter()
  DateTime get date;

  /// The distance ran in km.
  /// Used for stats.
  double get distance;
  String get notes;
  List<TeamWorkspace> get teams;

  /// Create a copy of TeamGroupWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeamGroupWorkspaceCopyWith<TeamGroupWorkspace> get copyWith =>
      _$TeamGroupWorkspaceCopyWithImpl<TeamGroupWorkspace>(
          this as TeamGroupWorkspace, _$identity);

  /// Serializes this TeamGroupWorkspace to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TeamGroupWorkspace &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other.teams, teams));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, date, distance, notes,
      const DeepCollectionEquality().hash(teams));

  @override
  String toString() {
    return 'TeamGroupWorkspace(id: $id, name: $name, date: $date, distance: $distance, notes: $notes, teams: $teams)';
  }
}

/// @nodoc
abstract mixin class $TeamGroupWorkspaceCopyWith<$Res> {
  factory $TeamGroupWorkspaceCopyWith(
          TeamGroupWorkspace value, $Res Function(TeamGroupWorkspace) _then) =
      _$TeamGroupWorkspaceCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      @NonNullableTimestampConverter() DateTime date,
      double distance,
      String notes,
      List<TeamWorkspace> teams});
}

/// @nodoc
class _$TeamGroupWorkspaceCopyWithImpl<$Res>
    implements $TeamGroupWorkspaceCopyWith<$Res> {
  _$TeamGroupWorkspaceCopyWithImpl(this._self, this._then);

  final TeamGroupWorkspace _self;
  final $Res Function(TeamGroupWorkspace) _then;

  /// Create a copy of TeamGroupWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? date = null,
    Object? distance = null,
    Object? notes = null,
    Object? teams = null,
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
      distance: null == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      teams: null == teams
          ? _self.teams
          : teams // ignore: cast_nullable_to_non_nullable
              as List<TeamWorkspace>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TeamGroupWorkspace implements TeamGroupWorkspace {
  const _TeamGroupWorkspace(
      {this.id = "",
      this.name = "",
      @NonNullableTimestampConverter() required this.date,
      this.distance = 0,
      this.notes = "",
      final List<TeamWorkspace> teams = const []})
      : _teams = teams;
  factory _TeamGroupWorkspace.fromJson(Map<String, dynamic> json) =>
      _$TeamGroupWorkspaceFromJson(json);

  @override
  @JsonKey()
  final String id;

  /// The name of the entire group.
  @override
  @JsonKey()
  final String name;
  @override
  @NonNullableTimestampConverter()
  final DateTime date;

  /// The distance ran in km.
  /// Used for stats.
  @override
  @JsonKey()
  final double distance;
  @override
  @JsonKey()
  final String notes;
  final List<TeamWorkspace> _teams;
  @override
  @JsonKey()
  List<TeamWorkspace> get teams {
    if (_teams is EqualUnmodifiableListView) return _teams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teams);
  }

  /// Create a copy of TeamGroupWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeamGroupWorkspaceCopyWith<_TeamGroupWorkspace> get copyWith =>
      __$TeamGroupWorkspaceCopyWithImpl<_TeamGroupWorkspace>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TeamGroupWorkspaceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TeamGroupWorkspace &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._teams, _teams));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, date, distance, notes,
      const DeepCollectionEquality().hash(_teams));

  @override
  String toString() {
    return 'TeamGroupWorkspace(id: $id, name: $name, date: $date, distance: $distance, notes: $notes, teams: $teams)';
  }
}

/// @nodoc
abstract mixin class _$TeamGroupWorkspaceCopyWith<$Res>
    implements $TeamGroupWorkspaceCopyWith<$Res> {
  factory _$TeamGroupWorkspaceCopyWith(
          _TeamGroupWorkspace value, $Res Function(_TeamGroupWorkspace) _then) =
      __$TeamGroupWorkspaceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @NonNullableTimestampConverter() DateTime date,
      double distance,
      String notes,
      List<TeamWorkspace> teams});
}

/// @nodoc
class __$TeamGroupWorkspaceCopyWithImpl<$Res>
    implements _$TeamGroupWorkspaceCopyWith<$Res> {
  __$TeamGroupWorkspaceCopyWithImpl(this._self, this._then);

  final _TeamGroupWorkspace _self;
  final $Res Function(_TeamGroupWorkspace) _then;

  /// Create a copy of TeamGroupWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? date = null,
    Object? distance = null,
    Object? notes = null,
    Object? teams = null,
  }) {
    return _then(_TeamGroupWorkspace(
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
      distance: null == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      teams: null == teams
          ? _self._teams
          : teams // ignore: cast_nullable_to_non_nullable
              as List<TeamWorkspace>,
    ));
  }
}

/// @nodoc
mixin _$TeamWorkspace {
  String get name;
  String get id;
  List<DogPairWorkspace> get dogPairs;

  /// Create a copy of TeamWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeamWorkspaceCopyWith<TeamWorkspace> get copyWith =>
      _$TeamWorkspaceCopyWithImpl<TeamWorkspace>(
          this as TeamWorkspace, _$identity);

  /// Serializes this TeamWorkspace to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TeamWorkspace &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.dogPairs, dogPairs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, id, const DeepCollectionEquality().hash(dogPairs));

  @override
  String toString() {
    return 'TeamWorkspace(name: $name, id: $id, dogPairs: $dogPairs)';
  }
}

/// @nodoc
abstract mixin class $TeamWorkspaceCopyWith<$Res> {
  factory $TeamWorkspaceCopyWith(
          TeamWorkspace value, $Res Function(TeamWorkspace) _then) =
      _$TeamWorkspaceCopyWithImpl;
  @useResult
  $Res call({String name, String id, List<DogPairWorkspace> dogPairs});
}

/// @nodoc
class _$TeamWorkspaceCopyWithImpl<$Res>
    implements $TeamWorkspaceCopyWith<$Res> {
  _$TeamWorkspaceCopyWithImpl(this._self, this._then);

  final TeamWorkspace _self;
  final $Res Function(TeamWorkspace) _then;

  /// Create a copy of TeamWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = null,
    Object? dogPairs = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dogPairs: null == dogPairs
          ? _self.dogPairs
          : dogPairs // ignore: cast_nullable_to_non_nullable
              as List<DogPairWorkspace>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TeamWorkspace implements TeamWorkspace {
  const _TeamWorkspace(
      {this.name = "",
      required this.id,
      final List<DogPairWorkspace> dogPairs = const []})
      : _dogPairs = dogPairs;
  factory _TeamWorkspace.fromJson(Map<String, dynamic> json) =>
      _$TeamWorkspaceFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  final String id;
  final List<DogPairWorkspace> _dogPairs;
  @override
  @JsonKey()
  List<DogPairWorkspace> get dogPairs {
    if (_dogPairs is EqualUnmodifiableListView) return _dogPairs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dogPairs);
  }

  /// Create a copy of TeamWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeamWorkspaceCopyWith<_TeamWorkspace> get copyWith =>
      __$TeamWorkspaceCopyWithImpl<_TeamWorkspace>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TeamWorkspaceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TeamWorkspace &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._dogPairs, _dogPairs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, id, const DeepCollectionEquality().hash(_dogPairs));

  @override
  String toString() {
    return 'TeamWorkspace(name: $name, id: $id, dogPairs: $dogPairs)';
  }
}

/// @nodoc
abstract mixin class _$TeamWorkspaceCopyWith<$Res>
    implements $TeamWorkspaceCopyWith<$Res> {
  factory _$TeamWorkspaceCopyWith(
          _TeamWorkspace value, $Res Function(_TeamWorkspace) _then) =
      __$TeamWorkspaceCopyWithImpl;
  @override
  @useResult
  $Res call({String name, String id, List<DogPairWorkspace> dogPairs});
}

/// @nodoc
class __$TeamWorkspaceCopyWithImpl<$Res>
    implements _$TeamWorkspaceCopyWith<$Res> {
  __$TeamWorkspaceCopyWithImpl(this._self, this._then);

  final _TeamWorkspace _self;
  final $Res Function(_TeamWorkspace) _then;

  /// Create a copy of TeamWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? id = null,
    Object? dogPairs = null,
  }) {
    return _then(_TeamWorkspace(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dogPairs: null == dogPairs
          ? _self._dogPairs
          : dogPairs // ignore: cast_nullable_to_non_nullable
              as List<DogPairWorkspace>,
    ));
  }
}

/// @nodoc
mixin _$DogPairWorkspace {
  String? get firstDogId;
  String? get secondDogId;
  String get id;

  /// Create a copy of DogPairWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DogPairWorkspaceCopyWith<DogPairWorkspace> get copyWith =>
      _$DogPairWorkspaceCopyWithImpl<DogPairWorkspace>(
          this as DogPairWorkspace, _$identity);

  /// Serializes this DogPairWorkspace to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DogPairWorkspace &&
            (identical(other.firstDogId, firstDogId) ||
                other.firstDogId == firstDogId) &&
            (identical(other.secondDogId, secondDogId) ||
                other.secondDogId == secondDogId) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, firstDogId, secondDogId, id);

  @override
  String toString() {
    return 'DogPairWorkspace(firstDogId: $firstDogId, secondDogId: $secondDogId, id: $id)';
  }
}

/// @nodoc
abstract mixin class $DogPairWorkspaceCopyWith<$Res> {
  factory $DogPairWorkspaceCopyWith(
          DogPairWorkspace value, $Res Function(DogPairWorkspace) _then) =
      _$DogPairWorkspaceCopyWithImpl;
  @useResult
  $Res call({String? firstDogId, String? secondDogId, String id});
}

/// @nodoc
class _$DogPairWorkspaceCopyWithImpl<$Res>
    implements $DogPairWorkspaceCopyWith<$Res> {
  _$DogPairWorkspaceCopyWithImpl(this._self, this._then);

  final DogPairWorkspace _self;
  final $Res Function(DogPairWorkspace) _then;

  /// Create a copy of DogPairWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstDogId = freezed,
    Object? secondDogId = freezed,
    Object? id = null,
  }) {
    return _then(_self.copyWith(
      firstDogId: freezed == firstDogId
          ? _self.firstDogId
          : firstDogId // ignore: cast_nullable_to_non_nullable
              as String?,
      secondDogId: freezed == secondDogId
          ? _self.secondDogId
          : secondDogId // ignore: cast_nullable_to_non_nullable
              as String?,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _DogPairWorkspace implements DogPairWorkspace {
  const _DogPairWorkspace(
      {this.firstDogId, this.secondDogId, required this.id});
  factory _DogPairWorkspace.fromJson(Map<String, dynamic> json) =>
      _$DogPairWorkspaceFromJson(json);

  @override
  final String? firstDogId;
  @override
  final String? secondDogId;
  @override
  final String id;

  /// Create a copy of DogPairWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DogPairWorkspaceCopyWith<_DogPairWorkspace> get copyWith =>
      __$DogPairWorkspaceCopyWithImpl<_DogPairWorkspace>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DogPairWorkspaceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DogPairWorkspace &&
            (identical(other.firstDogId, firstDogId) ||
                other.firstDogId == firstDogId) &&
            (identical(other.secondDogId, secondDogId) ||
                other.secondDogId == secondDogId) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, firstDogId, secondDogId, id);

  @override
  String toString() {
    return 'DogPairWorkspace(firstDogId: $firstDogId, secondDogId: $secondDogId, id: $id)';
  }
}

/// @nodoc
abstract mixin class _$DogPairWorkspaceCopyWith<$Res>
    implements $DogPairWorkspaceCopyWith<$Res> {
  factory _$DogPairWorkspaceCopyWith(
          _DogPairWorkspace value, $Res Function(_DogPairWorkspace) _then) =
      __$DogPairWorkspaceCopyWithImpl;
  @override
  @useResult
  $Res call({String? firstDogId, String? secondDogId, String id});
}

/// @nodoc
class __$DogPairWorkspaceCopyWithImpl<$Res>
    implements _$DogPairWorkspaceCopyWith<$Res> {
  __$DogPairWorkspaceCopyWithImpl(this._self, this._then);

  final _DogPairWorkspace _self;
  final $Res Function(_DogPairWorkspace) _then;

  /// Create a copy of DogPairWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? firstDogId = freezed,
    Object? secondDogId = freezed,
    Object? id = null,
  }) {
    return _then(_DogPairWorkspace(
      firstDogId: freezed == firstDogId
          ? _self.firstDogId
          : firstDogId // ignore: cast_nullable_to_non_nullable
              as String?,
      secondDogId: freezed == secondDogId
          ? _self.secondDogId
          : secondDogId // ignore: cast_nullable_to_non_nullable
              as String?,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$CustomerGroupWorkspace {
  CustomerGroup get customerGroup;
  List<Booking> get bookings;

  /// All customers by customer group ID.
  List<Customer> get customers;

  /// Create a copy of CustomerGroupWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomerGroupWorkspaceCopyWith<CustomerGroupWorkspace> get copyWith =>
      _$CustomerGroupWorkspaceCopyWithImpl<CustomerGroupWorkspace>(
          this as CustomerGroupWorkspace, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomerGroupWorkspace &&
            (identical(other.customerGroup, customerGroup) ||
                other.customerGroup == customerGroup) &&
            const DeepCollectionEquality().equals(other.bookings, bookings) &&
            const DeepCollectionEquality().equals(other.customers, customers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      customerGroup,
      const DeepCollectionEquality().hash(bookings),
      const DeepCollectionEquality().hash(customers));

  @override
  String toString() {
    return 'CustomerGroupWorkspace(customerGroup: $customerGroup, bookings: $bookings, customers: $customers)';
  }
}

/// @nodoc
abstract mixin class $CustomerGroupWorkspaceCopyWith<$Res> {
  factory $CustomerGroupWorkspaceCopyWith(CustomerGroupWorkspace value,
          $Res Function(CustomerGroupWorkspace) _then) =
      _$CustomerGroupWorkspaceCopyWithImpl;
  @useResult
  $Res call(
      {CustomerGroup customerGroup,
      List<Booking> bookings,
      List<Customer> customers});

  $CustomerGroupCopyWith<$Res> get customerGroup;
}

/// @nodoc
class _$CustomerGroupWorkspaceCopyWithImpl<$Res>
    implements $CustomerGroupWorkspaceCopyWith<$Res> {
  _$CustomerGroupWorkspaceCopyWithImpl(this._self, this._then);

  final CustomerGroupWorkspace _self;
  final $Res Function(CustomerGroupWorkspace) _then;

  /// Create a copy of CustomerGroupWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerGroup = null,
    Object? bookings = null,
    Object? customers = null,
  }) {
    return _then(_self.copyWith(
      customerGroup: null == customerGroup
          ? _self.customerGroup
          : customerGroup // ignore: cast_nullable_to_non_nullable
              as CustomerGroup,
      bookings: null == bookings
          ? _self.bookings
          : bookings // ignore: cast_nullable_to_non_nullable
              as List<Booking>,
      customers: null == customers
          ? _self.customers
          : customers // ignore: cast_nullable_to_non_nullable
              as List<Customer>,
    ));
  }

  /// Create a copy of CustomerGroupWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerGroupCopyWith<$Res> get customerGroup {
    return $CustomerGroupCopyWith<$Res>(_self.customerGroup, (value) {
      return _then(_self.copyWith(customerGroup: value));
    });
  }
}

/// @nodoc

class _CustomerGroupWorkspace implements CustomerGroupWorkspace {
  const _CustomerGroupWorkspace(
      {required this.customerGroup,
      final List<Booking> bookings = const [],
      final List<Customer> customers = const []})
      : _bookings = bookings,
        _customers = customers;

  @override
  final CustomerGroup customerGroup;
  final List<Booking> _bookings;
  @override
  @JsonKey()
  List<Booking> get bookings {
    if (_bookings is EqualUnmodifiableListView) return _bookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookings);
  }

  /// All customers by customer group ID.
  final List<Customer> _customers;

  /// All customers by customer group ID.
  @override
  @JsonKey()
  List<Customer> get customers {
    if (_customers is EqualUnmodifiableListView) return _customers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customers);
  }

  /// Create a copy of CustomerGroupWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CustomerGroupWorkspaceCopyWith<_CustomerGroupWorkspace> get copyWith =>
      __$CustomerGroupWorkspaceCopyWithImpl<_CustomerGroupWorkspace>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CustomerGroupWorkspace &&
            (identical(other.customerGroup, customerGroup) ||
                other.customerGroup == customerGroup) &&
            const DeepCollectionEquality().equals(other._bookings, _bookings) &&
            const DeepCollectionEquality()
                .equals(other._customers, _customers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      customerGroup,
      const DeepCollectionEquality().hash(_bookings),
      const DeepCollectionEquality().hash(_customers));

  @override
  String toString() {
    return 'CustomerGroupWorkspace(customerGroup: $customerGroup, bookings: $bookings, customers: $customers)';
  }
}

/// @nodoc
abstract mixin class _$CustomerGroupWorkspaceCopyWith<$Res>
    implements $CustomerGroupWorkspaceCopyWith<$Res> {
  factory _$CustomerGroupWorkspaceCopyWith(_CustomerGroupWorkspace value,
          $Res Function(_CustomerGroupWorkspace) _then) =
      __$CustomerGroupWorkspaceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {CustomerGroup customerGroup,
      List<Booking> bookings,
      List<Customer> customers});

  @override
  $CustomerGroupCopyWith<$Res> get customerGroup;
}

/// @nodoc
class __$CustomerGroupWorkspaceCopyWithImpl<$Res>
    implements _$CustomerGroupWorkspaceCopyWith<$Res> {
  __$CustomerGroupWorkspaceCopyWithImpl(this._self, this._then);

  final _CustomerGroupWorkspace _self;
  final $Res Function(_CustomerGroupWorkspace) _then;

  /// Create a copy of CustomerGroupWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? customerGroup = null,
    Object? bookings = null,
    Object? customers = null,
  }) {
    return _then(_CustomerGroupWorkspace(
      customerGroup: null == customerGroup
          ? _self.customerGroup
          : customerGroup // ignore: cast_nullable_to_non_nullable
              as CustomerGroup,
      bookings: null == bookings
          ? _self._bookings
          : bookings // ignore: cast_nullable_to_non_nullable
              as List<Booking>,
      customers: null == customers
          ? _self._customers
          : customers // ignore: cast_nullable_to_non_nullable
              as List<Customer>,
    ));
  }

  /// Create a copy of CustomerGroupWorkspace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerGroupCopyWith<$Res> get customerGroup {
    return $CustomerGroupCopyWith<$Res>(_self.customerGroup, (value) {
      return _then(_self.copyWith(customerGroup: value));
    });
  }
}

// dart format on
