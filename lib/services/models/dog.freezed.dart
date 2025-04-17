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
  String get pictureUrl;
  List<Tag> get tags;

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
            (identical(other.pictureUrl, pictureUrl) ||
                other.pictureUrl == pictureUrl) &&
            const DeepCollectionEquality().equals(other.tags, tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, sex, id, positions,
      pictureUrl, const DeepCollectionEquality().hash(tags));

  @override
  String toString() {
    return 'Dog(name: $name, sex: $sex, id: $id, positions: $positions, pictureUrl: $pictureUrl, tags: $tags)';
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
      String pictureUrl,
      List<Tag> tags});

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
    Object? pictureUrl = null,
    Object? tags = null,
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
      pictureUrl: null == pictureUrl
          ? _self.pictureUrl
          : pictureUrl // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
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
class _Dog implements Dog {
  const _Dog(
      {this.name = "",
      this.sex = DogSex.none,
      this.id = "",
      this.positions = const DogPositions(),
      this.pictureUrl = "",
      final List<Tag> tags = const []})
      : _tags = tags;
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
  @override
  @JsonKey()
  final String pictureUrl;
  final List<Tag> _tags;
  @override
  @JsonKey()
  List<Tag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

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
            (identical(other.pictureUrl, pictureUrl) ||
                other.pictureUrl == pictureUrl) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, sex, id, positions,
      pictureUrl, const DeepCollectionEquality().hash(_tags));

  @override
  String toString() {
    return 'Dog(name: $name, sex: $sex, id: $id, positions: $positions, pictureUrl: $pictureUrl, tags: $tags)';
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
      String pictureUrl,
      List<Tag> tags});

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
    Object? pictureUrl = null,
    Object? tags = null,
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
      pictureUrl: null == pictureUrl
          ? _self.pictureUrl
          : pictureUrl // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _self._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
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
  DateTime get created;
  @ColorConverter()
  Color get color;
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
            (identical(other.created, created) || other.created == created) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.expired, expired) || other.expired == expired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, created, color, expired);

  @override
  String toString() {
    return 'Tag(id: $id, name: $name, created: $created, color: $color, expired: $expired)';
  }
}

/// @nodoc
abstract mixin class $TagCopyWith<$Res> {
  factory $TagCopyWith(Tag value, $Res Function(Tag) _then) = _$TagCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      DateTime created,
      @ColorConverter() Color color,
      DateTime? expired});
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
      required this.created,
      @ColorConverter() this.color = Colors.green,
      this.expired});
  factory _Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  final DateTime created;
  @override
  @JsonKey()
  @ColorConverter()
  final Color color;
  @override
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
            (identical(other.created, created) || other.created == created) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.expired, expired) || other.expired == expired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, created, color, expired);

  @override
  String toString() {
    return 'Tag(id: $id, name: $name, created: $created, color: $color, expired: $expired)';
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
      DateTime created,
      @ColorConverter() Color color,
      DateTime? expired});
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
