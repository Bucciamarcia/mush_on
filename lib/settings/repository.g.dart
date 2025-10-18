// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserInvitation _$UserInvitationFromJson(Map<String, dynamic> json) =>
    _UserInvitation(
      email: json['email'] as String,
      userLevel: $enumDecode(_$UserLevelEnumMap, json['userLevel']),
      account: json['account'] as String,
    );

Map<String, dynamic> _$UserInvitationToJson(_UserInvitation instance) =>
    <String, dynamic>{
      'email': instance.email,
      'userLevel': _$UserLevelEnumMap[instance.userLevel]!,
      'account': instance.account,
    };

const _$UserLevelEnumMap = {
  UserLevel.musher: 'musher',
  UserLevel.handler: 'handler',
  UserLevel.guest: 'guest',
};
