// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TourType _$TourTypeFromJson(Map<String, dynamic> json) => _TourType(
      id: json['id'] as String,
      name: json['name'] as String? ?? "",
      displayName: json['displayName'] as String? ?? "",
      distance: (json['distance'] as num?)?.toDouble() ?? 0,
      duration: (json['duration'] as num).toInt(),
      notes: json['notes'] as String?,
      displayDescription: json['displayDescription'] as String?,
    );

Map<String, dynamic> _$TourTypeToJson(_TourType instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayName': instance.displayName,
      'distance': instance.distance,
      'duration': instance.duration,
      'notes': instance.notes,
      'displayDescription': instance.displayDescription,
    };

_TourTypePricing _$TourTypePricingFromJson(Map<String, dynamic> json) =>
    _TourTypePricing(
      id: json['id'] as String,
      name: json['name'] as String? ?? "",
      displayName: json['displayName'] as String? ?? "",
      notes: json['notes'] as String?,
      displayDescription: json['displayDescription'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$TourTypePricingToJson(_TourTypePricing instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayName': instance.displayName,
      'notes': instance.notes,
      'displayDescription': instance.displayDescription,
      'price': instance.price,
    };
