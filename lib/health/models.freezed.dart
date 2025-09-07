// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthEvent {
  /// Unique uuid of this event
  String get id;

  /// The dog associated with this event
  String get dogId;

  /// When the event was created initially
  @NonNullableTimestampConverter()
  DateTime get createdAt;

  /// When the event was last updated.
  @NonNullableTimestampConverter()
  DateTime get lastUpdated;

  /// The title of the event
  String get title;

  /// The date of this event
  @TimestampConverter()
  DateTime get date;

  /// When the event was solved. If null, still ongoing.
  /// If == date, it's a one shot event.
  @TimestampConverter()
  DateTime? get resolvedDate;

  /// Does this health event prevent the dog from running?
  bool get preventFromRunning;

  /// Other notes for this event
  String get notes;

  /// The type of this event (enum)
  HealthEventType get eventType;

  /// Document paths related to this event
  List<String> get documentIds;

  /// Create a copy of HealthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HealthEventCopyWith<HealthEvent> get copyWith =>
      _$HealthEventCopyWithImpl<HealthEvent>(this as HealthEvent, _$identity);

  /// Serializes this HealthEvent to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HealthEvent &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dogId, dogId) || other.dogId == dogId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.resolvedDate, resolvedDate) ||
                other.resolvedDate == resolvedDate) &&
            (identical(other.preventFromRunning, preventFromRunning) ||
                other.preventFromRunning == preventFromRunning) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            const DeepCollectionEquality()
                .equals(other.documentIds, documentIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      dogId,
      createdAt,
      lastUpdated,
      title,
      date,
      resolvedDate,
      preventFromRunning,
      notes,
      eventType,
      const DeepCollectionEquality().hash(documentIds));

  @override
  String toString() {
    return 'HealthEvent(id: $id, dogId: $dogId, createdAt: $createdAt, lastUpdated: $lastUpdated, title: $title, date: $date, resolvedDate: $resolvedDate, preventFromRunning: $preventFromRunning, notes: $notes, eventType: $eventType, documentIds: $documentIds)';
  }
}

/// @nodoc
abstract mixin class $HealthEventCopyWith<$Res> {
  factory $HealthEventCopyWith(
          HealthEvent value, $Res Function(HealthEvent) _then) =
      _$HealthEventCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String dogId,
      @NonNullableTimestampConverter() DateTime createdAt,
      @NonNullableTimestampConverter() DateTime lastUpdated,
      String title,
      @TimestampConverter() DateTime date,
      @TimestampConverter() DateTime? resolvedDate,
      bool preventFromRunning,
      String notes,
      HealthEventType eventType,
      List<String> documentIds});
}

/// @nodoc
class _$HealthEventCopyWithImpl<$Res> implements $HealthEventCopyWith<$Res> {
  _$HealthEventCopyWithImpl(this._self, this._then);

  final HealthEvent _self;
  final $Res Function(HealthEvent) _then;

