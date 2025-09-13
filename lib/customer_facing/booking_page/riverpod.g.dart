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

String _$monthCellColorHash() => r'bd9799cefc17884cdfa8b4be2e82c6b2c68feb9b';

/// See also [monthCellColor].
@ProviderFor(monthCellColor)
const monthCellColorProvider = MonthCellColorFamily();

/// See also [monthCellColor].
class MonthCellColorFamily extends Family<AsyncValue<Color>> {
  /// See also [monthCellColor].
  const MonthCellColorFamily();

  /// See also [monthCellColor].
  MonthCellColorProvider call(
    String todayCgIdsAndCapsKey,
    String account,
  ) {
    return MonthCellColorProvider(
      todayCgIdsAndCapsKey,
      account,
    );
  }

  @override
  MonthCellColorProvider getProviderOverride(
    covariant MonthCellColorProvider provider,
  ) {
    return call(
      provider.todayCgIdsAndCapsKey,
      provider.account,
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
  String? get name => r'monthCellColorProvider';
}

/// See also [monthCellColor].
class MonthCellColorProvider extends AutoDisposeFutureProvider<Color> {
  /// See also [monthCellColor].
  MonthCellColorProvider(
    String todayCgIdsAndCapsKey,
    String account,
  ) : this._internal(
          (ref) => monthCellColor(
            ref as MonthCellColorRef,
            todayCgIdsAndCapsKey,
            account,
          ),
          from: monthCellColorProvider,
          name: r'monthCellColorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthCellColorHash,
          dependencies: MonthCellColorFamily._dependencies,
          allTransitiveDependencies:
              MonthCellColorFamily._allTransitiveDependencies,
          todayCgIdsAndCapsKey: todayCgIdsAndCapsKey,
          account: account,
        );

  MonthCellColorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.todayCgIdsAndCapsKey,
    required this.account,
  }) : super.internal();

  final String todayCgIdsAndCapsKey;
  final String account;

  @override
  Override overrideWith(
    FutureOr<Color> Function(MonthCellColorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthCellColorProvider._internal(
        (ref) => create(ref as MonthCellColorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        todayCgIdsAndCapsKey: todayCgIdsAndCapsKey,
        account: account,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Color> createElement() {
    return _MonthCellColorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthCellColorProvider &&
        other.todayCgIdsAndCapsKey == todayCgIdsAndCapsKey &&
        other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, todayCgIdsAndCapsKey.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthCellColorRef on AutoDisposeFutureProviderRef<Color> {
  /// The parameter `todayCgIdsAndCapsKey` of this provider.
  String get todayCgIdsAndCapsKey;

  /// The parameter `account` of this provider.
  String get account;
}

class _MonthCellColorProviderElement
    extends AutoDisposeFutureProviderElement<Color> with MonthCellColorRef {
  _MonthCellColorProviderElement(super.provider);

  @override
  String get todayCgIdsAndCapsKey =>
      (origin as MonthCellColorProvider).todayCgIdsAndCapsKey;
  @override
  String get account => (origin as MonthCellColorProvider).account;
}

String _$bookingWidgetHash() => r'14dd631eaa619f171afe1417aa6d0a094d5e56de';

/// See also [bookingWidget].
@ProviderFor(bookingWidget)
const bookingWidgetProvider = BookingWidgetFamily();

/// See also [bookingWidget].
class BookingWidgetFamily extends Family<AsyncValue<Widget>> {
  /// See also [bookingWidget].
  const BookingWidgetFamily();

  /// See also [bookingWidget].
  BookingWidgetProvider call(
    DateTime? selectedDate,
    String account,
  ) {
    return BookingWidgetProvider(
      selectedDate,
      account,
    );
  }

  @override
  BookingWidgetProvider getProviderOverride(
    covariant BookingWidgetProvider provider,
  ) {
    return call(
      provider.selectedDate,
      provider.account,
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
  String? get name => r'bookingWidgetProvider';
}

/// See also [bookingWidget].
class BookingWidgetProvider extends AutoDisposeStreamProvider<Widget> {
  /// See also [bookingWidget].
  BookingWidgetProvider(
    DateTime? selectedDate,
    String account,
  ) : this._internal(
          (ref) => bookingWidget(
            ref as BookingWidgetRef,
            selectedDate,
            account,
          ),
          from: bookingWidgetProvider,
          name: r'bookingWidgetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingWidgetHash,
          dependencies: BookingWidgetFamily._dependencies,
          allTransitiveDependencies:
              BookingWidgetFamily._allTransitiveDependencies,
          selectedDate: selectedDate,
          account: account,
        );

  BookingWidgetProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.selectedDate,
    required this.account,
  }) : super.internal();

  final DateTime? selectedDate;
  final String account;

  @override
  Override overrideWith(
    Stream<Widget> Function(BookingWidgetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookingWidgetProvider._internal(
        (ref) => create(ref as BookingWidgetRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        selectedDate: selectedDate,
        account: account,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Widget> createElement() {
    return _BookingWidgetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingWidgetProvider &&
        other.selectedDate == selectedDate &&
        other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, selectedDate.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookingWidgetRef on AutoDisposeStreamProviderRef<Widget> {
  /// The parameter `selectedDate` of this provider.
  DateTime? get selectedDate;

  /// The parameter `account` of this provider.
  String get account;
}

class _BookingWidgetProviderElement
    extends AutoDisposeStreamProviderElement<Widget> with BookingWidgetRef {
  _BookingWidgetProviderElement(super.provider);

  @override
  DateTime? get selectedDate => (origin as BookingWidgetProvider).selectedDate;
  @override
  String get account => (origin as BookingWidgetProvider).account;
}

String _$visibleDatesHash() => r'dfe2cbad98045d9ada5bc582c89c0f797e7cd33b';

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
