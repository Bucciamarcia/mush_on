// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingDataSuccessHash() =>
    r'434beb393e6b6891b268fbecf959e015c6bf223b';

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

/// See also [bookingDataSuccess].
@ProviderFor(bookingDataSuccess)
const bookingDataSuccessProvider = BookingDataSuccessFamily();

/// See also [bookingDataSuccess].
class BookingDataSuccessFamily
    extends Family<AsyncValue<(Booking, List<Customer>, CustomerGroup)>> {
  /// See also [bookingDataSuccess].
  const BookingDataSuccessFamily();

  /// See also [bookingDataSuccess].
  BookingDataSuccessProvider call({
    required String bookingId,
    required String account,
  }) {
    return BookingDataSuccessProvider(
      bookingId: bookingId,
      account: account,
    );
  }

  @override
  BookingDataSuccessProvider getProviderOverride(
    covariant BookingDataSuccessProvider provider,
  ) {
    return call(
      bookingId: provider.bookingId,
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
  String? get name => r'bookingDataSuccessProvider';
}

/// See also [bookingDataSuccess].
class BookingDataSuccessProvider extends AutoDisposeFutureProvider<
    (Booking, List<Customer>, CustomerGroup)> {
  /// See also [bookingDataSuccess].
  BookingDataSuccessProvider({
    required String bookingId,
    required String account,
  }) : this._internal(
          (ref) => bookingDataSuccess(
            ref as BookingDataSuccessRef,
            bookingId: bookingId,
            account: account,
          ),
          from: bookingDataSuccessProvider,
          name: r'bookingDataSuccessProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingDataSuccessHash,
          dependencies: BookingDataSuccessFamily._dependencies,
          allTransitiveDependencies:
              BookingDataSuccessFamily._allTransitiveDependencies,
          bookingId: bookingId,
          account: account,
        );

  BookingDataSuccessProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingId,
    required this.account,
  }) : super.internal();

  final String bookingId;
  final String account;

  @override
  Override overrideWith(
    FutureOr<(Booking, List<Customer>, CustomerGroup)> Function(
            BookingDataSuccessRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookingDataSuccessProvider._internal(
        (ref) => create(ref as BookingDataSuccessRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookingId: bookingId,
        account: account,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<(Booking, List<Customer>, CustomerGroup)>
      createElement() {
    return _BookingDataSuccessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingDataSuccessProvider &&
        other.bookingId == bookingId &&
        other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookingDataSuccessRef
    on AutoDisposeFutureProviderRef<(Booking, List<Customer>, CustomerGroup)> {
  /// The parameter `bookingId` of this provider.
  String get bookingId;

  /// The parameter `account` of this provider.
  String get account;
}

class _BookingDataSuccessProviderElement
    extends AutoDisposeFutureProviderElement<
        (Booking, List<Customer>, CustomerGroup)> with BookingDataSuccessRef {
  _BookingDataSuccessProviderElement(super.provider);

  @override
  String get bookingId => (origin as BookingDataSuccessProvider).bookingId;
  @override
  String get account => (origin as BookingDataSuccessProvider).account;
}

String _$receiptUrlHash() => r'cdc75029d0d148d21c2874dc7126658d76b0ef04';

/// See also [receiptUrl].
@ProviderFor(receiptUrl)
const receiptUrlProvider = ReceiptUrlFamily();

/// See also [receiptUrl].
class ReceiptUrlFamily extends Family<AsyncValue<UrlAndAmount>> {
  /// See also [receiptUrl].
  const ReceiptUrlFamily();

  /// See also [receiptUrl].
  ReceiptUrlProvider call(
    String bookingId,
  ) {
    return ReceiptUrlProvider(
      bookingId,
    );
  }

  @override
  ReceiptUrlProvider getProviderOverride(
    covariant ReceiptUrlProvider provider,
  ) {
    return call(
      provider.bookingId,
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
  String? get name => r'receiptUrlProvider';
}

/// See also [receiptUrl].
class ReceiptUrlProvider extends AutoDisposeFutureProvider<UrlAndAmount> {
  /// See also [receiptUrl].
  ReceiptUrlProvider(
    String bookingId,
  ) : this._internal(
          (ref) => receiptUrl(
            ref as ReceiptUrlRef,
            bookingId,
          ),
          from: receiptUrlProvider,
          name: r'receiptUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$receiptUrlHash,
          dependencies: ReceiptUrlFamily._dependencies,
          allTransitiveDependencies:
              ReceiptUrlFamily._allTransitiveDependencies,
          bookingId: bookingId,
        );

  ReceiptUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingId,
  }) : super.internal();

  final String bookingId;

  @override
  Override overrideWith(
    FutureOr<UrlAndAmount> Function(ReceiptUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReceiptUrlProvider._internal(
        (ref) => create(ref as ReceiptUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookingId: bookingId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UrlAndAmount> createElement() {
    return _ReceiptUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReceiptUrlProvider && other.bookingId == bookingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReceiptUrlRef on AutoDisposeFutureProviderRef<UrlAndAmount> {
  /// The parameter `bookingId` of this provider.
  String get bookingId;
}

class _ReceiptUrlProviderElement
    extends AutoDisposeFutureProviderElement<UrlAndAmount> with ReceiptUrlRef {
  _ReceiptUrlProviderElement(super.provider);

  @override
  String get bookingId => (origin as ReceiptUrlProvider).bookingId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