  /// Create a copy of HealthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dogId = null,
    Object? createdAt = null,
    Object? lastUpdated = null,
    Object? title = null,
    Object? date = null,
    Object? resolvedDate = freezed,
    Object? preventFromRunning = null,
    Object? notes = null,
    Object? eventType = null,
    Object? documentIds = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dogId: null == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      resolvedDate: freezed == resolvedDate
          ? _self.resolvedDate
          : resolvedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preventFromRunning: null == preventFromRunning
          ? _self.preventFromRunning
          : preventFromRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _self.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as HealthEventType,
      documentIds: null == documentIds
          ? _self.documentIds
          : documentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [HealthEvent].
extension HealthEventPatterns on HealthEvent {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HealthEvent value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HealthEvent() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HealthEvent value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthEvent():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HealthEvent value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthEvent() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String dogId,
            @NonNullableTimestampConverter() DateTime createdAt,
            @NonNullableTimestampConverter() DateTime lastUpdated,
            String title,
            @TimestampConverter() DateTime date,
            @TimestampConverter() DateTime? resolvedDate,
            bool preventFromRunning,
            String notes,
            HealthEventType eventType,
            List<String> documentIds)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HealthEvent() when $default != null:
        return $default(
            _that.id,
            _that.dogId,
            _that.createdAt,
            _that.lastUpdated,
            _that.title,
            _that.date,
            _that.resolvedDate,
            _that.preventFromRunning,
            _that.notes,
            _that.eventType,
            _that.documentIds);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String dogId,
            @NonNullableTimestampConverter() DateTime createdAt,
            @NonNullableTimestampConverter() DateTime lastUpdated,
            String title,
            @TimestampConverter() DateTime date,
            @TimestampConverter() DateTime? resolvedDate,
            bool preventFromRunning,
            String notes,
            HealthEventType eventType,
            List<String> documentIds)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthEvent():
        return $default(
            _that.id,
            _that.dogId,
            _that.createdAt,
            _that.lastUpdated,
            _that.title,
            _that.date,
            _that.resolvedDate,
            _that.preventFromRunning,
            _that.notes,
            _that.eventType,
            _that.documentIds);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String dogId,
            @NonNullableTimestampConverter() DateTime createdAt,
            @NonNullableTimestampConverter() DateTime lastUpdated,
            String title,
            @TimestampConverter() DateTime date,
            @TimestampConverter() DateTime? resolvedDate,
            bool preventFromRunning,
            String notes,
            HealthEventType eventType,
            List<String> documentIds)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HealthEvent() when $default != null:
        return $default(
            _that.id,
            _that.dogId,
            _that.createdAt,
            _that.lastUpdated,
            _that.title,
            _that.date,
            _that.resolvedDate,
            _that.preventFromRunning,
            _that.notes,
            _that.eventType,
            _that.documentIds);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _HealthEvent implements HealthEvent {
  const _HealthEvent(
      {required this.id,
      required this.dogId,
      @NonNullableTimestampConverter() required this.createdAt,
      @NonNullableTimestampConverter() required this.lastUpdated,
      required this.title,
      @TimestampConverter() required this.date,
      @TimestampConverter() this.resolvedDate,
      this.preventFromRunning = false,
      this.notes = "",
      this.eventType = HealthEventType.observation,
      final List<String> documentIds = const []})
      : _documentIds = documentIds;
  factory _HealthEvent.fromJson(Map<String, dynamic> json) =>
      _$HealthEventFromJson(json);

  /// Unique uuid of this event
  @override
  final String id;

  /// The dog associated with this event
  @override
  final String dogId;

  /// When the event was created initially
  @override
  @NonNullableTimestampConverter()
  final DateTime createdAt;

  /// When the event was last updated.
  @override
  @NonNullableTimestampConverter()
  final DateTime lastUpdated;

  /// The title of the event
  @override
  final String title;

  /// The date of this event
  @override
  @TimestampConverter()
  final DateTime date;

  /// When the event was solved. If null, still ongoing.
  /// If == date, it's a one shot event.
  @override
  @TimestampConverter()
  final DateTime? resolvedDate;

  /// Does this health event prevent the dog from running?
  @override
  @JsonKey()
  final bool preventFromRunning;

  /// Other notes for this event
  @override
  @JsonKey()
  final String notes;

  /// The type of this event (enum)
  @override
  @JsonKey()
  final HealthEventType eventType;

  /// Document paths related to this event
  final List<String> _documentIds;

  /// Document paths related to this event
  @override
  @JsonKey()
  List<String> get documentIds {
    if (_documentIds is EqualUnmodifiableListView) return _documentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documentIds);
  }

  /// Create a copy of HealthEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HealthEventCopyWith<_HealthEvent> get copyWith =>
      __$HealthEventCopyWithImpl<_HealthEvent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HealthEventToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HealthEvent &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dogId, dogId) || other.dogId == dogId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.resolvedDate, resolvedDate) ||
                other.resolvedDate == resolvedDate) &&
            (identical(other.preventFromRunning, preventFromRunning) ||
                other.preventFromRunning == preventFromRunning) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            const DeepCollectionEquality()
                .equals(other._documentIds, _documentIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      dogId,
      createdAt,
      lastUpdated,
      title,
      date,
      resolvedDate,
      preventFromRunning,
      notes,
      eventType,
      const DeepCollectionEquality().hash(_documentIds));

  @override
  String toString() {
    return 'HealthEvent(id: $id, dogId: $dogId, createdAt: $createdAt, lastUpdated: $lastUpdated, title: $title, date: $date, resolvedDate: $resolvedDate, preventFromRunning: $preventFromRunning, notes: $notes, eventType: $eventType, documentIds: $documentIds)';
  }
}

