import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'username.g.dart';

@JsonSerializable()

/// This class represents a user in the database.
class UserName {
  @JsonKey(name: 'last_login', fromJson: _timestampToDateTime)
  final DateTime lastLogin;

  final String? account;

  UserName({required this.lastLogin, this.account});

  // Converter for Timestamp to DateTime
  static DateTime _timestampToDateTime(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    throw ArgumentError('Expected Timestamp');
  }

  factory UserName.fromJson(Map<String, dynamic> json) =>
      _$UserNameFromJson(json);
  Map<String, dynamic> toJson() => _$UserNameToJson(this);
}
