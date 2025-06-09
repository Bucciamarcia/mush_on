// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomField _$CustomFieldFromJson(Map<String, dynamic> json) => _CustomField(
      id: json['id'] as String,
      name: json['name'] as String,
      value: CustomFieldValue.fromJson(json['value'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomFieldToJson(_CustomField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
    };

_StringValue _$StringValueFromJson(Map<String, dynamic> json) => _StringValue(
      json['value'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$StringValueToJson(_StringValue instance) =>
    <String, dynamic>{
      'value': instance.value,
      'runtimeType': instance.$type,
    };

_IntValue _$IntValueFromJson(Map<String, dynamic> json) => _IntValue(
      (json['value'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$IntValueToJson(_IntValue instance) => <String, dynamic>{
      'value': instance.value,
      'runtimeType': instance.$type,
    };
