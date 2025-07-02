// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamGroupsHash() => r'fd541ea76671fa1b544f088e96fe4860a84e699f';

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
  TeamGroupsProvider call({
    required DateTime earliestDate,
    DateTime? finalDate,
  }) {
    return TeamGroupsProvider(
      earliestDate: earliestDate,
      finalDate: finalDate,
    );
  }

  @override
  TeamGroupsProvider getProviderOverride(
    covariant TeamGroupsProvider provider,
  ) {
    return call(
      earliestDate: provider.earliestDate,
      finalDate: provider.finalDate,
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
  TeamGroupsProvider({
    required DateTime earliestDate,
    DateTime? finalDate,
  }) : this._internal(
          (ref) => teamGroups(
            ref as TeamGroupsRef,
            earliestDate: earliestDate,
            finalDate: finalDate,
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
          earliestDate: earliestDate,
          finalDate: finalDate,
        );

  TeamGroupsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.earliestDate,
    required this.finalDate,
  }) : super.internal();

  final DateTime earliestDate;
  final DateTime? finalDate;

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
        earliestDate: earliestDate,
        finalDate: finalDate,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TeamGroup>> createElement() {
    return _TeamGroupsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamGroupsProvider &&
        other.earliestDate == earliestDate &&
        other.finalDate == finalDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, earliestDate.hashCode);
    hash = _SystemHash.combine(hash, finalDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TeamGroupsRef on AutoDisposeStreamProviderRef<List<TeamGroup>> {
  /// The parameter `earliestDate` of this provider.
  DateTime get earliestDate;

  /// The parameter `finalDate` of this provider.
  DateTime? get finalDate;
}

class _TeamGroupsProviderElement
    extends AutoDisposeStreamProviderElement<List<TeamGroup>>
    with TeamGroupsRef {
  _TeamGroupsProviderElement(super.provider);

  @override
  DateTime get earliestDate => (origin as TeamGroupsProvider).earliestDate;
  @override
  DateTime? get finalDate => (origin as TeamGroupsProvider).finalDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
