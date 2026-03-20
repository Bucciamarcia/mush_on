// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerCustomField _$CustomerCustomFieldFromJson(Map<String, dynamic> json) =>
    _CustomerCustomField(
      id: json['id'] as String,
      type: $enumDecode(_$CustomerCustomFieldTypeEnumMap, json['type']),
      name: json['name'] as String,
      description: json['description'] as String,
      isRequired: json['isRequired'] as bool,
    );

Map<String, dynamic> _$CustomerCustomFieldToJson(
        _CustomerCustomField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$CustomerCustomFieldTypeEnumMap[instance.type]!,
      'name': instance.name,
      'description': instance.description,
      'isRequired': instance.isRequired,
    };

const _$CustomerCustomFieldTypeEnumMap = {
  CustomerCustomFieldType.text: 'text',
  CustomerCustomFieldType.dropdown: 'dropdown',
};

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

String _$tempCustomerFieldsHash() =>
    r'76eaa8e0ce71bb2f95ad0615fe84fde858f36968';

/// See also [TempCustomerFields].
@ProviderFor(TempCustomerFields)
final tempCustomerFieldsProvider = AutoDisposeNotifierProvider<
    TempCustomerFields, List<CustomerCustomField>>.internal(
  TempCustomerFields.new,
  name: r'tempCustomerFieldsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tempCustomerFieldsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TempCustomerFields = AutoDisposeNotifier<List<CustomerCustomField>>;
String _$isCustomerCustomFieldsEditedHash() =>
    r'2346cddeb43766c3a00390fc016a831707af7664';

/// See also [IsCustomerCustomFieldsEdited].
@ProviderFor(IsCustomerCustomFieldsEdited)
final isCustomerCustomFieldsEditedProvider =
    AutoDisposeNotifierProvider<IsCustomerCustomFieldsEdited, bool>.internal(
  IsCustomerCustomFieldsEdited.new,
  name: r'isCustomerCustomFieldsEditedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isCustomerCustomFieldsEditedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsCustomerCustomFieldsEdited = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
