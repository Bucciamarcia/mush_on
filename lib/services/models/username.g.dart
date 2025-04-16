// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'username.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserName _$UserNameFromJson(Map<String, dynamic> json) => UserName(
      lastLogin: UserName._timestampToDateTime(json['last_login']),
      account: json['account'] as String?,
    );

Map<String, dynamic> _$UserNameToJson(UserName instance) => <String, dynamic>{
      'last_login': instance.lastLogin.toIso8601String(),
      'account': instance.account,
    };
