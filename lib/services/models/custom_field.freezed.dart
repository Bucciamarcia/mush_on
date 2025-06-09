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
  CustomFieldValue get value;

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
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, value);

  @override
  String toString() {
    return 'CustomField(id: $id, name: $name, value: $value)';
  }
}

/// @nodoc
abstract mixin class $CustomFieldCopyWith<$Res> {
  factory $CustomFieldCopyWith(
          CustomField value, $Res Function(CustomField) _then) =
      _$CustomFieldCopyWithImpl;
  @useResult
  $Res call({String id, String name, CustomFieldValue value});

  $CustomFieldValueCopyWith<$Res> get value;
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
    Object? value = null,
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
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as CustomFieldValue,
    ));
  }

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomFieldValueCopyWith<$Res> get value {
    return $CustomFieldValueCopyWith<$Res>(_self.value, (value) {
      return _then(_self.copyWith(value: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _CustomField implements CustomField {
  const _CustomField(
      {required this.id, required this.name, required this.value});
  factory _CustomField.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final CustomFieldValue value;

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
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, value);

  @override
  String toString() {
    return 'CustomField(id: $id, name: $name, value: $value)';
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
  $Res call({String id, String name, CustomFieldValue value});

  @override
  $CustomFieldValueCopyWith<$Res> get value;
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
    Object? value = null,
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
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as CustomFieldValue,
    ));
  }

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomFieldValueCopyWith<$Res> get value {
    return $CustomFieldValueCopyWith<$Res>(_self.value, (value) {
      return _then(_self.copyWith(value: value));
    });
  }
}

CustomFieldValue _$CustomFieldValueFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'stringValue':
      return _StringValue.fromJson(json);
    case 'intValue':
      return _IntValue.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'CustomFieldValue',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$CustomFieldValue {
  Object get value;

  /// Serializes this CustomFieldValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomFieldValue &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  @override
  String toString() {
    return 'CustomFieldValue(value: $value)';
  }
}

/// @nodoc
class $CustomFieldValueCopyWith<$Res> {
  $CustomFieldValueCopyWith(
      CustomFieldValue _, $Res Function(CustomFieldValue) __);
}

/// @nodoc
@JsonSerializable()
class _StringValue implements CustomFieldValue {
  const _StringValue(this.value, {final String? $type})
      : $type = $type ?? 'stringValue';
  factory _StringValue.fromJson(Map<String, dynamic> json) =>
      _$StringValueFromJson(json);

  @override
  final String value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of CustomFieldValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StringValueCopyWith<_StringValue> get copyWith =>
      __$StringValueCopyWithImpl<_StringValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StringValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StringValue &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'CustomFieldValue.stringValue(value: $value)';
  }
}

/// @nodoc
abstract mixin class _$StringValueCopyWith<$Res>
    implements $CustomFieldValueCopyWith<$Res> {
  factory _$StringValueCopyWith(
          _StringValue value, $Res Function(_StringValue) _then) =
      __$StringValueCopyWithImpl;
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$StringValueCopyWithImpl<$Res> implements _$StringValueCopyWith<$Res> {
  __$StringValueCopyWithImpl(this._self, this._then);

  final _StringValue _self;
  final $Res Function(_StringValue) _then;

  /// Create a copy of CustomFieldValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
  }) {
    return _then(_StringValue(
      null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _IntValue implements CustomFieldValue {
  const _IntValue(this.value, {final String? $type})
      : $type = $type ?? 'intValue';
  factory _IntValue.fromJson(Map<String, dynamic> json) =>
      _$IntValueFromJson(json);

  @override
  final int value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of CustomFieldValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IntValueCopyWith<_IntValue> get copyWith =>
      __$IntValueCopyWithImpl<_IntValue>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$IntValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _IntValue &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'CustomFieldValue.intValue(value: $value)';
  }
}

/// @nodoc
abstract mixin class _$IntValueCopyWith<$Res>
    implements $CustomFieldValueCopyWith<$Res> {
  factory _$IntValueCopyWith(_IntValue value, $Res Function(_IntValue) _then) =
      __$IntValueCopyWithImpl;
  @useResult
  $Res call({int value});
}

/// @nodoc
class __$IntValueCopyWithImpl<$Res> implements _$IntValueCopyWith<$Res> {
  __$IntValueCopyWithImpl(this._self, this._then);

  final _IntValue _self;
  final $Res Function(_IntValue) _then;

  /// Create a copy of CustomFieldValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
  }) {
    return _then(_IntValue(
      null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
