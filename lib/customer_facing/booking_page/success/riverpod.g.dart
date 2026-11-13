// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingDataSuccessHash() =>
    r'd88bc7b2fe4e3fa5aeb69895e7fa3e4521df56a8';

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

/// Stripe redirects to the success page right after payment, usually before
/// its webhook has marked the booking paid: keep re-checking while it's still
/// "waiting" so the page flips to "confirmed" on its own.
///
/// Copied from [bookingDataSuccess].
@ProviderFor(bookingDataSuccess)
const bookingDataSuccessProvider = BookingDataSuccessFamily();

/// Stripe redirects to the success page right after payment, usually before
/// its webhook has marked the booking paid: keep re-checking while it's still
/// "waiting" so the page flips to "confirmed" on its own.
///
/// Copied from [bookingDataSuccess].
class BookingDataSuccessFamily extends Family<AsyncValue<BookingSuccessData>> {
  /// Stripe redirects to the success page right after payment, usually before
  /// its webhook has marked the booking paid: keep re-checking while it's still
  /// "waiting" so the page flips to "confirmed" on its own.
  ///
  /// Copied from [bookingDataSuccess].
  const BookingDataSuccessFamily();

  /// Stripe redirects to the success page right after payment, usually before
  /// its webhook has marked the booking paid: keep re-checking while it's still
  /// "waiting" so the page flips to "confirmed" on its own.
  ///
  /// Copied from [bookingDataSuccess].
  BookingDataSuccessProvider call({
    required String bookingId,
    required String account,
  }) {
    return BookingDataSuccessProvider(bookingId: bookingId, account: account);
  }

  @override
  BookingDataSuccessProvider getProviderOverride(
    covariant BookingDataSuccessProvider provider,
  ) {
    return call(bookingId: provider.bookingId, account: provider.account);
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

/// Stripe redirects to the success page right after payment, usually before
/// its webhook has marked the booking paid: keep re-checking while it's still
/// "waiting" so the page flips to "confirmed" on its own.
///
/// Copied from [bookingDataSuccess].
class BookingDataSuccessProvider
    extends AutoDisposeStreamProvider<BookingSuccessData> {
  /// Stripe redirects to the success page right after payment, usually before
  /// its webhook has marked the booking paid: keep re-checking while it's still
  /// "waiting" so the page flips to "confirmed" on its own.
  ///
  /// Copied from [bookingDataSuccess].
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
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
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
    Stream<BookingSuccessData> Function(BookingDataSuccessRef provider) create,
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
  AutoDisposeStreamProviderElement<BookingSuccessData> createElement() {
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
    on AutoDisposeStreamProviderRef<BookingSuccessData> {
  /// The parameter `bookingId` of this provider.
  String get bookingId;

  /// The parameter `account` of this provider.
  String get account;
}

class _BookingDataSuccessProviderElement
    extends AutoDisposeStreamProviderElement<BookingSuccessData>
    with BookingDataSuccessRef {
  _BookingDataSuccessProviderElement(super.provider);

  @override
  String get bookingId => (origin as BookingDataSuccessProvider).bookingId;
  @override
  String get account => (origin as BookingDataSuccessProvider).account;
}

String _$receiptUrlHash() => r'e663cb356a78156bac00cee703cf71bb755d7e26';

/// See also [receiptUrl].
@ProviderFor(receiptUrl)
const receiptUrlProvider = ReceiptUrlFamily();

/// See also [receiptUrl].
class ReceiptUrlFamily extends Family<AsyncValue<UrlAndAmount>> {
  /// See also [receiptUrl].
  const ReceiptUrlFamily();

  /// See also [receiptUrl].
  ReceiptUrlProvider call({
    required String account,
    required String bookingId,
  }) {
    return ReceiptUrlProvider(account: account, bookingId: bookingId);
  }

  @override
  ReceiptUrlProvider getProviderOverride(
    covariant ReceiptUrlProvider provider,
  ) {
    return call(account: provider.account, bookingId: provider.bookingId);
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
  ReceiptUrlProvider({required String account, required String bookingId})
    : this._internal(
        (ref) => receiptUrl(
          ref as ReceiptUrlRef,
          account: account,
          bookingId: bookingId,
        ),
        from: receiptUrlProvider,
        name: r'receiptUrlProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$receiptUrlHash,
        dependencies: ReceiptUrlFamily._dependencies,
        allTransitiveDependencies: ReceiptUrlFamily._allTransitiveDependencies,
        account: account,
        bookingId: bookingId,
      );

  ReceiptUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
    required this.bookingId,
  }) : super.internal();

  final String account;
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
        account: account,
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
    return other is ReceiptUrlProvider &&
        other.account == account &&
        other.bookingId == bookingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReceiptUrlRef on AutoDisposeFutureProviderRef<UrlAndAmount> {
  /// The parameter `account` of this provider.
  String get account;

  /// The parameter `bookingId` of this provider.
  String get bookingId;
}

class _ReceiptUrlProviderElement
    extends AutoDisposeFutureProviderElement<UrlAndAmount>
    with ReceiptUrlRef {
  _ReceiptUrlProviderElement(super.provider);

  @override
  String get account => (origin as ReceiptUrlProvider).account;
  @override
  String get bookingId => (origin as ReceiptUrlProvider).bookingId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
