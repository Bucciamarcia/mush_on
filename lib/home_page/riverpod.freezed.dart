// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'riverpod.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomePageRiverpodResults {
  DogsWithWarnings get dogsWithWarnings;
  List<Dog> get dogs;
  TasksInMemory get tasks;

  /// Create a copy of HomePageRiverpodResults
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomePageRiverpodResultsCopyWith<HomePageRiverpodResults> get copyWith =>
      _$HomePageRiverpodResultsCopyWithImpl<HomePageRiverpodResults>(
          this as HomePageRiverpodResults, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomePageRiverpodResults &&
            (identical(other.dogsWithWarnings, dogsWithWarnings) ||
                other.dogsWithWarnings == dogsWithWarnings) &&
            const DeepCollectionEquality().equals(other.dogs, dogs) &&
            (identical(other.tasks, tasks) || other.tasks == tasks));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dogsWithWarnings,
      const DeepCollectionEquality().hash(dogs), tasks);

  @override
  String toString() {
    return 'HomePageRiverpodResults(dogsWithWarnings: $dogsWithWarnings, dogs: $dogs, tasks: $tasks)';
  }
}

/// @nodoc
abstract mixin class $HomePageRiverpodResultsCopyWith<$Res> {
  factory $HomePageRiverpodResultsCopyWith(HomePageRiverpodResults value,
          $Res Function(HomePageRiverpodResults) _then) =
      _$HomePageRiverpodResultsCopyWithImpl;
  @useResult
  $Res call(
      {DogsWithWarnings dogsWithWarnings, List<Dog> dogs, TasksInMemory tasks});

  $TasksInMemoryCopyWith<$Res> get tasks;
}

/// @nodoc
class _$HomePageRiverpodResultsCopyWithImpl<$Res>
    implements $HomePageRiverpodResultsCopyWith<$Res> {
  _$HomePageRiverpodResultsCopyWithImpl(this._self, this._then);

  final HomePageRiverpodResults _self;
  final $Res Function(HomePageRiverpodResults) _then;

  /// Create a copy of HomePageRiverpodResults
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dogsWithWarnings = null,
    Object? dogs = null,
    Object? tasks = null,
  }) {
    return _then(_self.copyWith(
      dogsWithWarnings: null == dogsWithWarnings
          ? _self.dogsWithWarnings
          : dogsWithWarnings // ignore: cast_nullable_to_non_nullable
              as DogsWithWarnings,
      dogs: null == dogs
          ? _self.dogs
          : dogs // ignore: cast_nullable_to_non_nullable
              as List<Dog>,
      tasks: null == tasks
          ? _self.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as TasksInMemory,
    ));
  }

  /// Create a copy of HomePageRiverpodResults
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TasksInMemoryCopyWith<$Res> get tasks {
    return $TasksInMemoryCopyWith<$Res>(_self.tasks, (value) {
      return _then(_self.copyWith(tasks: value));
    });
  }
}

/// @nodoc

class _HomePageRiverpodResults implements HomePageRiverpodResults {
  const _HomePageRiverpodResults(
      {required this.dogsWithWarnings,
      required final List<Dog> dogs,
      required this.tasks})
      : _dogs = dogs;

  @override
  final DogsWithWarnings dogsWithWarnings;
  final List<Dog> _dogs;
  @override
  List<Dog> get dogs {
    if (_dogs is EqualUnmodifiableListView) return _dogs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dogs);
  }

  @override
  final TasksInMemory tasks;

  /// Create a copy of HomePageRiverpodResults
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomePageRiverpodResultsCopyWith<_HomePageRiverpodResults> get copyWith =>
      __$HomePageRiverpodResultsCopyWithImpl<_HomePageRiverpodResults>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomePageRiverpodResults &&
            (identical(other.dogsWithWarnings, dogsWithWarnings) ||
                other.dogsWithWarnings == dogsWithWarnings) &&
            const DeepCollectionEquality().equals(other._dogs, _dogs) &&
            (identical(other.tasks, tasks) || other.tasks == tasks));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dogsWithWarnings,
      const DeepCollectionEquality().hash(_dogs), tasks);

  @override
  String toString() {
    return 'HomePageRiverpodResults(dogsWithWarnings: $dogsWithWarnings, dogs: $dogs, tasks: $tasks)';
  }
}

/// @nodoc
abstract mixin class _$HomePageRiverpodResultsCopyWith<$Res>
    implements $HomePageRiverpodResultsCopyWith<$Res> {
  factory _$HomePageRiverpodResultsCopyWith(_HomePageRiverpodResults value,
          $Res Function(_HomePageRiverpodResults) _then) =
      __$HomePageRiverpodResultsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DogsWithWarnings dogsWithWarnings, List<Dog> dogs, TasksInMemory tasks});

  @override
  $TasksInMemoryCopyWith<$Res> get tasks;
}

/// @nodoc
class __$HomePageRiverpodResultsCopyWithImpl<$Res>
    implements _$HomePageRiverpodResultsCopyWith<$Res> {
  __$HomePageRiverpodResultsCopyWithImpl(this._self, this._then);

  final _HomePageRiverpodResults _self;
  final $Res Function(_HomePageRiverpodResults) _then;

  /// Create a copy of HomePageRiverpodResults
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dogsWithWarnings = null,
    Object? dogs = null,
    Object? tasks = null,
  }) {
    return _then(_HomePageRiverpodResults(
      dogsWithWarnings: null == dogsWithWarnings
          ? _self.dogsWithWarnings
          : dogsWithWarnings // ignore: cast_nullable_to_non_nullable
              as DogsWithWarnings,
      dogs: null == dogs
          ? _self._dogs
          : dogs // ignore: cast_nullable_to_non_nullable
              as List<Dog>,
      tasks: null == tasks
          ? _self.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as TasksInMemory,
    ));
  }

  /// Create a copy of HomePageRiverpodResults
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TasksInMemoryCopyWith<$Res> get tasks {
    return $TasksInMemoryCopyWith<$Res>(_self.tasks, (value) {
      return _then(_self.copyWith(tasks: value));
    });
  }
}

// dart format on
