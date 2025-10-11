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
