// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userHash() => r'c3161ce3d6b5f77a6ddf8bfcc8411ef3237e22ac';

/// See also [user].
@ProviderFor(user)
final userProvider = StreamProvider<User?>.internal(
  user,
  name: r'userProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRef = StreamProviderRef<User?>;
String _$userNameHash() => r'f55ce80880725b0e816674a03db2671f458744d6';

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

/// This provider streams a user from firestore. Use UID to determine which, or null for self.
/// If it returns null, it couldn't find it.
///
/// Copied from [userName].
@ProviderFor(userName)
const userNameProvider = UserNameFamily();

/// This provider streams a user from firestore. Use UID to determine which, or null for self.
/// If it returns null, it couldn't find it.
///
/// Copied from [userName].
class UserNameFamily extends Family<AsyncValue<UserName?>> {
  /// This provider streams a user from firestore. Use UID to determine which, or null for self.
  /// If it returns null, it couldn't find it.
  ///
  /// Copied from [userName].
  const UserNameFamily();

  /// This provider streams a user from firestore. Use UID to determine which, or null for self.
  /// If it returns null, it couldn't find it.
  ///
  /// Copied from [userName].
  UserNameProvider call(
    String? uid,
  ) {
    return UserNameProvider(
      uid,
    );
  }

  @override
  UserNameProvider getProviderOverride(
    covariant UserNameProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'userNameProvider';
}

/// This provider streams a user from firestore. Use UID to determine which, or null for self.
/// If it returns null, it couldn't find it.
///
/// Copied from [userName].
class UserNameProvider extends StreamProvider<UserName?> {
  /// This provider streams a user from firestore. Use UID to determine which, or null for self.
  /// If it returns null, it couldn't find it.
  ///
  /// Copied from [userName].
  UserNameProvider(
    String? uid,
  ) : this._internal(
          (ref) => userName(
            ref as UserNameRef,
            uid,
          ),
          from: userNameProvider,
          name: r'userNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userNameHash,
          dependencies: UserNameFamily._dependencies,
          allTransitiveDependencies: UserNameFamily._allTransitiveDependencies,
          uid: uid,
        );

  UserNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String? uid;

  @override
  Override overrideWith(
    Stream<UserName?> Function(UserNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserNameProvider._internal(
        (ref) => create(ref as UserNameRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  StreamProviderElement<UserName?> createElement() {
    return _UserNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserNameProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserNameRef on StreamProviderRef<UserName?> {
  /// The parameter `uid` of this provider.
  String? get uid;
}

class _UserNameProviderElement extends StreamProviderElement<UserName?>
    with UserNameRef {
  _UserNameProviderElement(super.provider);

  @override
  String? get uid => (origin as UserNameProvider).uid;
}

String _$accountHash() => r'20726188d6b9c3448024fa63c59930995e7e12da';

/// See also [account].
@ProviderFor(account)
final accountProvider = StreamProvider<String>.internal(
  account,
  name: r'accountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountRef = StreamProviderRef<String>;
String _$settingsHash() => r'725d6da6cc18eb62f275849c1566665f8836e397';

/// See also [settings].
@ProviderFor(settings)
final settingsProvider = StreamProvider<SettingsModel>.internal(
  settings,
  name: r'settingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$settingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsRef = StreamProviderRef<SettingsModel>;
String _$tasksWithExpirationHash() =>
    r'7faa6cebf3795a161779280152a97f01996c98c1';

/// See also [tasksWithExpiration].
@ProviderFor(tasksWithExpiration)
const tasksWithExpirationProvider = TasksWithExpirationFamily();

/// See also [tasksWithExpiration].
class TasksWithExpirationFamily extends Family<AsyncValue<List<Task>>> {
  /// See also [tasksWithExpiration].
  const TasksWithExpirationFamily();

  /// See also [tasksWithExpiration].
  TasksWithExpirationProvider call(
    int? days,
  ) {
    return TasksWithExpirationProvider(
      days,
    );
  }

  @override
  TasksWithExpirationProvider getProviderOverride(
    covariant TasksWithExpirationProvider provider,
  ) {
    return call(
      provider.days,
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
  String? get name => r'tasksWithExpirationProvider';
}

/// See also [tasksWithExpiration].
class TasksWithExpirationProvider extends StreamProvider<List<Task>> {
  /// See also [tasksWithExpiration].
  TasksWithExpirationProvider(
    int? days,
  ) : this._internal(
          (ref) => tasksWithExpiration(
            ref as TasksWithExpirationRef,
            days,
          ),
          from: tasksWithExpirationProvider,
          name: r'tasksWithExpirationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tasksWithExpirationHash,
          dependencies: TasksWithExpirationFamily._dependencies,
          allTransitiveDependencies:
              TasksWithExpirationFamily._allTransitiveDependencies,
          days: days,
        );

  TasksWithExpirationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int? days;

  @override
  Override overrideWith(
    Stream<List<Task>> Function(TasksWithExpirationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TasksWithExpirationProvider._internal(
        (ref) => create(ref as TasksWithExpirationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  StreamProviderElement<List<Task>> createElement() {
    return _TasksWithExpirationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksWithExpirationProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TasksWithExpirationRef on StreamProviderRef<List<Task>> {
  /// The parameter `days` of this provider.
  int? get days;
}

class _TasksWithExpirationProviderElement
    extends StreamProviderElement<List<Task>> with TasksWithExpirationRef {
  _TasksWithExpirationProviderElement(super.provider);

  @override
  int? get days => (origin as TasksWithExpirationProvider).days;
}

String _$tasksNoExpirationHash() => r'ad41a53bf943061bf27eaecf7ca180cf492a8953';

/// See also [tasksNoExpiration].
@ProviderFor(tasksNoExpiration)
final tasksNoExpirationProvider = StreamProvider<List<Task>>.internal(
  tasksNoExpiration,
  name: r'tasksNoExpirationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tasksNoExpirationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TasksNoExpirationRef = StreamProviderRef<List<Task>>;
String _$tasksHash() => r'520468235b613eed5560f2cd8a56adcfbeb25e94';

/// See also [tasks].
@ProviderFor(tasks)
const tasksProvider = TasksFamily();

/// See also [tasks].
class TasksFamily extends Family<AsyncValue<TasksInMemory>> {
  /// See also [tasks].
  const TasksFamily();

  /// See also [tasks].
  TasksProvider call(
    int? days,
  ) {
    return TasksProvider(
      days,
    );
  }

  @override
  TasksProvider getProviderOverride(
    covariant TasksProvider provider,
  ) {
    return call(
      provider.days,
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
  String? get name => r'tasksProvider';
}

/// See also [tasks].
class TasksProvider extends StreamProvider<TasksInMemory> {
  /// See also [tasks].
  TasksProvider(
    int? days,
  ) : this._internal(
          (ref) => tasks(
            ref as TasksRef,
            days,
          ),
          from: tasksProvider,
          name: r'tasksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tasksHash,
          dependencies: TasksFamily._dependencies,
          allTransitiveDependencies: TasksFamily._allTransitiveDependencies,
          days: days,
        );

  TasksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int? days;

  @override
  Override overrideWith(
    Stream<TasksInMemory> Function(TasksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TasksProvider._internal(
        (ref) => create(ref as TasksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  StreamProviderElement<TasksInMemory> createElement() {
    return _TasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TasksRef on StreamProviderRef<TasksInMemory> {
  /// The parameter `days` of this provider.
  int? get days;
}

class _TasksProviderElement extends StreamProviderElement<TasksInMemory>
    with TasksRef {
  _TasksProviderElement(super.provider);

  @override
  int? get days => (origin as TasksProvider).days;
}

String _$dogsHash() => r'25024bf42f1503f765a876964eed096aaddd3f6e';

/// See also [dogs].
@ProviderFor(dogs)
final dogsProvider = StreamProvider<List<Dog>>.internal(
  dogs,
  name: r'dogsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dogsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DogsRef = StreamProviderRef<List<Dog>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
