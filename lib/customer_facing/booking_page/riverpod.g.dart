// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tourTypeHash() => r'c09458c71606c60edc8bf16607e93f4eabf3cb4e';

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
    r'905e850321969a1635aa77fb01fbf2ea054a051c';

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
String _$visibleBookingsHash() => r'd1acab068d6a11831b7c6806adc821693bfcc63f';

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
String _$visibleCustomersHash() => r'2381dbf7e28dcef21a347387b9f855404a3dee9b';

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
String _$customersNumberByCustomerGroupIdHash() =>
    r'f9ead66bf5efd8040d4d6bf3b6c3b10c08425a86';

/// How many customers are in each customer group, summing all bookings.
///
/// Copied from [customersNumberByCustomerGroupId].
@ProviderFor(customersNumberByCustomerGroupId)
final customersNumberByCustomerGroupIdProvider =
    AutoDisposeFutureProvider<Map<String, int>>.internal(
  customersNumberByCustomerGroupId,
  name: r'customersNumberByCustomerGroupIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customersNumberByCustomerGroupIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CustomersNumberByCustomerGroupIdRef
    = AutoDisposeFutureProviderRef<Map<String, int>>;
String _$tourTypePricesByTourIdHash() =>
    r'78e9440d0bf032c91e90eaa57d9e31d5cf526eab';

/// See also [tourTypePricesByTourId].
@ProviderFor(tourTypePricesByTourId)
const tourTypePricesByTourIdProvider = TourTypePricesByTourIdFamily();

/// See also [tourTypePricesByTourId].
class TourTypePricesByTourIdFamily
    extends Family<AsyncValue<List<TourTypePricing>>> {
  /// See also [tourTypePricesByTourId].
  const TourTypePricesByTourIdFamily();

  /// See also [tourTypePricesByTourId].
  TourTypePricesByTourIdProvider call({
    required String tourId,
    required String account,
  }) {
    return TourTypePricesByTourIdProvider(
      tourId: tourId,
      account: account,
    );
  }

  @override
  TourTypePricesByTourIdProvider getProviderOverride(
    covariant TourTypePricesByTourIdProvider provider,
  ) {
    return call(
      tourId: provider.tourId,
      account: provider.account,
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
  String? get name => r'tourTypePricesByTourIdProvider';
}

/// See also [tourTypePricesByTourId].
class TourTypePricesByTourIdProvider
    extends AutoDisposeFutureProvider<List<TourTypePricing>> {
  /// See also [tourTypePricesByTourId].
  TourTypePricesByTourIdProvider({
    required String tourId,
    required String account,
  }) : this._internal(
          (ref) => tourTypePricesByTourId(
            ref as TourTypePricesByTourIdRef,
            tourId: tourId,
            account: account,
          ),
          from: tourTypePricesByTourIdProvider,
          name: r'tourTypePricesByTourIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tourTypePricesByTourIdHash,
          dependencies: TourTypePricesByTourIdFamily._dependencies,
          allTransitiveDependencies:
              TourTypePricesByTourIdFamily._allTransitiveDependencies,
          tourId: tourId,
          account: account,
        );

  TourTypePricesByTourIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tourId,
    required this.account,
  }) : super.internal();

  final String tourId;
  final String account;

  @override
  Override overrideWith(
    FutureOr<List<TourTypePricing>> Function(TourTypePricesByTourIdRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TourTypePricesByTourIdProvider._internal(
        (ref) => create(ref as TourTypePricesByTourIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tourId: tourId,
        account: account,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TourTypePricing>> createElement() {
    return _TourTypePricesByTourIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TourTypePricesByTourIdProvider &&
        other.tourId == tourId &&
        other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tourId.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TourTypePricesByTourIdRef
    on AutoDisposeFutureProviderRef<List<TourTypePricing>> {
  /// The parameter `tourId` of this provider.
  String get tourId;

  /// The parameter `account` of this provider.
  String get account;
}

class _TourTypePricesByTourIdProviderElement
    extends AutoDisposeFutureProviderElement<List<TourTypePricing>>
    with TourTypePricesByTourIdRef {
  _TourTypePricesByTourIdProviderElement(super.provider);

  @override
  String get tourId => (origin as TourTypePricesByTourIdProvider).tourId;
  @override
  String get account => (origin as TourTypePricesByTourIdProvider).account;
}

String _$accountHash() => r'7abd3ebcb9dc9c2e383c47fb5fd37d9a706a08d7';

/// See also [Account].
@ProviderFor(Account)
final accountProvider = NotifierProvider<Account, String?>.internal(
  Account.new,
  name: r'accountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Account = Notifier<String?>;
String _$visibleDatesHash() => r'26be57b90483ad3e22700e8275c1ae57d5c7dbcd';

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
String _$selectedTourIdHash() => r'4a36b0a9ec4d88f9a0dcc800823e3b22bade3368';

/// See also [SelectedTourId].
@ProviderFor(SelectedTourId)
final selectedTourIdProvider =
    AutoDisposeNotifierProvider<SelectedTourId, String?>.internal(
  SelectedTourId.new,
  name: r'selectedTourIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedTourIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTourId = AutoDisposeNotifier<String?>;
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
String _$selectedCustomerGroupInCalendarHash() =>
    r'45540d75ccf0fa1d8eb8a1d098d0dc368e9aff97';

/// See also [SelectedCustomerGroupInCalendar].
@ProviderFor(SelectedCustomerGroupInCalendar)
final selectedCustomerGroupInCalendarProvider = AutoDisposeNotifierProvider<
    SelectedCustomerGroupInCalendar, CustomerGroup?>.internal(
  SelectedCustomerGroupInCalendar.new,
  name: r'selectedCustomerGroupInCalendarProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCustomerGroupInCalendarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCustomerGroupInCalendar = AutoDisposeNotifier<CustomerGroup?>;
String _$bookingDetailsSelectedPricingsHash() =>
    r'1bca2d631062e4ca34d211843bf7ce27385b1c8e';

abstract class _$BookingDetailsSelectedPricings
    extends BuildlessAutoDisposeNotifier<List<BookingPricingNumberBooked>> {
  late final List<TourTypePricing> pricings;

  List<BookingPricingNumberBooked> build(
    List<TourTypePricing> pricings,
  );
}

/// The number of each pricing tier that the customer has selected. Data for stripe.
///
/// Copied from [BookingDetailsSelectedPricings].
@ProviderFor(BookingDetailsSelectedPricings)
const bookingDetailsSelectedPricingsProvider =
    BookingDetailsSelectedPricingsFamily();

/// The number of each pricing tier that the customer has selected. Data for stripe.
///
/// Copied from [BookingDetailsSelectedPricings].
class BookingDetailsSelectedPricingsFamily
    extends Family<List<BookingPricingNumberBooked>> {
  /// The number of each pricing tier that the customer has selected. Data for stripe.
  ///
  /// Copied from [BookingDetailsSelectedPricings].
  const BookingDetailsSelectedPricingsFamily();

  /// The number of each pricing tier that the customer has selected. Data for stripe.
  ///
  /// Copied from [BookingDetailsSelectedPricings].
  BookingDetailsSelectedPricingsProvider call(
    List<TourTypePricing> pricings,
  ) {
    return BookingDetailsSelectedPricingsProvider(
      pricings,
    );
  }

  @override
  BookingDetailsSelectedPricingsProvider getProviderOverride(
    covariant BookingDetailsSelectedPricingsProvider provider,
  ) {
    return call(
      provider.pricings,
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
  String? get name => r'bookingDetailsSelectedPricingsProvider';
}

/// The number of each pricing tier that the customer has selected. Data for stripe.
///
/// Copied from [BookingDetailsSelectedPricings].
class BookingDetailsSelectedPricingsProvider
    extends AutoDisposeNotifierProviderImpl<BookingDetailsSelectedPricings,
        List<BookingPricingNumberBooked>> {
  /// The number of each pricing tier that the customer has selected. Data for stripe.
  ///
  /// Copied from [BookingDetailsSelectedPricings].
  BookingDetailsSelectedPricingsProvider(
    List<TourTypePricing> pricings,
  ) : this._internal(
          () => BookingDetailsSelectedPricings()..pricings = pricings,
          from: bookingDetailsSelectedPricingsProvider,
          name: r'bookingDetailsSelectedPricingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingDetailsSelectedPricingsHash,
          dependencies: BookingDetailsSelectedPricingsFamily._dependencies,
          allTransitiveDependencies:
              BookingDetailsSelectedPricingsFamily._allTransitiveDependencies,
          pricings: pricings,
        );

  BookingDetailsSelectedPricingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pricings,
  }) : super.internal();

  final List<TourTypePricing> pricings;

  @override
  List<BookingPricingNumberBooked> runNotifierBuild(
    covariant BookingDetailsSelectedPricings notifier,
  ) {
    return notifier.build(
      pricings,
    );
  }

  @override
  Override overrideWith(BookingDetailsSelectedPricings Function() create) {
    return ProviderOverride(
      origin: this,
      override: BookingDetailsSelectedPricingsProvider._internal(
        () => create()..pricings = pricings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pricings: pricings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<BookingDetailsSelectedPricings,
      List<BookingPricingNumberBooked>> createElement() {
    return _BookingDetailsSelectedPricingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingDetailsSelectedPricingsProvider &&
        other.pricings == pricings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pricings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookingDetailsSelectedPricingsRef
    on AutoDisposeNotifierProviderRef<List<BookingPricingNumberBooked>> {
  /// The parameter `pricings` of this provider.
  List<TourTypePricing> get pricings;
}

class _BookingDetailsSelectedPricingsProviderElement
    extends AutoDisposeNotifierProviderElement<BookingDetailsSelectedPricings,
        List<BookingPricingNumberBooked>>
    with BookingDetailsSelectedPricingsRef {
  _BookingDetailsSelectedPricingsProviderElement(super.provider);

  @override
  List<TourTypePricing> get pricings =>
      (origin as BookingDetailsSelectedPricingsProvider).pricings;
}

String _$panelToShowHash() => r'c292c7e60acd3d33e21fa47ee8c5e5f7abda3285';

/// Controls whether to show the date or info panel.
///
/// Copied from [PanelToShow].
@ProviderFor(PanelToShow)
final panelToShowProvider =
    AutoDisposeNotifierProvider<PanelToShow, ShowBookingPanel>.internal(
  PanelToShow.new,
  name: r'panelToShowProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$panelToShowHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PanelToShow = AutoDisposeNotifier<ShowBookingPanel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
