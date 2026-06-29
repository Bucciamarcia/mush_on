// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Partner _$PartnerFromJson(Map<String, dynamic> json) => _Partner(
  id: json['id'] as String,
  name: json['name'] as String? ?? "",
  code: json['code'] as String? ?? "",
  email: json['email'] as String?,
  discountRate: (json['discountRate'] as num?)?.toDouble(),
  allowDeferred: json['allowDeferred'] as bool? ?? false,
  deferredDays: (json['deferredDays'] as num?)?.toInt() ?? 0,
  invoiceEnabled: json['invoiceEnabled'] as bool? ?? false,
  invoiceLegalName: json['invoiceLegalName'] as String? ?? "",
  invoiceAddress: json['invoiceAddress'] as String? ?? "",
  invoiceBusinessId: json['invoiceBusinessId'] as String? ?? "",
  reverseChargeVat: json['reverseChargeVat'] as bool? ?? false,
  archived: json['archived'] as bool? ?? false,
);

Map<String, dynamic> _$PartnerToJson(_Partner instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
  'email': instance.email,
  'discountRate': instance.discountRate,
  'allowDeferred': instance.allowDeferred,
  'deferredDays': instance.deferredDays,
  'invoiceEnabled': instance.invoiceEnabled,
  'invoiceLegalName': instance.invoiceLegalName,
  'invoiceAddress': instance.invoiceAddress,
  'invoiceBusinessId': instance.invoiceBusinessId,
  'reverseChargeVat': instance.reverseChargeVat,
  'archived': instance.archived,
};