/// @nodoc
abstract mixin class _$HealthEventCopyWith<$Res>
    implements $HealthEventCopyWith<$Res> {
  factory _$HealthEventCopyWith(
          _HealthEvent value, $Res Function(_HealthEvent) _then) =
      __$HealthEventCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String dogId,
      @NonNullableTimestampConverter() DateTime createdAt,
      @NonNullableTimestampConverter() DateTime lastUpdated,
      String title,
      @TimestampConverter() DateTime date,
      @TimestampConverter() DateTime? resolvedDate,
      bool preventFromRunning,
      String notes,
      HealthEventType eventType,
      List<String> documentIds});
}

/// @nodoc
class __$HealthEventCopyWithImpl<$Res> implements _$HealthEventCopyWith<$Res> {
  __$HealthEventCopyWithImpl(this._self, this._then);

  final _HealthEvent _self;
  final $Res Function(_HealthEvent) _then;

  /// Create a copy of HealthEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? dogId = null,
    Object? createdAt = null,
    Object? lastUpdated = null,
    Object? title = null,
    Object? date = null,
    Object? resolvedDate = freezed,
    Object? preventFromRunning = null,
    Object? notes = null,
    Object? eventType = null,
    Object? documentIds = null,
  }) {
    return _then(_HealthEvent(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dogId: null == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      resolvedDate: freezed == resolvedDate
          ? _self.resolvedDate
          : resolvedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preventFromRunning: null == preventFromRunning
          ? _self.preventFromRunning
          : preventFromRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _self.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as HealthEventType,
      documentIds: null == documentIds
          ? _self._documentIds
          : documentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
mixin _$Vaccination {
  /// The unique uuid of the vaccination
  String get id;

  /// The dog's id associated with this vaccination
  String get dogId;

  /// When the event was created initially
  @NonNullableTimestampConverter()
  DateTime get createdAt;

  /// When the event was last updated.
  @NonNullableTimestampConverter()
  DateTime get lastUpdated;

  /// When the vaccination was administered
  @NonNullableTimestampConverter()
  DateTime get dateAdministered;

  /// When this vaccination expires
  @TimestampConverter()
  DateTime? get expirationDate;

  /// The ids of the documents related to the vaccination
  List<String> get documentIds;

  /// The custom title of this vaccination.
  String get title;

  /// Some custom notes for the vaccination.
  String get notes;

  /// The type of vaccination (eg. "rabies")
  String get vaccinationType;

  /// Create a copy of Vaccination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VaccinationCopyWith<Vaccination> get copyWith =>
      _$VaccinationCopyWithImpl<Vaccination>(this as Vaccination, _$identity);

  /// Serializes this Vaccination to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Vaccination &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dogId, dogId) || other.dogId == dogId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.dateAdministered, dateAdministered) ||
                other.dateAdministered == dateAdministered) &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            const DeepCollectionEquality()
                .equals(other.documentIds, documentIds) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.vaccinationType, vaccinationType) ||
                other.vaccinationType == vaccinationType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      dogId,
      createdAt,
      lastUpdated,
      dateAdministered,
      expirationDate,
      const DeepCollectionEquality().hash(documentIds),
      title,
      notes,
      vaccinationType);

  @override
  String toString() {
    return 'Vaccination(id: $id, dogId: $dogId, createdAt: $createdAt, lastUpdated: $lastUpdated, dateAdministered: $dateAdministered, expirationDate: $expirationDate, documentIds: $documentIds, title: $title, notes: $notes, vaccinationType: $vaccinationType)';
  }
}

