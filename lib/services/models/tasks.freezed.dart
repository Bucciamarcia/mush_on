// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tasks.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Task {
  /// The uuid of the task.
  String get id;

  /// The title of the task.
  String get title;

  /// The more lengthy description of the title.
  String get description;

  /// The expiration date of the task (if present).
  @TimestampConverter()
  DateTime? get expiration;

  /// Has the task been completed?
  bool get isDone;

  /// Mark for "all day" task?
  bool get isAllDay;

  /// Is this task urgent?
  bool get isUrgent;

  /// If this is a recurring task, and how often it repeats.
  RecurringType get recurring;

  /// The ID of the dog this task relates to.
  String? get dogId;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TaskCopyWith<Task> get copyWith =>
      _$TaskCopyWithImpl<Task>(this as Task, _$identity);

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Task &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.expiration, expiration) ||
                other.expiration == expiration) &&
            (identical(other.isDone, isDone) || other.isDone == isDone) &&
            (identical(other.isAllDay, isAllDay) ||
                other.isAllDay == isAllDay) &&
            (identical(other.isUrgent, isUrgent) ||
                other.isUrgent == isUrgent) &&
            (identical(other.recurring, recurring) ||
                other.recurring == recurring) &&
            (identical(other.dogId, dogId) || other.dogId == dogId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description,
      expiration, isDone, isAllDay, isUrgent, recurring, dogId);

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, expiration: $expiration, isDone: $isDone, isAllDay: $isAllDay, isUrgent: $isUrgent, recurring: $recurring, dogId: $dogId)';
  }
}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) =
      _$TaskCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      @TimestampConverter() DateTime? expiration,
      bool isDone,
      bool isAllDay,
      bool isUrgent,
      RecurringType recurring,
      String? dogId});
}

/// @nodoc
class _$TaskCopyWithImpl<$Res> implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? expiration = freezed,
    Object? isDone = null,
    Object? isAllDay = null,
    Object? isUrgent = null,
    Object? recurring = null,
    Object? dogId = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      expiration: freezed == expiration
          ? _self.expiration
          : expiration // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDone: null == isDone
          ? _self.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
      isAllDay: null == isAllDay
          ? _self.isAllDay
          : isAllDay // ignore: cast_nullable_to_non_nullable
              as bool,
      isUrgent: null == isUrgent
          ? _self.isUrgent
          : isUrgent // ignore: cast_nullable_to_non_nullable
              as bool,
      recurring: null == recurring
          ? _self.recurring
          : recurring // ignore: cast_nullable_to_non_nullable
              as RecurringType,
      dogId: freezed == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Task implements Task {
  const _Task(
      {this.id = "",
      this.title = "",
      this.description = "",
      @TimestampConverter() this.expiration,
      this.isDone = false,
      this.isAllDay = true,
      this.isUrgent = false,
      this.recurring = RecurringType.none,
      this.dogId});
  factory _Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  /// The uuid of the task.
  @override
  @JsonKey()
  final String id;

  /// The title of the task.
  @override
  @JsonKey()
  final String title;

  /// The more lengthy description of the title.
  @override
  @JsonKey()
  final String description;

  /// The expiration date of the task (if present).
  @override
  @TimestampConverter()
  final DateTime? expiration;

  /// Has the task been completed?
  @override
  @JsonKey()
  final bool isDone;

  /// Mark for "all day" task?
  @override
  @JsonKey()
  final bool isAllDay;

  /// Is this task urgent?
  @override
  @JsonKey()
  final bool isUrgent;

  /// If this is a recurring task, and how often it repeats.
  @override
  @JsonKey()
  final RecurringType recurring;

  /// The ID of the dog this task relates to.
  @override
  final String? dogId;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TaskCopyWith<_Task> get copyWith =>
      __$TaskCopyWithImpl<_Task>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TaskToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Task &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.expiration, expiration) ||
                other.expiration == expiration) &&
            (identical(other.isDone, isDone) || other.isDone == isDone) &&
            (identical(other.isAllDay, isAllDay) ||
                other.isAllDay == isAllDay) &&
            (identical(other.isUrgent, isUrgent) ||
                other.isUrgent == isUrgent) &&
            (identical(other.recurring, recurring) ||
                other.recurring == recurring) &&
            (identical(other.dogId, dogId) || other.dogId == dogId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description,
      expiration, isDone, isAllDay, isUrgent, recurring, dogId);

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, expiration: $expiration, isDone: $isDone, isAllDay: $isAllDay, isUrgent: $isUrgent, recurring: $recurring, dogId: $dogId)';
  }
}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) =
      __$TaskCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      @TimestampConverter() DateTime? expiration,
      bool isDone,
      bool isAllDay,
      bool isUrgent,
      RecurringType recurring,
      String? dogId});
}

