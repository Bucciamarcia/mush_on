// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$prefetchedTeamDataHash() =>
    r'42f00aeb8bf9b17edfade05664a46174d1356bc7';

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

/// See also [prefetchedTeamData].
@ProviderFor(prefetchedTeamData)
const prefetchedTeamDataProvider = PrefetchedTeamDataFamily();

/// See also [prefetchedTeamData].
class PrefetchedTeamDataFamily extends Family<AsyncValue<TeamGroupData>> {
  /// See also [prefetchedTeamData].
  const PrefetchedTeamDataFamily();

  /// See also [prefetchedTeamData].
  PrefetchedTeamDataProvider call(
    List<TeamGroup> teamGroups,
  ) {
    return PrefetchedTeamDataProvider(
      teamGroups,
    );
  }

  @override
  PrefetchedTeamDataProvider getProviderOverride(
    covariant PrefetchedTeamDataProvider provider,
  ) {
    return call(
      provider.teamGroups,
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
  String? get name => r'prefetchedTeamDataProvider';
}

/// See also [prefetchedTeamData].
class PrefetchedTeamDataProvider
    extends AutoDisposeFutureProvider<TeamGroupData> {
  /// See also [prefetchedTeamData].
  PrefetchedTeamDataProvider(
    List<TeamGroup> teamGroups,
  ) : this._internal(
          (ref) => prefetchedTeamData(
            ref as PrefetchedTeamDataRef,
            teamGroups,
          ),
          from: prefetchedTeamDataProvider,
          name: r'prefetchedTeamDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$prefetchedTeamDataHash,
          dependencies: PrefetchedTeamDataFamily._dependencies,
          allTransitiveDependencies:
              PrefetchedTeamDataFamily._allTransitiveDependencies,
          teamGroups: teamGroups,
        );

  PrefetchedTeamDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.teamGroups,
  }) : super.internal();

  final List<TeamGroup> teamGroups;

  @override
  Override overrideWith(
    FutureOr<TeamGroupData> Function(PrefetchedTeamDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PrefetchedTeamDataProvider._internal(
        (ref) => create(ref as PrefetchedTeamDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        teamGroups: teamGroups,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TeamGroupData> createElement() {
    return _PrefetchedTeamDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PrefetchedTeamDataProvider &&
        other.teamGroups == teamGroups;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, teamGroups.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PrefetchedTeamDataRef on AutoDisposeFutureProviderRef<TeamGroupData> {
  /// The parameter `teamGroups` of this provider.
  List<TeamGroup> get teamGroups;
}

class _PrefetchedTeamDataProviderElement
    extends AutoDisposeFutureProviderElement<TeamGroupData>
    with PrefetchedTeamDataRef {
  _PrefetchedTeamDataProviderElement(super.provider);

  @override
  List<TeamGroup> get teamGroups =>
      (origin as PrefetchedTeamDataProvider).teamGroups;
}

String _$statsDatesHash() => r'bef6ea319d1b6e629b2e5de2768659408beb1fb0';

/// See also [StatsDates].
@ProviderFor(StatsDates)
final statsDatesProvider =
    AutoDisposeNotifierProvider<StatsDates, StatsDateRange>.internal(
  StatsDates.new,
  name: r'statsDatesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$statsDatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StatsDates = AutoDisposeNotifier<StatsDateRange>;
String _$filteredDogsHash() => r'3b23d0a0f8386ff0530bc5b03cfcf098021b87f4';

/// See also [FilteredDogs].
@ProviderFor(FilteredDogs)
final filteredDogsProvider =
    AutoDisposeNotifierProvider<FilteredDogs, List<Dog>>.internal(
  FilteredDogs.new,
  name: r'filteredDogsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$filteredDogsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FilteredDogs = AutoDisposeNotifier<List<Dog>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
