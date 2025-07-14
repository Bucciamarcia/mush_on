// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homePageRiverpodHash() => r'f889cf5b9f97157944f9669d6769fa3629e565cc';

/// Just for the home page
///
/// Copied from [homePageRiverpod].
@ProviderFor(homePageRiverpod)
final homePageRiverpodProvider =
    AutoDisposeStreamProvider<HomePageRiverpodResults>.internal(
  homePageRiverpod,
  name: r'homePageRiverpodProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homePageRiverpodHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomePageRiverpodRef
    = AutoDisposeStreamProviderRef<HomePageRiverpodResults>;
String _$todayWhiteboardHash() => r'26d4f795d21262dd3020ee9b63f485269692b2f2';

/// Streams the list of today's whiteboard elements from the db.
///
/// Copied from [todayWhiteboard].
@ProviderFor(todayWhiteboard)
final todayWhiteboardProvider =
    AutoDisposeStreamProvider<List<WhiteboardElement>>.internal(
  todayWhiteboard,
  name: r'todayWhiteboardProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayWhiteboardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayWhiteboardRef
    = AutoDisposeStreamProviderRef<List<WhiteboardElement>>;
String _$dogsWithWarningsHash() => r'9fd0bdff023bde64ad75066400ee2073d4d376ea';

/// Simply returns the dogs with warnigns and errors, no other info.
///
/// Copied from [dogsWithWarnings].
@ProviderFor(dogsWithWarnings)
final dogsWithWarningsProvider =
    AutoDisposeStreamProvider<DogsWithWarnings>.internal(
  dogsWithWarnings,
  name: r'dogsWithWarningsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dogsWithWarningsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DogsWithWarningsRef = AutoDisposeStreamProviderRef<DogsWithWarnings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
