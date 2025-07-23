// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$teamGroupsByDateHash() => r'146f46791a46f56ceb367f99b177ec1df9d62ebc';

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

/// Returns a list of teamgroups that have he same date and time as the input
///
/// Copied from [teamGroupsByDate].
@ProviderFor(teamGroupsByDate)
const teamGroupsByDateProvider = TeamGroupsByDateFamily();

/// Returns a list of teamgroups that have he same date and time as the input
///
/// Copied from [teamGroupsByDate].
class TeamGroupsByDateFamily extends Family<AsyncValue<List<TeamGroup>>> {
  /// Returns a list of teamgroups that have he same date and time as the input
  ///
  /// Copied from [teamGroupsByDate].
  const TeamGroupsByDateFamily();

  /// Returns a list of teamgroups that have he same date and time as the input
  ///
  /// Copied from [teamGroupsByDate].
  TeamGroupsByDateProvider call(
    DateTime date,
  ) {
    return TeamGroupsByDateProvider(
      date,
    );
  }

  @override
  TeamGroupsByDateProvider getProviderOverride(
    covariant TeamGroupsByDateProvider provider,
  ) {
    return call(
      provider.date,
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
  String? get name => r'teamGroupsByDateProvider';
}

/// Returns a list of teamgroups that have he same date and time as the input
///
/// Copied from [teamGroupsByDate].
class TeamGroupsByDateProvider
    extends AutoDisposeStreamProvider<List<TeamGroup>> {
  /// Returns a list of teamgroups that have he same date and time as the input
  ///
  /// Copied from [teamGroupsByDate].
  TeamGroupsByDateProvider(
    DateTime date,
  ) : this._internal(
          (ref) => teamGroupsByDate(
            ref as TeamGroupsByDateRef,
            date,
          ),
          from: teamGroupsByDateProvider,
          name: r'teamGroupsByDateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$teamGroupsByDateHash,
          dependencies: TeamGroupsByDateFamily._dependencies,
          allTransitiveDependencies:
              TeamGroupsByDateFamily._allTransitiveDependencies,
          date: date,
        );

  TeamGroupsByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    Stream<List<TeamGroup>> Function(TeamGroupsByDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TeamGroupsByDateProvider._internal(
        (ref) => create(ref as TeamGroupsByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TeamGroup>> createElement() {
    return _TeamGroupsByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TeamGroupsByDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TeamGroupsByDateRef on AutoDisposeStreamProviderRef<List<TeamGroup>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _TeamGroupsByDateProviderElement
    extends AutoDisposeStreamProviderElement<List<TeamGroup>>
    with TeamGroupsByDateRef {
  _TeamGroupsByDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as TeamGroupsByDateProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
