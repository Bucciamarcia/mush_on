// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userProfilePicHash() => r'54f25411bbf3b8c4f49307602b1c10ce81630b80';

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

abstract class _$UserProfilePic
    extends BuildlessAutoDisposeAsyncNotifier<Uint8List?> {
  late final String? uid;

  FutureOr<Uint8List?> build(
    String? uid,
  );
}

/// See also [UserProfilePic].
@ProviderFor(UserProfilePic)
const userProfilePicProvider = UserProfilePicFamily();

/// See also [UserProfilePic].
class UserProfilePicFamily extends Family<AsyncValue<Uint8List?>> {
  /// See also [UserProfilePic].
  const UserProfilePicFamily();

  /// See also [UserProfilePic].
  UserProfilePicProvider call(
    String? uid,
  ) {
    return UserProfilePicProvider(
      uid,
    );
  }

  @override
  UserProfilePicProvider getProviderOverride(
    covariant UserProfilePicProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'userProfilePicProvider';
}

/// See also [UserProfilePic].
class UserProfilePicProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserProfilePic, Uint8List?> {
  /// See also [UserProfilePic].
  UserProfilePicProvider(
    String? uid,
  ) : this._internal(
          () => UserProfilePic()..uid = uid,
          from: userProfilePicProvider,
          name: r'userProfilePicProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userProfilePicHash,
          dependencies: UserProfilePicFamily._dependencies,
          allTransitiveDependencies:
              UserProfilePicFamily._allTransitiveDependencies,
          uid: uid,
        );

  UserProfilePicProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String? uid;

  @override
  FutureOr<Uint8List?> runNotifierBuild(
    covariant UserProfilePic notifier,
  ) {
    return notifier.build(
      uid,
    );
  }

  @override
  Override overrideWith(UserProfilePic Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserProfilePicProvider._internal(
        () => create()..uid = uid,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserProfilePic, Uint8List?>
      createElement() {
    return _UserProfilePicProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfilePicProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserProfilePicRef on AutoDisposeAsyncNotifierProviderRef<Uint8List?> {
  /// The parameter `uid` of this provider.
  String? get uid;
}

class _UserProfilePicProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserProfilePic, Uint8List?>
    with UserProfilePicRef {
  _UserProfilePicProviderElement(super.provider);

  @override
  String? get uid => (origin as UserProfilePicProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