/// @nodoc
abstract mixin class $VaccinationCopyWith<$Res> {
  factory $VaccinationCopyWith(
          Vaccination value, $Res Function(Vaccination) _then) =
      _$VaccinationCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String dogId,
      @NonNullableTimestampConverter() DateTime createdAt,
      @NonNullableTimestampConverter() DateTime lastUpdated,
      @NonNullableTimestampConverter() DateTime dateAdministered,
      @TimestampConverter() DateTime? expirationDate,
      List<String> documentIds,
      String title,
      String notes,
      String vaccinationType});
}

/// @nodoc
class _$VaccinationCopyWithImpl<$Res> implements $VaccinationCopyWith<$Res> {
  _$VaccinationCopyWithImpl(this._self, this._then);

  final Vaccination _self;
  final $Res Function(Vaccination) _then;

  /// Create a copy of Vaccination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dogId = null,
    Object? createdAt = null,
    Object? lastUpdated = null,
    Object? dateAdministered = null,
    Object? expirationDate = freezed,
    Object? documentIds = null,
    Object? title = null,
    Object? notes = null,
    Object? vaccinationType = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dogId: null == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateAdministered: null == dateAdministered
          ? _self.dateAdministered
          : dateAdministered // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expirationDate: freezed == expirationDate
          ? _self.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      documentIds: null == documentIds
          ? _self.documentIds
          : documentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      vaccinationType: null == vaccinationType
          ? _self.vaccinationType
          : vaccinationType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [Vaccination].
extension VaccinationPatterns on Vaccination {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Vaccination value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Vaccination() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Vaccination value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Vaccination():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Vaccination value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Vaccination() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String dogId,
            @NonNullableTimestampConverter() DateTime createdAt,
            @NonNullableTimestampConverter() DateTime lastUpdated,
            @NonNullableTimestampConverter() DateTime dateAdministered,
            @TimestampConverter() DateTime? expirationDate,
            List<String> documentIds,
            String title,
            String notes,
            String vaccinationType)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Vaccination() when $default != null:
        return $default(
            _that.id,
            _that.dogId,
            _that.createdAt,
            _that.lastUpdated,
            _that.dateAdministered,
            _that.expirationDate,
            _that.documentIds,
            _that.title,
            _that.notes,
            _that.vaccinationType);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String dogId,
            @NonNullableTimestampConverter() DateTime createdAt,
            @NonNullableTimestampConverter() DateTime lastUpdated,
            @NonNullableTimestampConverter() DateTime dateAdministered,
            @TimestampConverter() DateTime? expirationDate,
            List<String> documentIds,
            String title,
            String notes,
            String vaccinationType)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Vaccination():
        return $default(
            _that.id,
            _that.dogId,
            _that.createdAt,
            _that.lastUpdated,
            _that.dateAdministered,
            _that.expirationDate,
            _that.documentIds,
            _that.title,
            _that.notes,
            _that.vaccinationType);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String dogId,
            @NonNullableTimestampConverter() DateTime createdAt,
            @NonNullableTimestampConverter() DateTime lastUpdated,
            @NonNullableTimestampConverter() DateTime dateAdministered,
            @TimestampConverter() DateTime? expirationDate,
            List<String> documentIds,
            String title,
            String notes,
            String vaccinationType)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Vaccination() when $default != null:
        return $default(
            _that.id,
            _that.dogId,
            _that.createdAt,
            _that.lastUpdated,
            _that.dateAdministered,
            _that.expirationDate,
            _that.documentIds,
            _that.title,
            _that.notes,
            _that.vaccinationType);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Vaccination implements Vaccination {
  const _Vaccination(
      {required this.id,
      required this.dogId,
      @NonNullableTimestampConverter() required this.createdAt,
      @NonNullableTimestampConverter() required this.lastUpdated,
      @NonNullableTimestampConverter() required this.dateAdministered,
      @TimestampConverter() this.expirationDate,
      final List<String> documentIds = const [],
      required this.title,
      this.notes = "",
      required this.vaccinationType})
      : _documentIds = documentIds;
  factory _Vaccination.fromJson(Map<String, dynamic> json) =>
      _$VaccinationFromJson(json);

  /// The unique uuid of the vaccination
  @override
  final String id;

  /// The dog's id associated with this vaccination
  @override
  final String dogId;

  /// When the event was created initially
  @override
  @NonNullableTimestampConverter()
  final DateTime createdAt;

  /// When the event was last updated.
  @override
  @NonNullableTimestampConverter()
  final DateTime lastUpdated;

  /// When the vaccination was administered
  @override
  @NonNullableTimestampConverter()
  final DateTime dateAdministered;

  /// When this vaccination expires
  @override
  @TimestampConverter()
  final DateTime? expirationDate;

  /// The ids of the documents related to the vaccination
  final List<String> _documentIds;

  /// The ids of the documents related to the vaccination
  @override
  @JsonKey()
  List<String> get documentIds {
    if (_documentIds is EqualUnmodifiableListView) return _documentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documentIds);
  }

  /// The custom title of this vaccination.
  @override
  final String title;

  /// Some custom notes for the vaccination.
  @override
  @JsonKey()
  final String notes;

  /// The type of vaccination (eg. "rabies")
  @override
  final String vaccinationType;

  /// Create a copy of Vaccination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VaccinationCopyWith<_Vaccination> get copyWith =>
      __$VaccinationCopyWithImpl<_Vaccination>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VaccinationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Vaccination &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dogId, dogId) || other.dogId == dogId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.dateAdministered, dateAdministered) ||
                other.dateAdministered == dateAdministered) &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            const DeepCollectionEquality()
                .equals(other._documentIds, _documentIds) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.vaccinationType, vaccinationType) ||
                other.vaccinationType == vaccinationType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      dogId,
      createdAt,
      lastUpdated,
      dateAdministered,
      expirationDate,
      const DeepCollectionEquality().hash(_documentIds),
      title,
      notes,
      vaccinationType);

  @override
  String toString() {
    return 'Vaccination(id: $id, dogId: $dogId, createdAt: $createdAt, lastUpdated: $lastUpdated, dateAdministered: $dateAdministered, expirationDate: $expirationDate, documentIds: $documentIds, title: $title, notes: $notes, vaccinationType: $vaccinationType)';
  }
}

