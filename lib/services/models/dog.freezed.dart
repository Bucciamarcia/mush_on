// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Dog {
  String get name;
  DogSex get sex;
  String get id;
  DogPositions get positions;
  List<Tag> get tags;
  List<CustomField> get customFields;
  List<SingleDogNote> get notes;
  List<DistanceWarning> get distanceWarnings;
  @TimestampConverter()
  DateTime? get birth;

  /// Create a copy of Dog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DogCopyWith<Dog> get copyWith =>
      _$DogCopyWithImpl<Dog>(this as Dog, _$identity);

  /// Serializes this Dog to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Dog &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sex, sex) || other.sex == sex) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.positions, positions) ||
                other.positions == positions) &&
            const DeepCollectionEquality().equals(other.tags, tags) &&
            const DeepCollectionEquality()
                .equals(other.customFields, customFields) &&
            const DeepCollectionEquality().equals(other.notes, notes) &&
            const DeepCollectionEquality()
                .equals(other.distanceWarnings, distanceWarnings) &&
            (identical(other.birth, birth) || other.birth == birth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      sex,
      id,
      positions,
      const DeepCollectionEquality().hash(tags),
      const DeepCollectionEquality().hash(customFields),
      const DeepCollectionEquality().hash(notes),
      const DeepCollectionEquality().hash(distanceWarnings),
      birth);

  @override
  String toString() {
    return 'Dog(name: $name, sex: $sex, id: $id, positions: $positions, tags: $tags, customFields: $customFields, notes: $notes, distanceWarnings: $distanceWarnings, birth: $birth)';
  }
}

/// @nodoc
abstract mixin class $DogCopyWith<$Res> {
  factory $DogCopyWith(Dog value, $Res Function(Dog) _then) = _$DogCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      DogSex sex,
      String id,
      DogPositions positions,
      List<Tag> tags,
      List<CustomField> customFields,
      List<SingleDogNote> notes,
      List<DistanceWarning> distanceWarnings,
      @TimestampConverter() DateTime? birth});

  $DogPositionsCopyWith<$Res> get positions;
}

/// @nodoc
class _$DogCopyWithImpl<$Res> implements $DogCopyWith<$Res> {
  _$DogCopyWithImpl(this._self, this._then);

  final Dog _self;
  final $Res Function(Dog) _then;

  /// Create a copy of Dog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? sex = null,
    Object? id = null,
    Object? positions = null,
    Object? tags = null,
    Object? customFields = null,
    Object? notes = null,
    Object? distanceWarnings = null,
    Object? birth = freezed,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sex: null == sex
          ? _self.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as DogSex,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      positions: null == positions
          ? _self.positions
          : positions // ignore: cast_nullable_to_non_nullable
              as DogPositions,
      tags: null == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
      customFields: null == customFields
          ? _self.customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as List<CustomField>,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<SingleDogNote>,
      distanceWarnings: null == distanceWarnings
          ? _self.distanceWarnings
          : distanceWarnings // ignore: cast_nullable_to_non_nullable
              as List<DistanceWarning>,
      birth: freezed == birth
          ? _self.birth
          : birth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  /// Create a copy of Dog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DogPositionsCopyWith<$Res> get positions {
    return $DogPositionsCopyWith<$Res>(_self.positions, (value) {
      return _then(_self.copyWith(positions: value));
    });
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Dog extends Dog {
  const _Dog(
      {this.name = "",
      this.sex = DogSex.none,
      this.id = "",
      this.positions = const DogPositions(),
      final List<Tag> tags = const [],
      final List<CustomField> customFields = const [],
      final List<SingleDogNote> notes = const [],
      final List<DistanceWarning> distanceWarnings = const [],
      @TimestampConverter() this.birth})
      : _tags = tags,
        _customFields = customFields,
        _notes = notes,
        _distanceWarnings = distanceWarnings,
        super._();
  factory _Dog.fromJson(Map<String, dynamic> json) => _$DogFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final DogSex sex;
  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final DogPositions positions;
  final List<Tag> _tags;
  @override
  @JsonKey()
  List<Tag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<CustomField> _customFields;
  @override
  @JsonKey()
  List<CustomField> get customFields {
    if (_customFields is EqualUnmodifiableListView) return _customFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customFields);
  }

