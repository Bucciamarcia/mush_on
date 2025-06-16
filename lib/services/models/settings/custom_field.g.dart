// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomField _$CustomFieldFromJson(Map<String, dynamic> json) => _CustomField(
      templateId: json['templateId'] as String,
      value: CustomFieldValue.fromJson(json['value'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomFieldToJson(_CustomField instance) =>
    <String, dynamic>{
      'templateId': instance.templateId,
      'value': instance.value.toJson(),
    };

_CustomFieldTemplate _$CustomFieldTemplateFromJson(Map<String, dynamic> json) =>
    _CustomFieldTemplate(
      type: $enumDecode(_$CustomFieldTypeEnumMap, json['type']),
      name: json['name'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$CustomFieldTemplateToJson(
        _CustomFieldTemplate instance) =>
    <String, dynamic>{
      'type': _$CustomFieldTypeEnumMap[instance.type]!,
      'name': instance.name,
      'id': instance.id,
    };

const _$CustomFieldTypeEnumMap = {
  CustomFieldType.typeString: 'string',
  CustomFieldType.typeInt: 'int',
};

StringValue _$StringValueFromJson(Map<String, dynamic> json) => StringValue(
      json['value'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$StringValueToJson(StringValue instance) =>
    <String, dynamic>{
      'value': instance.value,
      'runtimeType': instance.$type,
    };

IntValue _$IntValueFromJson(Map<String, dynamic> json) => IntValue(
      (json['value'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$IntValueToJson(IntValue instance) => <String, dynamic>{
      'value': instance.value,
      'runtimeType': instance.$type,
    };
