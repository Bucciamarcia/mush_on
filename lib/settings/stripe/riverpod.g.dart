// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stripeConnectionHash() => r'e97fe04c85831344a6a330f3e6fe6f5a10f8fa20';

/// See also [stripeConnection].
@ProviderFor(stripeConnection)
final stripeConnectionProvider =
    AutoDisposeStreamProvider<StripeConnection?>.internal(
  stripeConnection,
  name: r'stripeConnectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stripeConnectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StripeConnectionRef = AutoDisposeStreamProviderRef<StripeConnection?>;
String _$bookingManagerKennelInfoHash() =>
    r'1025b29d541fc3699eaaf2a7b07582127060bd8f';

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

/// See also [bookingManagerKennelInfo].
@ProviderFor(bookingManagerKennelInfo)
const bookingManagerKennelInfoProvider = BookingManagerKennelInfoFamily();

/// See also [bookingManagerKennelInfo].
class BookingManagerKennelInfoFamily
    extends Family<AsyncValue<BookingManagerKennelInfo?>> {
  /// See also [bookingManagerKennelInfo].
  const BookingManagerKennelInfoFamily();

  /// See also [bookingManagerKennelInfo].
  BookingManagerKennelInfoProvider call({
    String? account,
  }) {
    return BookingManagerKennelInfoProvider(
      account: account,
    );
  }

  @override
  BookingManagerKennelInfoProvider getProviderOverride(
    covariant BookingManagerKennelInfoProvider provider,
  ) {
    return call(
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
  String? get name => r'bookingManagerKennelInfoProvider';
}

/// See also [bookingManagerKennelInfo].
class BookingManagerKennelInfoProvider
    extends AutoDisposeStreamProvider<BookingManagerKennelInfo?> {
  /// See also [bookingManagerKennelInfo].
  BookingManagerKennelInfoProvider({
    String? account,
  }) : this._internal(
          (ref) => bookingManagerKennelInfo(
            ref as BookingManagerKennelInfoRef,
            account: account,
          ),
          from: bookingManagerKennelInfoProvider,
          name: r'bookingManagerKennelInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingManagerKennelInfoHash,
          dependencies: BookingManagerKennelInfoFamily._dependencies,
          allTransitiveDependencies:
              BookingManagerKennelInfoFamily._allTransitiveDependencies,
          account: account,
        );

  BookingManagerKennelInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
  }) : super.internal();

  final String? account;

  @override
  Override overrideWith(
    Stream<BookingManagerKennelInfo?> Function(
            BookingManagerKennelInfoRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookingManagerKennelInfoProvider._internal(
        (ref) => create(ref as BookingManagerKennelInfoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<BookingManagerKennelInfo?> createElement() {
    return _BookingManagerKennelInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingManagerKennelInfoProvider &&
        other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookingManagerKennelInfoRef
    on AutoDisposeStreamProviderRef<BookingManagerKennelInfo?> {
  /// The parameter `account` of this provider.
  String? get account;
}

class _BookingManagerKennelInfoProviderElement
    extends AutoDisposeStreamProviderElement<BookingManagerKennelInfo?>
    with BookingManagerKennelInfoRef {
  _BookingManagerKennelInfoProviderElement(super.provider);

  @override
  String? get account => (origin as BookingManagerKennelInfoProvider).account;
}

String _$kennelImageHash() => r'06f48bb76ef49847690804a1c5f61cbefb57ae71';

abstract class _$KennelImage
    extends BuildlessAutoDisposeAsyncNotifier<Uint8List?> {
  late final String? account;

  FutureOr<Uint8List?> build({
    String? account,
  });
}

/// See also [KennelImage].
@ProviderFor(KennelImage)
const kennelImageProvider = KennelImageFamily();

/// See also [KennelImage].
class KennelImageFamily extends Family<AsyncValue<Uint8List?>> {
  /// See also [KennelImage].
  const KennelImageFamily();

  /// See also [KennelImage].
  KennelImageProvider call({
    String? account,
  }) {
    return KennelImageProvider(
      account: account,
    );
  }

  @override
  KennelImageProvider getProviderOverride(
    covariant KennelImageProvider provider,
  ) {
    return call(
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
  String? get name => r'kennelImageProvider';
}

/// See also [KennelImage].
class KennelImageProvider
    extends AutoDisposeAsyncNotifierProviderImpl<KennelImage, Uint8List?> {
  /// See also [KennelImage].
  KennelImageProvider({
    String? account,
  }) : this._internal(
          () => KennelImage()..account = account,
          from: kennelImageProvider,
          name: r'kennelImageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$kennelImageHash,
          dependencies: KennelImageFamily._dependencies,
          allTransitiveDependencies:
              KennelImageFamily._allTransitiveDependencies,
          account: account,
        );

  KennelImageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
  }) : super.internal();

  final String? account;

  @override
  FutureOr<Uint8List?> runNotifierBuild(
    covariant KennelImage notifier,
  ) {
    return notifier.build(
      account: account,
    );
  }

  @override
  Override overrideWith(KennelImage Function() create) {
    return ProviderOverride(
      origin: this,
      override: KennelImageProvider._internal(
        () => create()..account = account,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<KennelImage, Uint8List?>
      createElement() {
    return _KennelImageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is KennelImageProvider && other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin KennelImageRef on AutoDisposeAsyncNotifierProviderRef<Uint8List?> {
  /// The parameter `account` of this provider.
  String? get account;
}

class _KennelImageProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<KennelImage, Uint8List?>
    with KennelImageRef {
  _KennelImageProviderElement(super.provider);

  @override
  String? get account => (origin as KennelImageProvider).account;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
