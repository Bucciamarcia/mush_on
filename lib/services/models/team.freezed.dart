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
  List<DogPair> get dogPairs;

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
            const DeepCollectionEquality().equals(other.dogPairs, dogPairs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(dogPairs));

  @override
  String toString() {
    return 'Team(name: $name, dogPairs: $dogPairs)';
  }
}

/// @nodoc
abstract mixin class $TeamCopyWith<$Res> {
  factory $TeamCopyWith(Team value, $Res Function(Team) _then) =
      _$TeamCopyWithImpl;
  @useResult
  $Res call({String name, List<DogPair> dogPairs});
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
    Object? dogPairs = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dogPairs: null == dogPairs
          ? _self.dogPairs
          : dogPairs // ignore: cast_nullable_to_non_nullable
              as List<DogPair>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Team extends Team {
  const _Team({this.name = "", final List<DogPair> dogPairs = const []})
      : _dogPairs = dogPairs,
        super._();
  factory _Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  @override
  @JsonKey()
  final String name;
  final List<DogPair> _dogPairs;
  @override
  @JsonKey()
  List<DogPair> get dogPairs {
    if (_dogPairs is EqualUnmodifiableListView) return _dogPairs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dogPairs);
  }

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
            const DeepCollectionEquality().equals(other._dogPairs, _dogPairs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_dogPairs));

  @override
  String toString() {
    return 'Team(name: $name, dogPairs: $dogPairs)';
  }
}

/// @nodoc
abstract mixin class _$TeamCopyWith<$Res> implements $TeamCopyWith<$Res> {
  factory _$TeamCopyWith(_Team value, $Res Function(_Team) _then) =
      __$TeamCopyWithImpl;
  @override
  @useResult
  $Res call({String name, List<DogPair> dogPairs});
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
    Object? dogPairs = null,
  }) {
    return _then(_Team(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dogPairs: null == dogPairs
          ? _self._dogPairs
          : dogPairs // ignore: cast_nullable_to_non_nullable
              as List<DogPair>,
    ));
  }
}

// dart format on
