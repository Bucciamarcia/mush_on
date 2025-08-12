// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customerDogPhotosHash() => r'03e7f71106fafe047a5faf0f95f9ad9c081f8198';

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
    extends BuildlessAutoDisposeAsyncNotifier<List<Uint8List>> {
  late final String dogId;

  FutureOr<List<Uint8List>> build(
    String dogId,
  );
}

/// See also [CustomerDogPhotos].
@ProviderFor(CustomerDogPhotos)
const customerDogPhotosProvider = CustomerDogPhotosFamily();

/// See also [CustomerDogPhotos].
class CustomerDogPhotosFamily extends Family<AsyncValue<List<Uint8List>>> {
  /// See also [CustomerDogPhotos].
  const CustomerDogPhotosFamily();

  /// See also [CustomerDogPhotos].
  CustomerDogPhotosProvider call(
    String dogId,
  ) {
    return CustomerDogPhotosProvider(
      dogId,
    );
  }

  @override
  CustomerDogPhotosProvider getProviderOverride(
    covariant CustomerDogPhotosProvider provider,
  ) {
    return call(
      provider.dogId,
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
    CustomerDogPhotos, List<Uint8List>> {
  /// See also [CustomerDogPhotos].
  CustomerDogPhotosProvider(
    String dogId,
  ) : this._internal(
          () => CustomerDogPhotos()..dogId = dogId,
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
        );

  CustomerDogPhotosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dogId,
  }) : super.internal();

  final String dogId;

  @override
  FutureOr<List<Uint8List>> runNotifierBuild(
    covariant CustomerDogPhotos notifier,
  ) {
    return notifier.build(
      dogId,
    );
  }

  @override
  Override overrideWith(CustomerDogPhotos Function() create) {
    return ProviderOverride(
      origin: this,
      override: CustomerDogPhotosProvider._internal(
        () => create()..dogId = dogId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dogId: dogId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CustomerDogPhotos, List<Uint8List>>
      createElement() {
    return _CustomerDogPhotosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerDogPhotosProvider && other.dogId == dogId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dogId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerDogPhotosRef
    on AutoDisposeAsyncNotifierProviderRef<List<Uint8List>> {
  /// The parameter `dogId` of this provider.
  String get dogId;
}

class _CustomerDogPhotosProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CustomerDogPhotos,
        List<Uint8List>> with CustomerDogPhotosRef {
  _CustomerDogPhotosProviderElement(super.provider);

  @override
  String get dogId => (origin as CustomerDogPhotosProvider).dogId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
