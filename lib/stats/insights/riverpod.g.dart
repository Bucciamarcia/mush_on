// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$totalRanForDogHash() => r'bcdbcf15aa5a0d84fe2398974d61a0ca617b4c1d';

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

/// See also [totalRanForDog].
@ProviderFor(totalRanForDog)
const totalRanForDogProvider = TotalRanForDogFamily();

/// See also [totalRanForDog].
class TotalRanForDogFamily extends Family<double> {
  /// See also [totalRanForDog].
  const TotalRanForDogFamily();

  /// See also [totalRanForDog].
  TotalRanForDogProvider call(
    List<DogDailyStats> dogDailyStats,
  ) {
    return TotalRanForDogProvider(
      dogDailyStats,
    );
  }

  @override
  TotalRanForDogProvider getProviderOverride(
    covariant TotalRanForDogProvider provider,
  ) {
    return call(
      provider.dogDailyStats,
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
  String? get name => r'totalRanForDogProvider';
}

/// See also [totalRanForDog].
class TotalRanForDogProvider extends AutoDisposeProvider<double> {
  /// See also [totalRanForDog].
  TotalRanForDogProvider(
    List<DogDailyStats> dogDailyStats,
  ) : this._internal(
          (ref) => totalRanForDog(
            ref as TotalRanForDogRef,
            dogDailyStats,
          ),
          from: totalRanForDogProvider,
          name: r'totalRanForDogProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$totalRanForDogHash,
          dependencies: TotalRanForDogFamily._dependencies,
          allTransitiveDependencies:
              TotalRanForDogFamily._allTransitiveDependencies,
          dogDailyStats: dogDailyStats,
        );

  TotalRanForDogProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dogDailyStats,
  }) : super.internal();

  final List<DogDailyStats> dogDailyStats;

