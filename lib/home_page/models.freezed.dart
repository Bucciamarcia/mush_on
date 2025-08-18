// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomePageRiverpodResults {
  List<Dog> get dogs;
  TasksInMemory get tasks;
  List<HeatCycle> get heatCycles;
  List<HealthEvent> get healthEvents;
  List<WhiteboardElement> get whiteboardElements;

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
            const DeepCollectionEquality().equals(other.dogs, dogs) &&
            (identical(other.tasks, tasks) || other.tasks == tasks) &&
            const DeepCollectionEquality()
                .equals(other.heatCycles, heatCycles) &&
            const DeepCollectionEquality()
                .equals(other.healthEvents, healthEvents) &&
            const DeepCollectionEquality()
                .equals(other.whiteboardElements, whiteboardElements));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(dogs),
      tasks,
      const DeepCollectionEquality().hash(heatCycles),
      const DeepCollectionEquality().hash(healthEvents),
      const DeepCollectionEquality().hash(whiteboardElements));

  @override
  String toString() {
    return 'HomePageRiverpodResults(dogs: $dogs, tasks: $tasks, heatCycles: $heatCycles, healthEvents: $healthEvents, whiteboardElements: $whiteboardElements)';
  }
}

/// @nodoc
abstract mixin class $HomePageRiverpodResultsCopyWith<$Res> {
  factory $HomePageRiverpodResultsCopyWith(HomePageRiverpodResults value,
          $Res Function(HomePageRiverpodResults) _then) =
      _$HomePageRiverpodResultsCopyWithImpl;
  @useResult
  $Res call(
      {List<Dog> dogs,
      TasksInMemory tasks,
      List<HeatCycle> heatCycles,
      List<HealthEvent> healthEvents,
      List<WhiteboardElement> whiteboardElements});

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
    Object? dogs = null,
    Object? tasks = null,
    Object? heatCycles = null,
    Object? healthEvents = null,
    Object? whiteboardElements = null,
  }) {
    return _then(_self.copyWith(
      dogs: null == dogs
          ? _self.dogs
          : dogs // ignore: cast_nullable_to_non_nullable
              as List<Dog>,
      tasks: null == tasks
          ? _self.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as TasksInMemory,
      heatCycles: null == heatCycles
          ? _self.heatCycles
          : heatCycles // ignore: cast_nullable_to_non_nullable
              as List<HeatCycle>,
      healthEvents: null == healthEvents
          ? _self.healthEvents
          : healthEvents // ignore: cast_nullable_to_non_nullable
              as List<HealthEvent>,
      whiteboardElements: null == whiteboardElements
          ? _self.whiteboardElements
          : whiteboardElements // ignore: cast_nullable_to_non_nullable
              as List<WhiteboardElement>,
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
      {required final List<Dog> dogs,
      required this.tasks,
      required final List<HeatCycle> heatCycles,
      required final List<HealthEvent> healthEvents,
      required final List<WhiteboardElement> whiteboardElements})
      : _dogs = dogs,
        _heatCycles = heatCycles,
        _healthEvents = healthEvents,
        _whiteboardElements = whiteboardElements;

  final List<Dog> _dogs;
  @override
  List<Dog> get dogs {
    if (_dogs is EqualUnmodifiableListView) return _dogs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dogs);
  }

  @override
  final TasksInMemory tasks;
  final List<HeatCycle> _heatCycles;
  @override
  List<HeatCycle> get heatCycles {
    if (_heatCycles is EqualUnmodifiableListView) return _heatCycles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_heatCycles);
  }

  final List<HealthEvent> _healthEvents;
  @override
  List<HealthEvent> get healthEvents {
    if (_healthEvents is EqualUnmodifiableListView) return _healthEvents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_healthEvents);
  }

  final List<WhiteboardElement> _whiteboardElements;
  @override
  List<WhiteboardElement> get whiteboardElements {
    if (_whiteboardElements is EqualUnmodifiableListView)
      return _whiteboardElements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_whiteboardElements);
  }

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
            const DeepCollectionEquality().equals(other._dogs, _dogs) &&
            (identical(other.tasks, tasks) || other.tasks == tasks) &&
            const DeepCollectionEquality()
                .equals(other._heatCycles, _heatCycles) &&
            const DeepCollectionEquality()
                .equals(other._healthEvents, _healthEvents) &&
            const DeepCollectionEquality()
                .equals(other._whiteboardElements, _whiteboardElements));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_dogs),
      tasks,
      const DeepCollectionEquality().hash(_heatCycles),
      const DeepCollectionEquality().hash(_healthEvents),
      const DeepCollectionEquality().hash(_whiteboardElements));

  @override
  String toString() {
    return 'HomePageRiverpodResults(dogs: $dogs, tasks: $tasks, heatCycles: $heatCycles, healthEvents: $healthEvents, whiteboardElements: $whiteboardElements)';
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
      {List<Dog> dogs,
      TasksInMemory tasks,
      List<HeatCycle> heatCycles,
      List<HealthEvent> healthEvents,
      List<WhiteboardElement> whiteboardElements});

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
    Object? dogs = null,
    Object? tasks = null,
    Object? heatCycles = null,
    Object? healthEvents = null,
    Object? whiteboardElements = null,
  }) {
    return _then(_HomePageRiverpodResults(
      dogs: null == dogs
          ? _self._dogs
          : dogs // ignore: cast_nullable_to_non_nullable
              as List<Dog>,
      tasks: null == tasks
          ? _self.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as TasksInMemory,
      heatCycles: null == heatCycles
          ? _self._heatCycles
          : heatCycles // ignore: cast_nullable_to_non_nullable
              as List<HeatCycle>,
      healthEvents: null == healthEvents
          ? _self._healthEvents
          : healthEvents // ignore: cast_nullable_to_non_nullable
              as List<HealthEvent>,
      whiteboardElements: null == whiteboardElements
          ? _self._whiteboardElements
          : whiteboardElements // ignore: cast_nullable_to_non_nullable
              as List<WhiteboardElement>,
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
mixin _$WhiteboardElement {
  String get id;
  String get title;
  String get description;
  @NonNullableTimestampConverter()
  DateTime get date;

  /// The user ID of the author
  String? get author;
  List<WhiteboardElementComment> get comments;

  /// Create a copy of WhiteboardElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WhiteboardElementCopyWith<WhiteboardElement> get copyWith =>
      _$WhiteboardElementCopyWithImpl<WhiteboardElement>(
          this as WhiteboardElement, _$identity);

  /// Serializes this WhiteboardElement to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WhiteboardElement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.author, author) || other.author == author) &&
            const DeepCollectionEquality().equals(other.comments, comments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, date,
      author, const DeepCollectionEquality().hash(comments));

  @override
  String toString() {
    return 'WhiteboardElement(id: $id, title: $title, description: $description, date: $date, author: $author, comments: $comments)';
  }
}

/// @nodoc
abstract mixin class $WhiteboardElementCopyWith<$Res> {
  factory $WhiteboardElementCopyWith(
          WhiteboardElement value, $Res Function(WhiteboardElement) _then) =
      _$WhiteboardElementCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      @NonNullableTimestampConverter() DateTime date,
      String? author,
      List<WhiteboardElementComment> comments});
}

/// @nodoc
class _$WhiteboardElementCopyWithImpl<$Res>
    implements $WhiteboardElementCopyWith<$Res> {
  _$WhiteboardElementCopyWithImpl(this._self, this._then);

  final WhiteboardElement _self;
  final $Res Function(WhiteboardElement) _then;

  /// Create a copy of WhiteboardElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? date = null,
    Object? author = freezed,
    Object? comments = null,
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
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      author: freezed == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      comments: null == comments
          ? _self.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<WhiteboardElementComment>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _WhiteboardElement implements WhiteboardElement {
  const _WhiteboardElement(
      {required this.id,
      this.title = "",
      this.description = "",
      @NonNullableTimestampConverter() required this.date,
      this.author,
      final List<WhiteboardElementComment> comments =
          const <WhiteboardElementComment>[]})
      : _comments = comments;
  factory _WhiteboardElement.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardElementFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  @NonNullableTimestampConverter()
  final DateTime date;

  /// The user ID of the author
  @override
  final String? author;
  final List<WhiteboardElementComment> _comments;
  @override
  @JsonKey()
  List<WhiteboardElementComment> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  /// Create a copy of WhiteboardElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WhiteboardElementCopyWith<_WhiteboardElement> get copyWith =>
      __$WhiteboardElementCopyWithImpl<_WhiteboardElement>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WhiteboardElementToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WhiteboardElement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.author, author) || other.author == author) &&
            const DeepCollectionEquality().equals(other._comments, _comments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, date,
      author, const DeepCollectionEquality().hash(_comments));

  @override
  String toString() {
    return 'WhiteboardElement(id: $id, title: $title, description: $description, date: $date, author: $author, comments: $comments)';
  }
}

