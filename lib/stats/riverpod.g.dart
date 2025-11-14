// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedDateRangeHash() => r'fdfcfaf412b551c01916d44187589078ed712dbd';

/// The date `start` and `end` date selected to be displayed.
/// Start defaults to 30 days ago at midnight (so slightly over 30 days),
/// end defaults to today at 23:59:59.
///
/// Copied from [SelectedDateRange].
@ProviderFor(SelectedDateRange)
final selectedDateRangeProvider =
    AutoDisposeNotifierProvider<SelectedDateRange, DateRangeSelection>.internal(
  SelectedDateRange.new,
  name: r'selectedDateRangeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedDateRangeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDateRange = AutoDisposeNotifier<DateRangeSelection>;
String _$selectedDogsHash() => r'782a6b87c45e0e30fdf7032675cca4e6623a49ac';

/// See also [SelectedDogs].
@ProviderFor(SelectedDogs)
final selectedDogsProvider =
    AutoDisposeNotifierProvider<SelectedDogs, List<Dog>>.internal(
  SelectedDogs.new,
  name: r'selectedDogsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedDogsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDogs = AutoDisposeNotifier<List<Dog>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