/// @nodoc
abstract mixin class _$VaccinationCopyWith<$Res>
    implements $VaccinationCopyWith<$Res> {
  factory _$VaccinationCopyWith(
          _Vaccination value, $Res Function(_Vaccination) _then) =
      __$VaccinationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String dogId,
      @NonNullableTimestampConverter() DateTime createdAt,
      @NonNullableTimestampConverter() DateTime lastUpdated,
      @NonNullableTimestampConverter() DateTime dateAdministered,
      @TimestampConverter() DateTime? expirationDate,
      List<String> documentIds,
      String title,
      String notes,
      String vaccinationType});
}

/// @nodoc
class __$VaccinationCopyWithImpl<$Res> implements _$VaccinationCopyWith<$Res> {
  __$VaccinationCopyWithImpl(this._self, this._then);

  final _Vaccination _self;
  final $Res Function(_Vaccination) _then;

  /// Create a copy of Vaccination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? dogId = null,
    Object? createdAt = null,
    Object? lastUpdated = null,
    Object? dateAdministered = null,
    Object? expirationDate = freezed,
    Object? documentIds = null,
    Object? title = null,
    Object? notes = null,
    Object? vaccinationType = null,
  }) {
    return _then(_Vaccination(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dogId: null == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateAdministered: null == dateAdministered
          ? _self.dateAdministered
          : dateAdministered // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expirationDate: freezed == expirationDate
          ? _self.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      documentIds: null == documentIds
          ? _self._documentIds
          : documentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      vaccinationType: null == vaccinationType
          ? _self.vaccinationType
          : vaccinationType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$HeatCycle {
  /// The unique id of this heat event.
  String get id;

  /// The dog's id associated with this heat event.
  String get dogId;

  /// Notes regarding this heat.
  String get notes;

  /// Heat started date
  @NonNullableTimestampConverter()
  DateTime get startDate;

  /// When the event was created initially
  @NonNullableTimestampConverter()
  DateTime get createdAt;

  /// When the event was last updated.
  @NonNullableTimestampConverter()
  DateTime get lastUpdated;

  /// This heat prevents the dog from running
  bool get preventFromRunning;

  /// When it finished. If null, still ongoing.
  @TimestampConverter()
  DateTime? get endDate;

  /// Create a copy of HeatCycle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HeatCycleCopyWith<HeatCycle> get copyWith =>
      _$HeatCycleCopyWithImpl<HeatCycle>(this as HeatCycle, _$identity);

  /// Serializes this HeatCycle to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HeatCycle &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dogId, dogId) || other.dogId == dogId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.preventFromRunning, preventFromRunning) ||
                other.preventFromRunning == preventFromRunning) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, dogId, notes, startDate,
      createdAt, lastUpdated, preventFromRunning, endDate);

  @override
  String toString() {
    return 'HeatCycle(id: $id, dogId: $dogId, notes: $notes, startDate: $startDate, createdAt: $createdAt, lastUpdated: $lastUpdated, preventFromRunning: $preventFromRunning, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class $HeatCycleCopyWith<$Res> {
  factory $HeatCycleCopyWith(HeatCycle value, $Res Function(HeatCycle) _then) =
      _$HeatCycleCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String dogId,
      String notes,
      @NonNullableTimestampConverter() DateTime startDate,
      @NonNullableTimestampConverter() DateTime createdAt,
      @NonNullableTimestampConverter() DateTime lastUpdated,
      bool preventFromRunning,
      @TimestampConverter() DateTime? endDate});
}

