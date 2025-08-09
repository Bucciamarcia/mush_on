// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamGroupsByDateHash() => r'370a88db369c38b2264205d4c0e78fc270f5a92c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Returns a list of teamgroups that have he same date and time as the input
///
/// Copied from [teamGroupsByDate].
@ProviderFor(teamGroupsByDate)
const teamGroupsByDateProvider = TeamGroupsByDateFamily();

/// Returns a list of teamgroups that have he same date and time as the input
///
/// Copied from [teamGroupsByDate].
class TeamGroupsByDateFamily extends Family<AsyncValue<List<TeamGroup>>> {
  /// Returns a list of teamgroups that have he same date and time as the input
  ///
  /// Copied from [teamGroupsByDate].
  const TeamGroupsByDateFamily();

  /// Returns a list of teamgroups that have he same date and time as the input
  ///
  /// Copied from [teamGroupsByDate].
  TeamGroupsByDateProvider call(
    DateTime date,
  ) {
    return TeamGroupsByDateProvider(
      date,
    );
  }

  @override
  TeamGroupsByDateProvider getProviderOverride(
    covariant TeamGroupsByDateProvider provider,
  ) {
    return call(
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'teamGroupsByDateProvider';
}

/// Returns a list of teamgroups that have he same date and time as the input
///
/// Copied from [teamGroupsByDate].
class TeamGroupsByDateProvider
    extends AutoDisposeStreamProvider<List<TeamGroup>> {
  /// Returns a list of teamgroups that have he same date and time as the input
  ///
  /// Copied from [teamGroupsByDate].
  TeamGroupsByDateProvider(
    DateTime date,
  ) : this._internal(
          (ref) => teamGroupsByDate(
            ref as TeamGroupsByDateRef,
            date,
          ),
          from: teamGroupsByDateProvider,
          name: r'teamGroupsByDateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamGroupsByDateHash,
          dependencies: TeamGroupsByDateFamily._dependencies,
          allTransitiveDependencies:
              TeamGroupsByDateFamily._allTransitiveDependencies,
          date: date,
        );

  TeamGroupsByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    Stream<List<TeamGroup>> Function(TeamGroupsByDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TeamGroupsByDateProvider._internal(
        (ref) => create(ref as TeamGroupsByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TeamGroup>> createElement() {
    return _TeamGroupsByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamGroupsByDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TeamGroupsByDateRef on AutoDisposeStreamProviderRef<List<TeamGroup>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _TeamGroupsByDateProviderElement
    extends AutoDisposeStreamProviderElement<List<TeamGroup>>
    with TeamGroupsByDateRef {
  _TeamGroupsByDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as TeamGroupsByDateProvider).date;
}

String _$customerGroupsByDateRangeHash() =>
    r'b0fb30e2596ddfff8ec95ea41f35936a3f615a30';

/// See also [customerGroupsByDateRange].
@ProviderFor(customerGroupsByDateRange)
const customerGroupsByDateRangeProvider = CustomerGroupsByDateRangeFamily();

/// See also [customerGroupsByDateRange].
class CustomerGroupsByDateRangeFamily
    extends Family<AsyncValue<List<CustomerGroup>>> {
  /// See also [customerGroupsByDateRange].
  const CustomerGroupsByDateRangeFamily();

  /// See also [customerGroupsByDateRange].
  CustomerGroupsByDateRangeProvider call(
    List<DateTime> visibleDates,
  ) {
    return CustomerGroupsByDateRangeProvider(
      visibleDates,
    );
  }

  @override
  CustomerGroupsByDateRangeProvider getProviderOverride(
    covariant CustomerGroupsByDateRangeProvider provider,
  ) {
    return call(
      provider.visibleDates,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customerGroupsByDateRangeProvider';
}

/// See also [customerGroupsByDateRange].
class CustomerGroupsByDateRangeProvider
    extends AutoDisposeStreamProvider<List<CustomerGroup>> {
  /// See also [customerGroupsByDateRange].
  CustomerGroupsByDateRangeProvider(
    List<DateTime> visibleDates,
  ) : this._internal(
          (ref) => customerGroupsByDateRange(
            ref as CustomerGroupsByDateRangeRef,
            visibleDates,
          ),
          from: customerGroupsByDateRangeProvider,
          name: r'customerGroupsByDateRangeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerGroupsByDateRangeHash,
          dependencies: CustomerGroupsByDateRangeFamily._dependencies,
          allTransitiveDependencies:
              CustomerGroupsByDateRangeFamily._allTransitiveDependencies,
          visibleDates: visibleDates,
        );

  CustomerGroupsByDateRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.visibleDates,
  }) : super.internal();

  final List<DateTime> visibleDates;

  @override
  Override overrideWith(
    Stream<List<CustomerGroup>> Function(CustomerGroupsByDateRangeRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerGroupsByDateRangeProvider._internal(
        (ref) => create(ref as CustomerGroupsByDateRangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        visibleDates: visibleDates,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<CustomerGroup>> createElement() {
    return _CustomerGroupsByDateRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerGroupsByDateRangeProvider &&
        other.visibleDates == visibleDates;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, visibleDates.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerGroupsByDateRangeRef
    on AutoDisposeStreamProviderRef<List<CustomerGroup>> {
  /// The parameter `visibleDates` of this provider.
  List<DateTime> get visibleDates;
}

class _CustomerGroupsByDateRangeProviderElement
    extends AutoDisposeStreamProviderElement<List<CustomerGroup>>
    with CustomerGroupsByDateRangeRef {
  _CustomerGroupsByDateRangeProviderElement(super.provider);

  @override
  List<DateTime> get visibleDates =>
      (origin as CustomerGroupsByDateRangeProvider).visibleDates;
}

String _$customerGroupByIdHash() => r'7f9741a1a7216b1d8cb682b06373903ef6e5f74e';

/// Streams the Customer Group object associated with the ID provided.
///
/// Copied from [customerGroupById].
@ProviderFor(customerGroupById)
const customerGroupByIdProvider = CustomerGroupByIdFamily();

/// Streams the Customer Group object associated with the ID provided.
///
/// Copied from [customerGroupById].
class CustomerGroupByIdFamily extends Family<AsyncValue<CustomerGroup?>> {
  /// Streams the Customer Group object associated with the ID provided.
  ///
  /// Copied from [customerGroupById].
  const CustomerGroupByIdFamily();

  /// Streams the Customer Group object associated with the ID provided.
  ///
  /// Copied from [customerGroupById].
  CustomerGroupByIdProvider call(
    String id,
  ) {
    return CustomerGroupByIdProvider(
      id,
    );
  }

  @override
  CustomerGroupByIdProvider getProviderOverride(
    covariant CustomerGroupByIdProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customerGroupByIdProvider';
}

/// Streams the Customer Group object associated with the ID provided.
///
/// Copied from [customerGroupById].
class CustomerGroupByIdProvider
    extends AutoDisposeStreamProvider<CustomerGroup?> {
  /// Streams the Customer Group object associated with the ID provided.
  ///
  /// Copied from [customerGroupById].
  CustomerGroupByIdProvider(
    String id,
  ) : this._internal(
          (ref) => customerGroupById(
            ref as CustomerGroupByIdRef,
            id,
          ),
          from: customerGroupByIdProvider,
          name: r'customerGroupByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerGroupByIdHash,
          dependencies: CustomerGroupByIdFamily._dependencies,
          allTransitiveDependencies:
              CustomerGroupByIdFamily._allTransitiveDependencies,
          id: id,
        );

  CustomerGroupByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<CustomerGroup?> Function(CustomerGroupByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerGroupByIdProvider._internal(
        (ref) => create(ref as CustomerGroupByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<CustomerGroup?> createElement() {
    return _CustomerGroupByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerGroupByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerGroupByIdRef on AutoDisposeStreamProviderRef<CustomerGroup?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CustomerGroupByIdProviderElement
    extends AutoDisposeStreamProviderElement<CustomerGroup?>
    with CustomerGroupByIdRef {
  _CustomerGroupByIdProviderElement(super.provider);

  @override
  String get id => (origin as CustomerGroupByIdProvider).id;
}

String _$customerGroupsByDateHash() =>
    r'e71bb7c8197d11440635fa54fafef071e6aa9a24';

/// Returns a list of customer groups that have the same date and time as the input.
///
/// Copied from [customerGroupsByDate].
@ProviderFor(customerGroupsByDate)
const customerGroupsByDateProvider = CustomerGroupsByDateFamily();

/// Returns a list of customer groups that have the same date and time as the input.
///
/// Copied from [customerGroupsByDate].
class CustomerGroupsByDateFamily
    extends Family<AsyncValue<List<CustomerGroup>>> {
  /// Returns a list of customer groups that have the same date and time as the input.
  ///
  /// Copied from [customerGroupsByDate].
  const CustomerGroupsByDateFamily();

  /// Returns a list of customer groups that have the same date and time as the input.
  ///
  /// Copied from [customerGroupsByDate].
  CustomerGroupsByDateProvider call(
    DateTime date,
  ) {
    return CustomerGroupsByDateProvider(
      date,
    );
  }

  @override
  CustomerGroupsByDateProvider getProviderOverride(
    covariant CustomerGroupsByDateProvider provider,
  ) {
    return call(
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customerGroupsByDateProvider';
}

/// Returns a list of customer groups that have the same date and time as the input.
///
/// Copied from [customerGroupsByDate].
class CustomerGroupsByDateProvider
    extends AutoDisposeStreamProvider<List<CustomerGroup>> {
  /// Returns a list of customer groups that have the same date and time as the input.
  ///
  /// Copied from [customerGroupsByDate].
  CustomerGroupsByDateProvider(
    DateTime date,
  ) : this._internal(
          (ref) => customerGroupsByDate(
            ref as CustomerGroupsByDateRef,
            date,
          ),
          from: customerGroupsByDateProvider,
          name: r'customerGroupsByDateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerGroupsByDateHash,
          dependencies: CustomerGroupsByDateFamily._dependencies,
          allTransitiveDependencies:
              CustomerGroupsByDateFamily._allTransitiveDependencies,
          date: date,
        );

  CustomerGroupsByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    Stream<List<CustomerGroup>> Function(CustomerGroupsByDateRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerGroupsByDateProvider._internal(
        (ref) => create(ref as CustomerGroupsByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<CustomerGroup>> createElement() {
    return _CustomerGroupsByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerGroupsByDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerGroupsByDateRef
    on AutoDisposeStreamProviderRef<List<CustomerGroup>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _CustomerGroupsByDateProviderElement
    extends AutoDisposeStreamProviderElement<List<CustomerGroup>>
    with CustomerGroupsByDateRef {
  _CustomerGroupsByDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as CustomerGroupsByDateProvider).date;
}

String _$customerGroupsByDayHash() =>
    r'e9e3a448de5fda8492bfbd52598fe7916296fa90';

/// Returns a list of customer groups that have the same date.
///
/// Copied from [customerGroupsByDay].
@ProviderFor(customerGroupsByDay)
const customerGroupsByDayProvider = CustomerGroupsByDayFamily();

/// Returns a list of customer groups that have the same date.
///
/// Copied from [customerGroupsByDay].
class CustomerGroupsByDayFamily
    extends Family<AsyncValue<List<CustomerGroup>>> {
  /// Returns a list of customer groups that have the same date.
  ///
  /// Copied from [customerGroupsByDay].
  const CustomerGroupsByDayFamily();

  /// Returns a list of customer groups that have the same date.
  ///
  /// Copied from [customerGroupsByDay].
  CustomerGroupsByDayProvider call(
    DateTime date,
  ) {
    return CustomerGroupsByDayProvider(
      date,
    );
  }

  @override
  CustomerGroupsByDayProvider getProviderOverride(
    covariant CustomerGroupsByDayProvider provider,
  ) {
    return call(
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customerGroupsByDayProvider';
}

/// Returns a list of customer groups that have the same date.
///
/// Copied from [customerGroupsByDay].
class CustomerGroupsByDayProvider
    extends AutoDisposeStreamProvider<List<CustomerGroup>> {
  /// Returns a list of customer groups that have the same date.
  ///
  /// Copied from [customerGroupsByDay].
  CustomerGroupsByDayProvider(
    DateTime date,
  ) : this._internal(
          (ref) => customerGroupsByDay(
            ref as CustomerGroupsByDayRef,
            date,
          ),
          from: customerGroupsByDayProvider,
          name: r'customerGroupsByDayProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerGroupsByDayHash,
          dependencies: CustomerGroupsByDayFamily._dependencies,
          allTransitiveDependencies:
              CustomerGroupsByDayFamily._allTransitiveDependencies,
          date: date,
        );

  CustomerGroupsByDayProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    Stream<List<CustomerGroup>> Function(CustomerGroupsByDayRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerGroupsByDayProvider._internal(
        (ref) => create(ref as CustomerGroupsByDayRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<CustomerGroup>> createElement() {
    return _CustomerGroupsByDayProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerGroupsByDayProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerGroupsByDayRef
    on AutoDisposeStreamProviderRef<List<CustomerGroup>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _CustomerGroupsByDayProviderElement
    extends AutoDisposeStreamProviderElement<List<CustomerGroup>>
    with CustomerGroupsByDayRef {
  _CustomerGroupsByDayProviderElement(super.provider);

  @override
  DateTime get date => (origin as CustomerGroupsByDayProvider).date;
}

String _$customersByBookingIdHash() =>
    r'92c846e32819d114ef1584666606ee648c5b89d9';

/// Gets all the customers assigned to a certain booking
///
/// Copied from [customersByBookingId].
@ProviderFor(customersByBookingId)
const customersByBookingIdProvider = CustomersByBookingIdFamily();

/// Gets all the customers assigned to a certain booking
///
/// Copied from [customersByBookingId].
class CustomersByBookingIdFamily extends Family<AsyncValue<List<Customer>>> {
  /// Gets all the customers assigned to a certain booking
  ///
  /// Copied from [customersByBookingId].
  const CustomersByBookingIdFamily();

  /// Gets all the customers assigned to a certain booking
  ///
  /// Copied from [customersByBookingId].
  CustomersByBookingIdProvider call(
    String bookingId,
  ) {
    return CustomersByBookingIdProvider(
      bookingId,
    );
  }

  @override
  CustomersByBookingIdProvider getProviderOverride(
    covariant CustomersByBookingIdProvider provider,
  ) {
    return call(
      provider.bookingId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customersByBookingIdProvider';
}

/// Gets all the customers assigned to a certain booking
///
/// Copied from [customersByBookingId].
class CustomersByBookingIdProvider
    extends AutoDisposeStreamProvider<List<Customer>> {
  /// Gets all the customers assigned to a certain booking
  ///
  /// Copied from [customersByBookingId].
  CustomersByBookingIdProvider(
    String bookingId,
  ) : this._internal(
          (ref) => customersByBookingId(
            ref as CustomersByBookingIdRef,
            bookingId,
          ),
          from: customersByBookingIdProvider,
          name: r'customersByBookingIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customersByBookingIdHash,
          dependencies: CustomersByBookingIdFamily._dependencies,
          allTransitiveDependencies:
              CustomersByBookingIdFamily._allTransitiveDependencies,
          bookingId: bookingId,
        );

  CustomersByBookingIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingId,
  }) : super.internal();

  final String bookingId;

  @override
  Override overrideWith(
    Stream<List<Customer>> Function(CustomersByBookingIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomersByBookingIdProvider._internal(
        (ref) => create(ref as CustomersByBookingIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookingId: bookingId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Customer>> createElement() {
    return _CustomersByBookingIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomersByBookingIdProvider &&
        other.bookingId == bookingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomersByBookingIdRef on AutoDisposeStreamProviderRef<List<Customer>> {
  /// The parameter `bookingId` of this provider.
  String get bookingId;
}

class _CustomersByBookingIdProviderElement
    extends AutoDisposeStreamProviderElement<List<Customer>>
    with CustomersByBookingIdRef {
  _CustomersByBookingIdProviderElement(super.provider);

  @override
  String get bookingId => (origin as CustomersByBookingIdProvider).bookingId;
}

String _$customersByCustomerGroupIdHash() =>
    r'442c33a10b385abdf0f323c62e376a7909200c78';

/// Gets all the customers assigned to a customer group
///
/// Copied from [customersByCustomerGroupId].
@ProviderFor(customersByCustomerGroupId)
const customersByCustomerGroupIdProvider = CustomersByCustomerGroupIdFamily();

/// Gets all the customers assigned to a customer group
///
/// Copied from [customersByCustomerGroupId].
class CustomersByCustomerGroupIdFamily
    extends Family<AsyncValue<List<Customer>>> {
  /// Gets all the customers assigned to a customer group
  ///
  /// Copied from [customersByCustomerGroupId].
  const CustomersByCustomerGroupIdFamily();

  /// Gets all the customers assigned to a customer group
  ///
  /// Copied from [customersByCustomerGroupId].
  CustomersByCustomerGroupIdProvider call(
    String customerGroupId,
  ) {
    return CustomersByCustomerGroupIdProvider(
      customerGroupId,
    );
  }

  @override
  CustomersByCustomerGroupIdProvider getProviderOverride(
    covariant CustomersByCustomerGroupIdProvider provider,
  ) {
    return call(
      provider.customerGroupId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customersByCustomerGroupIdProvider';
}

/// Gets all the customers assigned to a customer group
///
/// Copied from [customersByCustomerGroupId].
class CustomersByCustomerGroupIdProvider
    extends AutoDisposeStreamProvider<List<Customer>> {
  /// Gets all the customers assigned to a customer group
  ///
  /// Copied from [customersByCustomerGroupId].
  CustomersByCustomerGroupIdProvider(
    String customerGroupId,
  ) : this._internal(
          (ref) => customersByCustomerGroupId(
            ref as CustomersByCustomerGroupIdRef,
            customerGroupId,
          ),
          from: customersByCustomerGroupIdProvider,
          name: r'customersByCustomerGroupIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customersByCustomerGroupIdHash,
          dependencies: CustomersByCustomerGroupIdFamily._dependencies,
          allTransitiveDependencies:
              CustomersByCustomerGroupIdFamily._allTransitiveDependencies,
          customerGroupId: customerGroupId,
        );

  CustomersByCustomerGroupIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.customerGroupId,
  }) : super.internal();

  final String customerGroupId;

  @override
  Override overrideWith(
    Stream<List<Customer>> Function(CustomersByCustomerGroupIdRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomersByCustomerGroupIdProvider._internal(
        (ref) => create(ref as CustomersByCustomerGroupIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        customerGroupId: customerGroupId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Customer>> createElement() {
    return _CustomersByCustomerGroupIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomersByCustomerGroupIdProvider &&
        other.customerGroupId == customerGroupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, customerGroupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomersByCustomerGroupIdRef
    on AutoDisposeStreamProviderRef<List<Customer>> {
  /// The parameter `customerGroupId` of this provider.
  String get customerGroupId;
}

class _CustomersByCustomerGroupIdProviderElement
    extends AutoDisposeStreamProviderElement<List<Customer>>
    with CustomersByCustomerGroupIdRef {
  _CustomersByCustomerGroupIdProviderElement(super.provider);

  @override
  String get customerGroupId =>
      (origin as CustomersByCustomerGroupIdProvider).customerGroupId;
}

String _$bookingsByCustomerGroupIdHash() =>
    r'd74bbb941e9fa3b549e5f93e785a3004a680363b';

/// See also [bookingsByCustomerGroupId].
@ProviderFor(bookingsByCustomerGroupId)
const bookingsByCustomerGroupIdProvider = BookingsByCustomerGroupIdFamily();

/// See also [bookingsByCustomerGroupId].
class BookingsByCustomerGroupIdFamily
    extends Family<AsyncValue<List<Booking>>> {
  /// See also [bookingsByCustomerGroupId].
  const BookingsByCustomerGroupIdFamily();

  /// See also [bookingsByCustomerGroupId].
  BookingsByCustomerGroupIdProvider call(
    String id,
  ) {
    return BookingsByCustomerGroupIdProvider(
      id,
    );
  }

  @override
  BookingsByCustomerGroupIdProvider getProviderOverride(
    covariant BookingsByCustomerGroupIdProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bookingsByCustomerGroupIdProvider';
}

/// See also [bookingsByCustomerGroupId].
class BookingsByCustomerGroupIdProvider
    extends AutoDisposeStreamProvider<List<Booking>> {
  /// See also [bookingsByCustomerGroupId].
  BookingsByCustomerGroupIdProvider(
    String id,
  ) : this._internal(
          (ref) => bookingsByCustomerGroupId(
            ref as BookingsByCustomerGroupIdRef,
            id,
          ),
          from: bookingsByCustomerGroupIdProvider,
          name: r'bookingsByCustomerGroupIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingsByCustomerGroupIdHash,
          dependencies: BookingsByCustomerGroupIdFamily._dependencies,
          allTransitiveDependencies:
              BookingsByCustomerGroupIdFamily._allTransitiveDependencies,
          id: id,
        );

  BookingsByCustomerGroupIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<List<Booking>> Function(BookingsByCustomerGroupIdRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookingsByCustomerGroupIdProvider._internal(
        (ref) => create(ref as BookingsByCustomerGroupIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Booking>> createElement() {
    return _BookingsByCustomerGroupIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingsByCustomerGroupIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookingsByCustomerGroupIdRef
    on AutoDisposeStreamProviderRef<List<Booking>> {
  /// The parameter `id` of this provider.
  String get id;
}

class _BookingsByCustomerGroupIdProviderElement
    extends AutoDisposeStreamProviderElement<List<Booking>>
    with BookingsByCustomerGroupIdRef {
  _BookingsByCustomerGroupIdProviderElement(super.provider);

  @override
  String get id => (origin as BookingsByCustomerGroupIdProvider).id;
}

String _$futureCustomerGroupsHash() =>
    r'eff8d56ab9ee433ef4a475a9319aefc8acecb22d';

/// See also [futureCustomerGroups].
@ProviderFor(futureCustomerGroups)
const futureCustomerGroupsProvider = FutureCustomerGroupsFamily();

/// See also [futureCustomerGroups].
class FutureCustomerGroupsFamily
    extends Family<AsyncValue<List<CustomerGroup>>> {
  /// See also [futureCustomerGroups].
  const FutureCustomerGroupsFamily();

  /// See also [futureCustomerGroups].
  FutureCustomerGroupsProvider call({
    required DateTime? untilDate,
  }) {
    return FutureCustomerGroupsProvider(
      untilDate: untilDate,
    );
  }

  @override
  FutureCustomerGroupsProvider getProviderOverride(
    covariant FutureCustomerGroupsProvider provider,
  ) {
    return call(
      untilDate: provider.untilDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'futureCustomerGroupsProvider';
}

/// See also [futureCustomerGroups].
class FutureCustomerGroupsProvider
    extends AutoDisposeStreamProvider<List<CustomerGroup>> {
  /// See also [futureCustomerGroups].
  FutureCustomerGroupsProvider({
    required DateTime? untilDate,
  }) : this._internal(
          (ref) => futureCustomerGroups(
            ref as FutureCustomerGroupsRef,
            untilDate: untilDate,
          ),
          from: futureCustomerGroupsProvider,
          name: r'futureCustomerGroupsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$futureCustomerGroupsHash,
          dependencies: FutureCustomerGroupsFamily._dependencies,
          allTransitiveDependencies:
              FutureCustomerGroupsFamily._allTransitiveDependencies,
          untilDate: untilDate,
        );

  FutureCustomerGroupsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.untilDate,
  }) : super.internal();

  final DateTime? untilDate;

  @override
  Override overrideWith(
    Stream<List<CustomerGroup>> Function(FutureCustomerGroupsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FutureCustomerGroupsProvider._internal(
        (ref) => create(ref as FutureCustomerGroupsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        untilDate: untilDate,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<CustomerGroup>> createElement() {
    return _FutureCustomerGroupsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FutureCustomerGroupsProvider &&
        other.untilDate == untilDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, untilDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FutureCustomerGroupsRef
    on AutoDisposeStreamProviderRef<List<CustomerGroup>> {
  /// The parameter `untilDate` of this provider.
  DateTime? get untilDate;
}

class _FutureCustomerGroupsProviderElement
    extends AutoDisposeStreamProviderElement<List<CustomerGroup>>
    with FutureCustomerGroupsRef {
  _FutureCustomerGroupsProviderElement(super.provider);

  @override
  DateTime? get untilDate => (origin as FutureCustomerGroupsProvider).untilDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
