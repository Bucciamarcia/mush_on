// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamGroupsHash() => r'63f4691bab4ebd154b82eeb855b2899008fd3caa';

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

/// See also [teamGroups].
@ProviderFor(teamGroups)
const teamGroupsProvider = TeamGroupsFamily();

/// See also [teamGroups].
class TeamGroupsFamily extends Family<AsyncValue<List<TeamGroup>>> {
  /// See also [teamGroups].
  const TeamGroupsFamily();

  /// See also [teamGroups].
  TeamGroupsProvider call(
    DateTime cutoff,
  ) {
    return TeamGroupsProvider(
      cutoff,
    );
  }

  @override
  TeamGroupsProvider getProviderOverride(
    covariant TeamGroupsProvider provider,
  ) {
    return call(
      provider.cutoff,
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
  String? get name => r'teamGroupsProvider';
}

/// See also [teamGroups].
class TeamGroupsProvider extends AutoDisposeStreamProvider<List<TeamGroup>> {
  /// See also [teamGroups].
  TeamGroupsProvider(
    DateTime cutoff,
  ) : this._internal(
          (ref) => teamGroups(
            ref as TeamGroupsRef,
            cutoff,
          ),
          from: teamGroupsProvider,
          name: r'teamGroupsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamGroupsHash,
          dependencies: TeamGroupsFamily._dependencies,
          allTransitiveDependencies:
              TeamGroupsFamily._allTransitiveDependencies,
          cutoff: cutoff,
        );

  TeamGroupsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cutoff,
  }) : super.internal();

  final DateTime cutoff;

  @override
  Override overrideWith(
    Stream<List<TeamGroup>> Function(TeamGroupsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TeamGroupsProvider._internal(
        (ref) => create(ref as TeamGroupsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cutoff: cutoff,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TeamGroup>> createElement() {
    return _TeamGroupsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamGroupsProvider && other.cutoff == cutoff;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cutoff.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TeamGroupsRef on AutoDisposeStreamProviderRef<List<TeamGroup>> {
  /// The parameter `cutoff` of this provider.
  DateTime get cutoff;
}

class _TeamGroupsProviderElement
    extends AutoDisposeStreamProviderElement<List<TeamGroup>>
    with TeamGroupsRef {
  _TeamGroupsProviderElement(super.provider);

  @override
  DateTime get cutoff => (origin as TeamGroupsProvider).cutoff;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
