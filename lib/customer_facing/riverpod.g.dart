// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customerDogPhotosHash() => r'e7af1698f6fbb4446159188144a26d85b9141050';

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

abstract class _$CustomerDogPhotos
    extends BuildlessAutoDisposeAsyncNotifier<List<DogPhoto>> {
  late final String dogId;
  late final bool includeAvatar;

  FutureOr<List<DogPhoto>> build({
    required String dogId,
    required bool includeAvatar,
  });
}

/// See also [CustomerDogPhotos].
@ProviderFor(CustomerDogPhotos)
const customerDogPhotosProvider = CustomerDogPhotosFamily();

/// See also [CustomerDogPhotos].
class CustomerDogPhotosFamily extends Family<AsyncValue<List<DogPhoto>>> {
  /// See also [CustomerDogPhotos].
  const CustomerDogPhotosFamily();

  /// See also [CustomerDogPhotos].
  CustomerDogPhotosProvider call({
    required String dogId,
    required bool includeAvatar,
  }) {
    return CustomerDogPhotosProvider(
      dogId: dogId,
      includeAvatar: includeAvatar,
    );
  }

  @override
  CustomerDogPhotosProvider getProviderOverride(
    covariant CustomerDogPhotosProvider provider,
  ) {
    return call(
      dogId: provider.dogId,
      includeAvatar: provider.includeAvatar,
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
  String? get name => r'customerDogPhotosProvider';
}

/// See also [CustomerDogPhotos].
class CustomerDogPhotosProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CustomerDogPhotos, List<DogPhoto>> {
  /// See also [CustomerDogPhotos].
  CustomerDogPhotosProvider({
    required String dogId,
    required bool includeAvatar,
  }) : this._internal(
          () => CustomerDogPhotos()
            ..dogId = dogId
            ..includeAvatar = includeAvatar,
          from: customerDogPhotosProvider,
          name: r'customerDogPhotosProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerDogPhotosHash,
          dependencies: CustomerDogPhotosFamily._dependencies,
          allTransitiveDependencies:
              CustomerDogPhotosFamily._allTransitiveDependencies,
          dogId: dogId,
          includeAvatar: includeAvatar,
        );

  CustomerDogPhotosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dogId,
    required this.includeAvatar,
  }) : super.internal();

  final String dogId;
  final bool includeAvatar;

  @override
  FutureOr<List<DogPhoto>> runNotifierBuild(
    covariant CustomerDogPhotos notifier,
  ) {
    return notifier.build(
      dogId: dogId,
      includeAvatar: includeAvatar,
    );
  }

  @override
  Override overrideWith(CustomerDogPhotos Function() create) {
    return ProviderOverride(
      origin: this,
      override: CustomerDogPhotosProvider._internal(
        () => create()
          ..dogId = dogId
          ..includeAvatar = includeAvatar,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dogId: dogId,
        includeAvatar: includeAvatar,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CustomerDogPhotos, List<DogPhoto>>
      createElement() {
    return _CustomerDogPhotosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerDogPhotosProvider &&
        other.dogId == dogId &&
        other.includeAvatar == includeAvatar;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dogId.hashCode);
    hash = _SystemHash.combine(hash, includeAvatar.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerDogPhotosRef
    on AutoDisposeAsyncNotifierProviderRef<List<DogPhoto>> {
  /// The parameter `dogId` of this provider.
  String get dogId;

  /// The parameter `includeAvatar` of this provider.
  bool get includeAvatar;
}

class _CustomerDogPhotosProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CustomerDogPhotos,
        List<DogPhoto>> with CustomerDogPhotosRef {
  _CustomerDogPhotosProviderElement(super.provider);

  @override
  String get dogId => (origin as CustomerDogPhotosProvider).dogId;
  @override
  bool get includeAvatar => (origin as CustomerDogPhotosProvider).includeAvatar;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