/// @nodoc
abstract mixin class _$WhiteboardElementCopyWith<$Res>
    implements $WhiteboardElementCopyWith<$Res> {
  factory _$WhiteboardElementCopyWith(
          _WhiteboardElement value, $Res Function(_WhiteboardElement) _then) =
      __$WhiteboardElementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      @NonNullableTimestampConverter() DateTime date,
      String? author,
      List<WhiteboardElementComment> comments});
}

/// @nodoc
class __$WhiteboardElementCopyWithImpl<$Res>
    implements _$WhiteboardElementCopyWith<$Res> {
  __$WhiteboardElementCopyWithImpl(this._self, this._then);

  final _WhiteboardElement _self;
  final $Res Function(_WhiteboardElement) _then;

  /// Create a copy of WhiteboardElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? date = null,
    Object? author = freezed,
    Object? comments = null,
  }) {
    return _then(_WhiteboardElement(
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
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      author: freezed == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      comments: null == comments
          ? _self._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<WhiteboardElementComment>,
    ));
  }
}

/// @nodoc
mixin _$WhiteboardElementComment {
  String get comment;

  /// The user ID of the author
  String? get author;
  @NonNullableTimestampConverter()
  DateTime get date;

  /// Create a copy of WhiteboardElementComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WhiteboardElementCommentCopyWith<WhiteboardElementComment> get copyWith =>
      _$WhiteboardElementCommentCopyWithImpl<WhiteboardElementComment>(
          this as WhiteboardElementComment, _$identity);

  /// Serializes this WhiteboardElementComment to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WhiteboardElementComment &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, comment, author, date);

  @override
  String toString() {
    return 'WhiteboardElementComment(comment: $comment, author: $author, date: $date)';
  }
}

