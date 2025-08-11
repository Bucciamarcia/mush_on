// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allTourTypesHash() => r'dae7b58e328ca93039e201a773d55d665abea6d2';

/// A list of every tour type.
///
/// Copied from [allTourTypes].
@ProviderFor(allTourTypes)
final allTourTypesProvider = AutoDisposeStreamProvider<List<TourType>>.internal(
  allTourTypes,
  name: r'allTourTypesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTourTypesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllTourTypesRef = AutoDisposeStreamProviderRef<List<TourType>>;
String _$tourTypeByIdHash() => r'b1f3612be40fef2775982b058a6912a61695d15d';

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

/// Gets the tour type object from its id.
///
/// Copied from [tourTypeById].
@ProviderFor(tourTypeById)
const tourTypeByIdProvider = TourTypeByIdFamily();

/// Gets the tour type object from its id.
///
/// Copied from [tourTypeById].
class TourTypeByIdFamily extends Family<AsyncValue<TourType>> {
  /// Gets the tour type object from its id.
  ///
  /// Copied from [tourTypeById].
  const TourTypeByIdFamily();

  /// Gets the tour type object from its id.
  ///
  /// Copied from [tourTypeById].
  TourTypeByIdProvider call(
    String id,
  ) {
    return TourTypeByIdProvider(
      id,
    );
  }

  @override
  TourTypeByIdProvider getProviderOverride(
    covariant TourTypeByIdProvider provider,
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
  String? get name => r'tourTypeByIdProvider';
}

/// Gets the tour type object from its id.
///
/// Copied from [tourTypeById].
class TourTypeByIdProvider extends AutoDisposeFutureProvider<TourType> {
  /// Gets the tour type object from its id.
  ///
  /// Copied from [tourTypeById].
  TourTypeByIdProvider(
    String id,
  ) : this._internal(
          (ref) => tourTypeById(
            ref as TourTypeByIdRef,
            id,
          ),
          from: tourTypeByIdProvider,
          name: r'tourTypeByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tourTypeByIdHash,
          dependencies: TourTypeByIdFamily._dependencies,
          allTransitiveDependencies:
              TourTypeByIdFamily._allTransitiveDependencies,
          id: id,
        );

  TourTypeByIdProvider._internal(
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
    FutureOr<TourType> Function(TourTypeByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TourTypeByIdProvider._internal(
        (ref) => create(ref as TourTypeByIdRef),
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
  AutoDisposeFutureProviderElement<TourType> createElement() {
    return _TourTypeByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TourTypeByIdProvider && other.id == id;
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
mixin TourTypeByIdRef on AutoDisposeFutureProviderRef<TourType> {
  /// The parameter `id` of this provider.
  String get id;
}

class _TourTypeByIdProviderElement
    extends AutoDisposeFutureProviderElement<TourType> with TourTypeByIdRef {
  _TourTypeByIdProviderElement(super.provider);

  @override
  String get id => (origin as TourTypeByIdProvider).id;
}

String _$tourTypePricingByIdHash() =>
    r'e14ac0923e988fdd2057a02158a064a39c224e09';

/// Returns the pricing model for a specific id
///
/// Copied from [tourTypePricingById].
@ProviderFor(tourTypePricingById)
const tourTypePricingByIdProvider = TourTypePricingByIdFamily();

/// Returns the pricing model for a specific id
///
/// Copied from [tourTypePricingById].
class TourTypePricingByIdFamily extends Family<AsyncValue<TourTypePricing?>> {
  /// Returns the pricing model for a specific id
  ///
  /// Copied from [tourTypePricingById].
  const TourTypePricingByIdFamily();

  /// Returns the pricing model for a specific id
  ///
  /// Copied from [tourTypePricingById].
  TourTypePricingByIdProvider call(
    String pricingId,
    String tourId,
  ) {
    return TourTypePricingByIdProvider(
      pricingId,
      tourId,
    );
  }

  @override
  TourTypePricingByIdProvider getProviderOverride(
    covariant TourTypePricingByIdProvider provider,
  ) {
    return call(
      provider.pricingId,
      provider.tourId,
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
  String? get name => r'tourTypePricingByIdProvider';
}

/// Returns the pricing model for a specific id
///
/// Copied from [tourTypePricingById].
class TourTypePricingByIdProvider
    extends AutoDisposeStreamProvider<TourTypePricing?> {
  /// Returns the pricing model for a specific id
  ///
  /// Copied from [tourTypePricingById].
  TourTypePricingByIdProvider(
    String pricingId,
    String tourId,
  ) : this._internal(
          (ref) => tourTypePricingById(
            ref as TourTypePricingByIdRef,
            pricingId,
            tourId,
          ),
          from: tourTypePricingByIdProvider,
          name: r'tourTypePricingByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tourTypePricingByIdHash,
          dependencies: TourTypePricingByIdFamily._dependencies,
          allTransitiveDependencies:
              TourTypePricingByIdFamily._allTransitiveDependencies,
          pricingId: pricingId,
          tourId: tourId,
        );

  TourTypePricingByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pricingId,
    required this.tourId,
  }) : super.internal();

  final String pricingId;
  final String tourId;

  @override
  Override overrideWith(
    Stream<TourTypePricing?> Function(TourTypePricingByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TourTypePricingByIdProvider._internal(
        (ref) => create(ref as TourTypePricingByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pricingId: pricingId,
        tourId: tourId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<TourTypePricing?> createElement() {
    return _TourTypePricingByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TourTypePricingByIdProvider &&
        other.pricingId == pricingId &&
        other.tourId == tourId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pricingId.hashCode);
    hash = _SystemHash.combine(hash, tourId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TourTypePricingByIdRef on AutoDisposeStreamProviderRef<TourTypePricing?> {
  /// The parameter `pricingId` of this provider.
  String get pricingId;

  /// The parameter `tourId` of this provider.
  String get tourId;
}

class _TourTypePricingByIdProviderElement
    extends AutoDisposeStreamProviderElement<TourTypePricing?>
    with TourTypePricingByIdRef {
  _TourTypePricingByIdProviderElement(super.provider);

  @override
  String get pricingId => (origin as TourTypePricingByIdProvider).pricingId;
  @override
  String get tourId => (origin as TourTypePricingByIdProvider).tourId;
}

String _$tourTypePricesHash() => r'98d3bcd53daf98544c56d704ef6b94a4be7b4fc8';

abstract class _$TourTypePrices
    extends BuildlessAutoDisposeStreamNotifier<List<TourTypePricing>> {
  late final String tourId;
  late final bool getArchived;

  Stream<List<TourTypePricing>> build(
    String tourId, {
    bool getArchived = false,
  });
}

/// Gets the tour prices from the tour id.
///
/// Copied from [TourTypePrices].
@ProviderFor(TourTypePrices)
const tourTypePricesProvider = TourTypePricesFamily();

/// Gets the tour prices from the tour id.
///
/// Copied from [TourTypePrices].
class TourTypePricesFamily extends Family<AsyncValue<List<TourTypePricing>>> {
  /// Gets the tour prices from the tour id.
  ///
  /// Copied from [TourTypePrices].
  const TourTypePricesFamily();

  /// Gets the tour prices from the tour id.
  ///
  /// Copied from [TourTypePrices].
  TourTypePricesProvider call(
    String tourId, {
    bool getArchived = false,
  }) {
    return TourTypePricesProvider(
      tourId,
      getArchived: getArchived,
    );
  }

  @override
  TourTypePricesProvider getProviderOverride(
    covariant TourTypePricesProvider provider,
  ) {
    return call(
      provider.tourId,
      getArchived: provider.getArchived,
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
  String? get name => r'tourTypePricesProvider';
}

/// Gets the tour prices from the tour id.
///
/// Copied from [TourTypePrices].
class TourTypePricesProvider extends AutoDisposeStreamNotifierProviderImpl<
    TourTypePrices, List<TourTypePricing>> {
  /// Gets the tour prices from the tour id.
  ///
  /// Copied from [TourTypePrices].
  TourTypePricesProvider(
    String tourId, {
    bool getArchived = false,
  }) : this._internal(
          () => TourTypePrices()
            ..tourId = tourId
            ..getArchived = getArchived,
          from: tourTypePricesProvider,
          name: r'tourTypePricesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tourTypePricesHash,
          dependencies: TourTypePricesFamily._dependencies,
          allTransitiveDependencies:
              TourTypePricesFamily._allTransitiveDependencies,
          tourId: tourId,
          getArchived: getArchived,
        );

  TourTypePricesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tourId,
    required this.getArchived,
  }) : super.internal();

  final String tourId;
  final bool getArchived;

  @override
  Stream<List<TourTypePricing>> runNotifierBuild(
    covariant TourTypePrices notifier,
  ) {
    return notifier.build(
      tourId,
      getArchived: getArchived,
    );
  }

  @override
  Override overrideWith(TourTypePrices Function() create) {
    return ProviderOverride(
      origin: this,
      override: TourTypePricesProvider._internal(
        () => create()
          ..tourId = tourId
          ..getArchived = getArchived,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tourId: tourId,
        getArchived: getArchived,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<TourTypePrices,
      List<TourTypePricing>> createElement() {
    return _TourTypePricesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TourTypePricesProvider &&
        other.tourId == tourId &&
        other.getArchived == getArchived;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tourId.hashCode);
    hash = _SystemHash.combine(hash, getArchived.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TourTypePricesRef
    on AutoDisposeStreamNotifierProviderRef<List<TourTypePricing>> {
  /// The parameter `tourId` of this provider.
  String get tourId;

  /// The parameter `getArchived` of this provider.
  bool get getArchived;
}

class _TourTypePricesProviderElement
    extends AutoDisposeStreamNotifierProviderElement<TourTypePrices,
        List<TourTypePricing>> with TourTypePricesRef {
  _TourTypePricesProviderElement(super.provider);

  @override
  String get tourId => (origin as TourTypePricesProvider).tourId;
  @override
  bool get getArchived => (origin as TourTypePricesProvider).getArchived;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
