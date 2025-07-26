// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamGroupWorkspace _$TeamGroupWorkspaceFromJson(Map<String, dynamic> json) =>
    _TeamGroupWorkspace(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      date: DateTime.parse(json['date'] as String),
      distance: (json['distance'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String? ?? "",
      teams: (json['teams'] as List<dynamic>?)
              ?.map((e) => TeamWorkspace.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TeamGroupWorkspaceToJson(_TeamGroupWorkspace instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': instance.date.toIso8601String(),
      'distance': instance.distance,
      'notes': instance.notes,
      'teams': instance.teams,
    };

_TeamWorkspace _$TeamWorkspaceFromJson(Map<String, dynamic> json) =>
    _TeamWorkspace(
      name: json['name'] as String? ?? "",
      id: json['id'] as String,
      dogPairs: (json['dogPairs'] as List<dynamic>?)
              ?.map((e) => DogPairWorkspace.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TeamWorkspaceToJson(_TeamWorkspace instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'dogPairs': instance.dogPairs,
    };

_DogPairWorkspace _$DogPairWorkspaceFromJson(Map<String, dynamic> json) =>
    _DogPairWorkspace(
      firstDogId: json['firstDogId'] as String?,
      secondDogId: json['secondDogId'] as String?,
      id: json['id'] as String,
    );

Map<String, dynamic> _$DogPairWorkspaceToJson(_DogPairWorkspace instance) =>
    <String, dynamic>{
      'firstDogId': instance.firstDogId,
      'secondDogId': instance.secondDogId,
      'id': instance.id,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$duplicateDogsHash() => r'79c3c033b192f43fe8046981b43bcab769b7a34c';

/// See also [duplicateDogs].
@ProviderFor(duplicateDogs)
final duplicateDogsProvider = AutoDisposeProvider<List<String>>.internal(
  duplicateDogs,
  name: r'duplicateDogsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$duplicateDogsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DuplicateDogsRef = AutoDisposeProviderRef<List<String>>;
String _$teamGroupByIdHash() => r'ca49231cdd446e8faf4c75c00cbb7a653c0d393e';

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

/// See also [teamGroupById].
@ProviderFor(teamGroupById)
const teamGroupByIdProvider = TeamGroupByIdFamily();

/// See also [teamGroupById].
class TeamGroupByIdFamily extends Family<AsyncValue<TeamGroup?>> {
  /// See also [teamGroupById].
  const TeamGroupByIdFamily();

  /// See also [teamGroupById].
  TeamGroupByIdProvider call(
    String id,
  ) {
    return TeamGroupByIdProvider(
      id,
    );
  }

  @override
  TeamGroupByIdProvider getProviderOverride(
    covariant TeamGroupByIdProvider provider,
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
  String? get name => r'teamGroupByIdProvider';
}

/// See also [teamGroupById].
class TeamGroupByIdProvider extends AutoDisposeFutureProvider<TeamGroup?> {
  /// See also [teamGroupById].
  TeamGroupByIdProvider(
    String id,
  ) : this._internal(
          (ref) => teamGroupById(
            ref as TeamGroupByIdRef,
            id,
          ),
          from: teamGroupByIdProvider,
          name: r'teamGroupByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamGroupByIdHash,
          dependencies: TeamGroupByIdFamily._dependencies,
          allTransitiveDependencies:
              TeamGroupByIdFamily._allTransitiveDependencies,
          id: id,
        );

  TeamGroupByIdProvider._internal(
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
    FutureOr<TeamGroup?> Function(TeamGroupByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TeamGroupByIdProvider._internal(
        (ref) => create(ref as TeamGroupByIdRef),
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
  AutoDisposeFutureProviderElement<TeamGroup?> createElement() {
    return _TeamGroupByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamGroupByIdProvider && other.id == id;
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
mixin TeamGroupByIdRef on AutoDisposeFutureProviderRef<TeamGroup?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _TeamGroupByIdProviderElement
    extends AutoDisposeFutureProviderElement<TeamGroup?> with TeamGroupByIdRef {
  _TeamGroupByIdProviderElement(super.provider);

  @override
  String get id => (origin as TeamGroupByIdProvider).id;
}

String _$customerGroupsForTeamgroupHash() =>
    r'893734f32ff66d9de8320d9a24ed8d97ae1b640d';

/// Gets all the customer groups assigned to this teamgroup.
///
/// Copied from [customerGroupsForTeamgroup].
@ProviderFor(customerGroupsForTeamgroup)
const customerGroupsForTeamgroupProvider = CustomerGroupsForTeamgroupFamily();

/// Gets all the customer groups assigned to this teamgroup.
///
/// Copied from [customerGroupsForTeamgroup].
class CustomerGroupsForTeamgroupFamily
    extends Family<AsyncValue<List<CustomerGroup>>> {
  /// Gets all the customer groups assigned to this teamgroup.
  ///
  /// Copied from [customerGroupsForTeamgroup].
  const CustomerGroupsForTeamgroupFamily();

  /// Gets all the customer groups assigned to this teamgroup.
  ///
  /// Copied from [customerGroupsForTeamgroup].
  CustomerGroupsForTeamgroupProvider call(
    String teamGroupId,
  ) {
    return CustomerGroupsForTeamgroupProvider(
      teamGroupId,
    );
  }

  @override
  CustomerGroupsForTeamgroupProvider getProviderOverride(
    covariant CustomerGroupsForTeamgroupProvider provider,
  ) {
    return call(
      provider.teamGroupId,
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
  String? get name => r'customerGroupsForTeamgroupProvider';
}

/// Gets all the customer groups assigned to this teamgroup.
///
/// Copied from [customerGroupsForTeamgroup].
class CustomerGroupsForTeamgroupProvider
    extends AutoDisposeStreamProvider<List<CustomerGroup>> {
  /// Gets all the customer groups assigned to this teamgroup.
  ///
  /// Copied from [customerGroupsForTeamgroup].
  CustomerGroupsForTeamgroupProvider(
    String teamGroupId,
  ) : this._internal(
          (ref) => customerGroupsForTeamgroup(
            ref as CustomerGroupsForTeamgroupRef,
            teamGroupId,
          ),
          from: customerGroupsForTeamgroupProvider,
          name: r'customerGroupsForTeamgroupProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerGroupsForTeamgroupHash,
          dependencies: CustomerGroupsForTeamgroupFamily._dependencies,
          allTransitiveDependencies:
              CustomerGroupsForTeamgroupFamily._allTransitiveDependencies,
          teamGroupId: teamGroupId,
        );

  CustomerGroupsForTeamgroupProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.teamGroupId,
  }) : super.internal();

  final String teamGroupId;

  @override
  Override overrideWith(
    Stream<List<CustomerGroup>> Function(CustomerGroupsForTeamgroupRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerGroupsForTeamgroupProvider._internal(
        (ref) => create(ref as CustomerGroupsForTeamgroupRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        teamGroupId: teamGroupId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<CustomerGroup>> createElement() {
    return _CustomerGroupsForTeamgroupProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerGroupsForTeamgroupProvider &&
        other.teamGroupId == teamGroupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, teamGroupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerGroupsForTeamgroupRef
    on AutoDisposeStreamProviderRef<List<CustomerGroup>> {
  /// The parameter `teamGroupId` of this provider.
  String get teamGroupId;
}

class _CustomerGroupsForTeamgroupProviderElement
    extends AutoDisposeStreamProviderElement<List<CustomerGroup>>
    with CustomerGroupsForTeamgroupRef {
  _CustomerGroupsForTeamgroupProviderElement(super.provider);

  @override
  String get teamGroupId =>
      (origin as CustomerGroupsForTeamgroupProvider).teamGroupId;
}

String _$canPopTeamGroupHash() => r'c9af7216c65b52eed3154435651dc810e0585519';

/// See also [CanPopTeamGroup].
@ProviderFor(CanPopTeamGroup)
final canPopTeamGroupProvider =
    AutoDisposeNotifierProvider<CanPopTeamGroup, bool>.internal(
  CanPopTeamGroup.new,
  name: r'canPopTeamGroupProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$canPopTeamGroupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CanPopTeamGroup = AutoDisposeNotifier<bool>;
String _$createTeamGroupHash() => r'64bbedebc3c5a73a9464af9541cb7d5d6311de69';

abstract class _$CreateTeamGroup
    extends BuildlessAutoDisposeNotifier<TeamGroupWorkspace> {
  late final TeamGroup? teamGroup;

  TeamGroupWorkspace build(
    TeamGroup? teamGroup,
  );
}

/// The teamgroup that is being built.
///
/// Copied from [CreateTeamGroup].
@ProviderFor(CreateTeamGroup)
const createTeamGroupProvider = CreateTeamGroupFamily();

/// The teamgroup that is being built.
///
/// Copied from [CreateTeamGroup].
class CreateTeamGroupFamily extends Family<TeamGroupWorkspace> {
  /// The teamgroup that is being built.
  ///
  /// Copied from [CreateTeamGroup].
  const CreateTeamGroupFamily();

  /// The teamgroup that is being built.
  ///
  /// Copied from [CreateTeamGroup].
  CreateTeamGroupProvider call(
    TeamGroup? teamGroup,
  ) {
    return CreateTeamGroupProvider(
      teamGroup,
    );
  }

  @override
  CreateTeamGroupProvider getProviderOverride(
    covariant CreateTeamGroupProvider provider,
  ) {
    return call(
      provider.teamGroup,
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
  String? get name => r'createTeamGroupProvider';
}

/// The teamgroup that is being built.
///
/// Copied from [CreateTeamGroup].
class CreateTeamGroupProvider extends AutoDisposeNotifierProviderImpl<
    CreateTeamGroup, TeamGroupWorkspace> {
  /// The teamgroup that is being built.
  ///
  /// Copied from [CreateTeamGroup].
  CreateTeamGroupProvider(
    TeamGroup? teamGroup,
  ) : this._internal(
          () => CreateTeamGroup()..teamGroup = teamGroup,
          from: createTeamGroupProvider,
          name: r'createTeamGroupProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createTeamGroupHash,
          dependencies: CreateTeamGroupFamily._dependencies,
          allTransitiveDependencies:
              CreateTeamGroupFamily._allTransitiveDependencies,
          teamGroup: teamGroup,
        );

  CreateTeamGroupProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.teamGroup,
  }) : super.internal();

  final TeamGroup? teamGroup;

  @override
  TeamGroupWorkspace runNotifierBuild(
    covariant CreateTeamGroup notifier,
  ) {
    return notifier.build(
      teamGroup,
    );
  }

  @override
  Override overrideWith(CreateTeamGroup Function() create) {
    return ProviderOverride(
      origin: this,
      override: CreateTeamGroupProvider._internal(
        () => create()..teamGroup = teamGroup,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        teamGroup: teamGroup,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CreateTeamGroup, TeamGroupWorkspace>
      createElement() {
    return _CreateTeamGroupProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateTeamGroupProvider && other.teamGroup == teamGroup;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, teamGroup.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateTeamGroupRef on AutoDisposeNotifierProviderRef<TeamGroupWorkspace> {
  /// The parameter `teamGroup` of this provider.
  TeamGroup? get teamGroup;
}

class _CreateTeamGroupProviderElement
    extends AutoDisposeNotifierProviderElement<CreateTeamGroup,
        TeamGroupWorkspace> with CreateTeamGroupRef {
  _CreateTeamGroupProviderElement(super.provider);

  @override
  TeamGroup? get teamGroup => (origin as CreateTeamGroupProvider).teamGroup;
}

String _$runningDogsHash() => r'db264451cef793ff4d560ea8e34df898aae17e5e';

abstract class _$RunningDogs
    extends BuildlessAutoDisposeNotifier<List<String>> {
  late final TeamGroupWorkspace group;

  List<String> build(
    TeamGroupWorkspace group,
  );
}

/// The ids of the dogs that are currently running.
///
/// Used to make the unavailable in the dropdown selection.
///
/// Copied from [RunningDogs].
@ProviderFor(RunningDogs)
const runningDogsProvider = RunningDogsFamily();

/// The ids of the dogs that are currently running.
///
/// Used to make the unavailable in the dropdown selection.
///
/// Copied from [RunningDogs].
class RunningDogsFamily extends Family<List<String>> {
  /// The ids of the dogs that are currently running.
  ///
  /// Used to make the unavailable in the dropdown selection.
  ///
  /// Copied from [RunningDogs].
  const RunningDogsFamily();

  /// The ids of the dogs that are currently running.
  ///
  /// Used to make the unavailable in the dropdown selection.
  ///
  /// Copied from [RunningDogs].
  RunningDogsProvider call(
    TeamGroupWorkspace group,
  ) {
    return RunningDogsProvider(
      group,
    );
  }

  @override
  RunningDogsProvider getProviderOverride(
    covariant RunningDogsProvider provider,
  ) {
    return call(
      provider.group,
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
  String? get name => r'runningDogsProvider';
}

/// The ids of the dogs that are currently running.
///
/// Used to make the unavailable in the dropdown selection.
///
/// Copied from [RunningDogs].
class RunningDogsProvider
    extends AutoDisposeNotifierProviderImpl<RunningDogs, List<String>> {
  /// The ids of the dogs that are currently running.
  ///
  /// Used to make the unavailable in the dropdown selection.
  ///
  /// Copied from [RunningDogs].
  RunningDogsProvider(
    TeamGroupWorkspace group,
  ) : this._internal(
          () => RunningDogs()..group = group,
          from: runningDogsProvider,
          name: r'runningDogsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$runningDogsHash,
          dependencies: RunningDogsFamily._dependencies,
          allTransitiveDependencies:
              RunningDogsFamily._allTransitiveDependencies,
          group: group,
        );

  RunningDogsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.group,
  }) : super.internal();

  final TeamGroupWorkspace group;

  @override
  List<String> runNotifierBuild(
    covariant RunningDogs notifier,
  ) {
    return notifier.build(
      group,
    );
  }

  @override
  Override overrideWith(RunningDogs Function() create) {
    return ProviderOverride(
      origin: this,
      override: RunningDogsProvider._internal(
        () => create()..group = group,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        group: group,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<RunningDogs, List<String>>
      createElement() {
    return _RunningDogsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RunningDogsProvider && other.group == group;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, group.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RunningDogsRef on AutoDisposeNotifierProviderRef<List<String>> {
  /// The parameter `group` of this provider.
  TeamGroupWorkspace get group;
}

class _RunningDogsProviderElement
    extends AutoDisposeNotifierProviderElement<RunningDogs, List<String>>
    with RunningDogsRef {
  _RunningDogsProviderElement(super.provider);

  @override
  TeamGroupWorkspace get group => (origin as RunningDogsProvider).group;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
