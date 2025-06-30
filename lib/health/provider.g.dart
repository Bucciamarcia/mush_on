// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$healthEventsHash() => r'90067b3960c0a72862e9f2104b07c03d8fa54f1e';

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

/// See also [healthEvents].
@ProviderFor(healthEvents)
const healthEventsProvider = HealthEventsFamily();

/// See also [healthEvents].
class HealthEventsFamily extends Family<AsyncValue<List<HealthEvent>>> {
  /// See also [healthEvents].
  const HealthEventsFamily();

  /// See also [healthEvents].
  HealthEventsProvider call(
    int? cutOff,
  ) {
    return HealthEventsProvider(
      cutOff,
    );
  }

  @override
  HealthEventsProvider getProviderOverride(
    covariant HealthEventsProvider provider,
  ) {
    return call(
      provider.cutOff,
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
  String? get name => r'healthEventsProvider';
}

/// See also [healthEvents].
class HealthEventsProvider
    extends AutoDisposeStreamProvider<List<HealthEvent>> {
  /// See also [healthEvents].
  HealthEventsProvider(
    int? cutOff,
  ) : this._internal(
          (ref) => healthEvents(
            ref as HealthEventsRef,
            cutOff,
          ),
          from: healthEventsProvider,
          name: r'healthEventsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$healthEventsHash,
          dependencies: HealthEventsFamily._dependencies,
          allTransitiveDependencies:
              HealthEventsFamily._allTransitiveDependencies,
          cutOff: cutOff,
        );

  HealthEventsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cutOff,
  }) : super.internal();

  final int? cutOff;