  final List<SingleDogNote> _notes;
  @override
  @JsonKey()
  List<SingleDogNote> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  final List<DistanceWarning> _distanceWarnings;
  @override
  @JsonKey()
  List<DistanceWarning> get distanceWarnings {
    if (_distanceWarnings is EqualUnmodifiableListView)
      return _distanceWarnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_distanceWarnings);
  }

  @override
  @TimestampConverter()
  final DateTime? birth;

  /// Create a copy of Dog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DogCopyWith<_Dog> get copyWith =>
      __$DogCopyWithImpl<_Dog>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DogToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Dog &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sex, sex) || other.sex == sex) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.positions, positions) ||
                other.positions == positions) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._customFields, _customFields) &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
            const DeepCollectionEquality()
                .equals(other._distanceWarnings, _distanceWarnings) &&
            (identical(other.birth, birth) || other.birth == birth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      sex,
      id,
      positions,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_customFields),
      const DeepCollectionEquality().hash(_notes),
      const DeepCollectionEquality().hash(_distanceWarnings),
      birth);

  @override
  String toString() {
    return 'Dog(name: $name, sex: $sex, id: $id, positions: $positions, tags: $tags, customFields: $customFields, notes: $notes, distanceWarnings: $distanceWarnings, birth: $birth)';
  }
}

/// @nodoc
abstract mixin class _$DogCopyWith<$Res> implements $DogCopyWith<$Res> {
  factory _$DogCopyWith(_Dog value, $Res Function(_Dog) _then) =
      __$DogCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      DogSex sex,
      String id,
      DogPositions positions,
      List<Tag> tags,
      List<CustomField> customFields,
      List<SingleDogNote> notes,
      List<DistanceWarning> distanceWarnings,
      @TimestampConverter() DateTime? birth});

  @override
  $DogPositionsCopyWith<$Res> get positions;
}

/// @nodoc
class __$DogCopyWithImpl<$Res> implements _$DogCopyWith<$Res> {
  __$DogCopyWithImpl(this._self, this._then);

  final _Dog _self;
  final $Res Function(_Dog) _then;

  /// Create a copy of Dog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? sex = null,
    Object? id = null,
    Object? positions = null,
    Object? tags = null,
    Object? customFields = null,
    Object? notes = null,
    Object? distanceWarnings = null,
    Object? birth = freezed,
  }) {
    return _then(_Dog(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sex: null == sex
          ? _self.sex
          : sex // ignore: cast_nullable_to_non_nullable
              as DogSex,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      positions: null == positions
          ? _self.positions
          : positions // ignore: cast_nullable_to_non_nullable
              as DogPositions,
      tags: null == tags
          ? _self._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
      customFields: null == customFields
          ? _self._customFields
          : customFields // ignore: cast_nullable_to_non_nullable
              as List<CustomField>,
      notes: null == notes
          ? _self._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<SingleDogNote>,
      distanceWarnings: null == distanceWarnings
          ? _self._distanceWarnings
          : distanceWarnings // ignore: cast_nullable_to_non_nullable
              as List<DistanceWarning>,
      birth: freezed == birth
          ? _self.birth
          : birth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  /// Create a copy of Dog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DogPositionsCopyWith<$Res> get positions {
    return $DogPositionsCopyWith<$Res>(_self.positions, (value) {
      return _then(_self.copyWith(positions: value));
    });
  }
}

/// @nodoc
mixin _$DogPositions {
  bool get lead;
  bool get swing;
  bool get team;
  bool get wheel;

  /// Create a copy of DogPositions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DogPositionsCopyWith<DogPositions> get copyWith =>
      _$DogPositionsCopyWithImpl<DogPositions>(
          this as DogPositions, _$identity);

  /// Serializes this DogPositions to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DogPositions &&
            (identical(other.lead, lead) || other.lead == lead) &&
            (identical(other.swing, swing) || other.swing == swing) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.wheel, wheel) || other.wheel == wheel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lead, swing, team, wheel);

  @override
  String toString() {
    return 'DogPositions(lead: $lead, swing: $swing, team: $team, wheel: $wheel)';
  }
}

