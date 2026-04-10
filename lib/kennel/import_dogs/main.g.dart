// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImportDogResult _$ImportDogResultFromJson(Map<String, dynamic> json) =>
    _ImportDogResult(
      dogs: (json['dogs'] as List<dynamic>).map((e) => e as String).toList(),
      isSuccessful: json['isSuccessful'] as bool,
    );

Map<String, dynamic> _$ImportDogResultToJson(_ImportDogResult instance) =>
    <String, dynamic>{
      'dogs': instance.dogs,
      'isSuccessful': instance.isSuccessful,
    };
