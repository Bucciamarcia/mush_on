// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dogpair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DogPair _$DogPairFromJson(Map<String, dynamic> json) => _DogPair(
      id: json['id'] as String? ?? "",
      firstDogId: json['firstDogId'] as String?,
      secondDogId: json['secondDogId'] as String?,
    );

Map<String, dynamic> _$DogPairToJson(_DogPair instance) => <String, dynamic>{
      'id': instance.id,
      'firstDogId': instance.firstDogId,
      'secondDogId': instance.secondDogId,
    };