/// @nodoc
abstract mixin class $DogPositionsCopyWith<$Res> {
  factory $DogPositionsCopyWith(
          DogPositions value, $Res Function(DogPositions) _then) =
      _$DogPositionsCopyWithImpl;
  @useResult
  $Res call({bool lead, bool swing, bool team, bool wheel});
}

/// @nodoc
class _$DogPositionsCopyWithImpl<$Res> implements $DogPositionsCopyWith<$Res> {
  _$DogPositionsCopyWithImpl(this._self, this._then);

  final DogPositions _self;
  final $Res Function(DogPositions) _then;

  /// Create a copy of DogPositions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lead = null,
    Object? swing = null,
    Object? team = null,
    Object? wheel = null,
  }) {
    return _then(_self.copyWith(
      lead: null == lead
          ? _self.lead
          : lead // ignore: cast_nullable_to_non_nullable
              as bool,
      swing: null == swing
          ? _self.swing
          : swing // ignore: cast_nullable_to_non_nullable
              as bool,
      team: null == team
          ? _self.team
          : team // ignore: cast_nullable_to_non_nullable
              as bool,
      wheel: null == wheel
          ? _self.wheel
          : wheel // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _DogPositions extends DogPositions {
  const _DogPositions(
      {this.lead = false,
      this.swing = false,
      this.team = false,
      this.wheel = false})
      : super._();
  factory _DogPositions.fromJson(Map<String, dynamic> json) =>
      _$DogPositionsFromJson(json);

  @override
  @JsonKey()
  final bool lead;
  @override
  @JsonKey()
  final bool swing;
  @override
  @JsonKey()
  final bool team;
  @override
  @JsonKey()
  final bool wheel;

  /// Create a copy of DogPositions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DogPositionsCopyWith<_DogPositions> get copyWith =>
      __$DogPositionsCopyWithImpl<_DogPositions>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DogPositionsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DogPositions &&
            (identical(other.lead, lead) || other.lead == lead) &&
            (identical(other.swing, swing) || other.swing == swing) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.wheel, wheel) || other.wheel == wheel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lead, swing, team, wheel);

  @override
  String toString() {
    return 'DogPositions(lead: $lead, swing: $swing, team: $team, wheel: $wheel)';
  }
}

/// @nodoc
abstract mixin class _$DogPositionsCopyWith<$Res>
    implements $DogPositionsCopyWith<$Res> {
  factory _$DogPositionsCopyWith(
          _DogPositions value, $Res Function(_DogPositions) _then) =
      __$DogPositionsCopyWithImpl;
  @override
  @useResult
  $Res call({bool lead, bool swing, bool team, bool wheel});
}

/// @nodoc
class __$DogPositionsCopyWithImpl<$Res>
    implements _$DogPositionsCopyWith<$Res> {
  __$DogPositionsCopyWithImpl(this._self, this._then);

  final _DogPositions _self;
  final $Res Function(_DogPositions) _then;

  /// Create a copy of DogPositions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? lead = null,
    Object? swing = null,
    Object? team = null,
    Object? wheel = null,
  }) {
    return _then(_DogPositions(
      lead: null == lead
          ? _self.lead
          : lead // ignore: cast_nullable_to_non_nullable
              as bool,
      swing: null == swing
          ? _self.swing
          : swing // ignore: cast_nullable_to_non_nullable
              as bool,
      team: null == team
          ? _self.team
          : team // ignore: cast_nullable_to_non_nullable
              as bool,
      wheel: null == wheel
          ? _self.wheel
          : wheel // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$Tag {
  String get id;
  String get name;
  bool get preventFromRun;
  bool get showInTeamBuilder;
  @TimestampConverter()
  DateTime get created;
  @ColorConverter()
  Color get color;
  @TimestampConverter()
  DateTime? get expired;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TagCopyWith<Tag> get copyWith =>
      _$TagCopyWithImpl<Tag>(this as Tag, _$identity);

  /// Serializes this Tag to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Tag &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.preventFromRun, preventFromRun) ||
                other.preventFromRun == preventFromRun) &&
            (identical(other.showInTeamBuilder, showInTeamBuilder) ||
                other.showInTeamBuilder == showInTeamBuilder) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.expired, expired) || other.expired == expired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, preventFromRun,
      showInTeamBuilder, created, color, expired);

  @override
  String toString() {
    return 'Tag(id: $id, name: $name, preventFromRun: $preventFromRun, showInTeamBuilder: $showInTeamBuilder, created: $created, color: $color, expired: $expired)';
  }
}

