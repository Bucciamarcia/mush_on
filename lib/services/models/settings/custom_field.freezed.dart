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
  /// The ID of the template this custom field is assigned to.
  String get templateId;
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
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, templateId, value);

  @override
  String toString() {
    return 'CustomField(templateId: $templateId, value: $value)';
  }
}

/// @nodoc
abstract mixin class $CustomFieldCopyWith<$Res> {
  factory $CustomFieldCopyWith(
          CustomField value, $Res Function(CustomField) _then) =
      _$CustomFieldCopyWithImpl;
  @useResult
  $Res call({String templateId, CustomFieldValue value});

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
    Object? templateId = null,
    Object? value = null,
  }) {
    return _then(_self.copyWith(
      templateId: null == templateId
          ? _self.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
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

@JsonSerializable(explicitToJson: true)
class _CustomField implements CustomField {
  const _CustomField({required this.templateId, required this.value});
  factory _CustomField.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldFromJson(json);

  /// The ID of the template this custom field is assigned to.
  @override
  final String templateId;
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
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, templateId, value);

  @override
  String toString() {
    return 'CustomField(templateId: $templateId, value: $value)';
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
  $Res call({String templateId, CustomFieldValue value});

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
    Object? templateId = null,
    Object? value = null,
  }) {
    return _then(_CustomField(
      templateId: null == templateId
          ? _self.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
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
mixin _$CustomFieldTemplate {
  CustomFieldType get type;
  String get name;
  String get id;

  /// Create a copy of CustomFieldTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomFieldTemplateCopyWith<CustomFieldTemplate> get copyWith =>
      _$CustomFieldTemplateCopyWithImpl<CustomFieldTemplate>(
          this as CustomFieldTemplate, _$identity);

  /// Serializes this CustomFieldTemplate to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomFieldTemplate &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, name, id);

  @override
  String toString() {
    return 'CustomFieldTemplate(type: $type, name: $name, id: $id)';
  }
}

/// @nodoc
abstract mixin class $CustomFieldTemplateCopyWith<$Res> {
  factory $CustomFieldTemplateCopyWith(
          CustomFieldTemplate value, $Res Function(CustomFieldTemplate) _then) =
      _$CustomFieldTemplateCopyWithImpl;
  @useResult
  $Res call({CustomFieldType type, String name, String id});
}

/// @nodoc
class _$CustomFieldTemplateCopyWithImpl<$Res>
    implements $CustomFieldTemplateCopyWith<$Res> {
  _$CustomFieldTemplateCopyWithImpl(this._self, this._then);

  final CustomFieldTemplate _self;
  final $Res Function(CustomFieldTemplate) _then;

  /// Create a copy of CustomFieldTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? id = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as CustomFieldType,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CustomFieldTemplate implements CustomFieldTemplate {
  const _CustomFieldTemplate(
      {required this.type, required this.name, required this.id});
  factory _CustomFieldTemplate.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldTemplateFromJson(json);

  @override
  final CustomFieldType type;
  @override
  final String name;
  @override
  final String id;

  /// Create a copy of CustomFieldTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CustomFieldTemplateCopyWith<_CustomFieldTemplate> get copyWith =>
      __$CustomFieldTemplateCopyWithImpl<_CustomFieldTemplate>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CustomFieldTemplateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CustomFieldTemplate &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, name, id);

  @override
  String toString() {
    return 'CustomFieldTemplate(type: $type, name: $name, id: $id)';
  }
}

/// @nodoc
abstract mixin class _$CustomFieldTemplateCopyWith<$Res>
    implements $CustomFieldTemplateCopyWith<$Res> {
  factory _$CustomFieldTemplateCopyWith(_CustomFieldTemplate value,
          $Res Function(_CustomFieldTemplate) _then) =
      __$CustomFieldTemplateCopyWithImpl;
  @override
  @useResult
  $Res call({CustomFieldType type, String name, String id});
}

/// @nodoc
class __$CustomFieldTemplateCopyWithImpl<$Res>
    implements _$CustomFieldTemplateCopyWith<$Res> {
  __$CustomFieldTemplateCopyWithImpl(this._self, this._then);

  final _CustomFieldTemplate _self;
  final $Res Function(_CustomFieldTemplate) _then;

  /// Create a copy of CustomFieldTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? id = null,
  }) {
    return _then(_CustomFieldTemplate(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as CustomFieldType,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

CustomFieldValue _$CustomFieldValueFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'stringValue':
      return StringValue.fromJson(json);
    case 'intValue':
      return IntValue.fromJson(json);

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
class StringValue extends CustomFieldValue {
  const StringValue(this.value, {final String? $type})
      : $type = $type ?? 'stringValue',
        super._();
  factory StringValue.fromJson(Map<String, dynamic> json) =>
      _$StringValueFromJson(json);

  @override
  final String value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of CustomFieldValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StringValueCopyWith<StringValue> get copyWith =>
      _$StringValueCopyWithImpl<StringValue>(this, _$identity);

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
            other is StringValue &&
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
abstract mixin class $StringValueCopyWith<$Res>
    implements $CustomFieldValueCopyWith<$Res> {
  factory $StringValueCopyWith(
          StringValue value, $Res Function(StringValue) _then) =
      _$StringValueCopyWithImpl;
  @useResult
  $Res call({String value});
}

/// @nodoc
class _$StringValueCopyWithImpl<$Res> implements $StringValueCopyWith<$Res> {
  _$StringValueCopyWithImpl(this._self, this._then);

  final StringValue _self;
  final $Res Function(StringValue) _then;

  /// Create a copy of CustomFieldValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
  }) {
    return _then(StringValue(
      null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class IntValue extends CustomFieldValue {
  const IntValue(this.value, {final String? $type})
      : $type = $type ?? 'intValue',
        super._();
  factory IntValue.fromJson(Map<String, dynamic> json) =>
      _$IntValueFromJson(json);

  @override
  final int value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of CustomFieldValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IntValueCopyWith<IntValue> get copyWith =>
      _$IntValueCopyWithImpl<IntValue>(this, _$identity);

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
            other is IntValue &&
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
abstract mixin class $IntValueCopyWith<$Res>
    implements $CustomFieldValueCopyWith<$Res> {
  factory $IntValueCopyWith(IntValue value, $Res Function(IntValue) _then) =
      _$IntValueCopyWithImpl;
  @useResult
  $Res call({int value});
}

/// @nodoc
class _$IntValueCopyWithImpl<$Res> implements $IntValueCopyWith<$Res> {
  _$IntValueCopyWithImpl(this._self, this._then);

  final IntValue _self;
  final $Res Function(IntValue) _then;

  /// Create a copy of CustomFieldValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
  }) {
    return _then(IntValue(
      null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
