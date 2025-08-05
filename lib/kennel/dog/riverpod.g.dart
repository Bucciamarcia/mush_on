// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$singleDogHash() => r'2d22e46026545facd4d7c0dc281cd3abfcb8b2e4';

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

/// See also [singleDog].
@ProviderFor(singleDog)
const singleDogProvider = SingleDogFamily();

/// See also [singleDog].
class SingleDogFamily extends Family<AsyncValue<Dog>> {
  /// See also [singleDog].
  const SingleDogFamily();

  /// See also [singleDog].
  SingleDogProvider call(
    String dogId,
  ) {
    return SingleDogProvider(
      dogId,
    );
  }

  @override
  SingleDogProvider getProviderOverride(
    covariant SingleDogProvider provider,
  ) {
    return call(
      provider.dogId,
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
  String? get name => r'singleDogProvider';
}

/// See also [singleDog].
class SingleDogProvider extends AutoDisposeStreamProvider<Dog> {
  /// See also [singleDog].
  SingleDogProvider(
    String dogId,
  ) : this._internal(
          (ref) => singleDog(
            ref as SingleDogRef,
            dogId,
          ),
          from: singleDogProvider,
          name: r'singleDogProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singleDogHash,
          dependencies: SingleDogFamily._dependencies,
          allTransitiveDependencies: SingleDogFamily._allTransitiveDependencies,
          dogId: dogId,
        );

  SingleDogProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dogId,
  }) : super.internal();

  final String dogId;

