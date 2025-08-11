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
      backgroundColor: const ColorConverter()
          .fromJson((json['backgroundColor'] as num).toInt()),
      isArchived: json['isArchived'] as bool? ?? false,
    );

Map<String, dynamic> _$TourTypeToJson(_TourType instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayName': instance.displayName,
      'distance': instance.distance,
      'duration': instance.duration,
      'notes': instance.notes,
      'displayDescription': instance.displayDescription,
      'backgroundColor':
          const ColorConverter().toJson(instance.backgroundColor),
      'isArchived': instance.isArchived,
    };

_TourTypePricing _$TourTypePricingFromJson(Map<String, dynamic> json) =>
    _TourTypePricing(
      id: json['id'] as String,
      name: json['name'] as String? ?? "",
      isArchived: json['isArchived'] as bool? ?? false,
      displayName: json['displayName'] as String? ?? "",
      notes: json['notes'] as String?,
      displayDescription: json['displayDescription'] as String?,
      priceCents: (json['priceCents'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TourTypePricingToJson(_TourTypePricing instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isArchived': instance.isArchived,
      'displayName': instance.displayName,
      'notes': instance.notes,
      'displayDescription': instance.displayDescription,
      'priceCents': instance.priceCents,
    };
