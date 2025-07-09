// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createTeamGroupHash() => r'ed07fc44c1704190c9e55f44b8474f59f2e8e03f';

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

abstract class _$CreateTeamGroup
    extends BuildlessAutoDisposeNotifier<TeamGroup> {
  late final TeamGroup? teamGroup;

  TeamGroup build(
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
class CreateTeamGroupFamily extends Family<TeamGroup> {
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
class CreateTeamGroupProvider
    extends AutoDisposeNotifierProviderImpl<CreateTeamGroup, TeamGroup> {
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
  TeamGroup runNotifierBuild(
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
  AutoDisposeNotifierProviderElement<CreateTeamGroup, TeamGroup>
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
mixin CreateTeamGroupRef on AutoDisposeNotifierProviderRef<TeamGroup> {
  /// The parameter `teamGroup` of this provider.
  TeamGroup? get teamGroup;
}

class _CreateTeamGroupProviderElement
    extends AutoDisposeNotifierProviderElement<CreateTeamGroup, TeamGroup>
    with CreateTeamGroupRef {
  _CreateTeamGroupProviderElement(super.provider);

  @override
  TeamGroup? get teamGroup => (origin as CreateTeamGroupProvider).teamGroup;
}

String _$runningDogsHash() => r'47508d280bbaccdb1ff51a9e023fef1e0a6c42ad';

abstract class _$RunningDogs
    extends BuildlessAutoDisposeNotifier<List<String>> {
  late final TeamGroup group;

  List<String> build(
    TeamGroup group,
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
    TeamGroup group,
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
    TeamGroup group,
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

  final TeamGroup group;

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
  TeamGroup get group;
}

class _RunningDogsProviderElement
    extends AutoDisposeNotifierProviderElement<RunningDogs, List<String>>
    with RunningDogsRef {
  _RunningDogsProviderElement(super.provider);

  @override
  TeamGroup get group => (origin as RunningDogsProvider).group;
}

String _$createDogNotesHash() => r'e849ebafa7a0d9fc87d8cd5bd2ed14f1f146d8d7';

/// See also [CreateDogNotes].
@ProviderFor(CreateDogNotes)
final createDogNotesProvider =
    AutoDisposeNotifierProvider<CreateDogNotes, List<DogNote>>.internal(
  CreateDogNotes.new,
  name: r'createDogNotesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createDogNotesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateDogNotes = AutoDisposeNotifier<List<DogNote>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
