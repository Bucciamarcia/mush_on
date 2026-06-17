// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userInvitationHash() => r'02b736a56aad7fc0f48a3638233d841298812815';

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

/// See also [userInvitation].
@ProviderFor(userInvitation)
const userInvitationProvider = UserInvitationFamily();

/// See also [userInvitation].
class UserInvitationFamily extends Family<AsyncValue<InvitationPreview>> {
  /// See also [userInvitation].
  const UserInvitationFamily();

  /// See also [userInvitation].
  UserInvitationProvider call({
    required String email,
    required String securityCode,
  }) {
    return UserInvitationProvider(email: email, securityCode: securityCode);
  }

  @override
  UserInvitationProvider getProviderOverride(
    covariant UserInvitationProvider provider,
  ) {
    return call(email: provider.email, securityCode: provider.securityCode);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userInvitationProvider';
}

/// See also [userInvitation].
class UserInvitationProvider
    extends AutoDisposeFutureProvider<InvitationPreview> {
  /// See also [userInvitation].
  UserInvitationProvider({required String email, required String securityCode})
    : this._internal(
        (ref) => userInvitation(
          ref as UserInvitationRef,
          email: email,
          securityCode: securityCode,
        ),
        from: userInvitationProvider,
        name: r'userInvitationProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userInvitationHash,
        dependencies: UserInvitationFamily._dependencies,
        allTransitiveDependencies:
            UserInvitationFamily._allTransitiveDependencies,
        email: email,
        securityCode: securityCode,
      );

  UserInvitationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
    required this.securityCode,
  }) : super.internal();

  final String email;
  final String securityCode;

  @override
  Override overrideWith(
    FutureOr<InvitationPreview> Function(UserInvitationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserInvitationProvider._internal(
        (ref) => create(ref as UserInvitationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
        securityCode: securityCode,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<InvitationPreview> createElement() {
    return _UserInvitationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserInvitationProvider &&
        other.email == email &&
        other.securityCode == securityCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, securityCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserInvitationRef on AutoDisposeFutureProviderRef<InvitationPreview> {
  /// The parameter `email` of this provider.
  String get email;

  /// The parameter `securityCode` of this provider.
  String get securityCode;
}

class _UserInvitationProviderElement
    extends AutoDisposeFutureProviderElement<InvitationPreview>
    with UserInvitationRef {
  _UserInvitationProviderElement(super.provider);

  @override
  String get email => (origin as UserInvitationProvider).email;
  @override
  String get securityCode => (origin as UserInvitationProvider).securityCode;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
