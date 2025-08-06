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

String _$tourTypePricesHash() => r'b69940c7b80560e02a24a3056fdafe8ec50f2634';

abstract class _$TourTypePrices
    extends BuildlessAutoDisposeAsyncNotifier<List<TourTypePricing>> {
  late final String tourId;

  FutureOr<List<TourTypePricing>> build(
    String tourId,
  );
}

/// Gets the tour prices from the tour id.
///
/// Notice: it gets once, does NOT stream.
///
/// Copied from [TourTypePrices].
@ProviderFor(TourTypePrices)
const tourTypePricesProvider = TourTypePricesFamily();

/// Gets the tour prices from the tour id.
///
/// Notice: it gets once, does NOT stream.
///
/// Copied from [TourTypePrices].
class TourTypePricesFamily extends Family<AsyncValue<List<TourTypePricing>>> {
  /// Gets the tour prices from the tour id.
  ///
  /// Notice: it gets once, does NOT stream.
  ///
  /// Copied from [TourTypePrices].
  const TourTypePricesFamily();

  /// Gets the tour prices from the tour id.
  ///
  /// Notice: it gets once, does NOT stream.
  ///
  /// Copied from [TourTypePrices].
  TourTypePricesProvider call(
    String tourId,
  ) {
    return TourTypePricesProvider(
      tourId,
    );
  }

  @override
  TourTypePricesProvider getProviderOverride(
    covariant TourTypePricesProvider provider,
  ) {
    return call(
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
  String? get name => r'tourTypePricesProvider';
}

/// Gets the tour prices from the tour id.
///
/// Notice: it gets once, does NOT stream.
///
/// Copied from [TourTypePrices].
class TourTypePricesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TourTypePrices, List<TourTypePricing>> {
  /// Gets the tour prices from the tour id.
  ///
  /// Notice: it gets once, does NOT stream.
  ///
  /// Copied from [TourTypePrices].
  TourTypePricesProvider(
    String tourId,
  ) : this._internal(
          () => TourTypePrices()..tourId = tourId,
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
        );

  TourTypePricesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tourId,
  }) : super.internal();

  final String tourId;

  @override
  FutureOr<List<TourTypePricing>> runNotifierBuild(
    covariant TourTypePrices notifier,
  ) {
    return notifier.build(
      tourId,
    );
  }

  @override
  Override overrideWith(TourTypePrices Function() create) {
    return ProviderOverride(
      origin: this,
      override: TourTypePricesProvider._internal(
        () => create()..tourId = tourId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tourId: tourId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TourTypePrices, List<TourTypePricing>>
      createElement() {
    return _TourTypePricesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TourTypePricesProvider && other.tourId == tourId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tourId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TourTypePricesRef
    on AutoDisposeAsyncNotifierProviderRef<List<TourTypePricing>> {
  /// The parameter `tourId` of this provider.
  String get tourId;
}

class _TourTypePricesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TourTypePrices,
        List<TourTypePricing>> with TourTypePricesRef {
  _TourTypePricesProviderElement(super.provider);

  @override
  String get tourId => (origin as TourTypePricesProvider).tourId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
