// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teamgroup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamGroup {
  String get id;

  /// The name of the entire group.
  String get name;
  @NonNullableTimestampConverter()
  DateTime get date;

  /// The distance ran in km.
  /// Used for stats.
  double get distance;
  String get notes;

  /// Create a copy of TeamGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeamGroupCopyWith<TeamGroup> get copyWith =>
      _$TeamGroupCopyWithImpl<TeamGroup>(this as TeamGroup, _$identity);

  /// Serializes this TeamGroup to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TeamGroup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, date, distance, notes);

  @override
  String toString() {
    return 'TeamGroup(id: $id, name: $name, date: $date, distance: $distance, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class $TeamGroupCopyWith<$Res> {
  factory $TeamGroupCopyWith(TeamGroup value, $Res Function(TeamGroup) _then) =
      _$TeamGroupCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      @NonNullableTimestampConverter() DateTime date,
      double distance,
      String notes});
}

/// @nodoc
class _$TeamGroupCopyWithImpl<$Res> implements $TeamGroupCopyWith<$Res> {
  _$TeamGroupCopyWithImpl(this._self, this._then);

  final TeamGroup _self;
  final $Res Function(TeamGroup) _then;

  /// Create a copy of TeamGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? date = null,
    Object? distance = null,
    Object? notes = null,
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
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      distance: null == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TeamGroup extends TeamGroup {
  const _TeamGroup(
      {this.id = "",
      this.name = "",
      @NonNullableTimestampConverter() required this.date,
      this.distance = 0,
      this.notes = ""})
      : super._();
  factory _TeamGroup.fromJson(Map<String, dynamic> json) =>
      _$TeamGroupFromJson(json);

  @override
  @JsonKey()
  final String id;

  /// The name of the entire group.
  @override
  @JsonKey()
  final String name;
  @override
  @NonNullableTimestampConverter()
  final DateTime date;

  /// The distance ran in km.
  /// Used for stats.
  @override
  @JsonKey()
  final double distance;
  @override
  @JsonKey()
  final String notes;

  /// Create a copy of TeamGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeamGroupCopyWith<_TeamGroup> get copyWith =>
      __$TeamGroupCopyWithImpl<_TeamGroup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TeamGroupToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TeamGroup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, date, distance, notes);

  @override
  String toString() {
    return 'TeamGroup(id: $id, name: $name, date: $date, distance: $distance, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class _$TeamGroupCopyWith<$Res>
    implements $TeamGroupCopyWith<$Res> {
  factory _$TeamGroupCopyWith(
          _TeamGroup value, $Res Function(_TeamGroup) _then) =
      __$TeamGroupCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @NonNullableTimestampConverter() DateTime date,
      double distance,
      String notes});
}

/// @nodoc
class __$TeamGroupCopyWithImpl<$Res> implements _$TeamGroupCopyWith<$Res> {
  __$TeamGroupCopyWithImpl(this._self, this._then);

  final _TeamGroup _self;
  final $Res Function(_TeamGroup) _then;

  /// Create a copy of TeamGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? date = null,
    Object? distance = null,
    Object? notes = null,
  }) {
    return _then(_TeamGroup(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      distance: null == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