  @override
  Override overrideWith(
    Stream<Dog> Function(SingleDogRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SingleDogProvider._internal(
        (ref) => create(ref as SingleDogRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dogId: dogId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Dog> createElement() {
    return _SingleDogProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleDogProvider && other.dogId == dogId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dogId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SingleDogRef on AutoDisposeStreamProviderRef<Dog> {
  /// The parameter `dogId` of this provider.
  String get dogId;
}

class _SingleDogProviderElement extends AutoDisposeStreamProviderElement<Dog>
    with SingleDogRef {
  _SingleDogProviderElement(super.provider);

  @override
  String get dogId => (origin as SingleDogProvider).dogId;
}

String _$dogTotalHash() => r'750f43ddb2cac233dc097496687ac9dcb82a58fd';

/// Gets the run totals for a single dog in the specified period.
///
/// Defaults to 30 days.
///
/// Copied from [dogTotal].
@ProviderFor(dogTotal)
const dogTotalProvider = DogTotalFamily();

/// Gets the run totals for a single dog in the specified period.
///
/// Defaults to 30 days.
///
/// Copied from [dogTotal].
class DogTotalFamily extends Family<AsyncValue<List<DogTotal>>> {
  /// Gets the run totals for a single dog in the specified period.
  ///
  /// Defaults to 30 days.
  ///
  /// Copied from [dogTotal].
  const DogTotalFamily();

  /// Gets the run totals for a single dog in the specified period.
  ///
  /// Defaults to 30 days.
  ///
  /// Copied from [dogTotal].
  DogTotalProvider call({
    required String dogId,
    DateTime? cutoff,
  }) {
    return DogTotalProvider(
      dogId: dogId,
      cutoff: cutoff,
    );
  }

  @override
  DogTotalProvider getProviderOverride(
    covariant DogTotalProvider provider,
  ) {
    return call(
      dogId: provider.dogId,
      cutoff: provider.cutoff,
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
  String? get name => r'dogTotalProvider';
}

/// Gets the run totals for a single dog in the specified period.
///
/// Defaults to 30 days.
///
/// Copied from [dogTotal].
class DogTotalProvider extends AutoDisposeStreamProvider<List<DogTotal>> {
  /// Gets the run totals for a single dog in the specified period.
  ///
  /// Defaults to 30 days.
  ///
  /// Copied from [dogTotal].
  DogTotalProvider({
    required String dogId,
    DateTime? cutoff,
  }) : this._internal(
          (ref) => dogTotal(
            ref as DogTotalRef,
            dogId: dogId,
            cutoff: cutoff,
          ),
          from: dogTotalProvider,
          name: r'dogTotalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dogTotalHash,
          dependencies: DogTotalFamily._dependencies,
          allTransitiveDependencies: DogTotalFamily._allTransitiveDependencies,
          dogId: dogId,
          cutoff: cutoff,
        );

  DogTotalProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dogId,
    required this.cutoff,
  }) : super.internal();

  final String dogId;
  final DateTime? cutoff;

  @override
  Override overrideWith(
    Stream<List<DogTotal>> Function(DogTotalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DogTotalProvider._internal(
        (ref) => create(ref as DogTotalRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dogId: dogId,
        cutoff: cutoff,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<DogTotal>> createElement() {
    return _DogTotalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DogTotalProvider &&
        other.dogId == dogId &&
        other.cutoff == cutoff;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dogId.hashCode);
    hash = _SystemHash.combine(hash, cutoff.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DogTotalRef on AutoDisposeStreamProviderRef<List<DogTotal>> {
  /// The parameter `dogId` of this provider.
  String get dogId;

  /// The parameter `cutoff` of this provider.
  DateTime? get cutoff;
}

class _DogTotalProviderElement
    extends AutoDisposeStreamProviderElement<List<DogTotal>> with DogTotalRef {
  _DogTotalProviderElement(super.provider);

  @override
  String get dogId => (origin as DogTotalProvider).dogId;
  @override
  DateTime? get cutoff => (origin as DogTotalProvider).cutoff;
}

String _$dogHealthEventsHash() => r'd44f6be58f75d92a035ea448100e97d5926c39e5';

/// All the health events related to a single dog. Cutoff default to 90 days.
///
/// Copied from [dogHealthEvents].
@ProviderFor(dogHealthEvents)
const dogHealthEventsProvider = DogHealthEventsFamily();

/// All the health events related to a single dog. Cutoff default to 90 days.
///
/// Copied from [dogHealthEvents].
class DogHealthEventsFamily extends Family<AsyncValue<List<HealthEvent>>> {
  /// All the health events related to a single dog. Cutoff default to 90 days.
  ///
  /// Copied from [dogHealthEvents].
  const DogHealthEventsFamily();

  /// All the health events related to a single dog. Cutoff default to 90 days.
  ///
  /// Copied from [dogHealthEvents].
  DogHealthEventsProvider call({
    required String dogId,
    DateTime? cutoff,
  }) {
    return DogHealthEventsProvider(
      dogId: dogId,
      cutoff: cutoff,
    );
  }

  @override
  DogHealthEventsProvider getProviderOverride(
    covariant DogHealthEventsProvider provider,
  ) {
    return call(
      dogId: provider.dogId,
      cutoff: provider.cutoff,
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
  String? get name => r'dogHealthEventsProvider';
}

/// All the health events related to a single dog. Cutoff default to 90 days.
///
/// Copied from [dogHealthEvents].
class DogHealthEventsProvider
    extends AutoDisposeStreamProvider<List<HealthEvent>> {
  /// All the health events related to a single dog. Cutoff default to 90 days.
  ///
  /// Copied from [dogHealthEvents].
  DogHealthEventsProvider({
    required String dogId,
    DateTime? cutoff,
  }) : this._internal(
          (ref) => dogHealthEvents(
            ref as DogHealthEventsRef,
            dogId: dogId,
            cutoff: cutoff,
          ),
          from: dogHealthEventsProvider,
          name: r'dogHealthEventsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dogHealthEventsHash,
          dependencies: DogHealthEventsFamily._dependencies,
          allTransitiveDependencies:
              DogHealthEventsFamily._allTransitiveDependencies,
          dogId: dogId,
          cutoff: cutoff,
        );

  DogHealthEventsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dogId,
    required this.cutoff,
  }) : super.internal();

  final String dogId;
  final DateTime? cutoff;

  @override
  Override overrideWith(
    Stream<List<HealthEvent>> Function(DogHealthEventsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DogHealthEventsProvider._internal(
        (ref) => create(ref as DogHealthEventsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dogId: dogId,
        cutoff: cutoff,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<HealthEvent>> createElement() {
    return _DogHealthEventsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DogHealthEventsProvider &&
        other.dogId == dogId &&
        other.cutoff == cutoff;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dogId.hashCode);
    hash = _SystemHash.combine(hash, cutoff.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DogHealthEventsRef on AutoDisposeStreamProviderRef<List<HealthEvent>> {
  /// The parameter `dogId` of this provider.
  String get dogId;

  /// The parameter `cutoff` of this provider.
  DateTime? get cutoff;
}

class _DogHealthEventsProviderElement
    extends AutoDisposeStreamProviderElement<List<HealthEvent>>
    with DogHealthEventsRef {
  _DogHealthEventsProviderElement(super.provider);

  @override
  String get dogId => (origin as DogHealthEventsProvider).dogId;
  @override
  DateTime? get cutoff => (origin as DogHealthEventsProvider).cutoff;
}

String _$dogVaccinationsHash() => r'a44a983a25fd973a43cd390cae9d5df6fc89a1f6';

/// All the vaccinations related to a single dog. Cutoff default to 90 days.
///
/// Copied from [dogVaccinations].
@ProviderFor(dogVaccinations)
const dogVaccinationsProvider = DogVaccinationsFamily();

/// All the vaccinations related to a single dog. Cutoff default to 90 days.
///
/// Copied from [dogVaccinations].
class DogVaccinationsFamily extends Family<AsyncValue<List<Vaccination>>> {
  /// All the vaccinations related to a single dog. Cutoff default to 90 days.
  ///
  /// Copied from [dogVaccinations].
  const DogVaccinationsFamily();

  /// All the vaccinations related to a single dog. Cutoff default to 90 days.
  ///
  /// Copied from [dogVaccinations].
  DogVaccinationsProvider call({
    required String dogId,
    DateTime? cutoff,
  }) {
    return DogVaccinationsProvider(
      dogId: dogId,
      cutoff: cutoff,
    );
  }

  @override
  DogVaccinationsProvider getProviderOverride(
    covariant DogVaccinationsProvider provider,
  ) {
    return call(
      dogId: provider.dogId,
      cutoff: provider.cutoff,
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
  String? get name => r'dogVaccinationsProvider';
}

/// All the vaccinations related to a single dog. Cutoff default to 90 days.
///
/// Copied from [dogVaccinations].
class DogVaccinationsProvider
    extends AutoDisposeStreamProvider<List<Vaccination>> {
  /// All the vaccinations related to a single dog. Cutoff default to 90 days.
  ///
  /// Copied from [dogVaccinations].
  DogVaccinationsProvider({
    required String dogId,
    DateTime? cutoff,
  }) : this._internal(
          (ref) => dogVaccinations(
            ref as DogVaccinationsRef,
            dogId: dogId,
            cutoff: cutoff,
          ),
          from: dogVaccinationsProvider,
          name: r'dogVaccinationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dogVaccinationsHash,
          dependencies: DogVaccinationsFamily._dependencies,
          allTransitiveDependencies:
              DogVaccinationsFamily._allTransitiveDependencies,
          dogId: dogId,
          cutoff: cutoff,
        );

  DogVaccinationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dogId,
    required this.cutoff,
  }) : super.internal();

  final String dogId;
  final DateTime? cutoff;

  @override
  Override overrideWith(
    Stream<List<Vaccination>> Function(DogVaccinationsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DogVaccinationsProvider._internal(
        (ref) => create(ref as DogVaccinationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dogId: dogId,
        cutoff: cutoff,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Vaccination>> createElement() {
    return _DogVaccinationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DogVaccinationsProvider &&
        other.dogId == dogId &&
        other.cutoff == cutoff;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dogId.hashCode);
    hash = _SystemHash.combine(hash, cutoff.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DogVaccinationsRef on AutoDisposeStreamProviderRef<List<Vaccination>> {
  /// The parameter `dogId` of this provider.
  String get dogId;

  /// The parameter `cutoff` of this provider.
  DateTime? get cutoff;
}

class _DogVaccinationsProviderElement
    extends AutoDisposeStreamProviderElement<List<Vaccination>>
    with DogVaccinationsRef {
  _DogVaccinationsProviderElement(super.provider);

  @override
  String get dogId => (origin as DogVaccinationsProvider).dogId;
  @override
  DateTime? get cutoff => (origin as DogVaccinationsProvider).cutoff;
}

String _$dogHeatsHash() => r'e0e879e97f757b77f20671f97a8748a5d908ffac';

/// All the heats related to a single dog. Cutoff default to 90 days.
///
/// Copied from [dogHeats].
@ProviderFor(dogHeats)
const dogHeatsProvider = DogHeatsFamily();

/// All the heats related to a single dog. Cutoff default to 90 days.
///
/// Copied from [dogHeats].
class DogHeatsFamily extends Family<AsyncValue<List<HeatCycle>>> {
  /// All the heats related to a single dog. Cutoff default to 90 days.
  ///
  /// Copied from [dogHeats].
  const DogHeatsFamily();

  /// All the heats related to a single dog. Cutoff default to 90 days.
  ///
  /// Copied from [dogHeats].
  DogHeatsProvider call({
    required String dogId,
    DateTime? cutoff,
  }) {
    return DogHeatsProvider(
      dogId: dogId,
      cutoff: cutoff,
    );
  }

  @override
  DogHeatsProvider getProviderOverride(
    covariant DogHeatsProvider provider,
  ) {
    return call(
      dogId: provider.dogId,
      cutoff: provider.cutoff,
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
  String? get name => r'dogHeatsProvider';
}

/// All the heats related to a single dog. Cutoff default to 90 days.
///
/// Copied from [dogHeats].
class DogHeatsProvider extends AutoDisposeStreamProvider<List<HeatCycle>> {
  /// All the heats related to a single dog. Cutoff default to 90 days.
  ///
  /// Copied from [dogHeats].
  DogHeatsProvider({
    required String dogId,
    DateTime? cutoff,
  }) : this._internal(
          (ref) => dogHeats(
            ref as DogHeatsRef,
            dogId: dogId,
            cutoff: cutoff,
          ),
          from: dogHeatsProvider,
          name: r'dogHeatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dogHeatsHash,
          dependencies: DogHeatsFamily._dependencies,
          allTransitiveDependencies: DogHeatsFamily._allTransitiveDependencies,
          dogId: dogId,
          cutoff: cutoff,
        );

  DogHeatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dogId,
    required this.cutoff,
  }) : super.internal();

  final String dogId;
  final DateTime? cutoff;

  @override
  Override overrideWith(
    Stream<List<HeatCycle>> Function(DogHeatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DogHeatsProvider._internal(
        (ref) => create(ref as DogHeatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dogId: dogId,
        cutoff: cutoff,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<HeatCycle>> createElement() {
    return _DogHeatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DogHeatsProvider &&
        other.dogId == dogId &&
        other.cutoff == cutoff;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dogId.hashCode);
    hash = _SystemHash.combine(hash, cutoff.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DogHeatsRef on AutoDisposeStreamProviderRef<List<HeatCycle>> {
  /// The parameter `dogId` of this provider.
  String get dogId;

  /// The parameter `cutoff` of this provider.
  DateTime? get cutoff;
}

class _DogHeatsProviderElement
    extends AutoDisposeStreamProviderElement<List<HeatCycle>> with DogHeatsRef {
  _DogHeatsProviderElement(super.provider);

  @override
  String get dogId => (origin as DogHeatsProvider).dogId;
  @override
  DateTime? get cutoff => (origin as DogHeatsProvider).cutoff;
}

String _$singleDogImageHash() => r'685d0275ff357bccd60b02c7a0061756c295e8a8';

abstract class _$SingleDogImage
    extends BuildlessAutoDisposeAsyncNotifier<Uint8List?> {
  late final String account;
  late final String dogId;

  FutureOr<Uint8List?> build(
    String account,
    String dogId,
  );
}

/// See also [SingleDogImage].
@ProviderFor(SingleDogImage)
const singleDogImageProvider = SingleDogImageFamily();

/// See also [SingleDogImage].
class SingleDogImageFamily extends Family<AsyncValue<Uint8List?>> {
  /// See also [SingleDogImage].
  const SingleDogImageFamily();

  /// See also [SingleDogImage].
  SingleDogImageProvider call(
    String account,
    String dogId,
  ) {
    return SingleDogImageProvider(
      account,
      dogId,
    );
  }

  @override
  SingleDogImageProvider getProviderOverride(
    covariant SingleDogImageProvider provider,
  ) {
    return call(
      provider.account,
      provider.dogId,
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
  String? get name => r'singleDogImageProvider';
}

/// See also [SingleDogImage].
class SingleDogImageProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SingleDogImage, Uint8List?> {
  /// See also [SingleDogImage].
  SingleDogImageProvider(
    String account,
    String dogId,
  ) : this._internal(
          () => SingleDogImage()
            ..account = account
            ..dogId = dogId,
          from: singleDogImageProvider,
          name: r'singleDogImageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singleDogImageHash,
          dependencies: SingleDogImageFamily._dependencies,
          allTransitiveDependencies:
              SingleDogImageFamily._allTransitiveDependencies,
          account: account,
          dogId: dogId,
        );

  SingleDogImageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
    required this.dogId,
  }) : super.internal();

  final String account;
  final String dogId;

  @override
  FutureOr<Uint8List?> runNotifierBuild(
    covariant SingleDogImage notifier,
  ) {
    return notifier.build(
      account,
      dogId,
    );
  }

  @override
  Override overrideWith(SingleDogImage Function() create) {
    return ProviderOverride(
      origin: this,
      override: SingleDogImageProvider._internal(
        () => create()
          ..account = account
          ..dogId = dogId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
        dogId: dogId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SingleDogImage, Uint8List?>
      createElement() {
    return _SingleDogImageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SingleDogImageProvider &&
        other.account == account &&
        other.dogId == dogId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, dogId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SingleDogImageRef on AutoDisposeAsyncNotifierProviderRef<Uint8List?> {
  /// The parameter `account` of this provider.
  String get account;

  /// The parameter `dogId` of this provider.
  String get dogId;
}

class _SingleDogImageProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SingleDogImage, Uint8List?>
    with SingleDogImageRef {
  _SingleDogImageProviderElement(super.provider);

  @override
  String get account => (origin as SingleDogImageProvider).account;
  @override
  String get dogId => (origin as SingleDogImageProvider).dogId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
