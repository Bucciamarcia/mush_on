// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamGroupsByDateHash() => r'146f46791a46f56ceb367f99b177ec1df9d62ebc';

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

String _$customerGroupsByDateHash() =>
    r'c5b3edfbd2a64bbf536ad9f6b65ec0aebd7d3a9e';

/// Returns a list of customer groups that have the same date and time as the input.
///
/// Used to get the customer groups that can be assigned to a booking.
///
/// Copied from [customerGroupsByDate].
@ProviderFor(customerGroupsByDate)
const customerGroupsByDateProvider = CustomerGroupsByDateFamily();

/// Returns a list of customer groups that have the same date and time as the input.
///
/// Used to get the customer groups that can be assigned to a booking.
///
/// Copied from [customerGroupsByDate].
class CustomerGroupsByDateFamily
    extends Family<AsyncValue<List<CustomerGroup>>> {
  /// Returns a list of customer groups that have the same date and time as the input.
  ///
  /// Used to get the customer groups that can be assigned to a booking.
  ///
  /// Copied from [customerGroupsByDate].
  const CustomerGroupsByDateFamily();

  /// Returns a list of customer groups that have the same date and time as the input.
  ///
  /// Used to get the customer groups that can be assigned to a booking.
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
/// Used to get the customer groups that can be assigned to a booking.
///
/// Copied from [customerGroupsByDate].
class CustomerGroupsByDateProvider
    extends AutoDisposeStreamProvider<List<CustomerGroup>> {
  /// Returns a list of customer groups that have the same date and time as the input.
  ///
  /// Used to get the customer groups that can be assigned to a booking.
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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