/// @nodoc
abstract mixin class $TagCopyWith<$Res> {
  factory $TagCopyWith(Tag value, $Res Function(Tag) _then) = _$TagCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      bool preventFromRun,
      bool showInTeamBuilder,
      @TimestampConverter() DateTime created,
      @ColorConverter() Color color,
      @TimestampConverter() DateTime? expired});
}

/// @nodoc
class _$TagCopyWithImpl<$Res> implements $TagCopyWith<$Res> {
  _$TagCopyWithImpl(this._self, this._then);

  final Tag _self;
  final $Res Function(Tag) _then;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? preventFromRun = null,
    Object? showInTeamBuilder = null,
    Object? created = null,
    Object? color = null,
    Object? expired = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      preventFromRun: null == preventFromRun
          ? _self.preventFromRun
          : preventFromRun // ignore: cast_nullable_to_non_nullable
              as bool,
      showInTeamBuilder: null == showInTeamBuilder
          ? _self.showInTeamBuilder
          : showInTeamBuilder // ignore: cast_nullable_to_non_nullable
              as bool,
      created: null == created
          ? _self.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      expired: freezed == expired
          ? _self.expired
          : expired // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Tag implements Tag {
  const _Tag(
      {this.id = "",
      this.name = "",
      this.preventFromRun = false,
      this.showInTeamBuilder = false,
      @TimestampConverter() required this.created,
      @ColorConverter() this.color = Colors.green,
      @TimestampConverter() this.expired});
  factory _Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final bool preventFromRun;
  @override
  @JsonKey()
  final bool showInTeamBuilder;
  @override
  @TimestampConverter()
  final DateTime created;
  @override
  @JsonKey()
  @ColorConverter()
  final Color color;
  @override
  @TimestampConverter()
  final DateTime? expired;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TagCopyWith<_Tag> get copyWith =>
      __$TagCopyWithImpl<_Tag>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TagToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Tag &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.preventFromRun, preventFromRun) ||
                other.preventFromRun == preventFromRun) &&
            (identical(other.showInTeamBuilder, showInTeamBuilder) ||
                other.showInTeamBuilder == showInTeamBuilder) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.expired, expired) || other.expired == expired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, preventFromRun,
      showInTeamBuilder, created, color, expired);

  @override
  String toString() {
    return 'Tag(id: $id, name: $name, preventFromRun: $preventFromRun, showInTeamBuilder: $showInTeamBuilder, created: $created, color: $color, expired: $expired)';
  }
}

/// @nodoc
abstract mixin class _$TagCopyWith<$Res> implements $TagCopyWith<$Res> {
  factory _$TagCopyWith(_Tag value, $Res Function(_Tag) _then) =
      __$TagCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      bool preventFromRun,
      bool showInTeamBuilder,
      @TimestampConverter() DateTime created,
      @ColorConverter() Color color,
      @TimestampConverter() DateTime? expired});
}

/// @nodoc
class __$TagCopyWithImpl<$Res> implements _$TagCopyWith<$Res> {
  __$TagCopyWithImpl(this._self, this._then);

  final _Tag _self;
  final $Res Function(_Tag) _then;

  /// Create a copy of Tag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? preventFromRun = null,
    Object? showInTeamBuilder = null,
    Object? created = null,
    Object? color = null,
    Object? expired = freezed,
  }) {
    return _then(_Tag(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      preventFromRun: null == preventFromRun
          ? _self.preventFromRun
          : preventFromRun // ignore: cast_nullable_to_non_nullable
              as bool,
      showInTeamBuilder: null == showInTeamBuilder
          ? _self.showInTeamBuilder
          : showInTeamBuilder // ignore: cast_nullable_to_non_nullable
              as bool,
      created: null == created
          ? _self.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      expired: freezed == expired
          ? _self.expired
          : expired // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