  @override
  Override overrideWith(
    double Function(TotalRanForDogRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TotalRanForDogProvider._internal(
        (ref) => create(ref as TotalRanForDogRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dogDailyStats: dogDailyStats,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _TotalRanForDogProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalRanForDogProvider &&
        other.dogDailyStats == dogDailyStats;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dogDailyStats.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TotalRanForDogRef on AutoDisposeProviderRef<double> {
  /// The parameter `dogDailyStats` of this provider.
  List<DogDailyStats> get dogDailyStats;
}

class _TotalRanForDogProviderElement extends AutoDisposeProviderElement<double>
    with TotalRanForDogRef {
  _TotalRanForDogProviderElement(super.provider);

  @override
  List<DogDailyStats> get dogDailyStats =>
      (origin as TotalRanForDogProvider).dogDailyStats;
}

String _$runRateHash() => r'39e5ac4478483036fb2ac9f096f290de5ca573b7';

/// See also [runRate].
@ProviderFor(runRate)
const runRateProvider = RunRateFamily();

/// See also [runRate].
class RunRateFamily extends Family<double> {
  /// See also [runRate].
  const RunRateFamily();

  /// See also [runRate].
  RunRateProvider call(
    List<DogDailyStats> list,
    StatsDateRange dateRange,
  ) {
    return RunRateProvider(
      list,
      dateRange,
    );
  }

  @override
  RunRateProvider getProviderOverride(
    covariant RunRateProvider provider,
  ) {
    return call(
      provider.list,
      provider.dateRange,
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
  String? get name => r'runRateProvider';
}

/// See also [runRate].
class RunRateProvider extends AutoDisposeProvider<double> {
  /// See also [runRate].
  RunRateProvider(
    List<DogDailyStats> list,
    StatsDateRange dateRange,
  ) : this._internal(
          (ref) => runRate(
            ref as RunRateRef,
            list,
            dateRange,
          ),
          from: runRateProvider,
          name: r'runRateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$runRateHash,
          dependencies: RunRateFamily._dependencies,
          allTransitiveDependencies: RunRateFamily._allTransitiveDependencies,
          list: list,
          dateRange: dateRange,
        );

  RunRateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.list,
    required this.dateRange,
  }) : super.internal();

  final List<DogDailyStats> list;
  final StatsDateRange dateRange;

  @override
  Override overrideWith(
    double Function(RunRateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RunRateProvider._internal(
        (ref) => create(ref as RunRateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        list: list,
        dateRange: dateRange,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _RunRateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RunRateProvider &&
        other.list == list &&
        other.dateRange == dateRange;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, list.hashCode);
    hash = _SystemHash.combine(hash, dateRange.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RunRateRef on AutoDisposeProviderRef<double> {
  /// The parameter `list` of this provider.
  List<DogDailyStats> get list;

  /// The parameter `dateRange` of this provider.
  StatsDateRange get dateRange;
}

class _RunRateProviderElement extends AutoDisposeProviderElement<double>
    with RunRateRef {
  _RunRateProviderElement(super.provider);

  @override
  List<DogDailyStats> get list => (origin as RunRateProvider).list;
  @override
  StatsDateRange get dateRange => (origin as RunRateProvider).dateRange;
}

String _$reliabilityHash() => r'970292fdd6571850c57cd9d047b065b21f4d0647';

/// See also [reliability].
@ProviderFor(reliability)
const reliabilityProvider = ReliabilityFamily();

/// See also [reliability].
class ReliabilityFamily extends Family<double> {
  /// See also [reliability].
  const ReliabilityFamily();

  /// See also [reliability].
  ReliabilityProvider call(
    String id,
    List<HealthEvent> healthEvents,
    StatsDateRange dateRange,
  ) {
    return ReliabilityProvider(
      id,
      healthEvents,
      dateRange,
    );
  }

  @override
  ReliabilityProvider getProviderOverride(
    covariant ReliabilityProvider provider,
  ) {
    return call(
      provider.id,
      provider.healthEvents,
      provider.dateRange,
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
  String? get name => r'reliabilityProvider';
}

/// See also [reliability].
class ReliabilityProvider extends AutoDisposeProvider<double> {
  /// See also [reliability].
  ReliabilityProvider(
    String id,
    List<HealthEvent> healthEvents,
    StatsDateRange dateRange,
  ) : this._internal(
          (ref) => reliability(
            ref as ReliabilityRef,
            id,
            healthEvents,
            dateRange,
          ),
          from: reliabilityProvider,
          name: r'reliabilityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reliabilityHash,
          dependencies: ReliabilityFamily._dependencies,
          allTransitiveDependencies:
              ReliabilityFamily._allTransitiveDependencies,
          id: id,
          healthEvents: healthEvents,
          dateRange: dateRange,
        );

  ReliabilityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.healthEvents,
    required this.dateRange,
  }) : super.internal();

  final String id;
  final List<HealthEvent> healthEvents;
  final StatsDateRange dateRange;

  @override
  Override overrideWith(
    double Function(ReliabilityRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReliabilityProvider._internal(
        (ref) => create(ref as ReliabilityRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        healthEvents: healthEvents,
        dateRange: dateRange,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _ReliabilityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReliabilityProvider &&
        other.id == id &&
        other.healthEvents == healthEvents &&
        other.dateRange == dateRange;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, healthEvents.hashCode);
    hash = _SystemHash.combine(hash, dateRange.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReliabilityRef on AutoDisposeProviderRef<double> {
  /// The parameter `id` of this provider.
  String get id;

  /// The parameter `healthEvents` of this provider.
  List<HealthEvent> get healthEvents;

  /// The parameter `dateRange` of this provider.
  StatsDateRange get dateRange;
}

class _ReliabilityProviderElement extends AutoDisposeProviderElement<double>
    with ReliabilityRef {
  _ReliabilityProviderElement(super.provider);

  @override
  String get id => (origin as ReliabilityProvider).id;
  @override
  List<HealthEvent> get healthEvents =>
      (origin as ReliabilityProvider).healthEvents;
  @override
  StatsDateRange get dateRange => (origin as ReliabilityProvider).dateRange;
}

String _$insightsDataHash() => r'0cdee2e8f38d1bd2b39cfc82fd4be49f446ad8de';

abstract class _$InsightsData
    extends BuildlessAutoDisposeNotifier<List<DataGridRow>> {
  late final List<Dog> dogs;
  late final StatsDateRange dateRange;
  late final List<HealthEvent> healthEvents;
  late final Map<String, List<DogDailyStats>> dogDailyStats;

  List<DataGridRow> build({
    required List<Dog> dogs,
    required StatsDateRange dateRange,
    required List<HealthEvent> healthEvents,
    required Map<String, List<DogDailyStats>> dogDailyStats,
  });
}

/// See also [InsightsData].
@ProviderFor(InsightsData)
const insightsDataProvider = InsightsDataFamily();

/// See also [InsightsData].
class InsightsDataFamily extends Family<List<DataGridRow>> {
  /// See also [InsightsData].
  const InsightsDataFamily();

  /// See also [InsightsData].
  InsightsDataProvider call({
    required List<Dog> dogs,
    required StatsDateRange dateRange,
    required List<HealthEvent> healthEvents,
    required Map<String, List<DogDailyStats>> dogDailyStats,
  }) {
    return InsightsDataProvider(
      dogs: dogs,
      dateRange: dateRange,
      healthEvents: healthEvents,
      dogDailyStats: dogDailyStats,
    );
  }

  @override
  InsightsDataProvider getProviderOverride(
    covariant InsightsDataProvider provider,
  ) {
    return call(
      dogs: provider.dogs,
      dateRange: provider.dateRange,
      healthEvents: provider.healthEvents,
      dogDailyStats: provider.dogDailyStats,
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
  String? get name => r'insightsDataProvider';
}

/// See also [InsightsData].
class InsightsDataProvider
    extends AutoDisposeNotifierProviderImpl<InsightsData, List<DataGridRow>> {
  /// See also [InsightsData].
  InsightsDataProvider({
    required List<Dog> dogs,
    required StatsDateRange dateRange,
    required List<HealthEvent> healthEvents,
    required Map<String, List<DogDailyStats>> dogDailyStats,
  }) : this._internal(
          () => InsightsData()
            ..dogs = dogs
            ..dateRange = dateRange
            ..healthEvents = healthEvents
            ..dogDailyStats = dogDailyStats,
          from: insightsDataProvider,
          name: r'insightsDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$insightsDataHash,
          dependencies: InsightsDataFamily._dependencies,
          allTransitiveDependencies:
              InsightsDataFamily._allTransitiveDependencies,
          dogs: dogs,
          dateRange: dateRange,
          healthEvents: healthEvents,
          dogDailyStats: dogDailyStats,
        );

  InsightsDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dogs,
    required this.dateRange,
    required this.healthEvents,
    required this.dogDailyStats,
  }) : super.internal();

  final List<Dog> dogs;
  final StatsDateRange dateRange;
  final List<HealthEvent> healthEvents;
  final Map<String, List<DogDailyStats>> dogDailyStats;

  @override
  List<DataGridRow> runNotifierBuild(
    covariant InsightsData notifier,
  ) {
    return notifier.build(
      dogs: dogs,
      dateRange: dateRange,
      healthEvents: healthEvents,
      dogDailyStats: dogDailyStats,
    );
  }

  @override
  Override overrideWith(InsightsData Function() create) {
    return ProviderOverride(
      origin: this,
      override: InsightsDataProvider._internal(
        () => create()
          ..dogs = dogs
          ..dateRange = dateRange
          ..healthEvents = healthEvents
          ..dogDailyStats = dogDailyStats,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dogs: dogs,
        dateRange: dateRange,
        healthEvents: healthEvents,
        dogDailyStats: dogDailyStats,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<InsightsData, List<DataGridRow>>
      createElement() {
    return _InsightsDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InsightsDataProvider &&
        other.dogs == dogs &&
        other.dateRange == dateRange &&
        other.healthEvents == healthEvents &&
        other.dogDailyStats == dogDailyStats;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dogs.hashCode);
    hash = _SystemHash.combine(hash, dateRange.hashCode);
    hash = _SystemHash.combine(hash, healthEvents.hashCode);
    hash = _SystemHash.combine(hash, dogDailyStats.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InsightsDataRef on AutoDisposeNotifierProviderRef<List<DataGridRow>> {
  /// The parameter `dogs` of this provider.
  List<Dog> get dogs;

  /// The parameter `dateRange` of this provider.
  StatsDateRange get dateRange;

  /// The parameter `healthEvents` of this provider.
  List<HealthEvent> get healthEvents;

  /// The parameter `dogDailyStats` of this provider.
  Map<String, List<DogDailyStats>> get dogDailyStats;
}

class _InsightsDataProviderElement
    extends AutoDisposeNotifierProviderElement<InsightsData, List<DataGridRow>>
    with InsightsDataRef {
  _InsightsDataProviderElement(super.provider);

  @override
  List<Dog> get dogs => (origin as InsightsDataProvider).dogs;
  @override
  StatsDateRange get dateRange => (origin as InsightsDataProvider).dateRange;
  @override
  List<HealthEvent> get healthEvents =>
      (origin as InsightsDataProvider).healthEvents;
  @override
  Map<String, List<DogDailyStats>> get dogDailyStats =>
      (origin as InsightsDataProvider).dogDailyStats;
}

String _$reliabilityMatrixDataHash() =>
    r'5520f7bed6d11c38b6d51e03a3d5881566fdc24f';

abstract class _$ReliabilityMatrixData
    extends BuildlessAutoDisposeNotifier<List<ReliabilityMatrixChartData>> {
  late final List<Dog> dogs;
  late final StatsDateRange dateRange;
  late final List<HealthEvent> healthEvents;
  late final Map<String, List<DogDailyStats>> dogDailyStats;

  List<ReliabilityMatrixChartData> build({
    required List<Dog> dogs,
    required StatsDateRange dateRange,
    required List<HealthEvent> healthEvents,
    required Map<String, List<DogDailyStats>> dogDailyStats,
  });
}

/// See also [ReliabilityMatrixData].
@ProviderFor(ReliabilityMatrixData)
const reliabilityMatrixDataProvider = ReliabilityMatrixDataFamily();

/// See also [ReliabilityMatrixData].
class ReliabilityMatrixDataFamily
    extends Family<List<ReliabilityMatrixChartData>> {
  /// See also [ReliabilityMatrixData].
  const ReliabilityMatrixDataFamily();

  /// See also [ReliabilityMatrixData].
  ReliabilityMatrixDataProvider call({
    required List<Dog> dogs,
    required StatsDateRange dateRange,
    required List<HealthEvent> healthEvents,
    required Map<String, List<DogDailyStats>> dogDailyStats,
  }) {
    return ReliabilityMatrixDataProvider(
      dogs: dogs,
      dateRange: dateRange,
      healthEvents: healthEvents,
      dogDailyStats: dogDailyStats,
    );
  }

  @override
  ReliabilityMatrixDataProvider getProviderOverride(
    covariant ReliabilityMatrixDataProvider provider,
  ) {
    return call(
      dogs: provider.dogs,
      dateRange: provider.dateRange,
      healthEvents: provider.healthEvents,
      dogDailyStats: provider.dogDailyStats,
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
  String? get name => r'reliabilityMatrixDataProvider';
}

/// See also [ReliabilityMatrixData].
class ReliabilityMatrixDataProvider extends AutoDisposeNotifierProviderImpl<
    ReliabilityMatrixData, List<ReliabilityMatrixChartData>> {
  /// See also [ReliabilityMatrixData].
  ReliabilityMatrixDataProvider({
    required List<Dog> dogs,
    required StatsDateRange dateRange,
    required List<HealthEvent> healthEvents,
    required Map<String, List<DogDailyStats>> dogDailyStats,
  }) : this._internal(
          () => ReliabilityMatrixData()
            ..dogs = dogs
            ..dateRange = dateRange
            ..healthEvents = healthEvents
            ..dogDailyStats = dogDailyStats,
          from: reliabilityMatrixDataProvider,
          name: r'reliabilityMatrixDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reliabilityMatrixDataHash,
          dependencies: ReliabilityMatrixDataFamily._dependencies,
          allTransitiveDependencies:
              ReliabilityMatrixDataFamily._allTransitiveDependencies,
          dogs: dogs,
          dateRange: dateRange,
          healthEvents: healthEvents,
          dogDailyStats: dogDailyStats,
        );

  ReliabilityMatrixDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dogs,
    required this.dateRange,
    required this.healthEvents,
    required this.dogDailyStats,
  }) : super.internal();

  final List<Dog> dogs;
  final StatsDateRange dateRange;
  final List<HealthEvent> healthEvents;
  final Map<String, List<DogDailyStats>> dogDailyStats;

  @override
  List<ReliabilityMatrixChartData> runNotifierBuild(
    covariant ReliabilityMatrixData notifier,
  ) {
    return notifier.build(
      dogs: dogs,
      dateRange: dateRange,
      healthEvents: healthEvents,
      dogDailyStats: dogDailyStats,
    );
  }

  @override
  Override overrideWith(ReliabilityMatrixData Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReliabilityMatrixDataProvider._internal(
        () => create()
          ..dogs = dogs
          ..dateRange = dateRange
          ..healthEvents = healthEvents
          ..dogDailyStats = dogDailyStats,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dogs: dogs,
        dateRange: dateRange,
        healthEvents: healthEvents,
        dogDailyStats: dogDailyStats,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ReliabilityMatrixData,
      List<ReliabilityMatrixChartData>> createElement() {
    return _ReliabilityMatrixDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReliabilityMatrixDataProvider &&
        other.dogs == dogs &&
        other.dateRange == dateRange &&
        other.healthEvents == healthEvents &&
        other.dogDailyStats == dogDailyStats;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dogs.hashCode);
    hash = _SystemHash.combine(hash, dateRange.hashCode);
    hash = _SystemHash.combine(hash, healthEvents.hashCode);
    hash = _SystemHash.combine(hash, dogDailyStats.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReliabilityMatrixDataRef
    on AutoDisposeNotifierProviderRef<List<ReliabilityMatrixChartData>> {
  /// The parameter `dogs` of this provider.
  List<Dog> get dogs;

  /// The parameter `dateRange` of this provider.
  StatsDateRange get dateRange;

  /// The parameter `healthEvents` of this provider.
  List<HealthEvent> get healthEvents;

  /// The parameter `dogDailyStats` of this provider.
  Map<String, List<DogDailyStats>> get dogDailyStats;
}

class _ReliabilityMatrixDataProviderElement
    extends AutoDisposeNotifierProviderElement<ReliabilityMatrixData,
        List<ReliabilityMatrixChartData>> with ReliabilityMatrixDataRef {
  _ReliabilityMatrixDataProviderElement(super.provider);

  @override
  List<Dog> get dogs => (origin as ReliabilityMatrixDataProvider).dogs;
  @override
  StatsDateRange get dateRange =>
      (origin as ReliabilityMatrixDataProvider).dateRange;
  @override
  List<HealthEvent> get healthEvents =>
      (origin as ReliabilityMatrixDataProvider).healthEvents;
  @override
  Map<String, List<DogDailyStats>> get dogDailyStats =>
      (origin as ReliabilityMatrixDataProvider).dogDailyStats;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