/// @nodoc
class _$HeatCycleCopyWithImpl<$Res> implements $HeatCycleCopyWith<$Res> {
  _$HeatCycleCopyWithImpl(this._self, this._then);

  final HeatCycle _self;
  final $Res Function(HeatCycle) _then;

  /// Create a copy of HeatCycle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dogId = null,
    Object? notes = null,
    Object? startDate = null,
    Object? createdAt = null,
    Object? lastUpdated = null,
    Object? preventFromRunning = null,
    Object? endDate = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dogId: null == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      preventFromRunning: null == preventFromRunning
          ? _self.preventFromRunning
          : preventFromRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [HeatCycle].
extension HeatCyclePatterns on HeatCycle {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HeatCycle value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeatCycle() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HeatCycle value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatCycle():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HeatCycle value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatCycle() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String dogId,
            String notes,
            @NonNullableTimestampConverter() DateTime startDate,
            @NonNullableTimestampConverter() DateTime createdAt,
            @NonNullableTimestampConverter() DateTime lastUpdated,
            bool preventFromRunning,
            @TimestampConverter() DateTime? endDate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HeatCycle() when $default != null:
        return $default(
            _that.id,
            _that.dogId,
            _that.notes,
            _that.startDate,
            _that.createdAt,
            _that.lastUpdated,
            _that.preventFromRunning,
            _that.endDate);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String dogId,
            String notes,
            @NonNullableTimestampConverter() DateTime startDate,
            @NonNullableTimestampConverter() DateTime createdAt,
            @NonNullableTimestampConverter() DateTime lastUpdated,
            bool preventFromRunning,
            @TimestampConverter() DateTime? endDate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatCycle():
        return $default(
            _that.id,
            _that.dogId,
            _that.notes,
            _that.startDate,
            _that.createdAt,
            _that.lastUpdated,
            _that.preventFromRunning,
            _that.endDate);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String dogId,
            String notes,
            @NonNullableTimestampConverter() DateTime startDate,
            @NonNullableTimestampConverter() DateTime createdAt,
            @NonNullableTimestampConverter() DateTime lastUpdated,
            bool preventFromRunning,
            @TimestampConverter() DateTime? endDate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HeatCycle() when $default != null:
        return $default(
            _that.id,
            _that.dogId,
            _that.notes,
            _that.startDate,
            _that.createdAt,
            _that.lastUpdated,
            _that.preventFromRunning,
            _that.endDate);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HeatCycle implements HeatCycle {
  const _HeatCycle(
      {required this.id,
      required this.dogId,
      this.notes = "",
      @NonNullableTimestampConverter() required this.startDate,
      @NonNullableTimestampConverter() required this.createdAt,
      @NonNullableTimestampConverter() required this.lastUpdated,
      this.preventFromRunning = false,
      @TimestampConverter() this.endDate});
  factory _HeatCycle.fromJson(Map<String, dynamic> json) =>
      _$HeatCycleFromJson(json);

  /// The unique id of this heat event.
  @override
  final String id;

  /// The dog's id associated with this heat event.
  @override
  final String dogId;

  /// Notes regarding this heat.
  @override
  @JsonKey()
  final String notes;

  /// Heat started date
  @override
  @NonNullableTimestampConverter()
  final DateTime startDate;

  /// When the event was created initially
  @override
  @NonNullableTimestampConverter()
  final DateTime createdAt;

  /// When the event was last updated.
  @override
  @NonNullableTimestampConverter()
  final DateTime lastUpdated;

  /// This heat prevents the dog from running
  @override
  @JsonKey()
  final bool preventFromRunning;

  /// When it finished. If null, still ongoing.
  @override
  @TimestampConverter()
  final DateTime? endDate;

  /// Create a copy of HeatCycle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HeatCycleCopyWith<_HeatCycle> get copyWith =>
      __$HeatCycleCopyWithImpl<_HeatCycle>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HeatCycleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HeatCycle &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dogId, dogId) || other.dogId == dogId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.preventFromRunning, preventFromRunning) ||
                other.preventFromRunning == preventFromRunning) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, dogId, notes, startDate,
      createdAt, lastUpdated, preventFromRunning, endDate);

  @override
  String toString() {
    return 'HeatCycle(id: $id, dogId: $dogId, notes: $notes, startDate: $startDate, createdAt: $createdAt, lastUpdated: $lastUpdated, preventFromRunning: $preventFromRunning, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class _$HeatCycleCopyWith<$Res>
    implements $HeatCycleCopyWith<$Res> {
  factory _$HeatCycleCopyWith(
          _HeatCycle value, $Res Function(_HeatCycle) _then) =
      __$HeatCycleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String dogId,
      String notes,
      @NonNullableTimestampConverter() DateTime startDate,
      @NonNullableTimestampConverter() DateTime createdAt,
      @NonNullableTimestampConverter() DateTime lastUpdated,
      bool preventFromRunning,
      @TimestampConverter() DateTime? endDate});
}

/// @nodoc
class __$HeatCycleCopyWithImpl<$Res> implements _$HeatCycleCopyWith<$Res> {
  __$HeatCycleCopyWithImpl(this._self, this._then);

  final _HeatCycle _self;
  final $Res Function(_HeatCycle) _then;

  /// Create a copy of HeatCycle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? dogId = null,
    Object? notes = null,
    Object? startDate = null,
    Object? createdAt = null,
    Object? lastUpdated = null,
    Object? preventFromRunning = null,
    Object? endDate = freezed,
  }) {
    return _then(_HeatCycle(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dogId: null == dogId
          ? _self.dogId
          : dogId // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: null == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      preventFromRunning: null == preventFromRunning
          ? _self.preventFromRunning
          : preventFromRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
