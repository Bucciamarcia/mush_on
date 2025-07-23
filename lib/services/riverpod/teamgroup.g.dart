// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamgroup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamGroupFromIdHash() => r'44339a00c10e981f77eb43dc40a074043dc878ba';

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

/// Returns the TeamGroup element from its id from the db
///
/// Copied from [teamGroupFromId].
@ProviderFor(teamGroupFromId)
const teamGroupFromIdProvider = TeamGroupFromIdFamily();

/// Returns the TeamGroup element from its id from the db
///
/// Copied from [teamGroupFromId].
class TeamGroupFromIdFamily extends Family<AsyncValue<TeamGroup>> {
  /// Returns the TeamGroup element from its id from the db
  ///
  /// Copied from [teamGroupFromId].
  const TeamGroupFromIdFamily();

  /// Returns the TeamGroup element from its id from the db
  ///
  /// Copied from [teamGroupFromId].
  TeamGroupFromIdProvider call(
    String id,
  ) {
    return TeamGroupFromIdProvider(
      id,
    );
  }

  @override
  TeamGroupFromIdProvider getProviderOverride(
    covariant TeamGroupFromIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'teamGroupFromIdProvider';
}

/// Returns the TeamGroup element from its id from the db
///
/// Copied from [teamGroupFromId].
class TeamGroupFromIdProvider extends AutoDisposeFutureProvider<TeamGroup> {
  /// Returns the TeamGroup element from its id from the db
  ///
  /// Copied from [teamGroupFromId].
  TeamGroupFromIdProvider(
    String id,
  ) : this._internal(
          (ref) => teamGroupFromId(
            ref as TeamGroupFromIdRef,
            id,
          ),
          from: teamGroupFromIdProvider,
          name: r'teamGroupFromIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamGroupFromIdHash,
          dependencies: TeamGroupFromIdFamily._dependencies,
          allTransitiveDependencies:
              TeamGroupFromIdFamily._allTransitiveDependencies,
          id: id,
        );

  TeamGroupFromIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<TeamGroup> Function(TeamGroupFromIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TeamGroupFromIdProvider._internal(
        (ref) => create(ref as TeamGroupFromIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TeamGroup> createElement() {
    return _TeamGroupFromIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamGroupFromIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TeamGroupFromIdRef on AutoDisposeFutureProviderRef<TeamGroup> {
  /// The parameter `id` of this provider.
  String get id;
}

class _TeamGroupFromIdProviderElement
    extends AutoDisposeFutureProviderElement<TeamGroup>
    with TeamGroupFromIdRef {
  _TeamGroupFromIdProviderElement(super.provider);

  @override
  String get id => (origin as TeamGroupFromIdProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
