// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    _SettingsModel(
      customFieldTemplates: (json['customFieldTemplates'] as List<dynamic>?)
              ?.map((e) =>
                  CustomFieldTemplate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      globalDistanceWarnings: (json['globalDistanceWarnings'] as List<dynamic>?)
              ?.map((e) => DistanceWarning.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SettingsModelToJson(_SettingsModel instance) =>
    <String, dynamic>{
      'customFieldTemplates':
          instance.customFieldTemplates.map((e) => e.toJson()).toList(),
      'globalDistanceWarnings':
          instance.globalDistanceWarnings.map((e) => e.toJson()).toList(),
    };
