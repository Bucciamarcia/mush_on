// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tourTypesHash() => r'e7c85c400480e5898bc766e6dc9b0c1a96041fec';

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

/// See also [tourTypes].
@ProviderFor(tourTypes)
const tourTypesProvider = TourTypesFamily();

/// See also [tourTypes].
class TourTypesFamily extends Family<AsyncValue<List<TourType>>> {
  /// See also [tourTypes].
  const TourTypesFamily();

  /// See also [tourTypes].
  TourTypesProvider call(
    String account,
  ) {
    return TourTypesProvider(
      account,
    );
  }

  @override
  TourTypesProvider getProviderOverride(
    covariant TourTypesProvider provider,
  ) {
    return call(
      provider.account,
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
  String? get name => r'tourTypesProvider';
}

/// See also [tourTypes].
class TourTypesProvider extends AutoDisposeFutureProvider<List<TourType>> {
  /// See also [tourTypes].
  TourTypesProvider(
    String account,
  ) : this._internal(
          (ref) => tourTypes(
            ref as TourTypesRef,
            account,
          ),
          from: tourTypesProvider,
          name: r'tourTypesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tourTypesHash,
          dependencies: TourTypesFamily._dependencies,
          allTransitiveDependencies: TourTypesFamily._allTransitiveDependencies,
          account: account,
        );

  TourTypesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
  }) : super.internal();

  final String account;

  @override
  Override overrideWith(
    FutureOr<List<TourType>> Function(TourTypesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TourTypesProvider._internal(
        (ref) => create(ref as TourTypesRef),
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
  AutoDisposeFutureProviderElement<List<TourType>> createElement() {
    return _TourTypesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TourTypesProvider && other.account == account;
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
mixin TourTypesRef on AutoDisposeFutureProviderRef<List<TourType>> {
  /// The parameter `account` of this provider.
  String get account;
}

class _TourTypesProviderElement
    extends AutoDisposeFutureProviderElement<List<TourType>> with TourTypesRef {
  _TourTypesProviderElement(super.provider);

  @override
  String get account => (origin as TourTypesProvider).account;
}

String _$accountToResellHash() => r'1d465256eb279572dc1c5abbac9769097b994256';

/// See also [AccountToResell].
@ProviderFor(AccountToResell)
final accountToResellProvider =
    AsyncNotifierProvider<AccountToResell, AccountAndDiscount?>.internal(
  AccountToResell.new,
  name: r'accountToResellProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountToResellHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountToResell = AsyncNotifier<AccountAndDiscount?>;
String _$visibleDatesHash() => r'26b3e3a4a1b914351e5abd1284a056339f9c5848';

/// See also [VisibleDates].
@ProviderFor(VisibleDates)
final visibleDatesProvider =
    AutoDisposeNotifierProvider<VisibleDates, List<DateTime>>.internal(
  VisibleDates.new,
  name: r'visibleDatesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$visibleDatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VisibleDates = AutoDisposeNotifier<List<DateTime>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
