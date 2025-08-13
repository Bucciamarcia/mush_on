// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DogCustomerFacingInfo _$DogCustomerFacingInfoFromJson(
        Map<String, dynamic> json) =>
    _DogCustomerFacingInfo(
      id: json['id'] as String,
      dogId: json['dogId'] as String,
      description: json['description'] as String? ?? "",
    );

Map<String, dynamic> _$DogCustomerFacingInfoToJson(
        _DogCustomerFacingInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dogId': instance.dogId,
      'description': instance.description,
    };