  @override
  Override overrideWith(
    Stream<List<HealthEvent>> Function(HealthEventsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HealthEventsProvider._internal(
        (ref) => create(ref as HealthEventsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cutOff: cutOff,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<HealthEvent>> createElement() {
    return _HealthEventsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HealthEventsProvider && other.cutOff == cutOff;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cutOff.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HealthEventsRef on AutoDisposeStreamProviderRef<List<HealthEvent>> {
  /// The parameter `cutOff` of this provider.
  int? get cutOff;
}

class _HealthEventsProviderElement
    extends AutoDisposeStreamProviderElement<List<HealthEvent>>
    with HealthEventsRef {
  _HealthEventsProviderElement(super.provider);

  @override
  int? get cutOff => (origin as HealthEventsProvider).cutOff;
}

String _$vaccinationsHash() => r'a7ab6336874e6cd34d78c1062aa769991f820a8e';

/// See also [vaccinations].
@ProviderFor(vaccinations)
const vaccinationsProvider = VaccinationsFamily();

/// See also [vaccinations].
class VaccinationsFamily extends Family<AsyncValue<List<Vaccination>>> {
  /// See also [vaccinations].
  const VaccinationsFamily();

  /// See also [vaccinations].
  VaccinationsProvider call(
    int? cutOff,
  ) {
    return VaccinationsProvider(
      cutOff,
    );
  }

  @override
  VaccinationsProvider getProviderOverride(
    covariant VaccinationsProvider provider,
  ) {
    return call(
      provider.cutOff,
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
  String? get name => r'vaccinationsProvider';
}

/// See also [vaccinations].
class VaccinationsProvider
    extends AutoDisposeStreamProvider<List<Vaccination>> {
  /// See also [vaccinations].
  VaccinationsProvider(
    int? cutOff,
  ) : this._internal(
          (ref) => vaccinations(
            ref as VaccinationsRef,
            cutOff,
          ),
          from: vaccinationsProvider,
          name: r'vaccinationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$vaccinationsHash,
          dependencies: VaccinationsFamily._dependencies,
          allTransitiveDependencies:
              VaccinationsFamily._allTransitiveDependencies,
          cutOff: cutOff,
        );

  VaccinationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cutOff,
  }) : super.internal();

  final int? cutOff;

  @override
  Override overrideWith(
    Stream<List<Vaccination>> Function(VaccinationsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VaccinationsProvider._internal(
        (ref) => create(ref as VaccinationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cutOff: cutOff,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Vaccination>> createElement() {
    return _VaccinationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VaccinationsProvider && other.cutOff == cutOff;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cutOff.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VaccinationsRef on AutoDisposeStreamProviderRef<List<Vaccination>> {
  /// The parameter `cutOff` of this provider.
  int? get cutOff;
}

class _VaccinationsProviderElement
    extends AutoDisposeStreamProviderElement<List<Vaccination>>
    with VaccinationsRef {
  _VaccinationsProviderElement(super.provider);

  @override
  int? get cutOff => (origin as VaccinationsProvider).cutOff;
}

String _$heatCyclesHash() => r'ff474e37ba6b500bb78e1289825f088f6e7525fc';

/// See also [heatCycles].
@ProviderFor(heatCycles)
const heatCyclesProvider = HeatCyclesFamily();

/// See also [heatCycles].
class HeatCyclesFamily extends Family<AsyncValue<List<HeatCycle>>> {
  /// See also [heatCycles].
  const HeatCyclesFamily();

  /// See also [heatCycles].
  HeatCyclesProvider call(
    int? cutOff,
  ) {
    return HeatCyclesProvider(
      cutOff,
    );
  }

  @override
  HeatCyclesProvider getProviderOverride(
    covariant HeatCyclesProvider provider,
  ) {
    return call(
      provider.cutOff,
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
  String? get name => r'heatCyclesProvider';
}

/// See also [heatCycles].
class HeatCyclesProvider extends AutoDisposeStreamProvider<List<HeatCycle>> {
  /// See also [heatCycles].
  HeatCyclesProvider(
    int? cutOff,
  ) : this._internal(
          (ref) => heatCycles(
            ref as HeatCyclesRef,
            cutOff,
          ),
          from: heatCyclesProvider,
          name: r'heatCyclesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$heatCyclesHash,
          dependencies: HeatCyclesFamily._dependencies,
          allTransitiveDependencies:
              HeatCyclesFamily._allTransitiveDependencies,
          cutOff: cutOff,
        );

  HeatCyclesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cutOff,
  }) : super.internal();

  final int? cutOff;

  @override
  Override overrideWith(
    Stream<List<HeatCycle>> Function(HeatCyclesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HeatCyclesProvider._internal(
        (ref) => create(ref as HeatCyclesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cutOff: cutOff,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<HeatCycle>> createElement() {
    return _HeatCyclesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HeatCyclesProvider && other.cutOff == cutOff;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cutOff.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HeatCyclesRef on AutoDisposeStreamProviderRef<List<HeatCycle>> {
  /// The parameter `cutOff` of this provider.
  int? get cutOff;
}

class _HeatCyclesProviderElement
    extends AutoDisposeStreamProviderElement<List<HeatCycle>>
    with HeatCyclesRef {
  _HeatCyclesProviderElement(super.provider);

  @override
  int? get cutOff => (origin as HeatCyclesProvider).cutOff;
}

String _$triggerAddhealthEventHash() =>
    r'2cd7c3ea83210a53bb68b27c677d1bd0672ae09f';

/// See also [TriggerAddhealthEvent].
@ProviderFor(TriggerAddhealthEvent)
final triggerAddhealthEventProvider =
    AutoDisposeNotifierProvider<TriggerAddhealthEvent, bool>.internal(
  TriggerAddhealthEvent.new,
  name: r'triggerAddhealthEventProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$triggerAddhealthEventHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TriggerAddhealthEvent = AutoDisposeNotifier<bool>;
String _$triggerAddVaccinationHash() =>
    r'a9c3d1215bb8563ebf851aa527deac93bc7cdbd1';

/// See also [TriggerAddVaccination].
@ProviderFor(TriggerAddVaccination)
final triggerAddVaccinationProvider =
    AutoDisposeNotifierProvider<TriggerAddVaccination, bool>.internal(
  TriggerAddVaccination.new,
  name: r'triggerAddVaccinationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$triggerAddVaccinationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TriggerAddVaccination = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
