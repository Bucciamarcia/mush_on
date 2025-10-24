// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'username.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserName _$UserNameFromJson(Map<String, dynamic> json) => _UserName(
      lastLogin:
          const TimestampConverter().fromJson(json['lastLogin'] as Timestamp?),
      account: json['account'] as String?,
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String? ?? "",
      userLevel: $enumDecodeNullable(_$UserLevelEnumMap, json['userLevel']) ??
          UserLevel.handler,
      userType: $enumDecodeNullable(_$UserTypeEnumMap, json['userType']) ??
          UserType.musher,
    );

Map<String, dynamic> _$UserNameToJson(_UserName instance) => <String, dynamic>{
      'lastLogin': const TimestampConverter().toJson(instance.lastLogin),
      'account': instance.account,
      'uid': instance.uid,
      'email': instance.email,
      'name': instance.name,
      'userLevel': _$UserLevelEnumMap[instance.userLevel]!,
      'userType': _$UserTypeEnumMap[instance.userType]!,
    };

const _$UserLevelEnumMap = {
  UserLevel.musher: 'musher',
  UserLevel.handler: 'handler',
  UserLevel.guest: 'guest',
};

const _$UserTypeEnumMap = {
  UserType.musher: 'musher',
  UserType.reseller: 'reseller',
};
