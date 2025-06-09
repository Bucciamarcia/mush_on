// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomField {
  String get id;
  String get name;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomFieldCopyWith<CustomField> get copyWith =>
      _$CustomFieldCopyWithImpl<CustomField>(this as CustomField, _$identity);

  /// Serializes this CustomField to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomField &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'CustomField(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class $CustomFieldCopyWith<$Res> {
  factory $CustomFieldCopyWith(
          CustomField value, $Res Function(CustomField) _then) =
      _$CustomFieldCopyWithImpl;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$CustomFieldCopyWithImpl<$Res> implements $CustomFieldCopyWith<$Res> {
  _$CustomFieldCopyWithImpl(this._self, this._then);

  final CustomField _self;
  final $Res Function(CustomField) _then;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CustomField implements CustomField {
  const _CustomField({required this.id, required this.name});
  factory _CustomField.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldFromJson(json);

  @override
  final String id;
  @override
  final String name;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CustomFieldCopyWith<_CustomField> get copyWith =>
      __$CustomFieldCopyWithImpl<_CustomField>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CustomFieldToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CustomField &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'CustomField(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$CustomFieldCopyWith<$Res>
    implements $CustomFieldCopyWith<$Res> {
  factory _$CustomFieldCopyWith(
          _CustomField value, $Res Function(_CustomField) _then) =
      __$CustomFieldCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$CustomFieldCopyWithImpl<$Res> implements _$CustomFieldCopyWith<$Res> {
  __$CustomFieldCopyWithImpl(this._self, this._then);

  final _CustomField _self;
  final $Res Function(_CustomField) _then;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_CustomField(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
