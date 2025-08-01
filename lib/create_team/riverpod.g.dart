// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamGroupWorkspace _$TeamGroupWorkspaceFromJson(Map<String, dynamic> json) =>
    _TeamGroupWorkspace(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      date: const NonNullableTimestampConverter()
          .fromJson(json['date'] as Timestamp),
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
      'date': const NonNullableTimestampConverter().toJson(instance.date),
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

String _$duplicateDogsHash() => r'a1d4dc31e0385ef9efa3ed628f01b36c6d623bb0';

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

String _$customerGroupForTeamgroupHash() =>
    r'05ee040047f7b4173b546dc6a8ea833df2e87790';

/// Gets all the customer groups assigned to this teamgroup.
///
/// Copied from [customerGroupForTeamgroup].
@ProviderFor(customerGroupForTeamgroup)
const customerGroupForTeamgroupProvider = CustomerGroupForTeamgroupFamily();

/// Gets all the customer groups assigned to this teamgroup.
///
/// Copied from [customerGroupForTeamgroup].
class CustomerGroupForTeamgroupFamily
    extends Family<AsyncValue<CustomerGroup>> {
  /// Gets all the customer groups assigned to this teamgroup.
  ///
  /// Copied from [customerGroupForTeamgroup].
  const CustomerGroupForTeamgroupFamily();

  /// Gets all the customer groups assigned to this teamgroup.
  ///
  /// Copied from [customerGroupForTeamgroup].
  CustomerGroupForTeamgroupProvider call(
    String teamGroupId,
  ) {
    return CustomerGroupForTeamgroupProvider(
      teamGroupId,
    );
  }

  @override
  CustomerGroupForTeamgroupProvider getProviderOverride(
    covariant CustomerGroupForTeamgroupProvider provider,
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
  String? get name => r'customerGroupForTeamgroupProvider';
}

/// Gets all the customer groups assigned to this teamgroup.
///
/// Copied from [customerGroupForTeamgroup].
class CustomerGroupForTeamgroupProvider
    extends AutoDisposeStreamProvider<CustomerGroup> {
  /// Gets all the customer groups assigned to this teamgroup.
  ///
  /// Copied from [customerGroupForTeamgroup].
  CustomerGroupForTeamgroupProvider(
    String teamGroupId,
  ) : this._internal(
          (ref) => customerGroupForTeamgroup(
            ref as CustomerGroupForTeamgroupRef,
            teamGroupId,
          ),
          from: customerGroupForTeamgroupProvider,
          name: r'customerGroupForTeamgroupProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerGroupForTeamgroupHash,
          dependencies: CustomerGroupForTeamgroupFamily._dependencies,
          allTransitiveDependencies:
              CustomerGroupForTeamgroupFamily._allTransitiveDependencies,
          teamGroupId: teamGroupId,
        );

  CustomerGroupForTeamgroupProvider._internal(
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
    Stream<CustomerGroup> Function(CustomerGroupForTeamgroupRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerGroupForTeamgroupProvider._internal(
        (ref) => create(ref as CustomerGroupForTeamgroupRef),
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
  AutoDisposeStreamProviderElement<CustomerGroup> createElement() {
    return _CustomerGroupForTeamgroupProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerGroupForTeamgroupProvider &&
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
mixin CustomerGroupForTeamgroupRef
    on AutoDisposeStreamProviderRef<CustomerGroup> {
  /// The parameter `teamGroupId` of this provider.
  String get teamGroupId;
}

class _CustomerGroupForTeamgroupProviderElement
    extends AutoDisposeStreamProviderElement<CustomerGroup>
    with CustomerGroupForTeamgroupRef {
  _CustomerGroupForTeamgroupProviderElement(super.provider);

  @override
  String get teamGroupId =>
      (origin as CustomerGroupForTeamgroupProvider).teamGroupId;
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
String _$customerAssignHash() => r'db8a1c053606d0cf1b2e6b01db731e9ef202afcf';

abstract class _$CustomerAssign
    extends BuildlessAutoDisposeAsyncNotifier<CustomerGroupWorkspace> {
  late final String? teamGroupId;

  FutureOr<CustomerGroupWorkspace> build(
    String? teamGroupId,
  );
}

/// See also [CustomerAssign].
@ProviderFor(CustomerAssign)
const customerAssignProvider = CustomerAssignFamily();

/// See also [CustomerAssign].
class CustomerAssignFamily extends Family<AsyncValue<CustomerGroupWorkspace>> {
  /// See also [CustomerAssign].
  const CustomerAssignFamily();

  /// See also [CustomerAssign].
  CustomerAssignProvider call(
    String? teamGroupId,
  ) {
    return CustomerAssignProvider(
      teamGroupId,
    );
  }

  @override
  CustomerAssignProvider getProviderOverride(
    covariant CustomerAssignProvider provider,
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
  String? get name => r'customerAssignProvider';
}

/// See also [CustomerAssign].
class CustomerAssignProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CustomerAssign, CustomerGroupWorkspace> {
  /// See also [CustomerAssign].
  CustomerAssignProvider(
    String? teamGroupId,
  ) : this._internal(
          () => CustomerAssign()..teamGroupId = teamGroupId,
          from: customerAssignProvider,
          name: r'customerAssignProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerAssignHash,
          dependencies: CustomerAssignFamily._dependencies,
          allTransitiveDependencies:
              CustomerAssignFamily._allTransitiveDependencies,
          teamGroupId: teamGroupId,
        );

  CustomerAssignProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.teamGroupId,
  }) : super.internal();

  final String? teamGroupId;

  @override
  FutureOr<CustomerGroupWorkspace> runNotifierBuild(
    covariant CustomerAssign notifier,
  ) {
    return notifier.build(
      teamGroupId,
    );
  }

  @override
  Override overrideWith(CustomerAssign Function() create) {
    return ProviderOverride(
      origin: this,
      override: CustomerAssignProvider._internal(
        () => create()..teamGroupId = teamGroupId,
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
  AutoDisposeAsyncNotifierProviderElement<CustomerAssign,
      CustomerGroupWorkspace> createElement() {
    return _CustomerAssignProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerAssignProvider && other.teamGroupId == teamGroupId;
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
mixin CustomerAssignRef
    on AutoDisposeAsyncNotifierProviderRef<CustomerGroupWorkspace> {
  /// The parameter `teamGroupId` of this provider.
  String? get teamGroupId;
}

class _CustomerAssignProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CustomerAssign,
        CustomerGroupWorkspace> with CustomerAssignRef {
  _CustomerAssignProviderElement(super.provider);

  @override
  String? get teamGroupId => (origin as CustomerAssignProvider).teamGroupId;
}

String _$createTeamGroupHash() => r'b07ad98195210efe06a1f7c4d05a577037f8d87f';

abstract class _$CreateTeamGroup
    extends BuildlessAutoDisposeAsyncNotifier<TeamGroupWorkspace> {
  late final String? teamGroupId;

  FutureOr<TeamGroupWorkspace> build(
    String? teamGroupId,
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
class CreateTeamGroupFamily extends Family<AsyncValue<TeamGroupWorkspace>> {
  /// The teamgroup that is being built.
  ///
  /// Copied from [CreateTeamGroup].
  const CreateTeamGroupFamily();

  /// The teamgroup that is being built.
  ///
  /// Copied from [CreateTeamGroup].
  CreateTeamGroupProvider call(
    String? teamGroupId,
  ) {
    return CreateTeamGroupProvider(
      teamGroupId,
    );
  }

  @override
  CreateTeamGroupProvider getProviderOverride(
    covariant CreateTeamGroupProvider provider,
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
  String? get name => r'createTeamGroupProvider';
}

/// The teamgroup that is being built.
///
/// Copied from [CreateTeamGroup].
class CreateTeamGroupProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CreateTeamGroup, TeamGroupWorkspace> {
  /// The teamgroup that is being built.
  ///
  /// Copied from [CreateTeamGroup].
  CreateTeamGroupProvider(
    String? teamGroupId,
  ) : this._internal(
          () => CreateTeamGroup()..teamGroupId = teamGroupId,
          from: createTeamGroupProvider,
          name: r'createTeamGroupProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createTeamGroupHash,
          dependencies: CreateTeamGroupFamily._dependencies,
          allTransitiveDependencies:
              CreateTeamGroupFamily._allTransitiveDependencies,
          teamGroupId: teamGroupId,
        );

  CreateTeamGroupProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.teamGroupId,
  }) : super.internal();

  final String? teamGroupId;

  @override
  FutureOr<TeamGroupWorkspace> runNotifierBuild(
    covariant CreateTeamGroup notifier,
  ) {
    return notifier.build(
      teamGroupId,
    );
  }

  @override
  Override overrideWith(CreateTeamGroup Function() create) {
    return ProviderOverride(
      origin: this,
      override: CreateTeamGroupProvider._internal(
        () => create()..teamGroupId = teamGroupId,
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
  AutoDisposeAsyncNotifierProviderElement<CreateTeamGroup, TeamGroupWorkspace>
      createElement() {
    return _CreateTeamGroupProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateTeamGroupProvider && other.teamGroupId == teamGroupId;
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
mixin CreateTeamGroupRef
    on AutoDisposeAsyncNotifierProviderRef<TeamGroupWorkspace> {
  /// The parameter `teamGroupId` of this provider.
  String? get teamGroupId;
}

class _CreateTeamGroupProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CreateTeamGroup,
        TeamGroupWorkspace> with CreateTeamGroupRef {
  _CreateTeamGroupProviderElement(super.provider);

  @override
  String? get teamGroupId => (origin as CreateTeamGroupProvider).teamGroupId;
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