/// @nodoc
class __$TaskCopyWithImpl<$Res> implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? expiration = freezed,
    Object? isDone = null,
    Object? isAllDay = null,
    Object? isUrgent = null,
    Object? recurring = null,
    Object? dogId = freezed,
  }) {
    return _then(_Task(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      expiration: freezed == expiration
          ? _self.expiration
          : expiration // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDone: null == isDone
          ? _self.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
      isAllDay: null == isAllDay
          ? _self.isAllDay
          : isAllDay // ignore: cast_nullable_to_non_nullable
              as bool,
      isUrgent: null == isUrgent
          ? _self.isUrgent
          : isUrgent // ignore: cast_nullable_to_non_nullable
              as bool,
      recurring: null == recurring
          ? _self.recurring
          : recurring // ignore: cast_nullable_to_non_nullable
              as RecurringType,
      dogId: freezed == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$TasksInMemory {
  /// The list of tasks
  List<Task> get tasks;

  /// The oldest expiration fetched. Null if fetched from the beginning.
  DateTime? get oldestFetched;

  /// The newest expiration fetched (also in the future). Null if fetched until the end.
  DateTime? get newestFetched;

  /// Have the tasks with no expiration been fetched?
  bool get noExpirationFetched;

  /// Create a copy of TasksInMemory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TasksInMemoryCopyWith<TasksInMemory> get copyWith =>
      _$TasksInMemoryCopyWithImpl<TasksInMemory>(
          this as TasksInMemory, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TasksInMemory &&
            const DeepCollectionEquality().equals(other.tasks, tasks) &&
            (identical(other.oldestFetched, oldestFetched) ||
                other.oldestFetched == oldestFetched) &&
            (identical(other.newestFetched, newestFetched) ||
                other.newestFetched == newestFetched) &&
            (identical(other.noExpirationFetched, noExpirationFetched) ||
                other.noExpirationFetched == noExpirationFetched));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(tasks),
      oldestFetched,
      newestFetched,
      noExpirationFetched);

  @override
  String toString() {
    return 'TasksInMemory(tasks: $tasks, oldestFetched: $oldestFetched, newestFetched: $newestFetched, noExpirationFetched: $noExpirationFetched)';
  }
}

/// @nodoc
abstract mixin class $TasksInMemoryCopyWith<$Res> {
  factory $TasksInMemoryCopyWith(
          TasksInMemory value, $Res Function(TasksInMemory) _then) =
      _$TasksInMemoryCopyWithImpl;
  @useResult
  $Res call(
      {List<Task> tasks,
      DateTime? oldestFetched,
      DateTime? newestFetched,
      bool noExpirationFetched});
}

/// @nodoc
class _$TasksInMemoryCopyWithImpl<$Res>
    implements $TasksInMemoryCopyWith<$Res> {
  _$TasksInMemoryCopyWithImpl(this._self, this._then);

  final TasksInMemory _self;
  final $Res Function(TasksInMemory) _then;

  /// Create a copy of TasksInMemory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
    Object? oldestFetched = freezed,
    Object? newestFetched = freezed,
    Object? noExpirationFetched = null,
  }) {
    return _then(_self.copyWith(
      tasks: null == tasks
          ? _self.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
      oldestFetched: freezed == oldestFetched
          ? _self.oldestFetched
          : oldestFetched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      newestFetched: freezed == newestFetched
          ? _self.newestFetched
          : newestFetched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      noExpirationFetched: null == noExpirationFetched
          ? _self.noExpirationFetched
          : noExpirationFetched // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _TasksInMemory implements TasksInMemory {
  const _TasksInMemory(
      {final List<Task> tasks = const <Task>[],
      this.oldestFetched,
      this.newestFetched,
      this.noExpirationFetched = false})
      : _tasks = tasks;

  /// The list of tasks
  final List<Task> _tasks;

  /// The list of tasks
  @override
  @JsonKey()
  List<Task> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  /// The oldest expiration fetched. Null if fetched from the beginning.
  @override
  final DateTime? oldestFetched;

  /// The newest expiration fetched (also in the future). Null if fetched until the end.
  @override
  final DateTime? newestFetched;

  /// Have the tasks with no expiration been fetched?
  @override
  @JsonKey()
  final bool noExpirationFetched;

  /// Create a copy of TasksInMemory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TasksInMemoryCopyWith<_TasksInMemory> get copyWith =>
      __$TasksInMemoryCopyWithImpl<_TasksInMemory>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TasksInMemory &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            (identical(other.oldestFetched, oldestFetched) ||
                other.oldestFetched == oldestFetched) &&
            (identical(other.newestFetched, newestFetched) ||
                other.newestFetched == newestFetched) &&
            (identical(other.noExpirationFetched, noExpirationFetched) ||
                other.noExpirationFetched == noExpirationFetched));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tasks),
      oldestFetched,
      newestFetched,
      noExpirationFetched);

  @override
  String toString() {
    return 'TasksInMemory(tasks: $tasks, oldestFetched: $oldestFetched, newestFetched: $newestFetched, noExpirationFetched: $noExpirationFetched)';
  }
}

/// @nodoc
abstract mixin class _$TasksInMemoryCopyWith<$Res>
    implements $TasksInMemoryCopyWith<$Res> {
  factory _$TasksInMemoryCopyWith(
          _TasksInMemory value, $Res Function(_TasksInMemory) _then) =
      __$TasksInMemoryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Task> tasks,
      DateTime? oldestFetched,
      DateTime? newestFetched,
      bool noExpirationFetched});
}

/// @nodoc
class __$TasksInMemoryCopyWithImpl<$Res>
    implements _$TasksInMemoryCopyWith<$Res> {
  __$TasksInMemoryCopyWithImpl(this._self, this._then);

  final _TasksInMemory _self;
  final $Res Function(_TasksInMemory) _then;

  /// Create a copy of TasksInMemory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tasks = null,
    Object? oldestFetched = freezed,
    Object? newestFetched = freezed,
    Object? noExpirationFetched = null,
  }) {
    return _then(_TasksInMemory(
      tasks: null == tasks
          ? _self._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
      oldestFetched: freezed == oldestFetched
          ? _self.oldestFetched
          : oldestFetched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      newestFetched: freezed == newestFetched
          ? _self.newestFetched
          : newestFetched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      noExpirationFetched: null == noExpirationFetched
          ? _self.noExpirationFetched
          : noExpirationFetched // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
