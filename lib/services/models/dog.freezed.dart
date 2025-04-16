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
  String get id;
  DogPositions get positions;

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
            (identical(other.id, id) || other.id == id) &&
            (identical(other.positions, positions) ||
                other.positions == positions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, id, positions);

  @override
  String toString() {
    return 'Dog(name: $name, id: $id, positions: $positions)';
  }
}

/// @nodoc
abstract mixin class $DogCopyWith<$Res> {
  factory $DogCopyWith(Dog value, $Res Function(Dog) _then) = _$DogCopyWithImpl;
  @useResult
  $Res call({String name, String id, DogPositions positions});

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
    Object? id = null,
    Object? positions = null,
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
      positions: null == positions
          ? _self.positions
          : positions // ignore: cast_nullable_to_non_nullable
              as DogPositions,
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
@JsonSerializable()
class _Dog implements Dog {
  const _Dog(
      {this.name = "", this.id = "", this.positions = const DogPositions()});
  factory _Dog.fromJson(Map<String, dynamic> json) => _$DogFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final DogPositions positions;

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
            (identical(other.id, id) || other.id == id) &&
            (identical(other.positions, positions) ||
                other.positions == positions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, id, positions);

  @override
  String toString() {
    return 'Dog(name: $name, id: $id, positions: $positions)';
  }
}

/// @nodoc
abstract mixin class _$DogCopyWith<$Res> implements $DogCopyWith<$Res> {
  factory _$DogCopyWith(_Dog value, $Res Function(_Dog) _then) =
      __$DogCopyWithImpl;
  @override
  @useResult
  $Res call({String name, String id, DogPositions positions});

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
    Object? id = null,
    Object? positions = null,
  }) {
    return _then(_Dog(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      positions: null == positions
          ? _self.positions
          : positions // ignore: cast_nullable_to_non_nullable
              as DogPositions,
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
class _DogPositions implements DogPositions {
  const _DogPositions(
      {this.lead = false,
      this.swing = false,
      this.team = false,
      this.wheel = false});
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

// dart format on
