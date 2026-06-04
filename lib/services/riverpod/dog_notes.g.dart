// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dog_notes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dogNotesHash() => r'4d849d300ba28a8e7c64aa13b1a39db0f26ca4cf';

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

/// See also [dogNotes].
@ProviderFor(dogNotes)
const dogNotesProvider = DogNotesFamily();

/// See also [dogNotes].
class DogNotesFamily extends Family<List<DogNote>> {
  /// See also [dogNotes].
  const DogNotesFamily();

  /// See also [dogNotes].
  DogNotesProvider call({
    required DateTime? latestDate,
    TeamGroupWorkspace? teamGroup,
  }) {
    return DogNotesProvider(latestDate: latestDate, teamGroup: teamGroup);
  }

  @override
  DogNotesProvider getProviderOverride(covariant DogNotesProvider provider) {
    return call(latestDate: provider.latestDate, teamGroup: provider.teamGroup);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dogNotesProvider';
}

/// See also [dogNotes].
class DogNotesProvider extends AutoDisposeProvider<List<DogNote>> {
  /// See also [dogNotes].
  DogNotesProvider({
    required DateTime? latestDate,
    TeamGroupWorkspace? teamGroup,
  }) : this._internal(
         (ref) => dogNotes(
           ref as DogNotesRef,
           latestDate: latestDate,
           teamGroup: teamGroup,
         ),
         from: dogNotesProvider,
         name: r'dogNotesProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$dogNotesHash,
         dependencies: DogNotesFamily._dependencies,
         allTransitiveDependencies: DogNotesFamily._allTransitiveDependencies,
         latestDate: latestDate,
         teamGroup: teamGroup,
       );

  DogNotesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.latestDate,
    required this.teamGroup,
  }) : super.internal();

  final DateTime? latestDate;
  final TeamGroupWorkspace? teamGroup;

  @override
  Override overrideWith(List<DogNote> Function(DogNotesRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: DogNotesProvider._internal(
        (ref) => create(ref as DogNotesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        latestDate: latestDate,
        teamGroup: teamGroup,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<DogNote>> createElement() {
    return _DogNotesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DogNotesProvider &&
        other.latestDate == latestDate &&
        other.teamGroup == teamGroup;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, latestDate.hashCode);
    hash = _SystemHash.combine(hash, teamGroup.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DogNotesRef on AutoDisposeProviderRef<List<DogNote>> {
  /// The parameter `latestDate` of this provider.
  DateTime? get latestDate;

  /// The parameter `teamGroup` of this provider.
  TeamGroupWorkspace? get teamGroup;
}

class _DogNotesProviderElement extends AutoDisposeProviderElement<List<DogNote>>
    with DogNotesRef {
  _DogNotesProviderElement(super.provider);

  @override
  DateTime? get latestDate => (origin as DogNotesProvider).latestDate;
  @override
  TeamGroupWorkspace? get teamGroup => (origin as DogNotesProvider).teamGroup;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
