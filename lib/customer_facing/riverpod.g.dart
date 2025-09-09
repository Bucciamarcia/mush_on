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
    r'12417b9ed63bb9984500d87e75c103bb0f61520e';

/// See also [customerGroupsForTour].
@ProviderFor(customerGroupsForTour)
const customerGroupsForTourProvider = CustomerGroupsForTourFamily();

/// See also [customerGroupsForTour].
class CustomerGroupsForTourFamily
    extends Family<AsyncValue<List<CustomerGroup>>> {
  /// See also [customerGroupsForTour].
  const CustomerGroupsForTourFamily();

  /// See also [customerGroupsForTour].
  CustomerGroupsForTourProvider call({
    required String account,
    required String tourTypeId,
    required DateTime intialDate,
    required DateTime finalDate,
  }) {
    return CustomerGroupsForTourProvider(
      account: account,
      tourTypeId: tourTypeId,
      intialDate: intialDate,
      finalDate: finalDate,
    );
  }

  @override
  CustomerGroupsForTourProvider getProviderOverride(
    covariant CustomerGroupsForTourProvider provider,
  ) {
    return call(
      account: provider.account,
      tourTypeId: provider.tourTypeId,
      intialDate: provider.intialDate,
      finalDate: provider.finalDate,
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
  String? get name => r'customerGroupsForTourProvider';
}

/// See also [customerGroupsForTour].
class CustomerGroupsForTourProvider
    extends AutoDisposeStreamProvider<List<CustomerGroup>> {
  /// See also [customerGroupsForTour].
  CustomerGroupsForTourProvider({
    required String account,
    required String tourTypeId,
    required DateTime intialDate,
    required DateTime finalDate,
  }) : this._internal(
          (ref) => customerGroupsForTour(
            ref as CustomerGroupsForTourRef,
            account: account,
            tourTypeId: tourTypeId,
            intialDate: intialDate,
            finalDate: finalDate,
          ),
          from: customerGroupsForTourProvider,
          name: r'customerGroupsForTourProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerGroupsForTourHash,
          dependencies: CustomerGroupsForTourFamily._dependencies,
          allTransitiveDependencies:
              CustomerGroupsForTourFamily._allTransitiveDependencies,
          account: account,
          tourTypeId: tourTypeId,
          intialDate: intialDate,
          finalDate: finalDate,
        );

  CustomerGroupsForTourProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
    required this.tourTypeId,
    required this.intialDate,
    required this.finalDate,
  }) : super.internal();

  final String account;
  final String tourTypeId;
  final DateTime intialDate;
  final DateTime finalDate;

  @override
  Override overrideWith(
    Stream<List<CustomerGroup>> Function(CustomerGroupsForTourRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerGroupsForTourProvider._internal(
        (ref) => create(ref as CustomerGroupsForTourRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
        tourTypeId: tourTypeId,
        intialDate: intialDate,
        finalDate: finalDate,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<CustomerGroup>> createElement() {
    return _CustomerGroupsForTourProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerGroupsForTourProvider &&
        other.account == account &&
        other.tourTypeId == tourTypeId &&
        other.intialDate == intialDate &&
        other.finalDate == finalDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, tourTypeId.hashCode);
    hash = _SystemHash.combine(hash, intialDate.hashCode);
    hash = _SystemHash.combine(hash, finalDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerGroupsForTourRef
    on AutoDisposeStreamProviderRef<List<CustomerGroup>> {
  /// The parameter `account` of this provider.
  String get account;

  /// The parameter `tourTypeId` of this provider.
  String get tourTypeId;

  /// The parameter `intialDate` of this provider.
  DateTime get intialDate;

  /// The parameter `finalDate` of this provider.
  DateTime get finalDate;
}

class _CustomerGroupsForTourProviderElement
    extends AutoDisposeStreamProviderElement<List<CustomerGroup>>
    with CustomerGroupsForTourRef {
  _CustomerGroupsForTourProviderElement(super.provider);

  @override
  String get account => (origin as CustomerGroupsForTourProvider).account;
  @override
  String get tourTypeId => (origin as CustomerGroupsForTourProvider).tourTypeId;
  @override
  DateTime get intialDate =>
      (origin as CustomerGroupsForTourProvider).intialDate;
  @override
  DateTime get finalDate => (origin as CustomerGroupsForTourProvider).finalDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
