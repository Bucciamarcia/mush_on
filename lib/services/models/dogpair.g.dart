// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dogpair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DogPair _$DogPairFromJson(Map<String, dynamic> json) => _DogPair(
      firstDogId: json['firstDogId'] as String?,
      secondDogId: json['secondDogId'] as String?,
      id: json['id'] as String,
      rank: (json['rank'] as num).toInt(),
    );

Map<String, dynamic> _$DogPairToJson(_DogPair instance) => <String, dynamic>{
      'firstDogId': instance.firstDogId,
      'secondDogId': instance.secondDogId,
      'id': instance.id,
      'rank': instance.rank,
    };
