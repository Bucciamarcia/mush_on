// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tourTypeHash() => r'9d811f6e749817ade37ff16d41782acad7f4c891';

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

/// See also [tourType].
@ProviderFor(tourType)
const tourTypeProvider = TourTypeFamily();

/// See also [tourType].
class TourTypeFamily extends Family<AsyncValue<TourType?>> {
  /// See also [tourType].
  const TourTypeFamily();

  /// See also [tourType].
  TourTypeProvider call({
    required String account,
    required String tourId,
  }) {
    return TourTypeProvider(
      account: account,
      tourId: tourId,
    );
  }

  @override
  TourTypeProvider getProviderOverride(
    covariant TourTypeProvider provider,
  ) {
    return call(
      account: provider.account,
      tourId: provider.tourId,
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
  String? get name => r'tourTypeProvider';
}

/// See also [tourType].
class TourTypeProvider extends AutoDisposeStreamProvider<TourType?> {
  /// See also [tourType].
  TourTypeProvider({
    required String account,
    required String tourId,
  }) : this._internal(
          (ref) => tourType(
            ref as TourTypeRef,
            account: account,
            tourId: tourId,
          ),
          from: tourTypeProvider,
          name: r'tourTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tourTypeHash,
          dependencies: TourTypeFamily._dependencies,
          allTransitiveDependencies: TourTypeFamily._allTransitiveDependencies,
          account: account,
          tourId: tourId,
        );

  TourTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
    required this.tourId,
  }) : super.internal();

  final String account;
  final String tourId;

  @override
  Override overrideWith(
    Stream<TourType?> Function(TourTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TourTypeProvider._internal(
        (ref) => create(ref as TourTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
        tourId: tourId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<TourType?> createElement() {
    return _TourTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TourTypeProvider &&
        other.account == account &&
        other.tourId == tourId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, tourId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TourTypeRef on AutoDisposeStreamProviderRef<TourType?> {
  /// The parameter `account` of this provider.
  String get account;

  /// The parameter `tourId` of this provider.
  String get tourId;
}

class _TourTypeProviderElement
    extends AutoDisposeStreamProviderElement<TourType?> with TourTypeRef {
  _TourTypeProviderElement(super.provider);

  @override
  String get account => (origin as TourTypeProvider).account;
  @override
  String get tourId => (origin as TourTypeProvider).tourId;
}

String _$visibleCustomerGroupsHash() =>
    r'816b361e8827b1288045b00b116cee1a242b3a5a';

/// See also [visibleCustomerGroups].
@ProviderFor(visibleCustomerGroups)
final visibleCustomerGroupsProvider =
    AutoDisposeFutureProvider<List<CustomerGroup>>.internal(
  visibleCustomerGroups,
  name: r'visibleCustomerGroupsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$visibleCustomerGroupsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VisibleCustomerGroupsRef
    = AutoDisposeFutureProviderRef<List<CustomerGroup>>;
String _$visibleBookingsHash() => r'dcb2ac46459aa7d990744a19122e9998615ae414';

/// See also [visibleBookings].
@ProviderFor(visibleBookings)
final visibleBookingsProvider =
    AutoDisposeFutureProvider<List<Booking>>.internal(
  visibleBookings,
  name: r'visibleBookingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$visibleBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VisibleBookingsRef = AutoDisposeFutureProviderRef<List<Booking>>;
String _$visibleCustomersHash() => r'e36ac592a03c5a713d16a5f510b045271b7e01bf';

/// See also [visibleCustomers].
@ProviderFor(visibleCustomers)
final visibleCustomersProvider =
    AutoDisposeFutureProvider<List<Customer>>.internal(
  visibleCustomers,
  name: r'visibleCustomersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$visibleCustomersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VisibleCustomersRef = AutoDisposeFutureProviderRef<List<Customer>>;
String _$customerGroupsByDayHash() =>
    r'58e550d1f1f3a607313291b57372623854bbb236';

/// See also [customerGroupsByDay].
@ProviderFor(customerGroupsByDay)
final customerGroupsByDayProvider =
    AutoDisposeFutureProvider<Map<DateTime, List<CustomerGroup>>>.internal(
  customerGroupsByDay,
  name: r'customerGroupsByDayProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customerGroupsByDayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CustomerGroupsByDayRef
    = AutoDisposeFutureProviderRef<Map<DateTime, List<CustomerGroup>>>;
String _$bookingsByCustomerGroupIdHash() =>
    r'c019aa8309ed5eb9c648815af6eff854260caea4';

/// See also [bookingsByCustomerGroupId].
@ProviderFor(bookingsByCustomerGroupId)
final bookingsByCustomerGroupIdProvider =
    AutoDisposeFutureProvider<Map<String, List<Booking>>>.internal(
  bookingsByCustomerGroupId,
  name: r'bookingsByCustomerGroupIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookingsByCustomerGroupIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookingsByCustomerGroupIdRef
    = AutoDisposeFutureProviderRef<Map<String, List<Booking>>>;
String _$customersByBookingIdHash() =>
    r'82e26dbf8f1d5d73ba19c5c5da4bf3e7fe8d8c44';

/// See also [customersByBookingId].
@ProviderFor(customersByBookingId)
final customersByBookingIdProvider =
    AutoDisposeFutureProvider<Map<String, List<Customer>>>.internal(
  customersByBookingId,
  name: r'customersByBookingIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customersByBookingIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CustomersByBookingIdRef
    = AutoDisposeFutureProviderRef<Map<String, List<Customer>>>;
String _$accountHash() => r'2787716ed8903cef7bf0ef3133f6c1365ef6caab';

/// See also [Account].
@ProviderFor(Account)
final accountProvider = AutoDisposeNotifierProvider<Account, String?>.internal(
  Account.new,
  name: r'accountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Account = AutoDisposeNotifier<String?>;
String _$visibleDatesHash() => r'56469be751db1a9e462ea752b71ea49d955d2d8e';

/// See also [VisibleDates].
@ProviderFor(VisibleDates)
final visibleDatesProvider =
    AutoDisposeNotifierProvider<VisibleDates, List<DateTime>>.internal(
  VisibleDates.new,
  name: r'visibleDatesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$visibleDatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VisibleDates = AutoDisposeNotifier<List<DateTime>>;
String _$selectedDateInCalendarHash() =>
    r'462e39d7ac188907fd9bb9423d3df8eabc886aa6';

/// See also [SelectedDateInCalendar].
@ProviderFor(SelectedDateInCalendar)
final selectedDateInCalendarProvider =
    AutoDisposeNotifierProvider<SelectedDateInCalendar, DateTime?>.internal(
  SelectedDateInCalendar.new,
  name: r'selectedDateInCalendarProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedDateInCalendarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDateInCalendar = AutoDisposeNotifier<DateTime?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
