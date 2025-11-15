// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamgroup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamGroupFromIdHash() => r'a3a9cd0e7b752babb80b44e9f3c24c0132c5c500';

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
class TeamGroupFromIdProvider extends AutoDisposeStreamProvider<TeamGroup> {
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
    Stream<TeamGroup> Function(TeamGroupFromIdRef provider) create,
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
  AutoDisposeStreamProviderElement<TeamGroup> createElement() {
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
mixin TeamGroupFromIdRef on AutoDisposeStreamProviderRef<TeamGroup> {
  /// The parameter `id` of this provider.
  String get id;
}

class _TeamGroupFromIdProviderElement
    extends AutoDisposeStreamProviderElement<TeamGroup>
    with TeamGroupFromIdRef {
  _TeamGroupFromIdProviderElement(super.provider);

  @override
  String get id => (origin as TeamGroupFromIdProvider).id;
}

String _$teamsInTeamgroupHash() => r'6db75d08a5cea992c43efcda42bfa8f2610c93b8';

/// The list of teams in a teamgroup
///
/// Copied from [teamsInTeamgroup].
@ProviderFor(teamsInTeamgroup)
const teamsInTeamgroupProvider = TeamsInTeamgroupFamily();

/// The list of teams in a teamgroup
///
/// Copied from [teamsInTeamgroup].
class TeamsInTeamgroupFamily extends Family<AsyncValue<List<Team>>> {
  /// The list of teams in a teamgroup
  ///
  /// Copied from [teamsInTeamgroup].
  const TeamsInTeamgroupFamily();

  /// The list of teams in a teamgroup
  ///
  /// Copied from [teamsInTeamgroup].
  TeamsInTeamgroupProvider call(
    String teamgroupId,
  ) {
    return TeamsInTeamgroupProvider(
      teamgroupId,
    );
  }

  @override
  TeamsInTeamgroupProvider getProviderOverride(
    covariant TeamsInTeamgroupProvider provider,
  ) {
    return call(
      provider.teamgroupId,
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
  String? get name => r'teamsInTeamgroupProvider';
}

/// The list of teams in a teamgroup
///
/// Copied from [teamsInTeamgroup].
class TeamsInTeamgroupProvider extends AutoDisposeStreamProvider<List<Team>> {
  /// The list of teams in a teamgroup
  ///
  /// Copied from [teamsInTeamgroup].
  TeamsInTeamgroupProvider(
    String teamgroupId,
  ) : this._internal(
          (ref) => teamsInTeamgroup(
            ref as TeamsInTeamgroupRef,
            teamgroupId,
          ),
          from: teamsInTeamgroupProvider,
          name: r'teamsInTeamgroupProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamsInTeamgroupHash,
          dependencies: TeamsInTeamgroupFamily._dependencies,
          allTransitiveDependencies:
              TeamsInTeamgroupFamily._allTransitiveDependencies,
          teamgroupId: teamgroupId,
        );

  TeamsInTeamgroupProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.teamgroupId,
  }) : super.internal();

  final String teamgroupId;

  @override
  Override overrideWith(
    Stream<List<Team>> Function(TeamsInTeamgroupRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TeamsInTeamgroupProvider._internal(
        (ref) => create(ref as TeamsInTeamgroupRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        teamgroupId: teamgroupId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Team>> createElement() {
    return _TeamsInTeamgroupProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamsInTeamgroupProvider &&
        other.teamgroupId == teamgroupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, teamgroupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TeamsInTeamgroupRef on AutoDisposeStreamProviderRef<List<Team>> {
  /// The parameter `teamgroupId` of this provider.
  String get teamgroupId;
}

class _TeamsInTeamgroupProviderElement
    extends AutoDisposeStreamProviderElement<List<Team>>
    with TeamsInTeamgroupRef {
  _TeamsInTeamgroupProviderElement(super.provider);

  @override
  String get teamgroupId => (origin as TeamsInTeamgroupProvider).teamgroupId;
}

String _$dogPairsInTeamHash() => r'cd64c294fb83217cb07cbaaacd0522274de67a9c';

/// The list of dogpairs in a team
///
/// Copied from [dogPairsInTeam].
@ProviderFor(dogPairsInTeam)
const dogPairsInTeamProvider = DogPairsInTeamFamily();

/// The list of dogpairs in a team
///
/// Copied from [dogPairsInTeam].
class DogPairsInTeamFamily extends Family<AsyncValue<List<DogPair>>> {
  /// The list of dogpairs in a team
  ///
  /// Copied from [dogPairsInTeam].
  const DogPairsInTeamFamily();

  /// The list of dogpairs in a team
  ///
  /// Copied from [dogPairsInTeam].
  DogPairsInTeamProvider call(
    String teamgroupId,
    String teamId,
  ) {
    return DogPairsInTeamProvider(
      teamgroupId,
      teamId,
    );
  }

  @override
  DogPairsInTeamProvider getProviderOverride(
    covariant DogPairsInTeamProvider provider,
  ) {
    return call(
      provider.teamgroupId,
      provider.teamId,
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
  String? get name => r'dogPairsInTeamProvider';
}

/// The list of dogpairs in a team
///
/// Copied from [dogPairsInTeam].
class DogPairsInTeamProvider extends AutoDisposeStreamProvider<List<DogPair>> {
  /// The list of dogpairs in a team
  ///
  /// Copied from [dogPairsInTeam].
  DogPairsInTeamProvider(
    String teamgroupId,
    String teamId,
  ) : this._internal(
          (ref) => dogPairsInTeam(
            ref as DogPairsInTeamRef,
            teamgroupId,
            teamId,
          ),
          from: dogPairsInTeamProvider,
          name: r'dogPairsInTeamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dogPairsInTeamHash,
          dependencies: DogPairsInTeamFamily._dependencies,
          allTransitiveDependencies:
              DogPairsInTeamFamily._allTransitiveDependencies,
          teamgroupId: teamgroupId,
          teamId: teamId,
        );

  DogPairsInTeamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.teamgroupId,
    required this.teamId,
  }) : super.internal();

  final String teamgroupId;
  final String teamId;

  @override
  Override overrideWith(
    Stream<List<DogPair>> Function(DogPairsInTeamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DogPairsInTeamProvider._internal(
        (ref) => create(ref as DogPairsInTeamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        teamgroupId: teamgroupId,
        teamId: teamId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<DogPair>> createElement() {
    return _DogPairsInTeamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DogPairsInTeamProvider &&
        other.teamgroupId == teamgroupId &&
        other.teamId == teamId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, teamgroupId.hashCode);
    hash = _SystemHash.combine(hash, teamId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DogPairsInTeamRef on AutoDisposeStreamProviderRef<List<DogPair>> {
  /// The parameter `teamgroupId` of this provider.
  String get teamgroupId;

  /// The parameter `teamId` of this provider.
  String get teamId;
}

class _DogPairsInTeamProviderElement
    extends AutoDisposeStreamProviderElement<List<DogPair>>
    with DogPairsInTeamRef {
  _DogPairsInTeamProviderElement(super.provider);

  @override
  String get teamgroupId => (origin as DogPairsInTeamProvider).teamgroupId;
  @override
  String get teamId => (origin as DogPairsInTeamProvider).teamId;
}

String _$teamGroupsWorkspaceFromDateRangeHash() =>
    r'7a8179663a19325c5e8b07b4c4a9e810b5125545';

/// See also [teamGroupsWorkspaceFromDateRange].
@ProviderFor(teamGroupsWorkspaceFromDateRange)
const teamGroupsWorkspaceFromDateRangeProvider =
    TeamGroupsWorkspaceFromDateRangeFamily();

/// See also [teamGroupsWorkspaceFromDateRange].
class TeamGroupsWorkspaceFromDateRangeFamily
    extends Family<AsyncValue<List<TeamGroupWorkspace>>> {
  /// See also [teamGroupsWorkspaceFromDateRange].
  const TeamGroupsWorkspaceFromDateRangeFamily();

  /// See also [teamGroupsWorkspaceFromDateRange].
  TeamGroupsWorkspaceFromDateRangeProvider call({
    required DateTime start,
    required DateTime end,
  }) {
    return TeamGroupsWorkspaceFromDateRangeProvider(
      start: start,
      end: end,
    );
  }

  @override
  TeamGroupsWorkspaceFromDateRangeProvider getProviderOverride(
    covariant TeamGroupsWorkspaceFromDateRangeProvider provider,
  ) {
    return call(
      start: provider.start,
      end: provider.end,
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
  String? get name => r'teamGroupsWorkspaceFromDateRangeProvider';
}

/// See also [teamGroupsWorkspaceFromDateRange].
class TeamGroupsWorkspaceFromDateRangeProvider
    extends AutoDisposeFutureProvider<List<TeamGroupWorkspace>> {
  /// See also [teamGroupsWorkspaceFromDateRange].
  TeamGroupsWorkspaceFromDateRangeProvider({
    required DateTime start,
    required DateTime end,
  }) : this._internal(
          (ref) => teamGroupsWorkspaceFromDateRange(
            ref as TeamGroupsWorkspaceFromDateRangeRef,
            start: start,
            end: end,
          ),
          from: teamGroupsWorkspaceFromDateRangeProvider,
          name: r'teamGroupsWorkspaceFromDateRangeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamGroupsWorkspaceFromDateRangeHash,
          dependencies: TeamGroupsWorkspaceFromDateRangeFamily._dependencies,
          allTransitiveDependencies:
              TeamGroupsWorkspaceFromDateRangeFamily._allTransitiveDependencies,
          start: start,
          end: end,
        );

  TeamGroupsWorkspaceFromDateRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.start,
    required this.end,
  }) : super.internal();

  final DateTime start;
  final DateTime end;

  @override
  Override overrideWith(
    FutureOr<List<TeamGroupWorkspace>> Function(
            TeamGroupsWorkspaceFromDateRangeRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TeamGroupsWorkspaceFromDateRangeProvider._internal(
        (ref) => create(ref as TeamGroupsWorkspaceFromDateRangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        start: start,
        end: end,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TeamGroupWorkspace>> createElement() {
    return _TeamGroupsWorkspaceFromDateRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamGroupsWorkspaceFromDateRangeProvider &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, start.hashCode);
    hash = _SystemHash.combine(hash, end.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TeamGroupsWorkspaceFromDateRangeRef
    on AutoDisposeFutureProviderRef<List<TeamGroupWorkspace>> {
  /// The parameter `start` of this provider.
  DateTime get start;

  /// The parameter `end` of this provider.
  DateTime get end;
}

class _TeamGroupsWorkspaceFromDateRangeProviderElement
    extends AutoDisposeFutureProviderElement<List<TeamGroupWorkspace>>
    with TeamGroupsWorkspaceFromDateRangeRef {
  _TeamGroupsWorkspaceFromDateRangeProviderElement(super.provider);

  @override
  DateTime get start =>
      (origin as TeamGroupsWorkspaceFromDateRangeProvider).start;
  @override
  DateTime get end => (origin as TeamGroupsWorkspaceFromDateRangeProvider).end;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