/// @nodoc
abstract mixin class $WhiteboardElementCommentCopyWith<$Res> {
  factory $WhiteboardElementCommentCopyWith(WhiteboardElementComment value,
          $Res Function(WhiteboardElementComment) _then) =
      _$WhiteboardElementCommentCopyWithImpl;
  @useResult
  $Res call(
      {String comment,
      String? author,
      @NonNullableTimestampConverter() DateTime date});
}

/// @nodoc
class _$WhiteboardElementCommentCopyWithImpl<$Res>
    implements $WhiteboardElementCommentCopyWith<$Res> {
  _$WhiteboardElementCommentCopyWithImpl(this._self, this._then);

  final WhiteboardElementComment _self;
  final $Res Function(WhiteboardElementComment) _then;

  /// Create a copy of WhiteboardElementComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comment = null,
    Object? author = freezed,
    Object? date = null,
  }) {
    return _then(_self.copyWith(
      comment: null == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      author: freezed == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _WhiteboardElementComment implements WhiteboardElementComment {
  const _WhiteboardElementComment(
      {this.comment = "",
      this.author,
      @NonNullableTimestampConverter() required this.date});
  factory _WhiteboardElementComment.fromJson(Map<String, dynamic> json) =>
      _$WhiteboardElementCommentFromJson(json);

  @override
  @JsonKey()
  final String comment;

  /// The user ID of the author
  @override
  final String? author;
  @override
  @NonNullableTimestampConverter()
  final DateTime date;

  /// Create a copy of WhiteboardElementComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WhiteboardElementCommentCopyWith<_WhiteboardElementComment> get copyWith =>
      __$WhiteboardElementCommentCopyWithImpl<_WhiteboardElementComment>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WhiteboardElementCommentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WhiteboardElementComment &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, comment, author, date);

  @override
  String toString() {
    return 'WhiteboardElementComment(comment: $comment, author: $author, date: $date)';
  }
}

/// @nodoc
abstract mixin class _$WhiteboardElementCommentCopyWith<$Res>
    implements $WhiteboardElementCommentCopyWith<$Res> {
  factory _$WhiteboardElementCommentCopyWith(_WhiteboardElementComment value,
          $Res Function(_WhiteboardElementComment) _then) =
      __$WhiteboardElementCommentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String comment,
      String? author,
      @NonNullableTimestampConverter() DateTime date});
}

/// @nodoc
class __$WhiteboardElementCommentCopyWithImpl<$Res>
    implements _$WhiteboardElementCommentCopyWith<$Res> {
  __$WhiteboardElementCommentCopyWithImpl(this._self, this._then);

  final _WhiteboardElementComment _self;
  final $Res Function(_WhiteboardElementComment) _then;

  /// Create a copy of WhiteboardElementComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? comment = null,
    Object? author = freezed,
    Object? date = null,
  }) {
    return _then(_WhiteboardElementComment(
      comment: null == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      author: freezed == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
