// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$distanceWarningsHash() => r'de36c074a775082a8ecd3887e035e960d7f6db18';

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

/// A list of distance warnings for dogs that ran too much.
///
/// Copied from [distanceWarnings].
@ProviderFor(distanceWarnings)
const distanceWarningsProvider = DistanceWarningsFamily();

/// A list of distance warnings for dogs that ran too much.
///
/// Copied from [distanceWarnings].
class DistanceWarningsFamily
    extends Family<AsyncValue<List<DogDistanceWarning>>> {
  /// A list of distance warnings for dogs that ran too much.
  ///
  /// Copied from [distanceWarnings].
  const DistanceWarningsFamily();

  /// A list of distance warnings for dogs that ran too much.
  ///
  /// Copied from [distanceWarnings].
  DistanceWarningsProvider call({
    DateTime? latestDate,
  }) {
    return DistanceWarningsProvider(
      latestDate: latestDate,
    );
  }

  @override
  DistanceWarningsProvider getProviderOverride(
    covariant DistanceWarningsProvider provider,
  ) {
    return call(
      latestDate: provider.latestDate,
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
  String? get name => r'distanceWarningsProvider';
}

/// A list of distance warnings for dogs that ran too much.
///
/// Copied from [distanceWarnings].
class DistanceWarningsProvider
    extends AutoDisposeStreamProvider<List<DogDistanceWarning>> {
  /// A list of distance warnings for dogs that ran too much.
  ///
  /// Copied from [distanceWarnings].
  DistanceWarningsProvider({
    DateTime? latestDate,
  }) : this._internal(
          (ref) => distanceWarnings(
            ref as DistanceWarningsRef,
            latestDate: latestDate,
          ),
          from: distanceWarningsProvider,
          name: r'distanceWarningsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$distanceWarningsHash,
          dependencies: DistanceWarningsFamily._dependencies,
          allTransitiveDependencies:
              DistanceWarningsFamily._allTransitiveDependencies,
          latestDate: latestDate,
        );

  DistanceWarningsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.latestDate,
  }) : super.internal();

  final DateTime? latestDate;

  @override
  Override overrideWith(
    Stream<List<DogDistanceWarning>> Function(DistanceWarningsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DistanceWarningsProvider._internal(
        (ref) => create(ref as DistanceWarningsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        latestDate: latestDate,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<DogDistanceWarning>> createElement() {
    return _DistanceWarningsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DistanceWarningsProvider && other.latestDate == latestDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, latestDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DistanceWarningsRef
    on AutoDisposeStreamProviderRef<List<DogDistanceWarning>> {
  /// The parameter `latestDate` of this provider.
  DateTime? get latestDate;
}

class _DistanceWarningsProviderElement
    extends AutoDisposeStreamProviderElement<List<DogDistanceWarning>>
    with DistanceWarningsRef {
  _DistanceWarningsProviderElement(super.provider);

  @override
  DateTime? get latestDate => (origin as DistanceWarningsProvider).latestDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
