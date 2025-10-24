import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/models/custom_converters.dart';
import 'package:mush_on/services/models/user_level.dart';
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
    @Default("") String name,

    /// Used to restrict access to sensitive info.
    @Default(UserLevel.handler) UserLevel userLevel,

    /// If he's a musher (normal access) or reseller. Defaults to musher.
    @Default(UserType.musher) UserType userType,
  }) = _UserName;

  const UserName._();

  factory UserName.fromJson(Map<String, dynamic> json) =>
      _$UserNameFromJson(json);
}

@JsonEnum()
enum UserType {
  /// A musher or handler, or someone who needs regular access
  musher,

  /// A business entity that sells B2B a kennel's tours
  reseller
}
