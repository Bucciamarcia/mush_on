// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stripeConnectionHash() => r'4baf134e47218c68ccac010d58c3eae9c5f4a7d4';

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
    r'3b17ef822d7f273a2e7b773c3ad6982d8ed113e0';

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

String _$kennelImageHash() => r'4fb8f62e83fa483a373d90d14077738de80ca8d2';

/// See also [KennelImage].
@ProviderFor(KennelImage)
final kennelImageProvider =
    AutoDisposeAsyncNotifierProvider<KennelImage, Uint8List?>.internal(
  KennelImage.new,
  name: r'kennelImageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$kennelImageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$KennelImage = AutoDisposeAsyncNotifier<Uint8List?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
