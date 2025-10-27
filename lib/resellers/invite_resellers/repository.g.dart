// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reseller _$ResellerFromJson(Map<String, dynamic> json) => _Reseller(
      uid: json['uid'] as String,
      email: json['email'] as String,
      accounts:
          (json['accounts'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ResellerToJson(_Reseller instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'accounts': instance.accounts,
    };

_ResellerInvitation _$ResellerInvitationFromJson(Map<String, dynamic> json) =>
    _ResellerInvitation(
      accepted: json['accepted'] as bool,
      account: json['account'] as String,
      discount: (json['discount'] as num).toInt(),
      email: json['email'] as String,
      securityCode: json['securityCode'] as String,
    );

Map<String, dynamic> _$ResellerInvitationToJson(_ResellerInvitation instance) =>
    <String, dynamic>{
      'accepted': instance.accepted,
      'account': instance.account,
      'discount': instance.discount,
      'email': instance.email,
      'securityCode': instance.securityCode,
    };
