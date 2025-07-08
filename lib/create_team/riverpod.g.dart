// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createTeamGroupHash() => r'b7f28c07d2d112f3934019ad87d7f1a9f6decb0f';

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

String _$runningDogsHash() => r'6a493df024f0ca518832ce7fbe4ffe8cda5b0b6e';

/// The ids of the dogs that are currently running.
///
/// Used to make the unavailable in the dropdown selection.
///
/// Copied from [RunningDogs].
@ProviderFor(RunningDogs)
final runningDogsProvider =
    AutoDisposeNotifierProvider<RunningDogs, List<String>>.internal(
  RunningDogs.new,
  name: r'runningDogsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$runningDogsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RunningDogs = AutoDisposeNotifier<List<String>>;
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
