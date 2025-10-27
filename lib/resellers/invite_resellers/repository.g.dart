// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reseller _$ResellerFromJson(Map<String, dynamic> json) => _Reseller(
      uid: json['uid'] as String,
      email: json['email'] as String,
      resellerAccounts: (json['resellerAccounts'] as List<dynamic>)
          .map((e) => AccountAndDiscount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResellerToJson(_Reseller instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'resellerAccounts':
          instance.resellerAccounts.map((e) => e.toJson()).toList(),
    };

_AccountAndDiscount _$AccountAndDiscountFromJson(Map<String, dynamic> json) =>
    _AccountAndDiscount(
      accountName: json['accountName'] as String,
      discountAmount: (json['discountAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$AccountAndDiscountToJson(_AccountAndDiscount instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'discountAmount': instance.discountAmount,
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
