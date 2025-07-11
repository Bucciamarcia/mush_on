import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/models/custom_converters.dart';
part 'username.g.dart';
part 'username.freezed.dart';

@freezed

/// This class represents a user in the database.
sealed class UserName with _$UserName {
  const factory UserName({
    @TimestampConverter() DateTime? lastLogin,
    String? account,
    required String uid,
    required String email,
  }) = _UserName;

  const UserName._();

  factory UserName.fromJson(Map<String, dynamic> json) =>
      _$UserNameFromJson(json);
}
