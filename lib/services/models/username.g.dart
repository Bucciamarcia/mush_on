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
    );

Map<String, dynamic> _$UserNameToJson(_UserName instance) => <String, dynamic>{
      'lastLogin': const TimestampConverter().toJson(instance.lastLogin),
      'account': instance.account,
      'uid': instance.uid,
      'email': instance.email,
    };
