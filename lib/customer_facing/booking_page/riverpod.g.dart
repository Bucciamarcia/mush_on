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

String _$customerGroupsForTourHash() =>
    r'3f9ce826552eba06a0727bdd89e0c4307676da06';

/// See also [CustomerGroupsForTour].
@ProviderFor(CustomerGroupsForTour)
final customerGroupsForTourProvider = AutoDisposeNotifierProvider<
    CustomerGroupsForTour, List<CustomerGroup>>.internal(
  CustomerGroupsForTour.new,
  name: r'customerGroupsForTourProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$customerGroupsForTourHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CustomerGroupsForTour = AutoDisposeNotifier<List<CustomerGroup>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
