// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Team {
  String get name;
  String get id;
  int get capacity;
  int get rank;

  /// Create a copy of Team
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeamCopyWith<Team> get copyWith =>
      _$TeamCopyWithImpl<Team>(this as Team, _$identity);

  /// Serializes this Team to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Team &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, id, capacity, rank);

  @override
  String toString() {
    return 'Team(name: $name, id: $id, capacity: $capacity, rank: $rank)';
  }
}

/// @nodoc
abstract mixin class $TeamCopyWith<$Res> {
  factory $TeamCopyWith(Team value, $Res Function(Team) _then) =
      _$TeamCopyWithImpl;
  @useResult
  $Res call({String name, String id, int capacity, int rank});
}

/// @nodoc
class _$TeamCopyWithImpl<$Res> implements $TeamCopyWith<$Res> {
  _$TeamCopyWithImpl(this._self, this._then);

  final Team _self;
  final $Res Function(Team) _then;

  /// Create a copy of Team
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = null,
    Object? capacity = null,
    Object? rank = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      capacity: null == capacity
          ? _self.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _self.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Team extends Team {
  const _Team(
      {this.name = "", required this.id, this.capacity = 0, required this.rank})
      : super._();
  factory _Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  final String id;
  @override
  @JsonKey()
  final int capacity;
  @override
  final int rank;

  /// Create a copy of Team
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeamCopyWith<_Team> get copyWith =>
      __$TeamCopyWithImpl<_Team>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TeamToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Team &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, id, capacity, rank);

  @override
  String toString() {
    return 'Team(name: $name, id: $id, capacity: $capacity, rank: $rank)';
  }
}

/// @nodoc
abstract mixin class _$TeamCopyWith<$Res> implements $TeamCopyWith<$Res> {
  factory _$TeamCopyWith(_Team value, $Res Function(_Team) _then) =
      __$TeamCopyWithImpl;
  @override
  @useResult
  $Res call({String name, String id, int capacity, int rank});
}

/// @nodoc
class __$TeamCopyWithImpl<$Res> implements _$TeamCopyWith<$Res> {
  __$TeamCopyWithImpl(this._self, this._then);

  final _Team _self;
  final $Res Function(_Team) _then;

  /// Create a copy of Team
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? id = null,
    Object? capacity = null,
    Object? rank = null,
  }) {
    return _then(_Team(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      capacity: null == capacity
          ? _self.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _self.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
