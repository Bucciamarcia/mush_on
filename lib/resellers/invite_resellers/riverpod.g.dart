// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resellerInvitationHash() =>
    r'6555513a1293007f0a7f495a3fb6d83ea779bb70';

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

/// See also [resellerInvitation].
@ProviderFor(resellerInvitation)
const resellerInvitationProvider = ResellerInvitationFamily();

/// See also [resellerInvitation].
class ResellerInvitationFamily extends Family<AsyncValue<ResellerInvitation?>> {
  /// See also [resellerInvitation].
  const ResellerInvitationFamily();

  /// See also [resellerInvitation].
  ResellerInvitationProvider call(
    String email,
  ) {
    return ResellerInvitationProvider(
      email,
    );
  }

  @override
  ResellerInvitationProvider getProviderOverride(
    covariant ResellerInvitationProvider provider,
  ) {
    return call(
      provider.email,
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
  String? get name => r'resellerInvitationProvider';
}

/// See also [resellerInvitation].
class ResellerInvitationProvider
    extends AutoDisposeStreamProvider<ResellerInvitation?> {
  /// See also [resellerInvitation].
  ResellerInvitationProvider(
    String email,
  ) : this._internal(
          (ref) => resellerInvitation(
            ref as ResellerInvitationRef,
            email,
          ),
          from: resellerInvitationProvider,
          name: r'resellerInvitationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$resellerInvitationHash,
          dependencies: ResellerInvitationFamily._dependencies,
          allTransitiveDependencies:
              ResellerInvitationFamily._allTransitiveDependencies,
          email: email,
        );

  ResellerInvitationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
  }) : super.internal();

  final String email;

  @override
  Override overrideWith(
    Stream<ResellerInvitation?> Function(ResellerInvitationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ResellerInvitationProvider._internal(
        (ref) => create(ref as ResellerInvitationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<ResellerInvitation?> createElement() {
    return _ResellerInvitationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ResellerInvitationProvider && other.email == email;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ResellerInvitationRef
    on AutoDisposeStreamProviderRef<ResellerInvitation?> {
  /// The parameter `email` of this provider.
  String get email;
}

class _ResellerInvitationProviderElement
    extends AutoDisposeStreamProviderElement<ResellerInvitation?>
    with ResellerInvitationRef {
  _ResellerInvitationProviderElement(super.provider);

  @override
  String get email => (origin as ResellerInvitationProvider).email;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
