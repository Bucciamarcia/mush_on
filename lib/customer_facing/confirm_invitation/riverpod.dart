import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/user_level.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'riverpod.g.dart';

class InvitationPreview {
  final String email;
  final String account;
  final UserLevel userLevel;
  final bool accepted;

  const InvitationPreview({
    required this.email,
    required this.account,
    required this.userLevel,
    required this.accepted,
  });

  factory InvitationPreview.fromJson(Map<String, dynamic> json) {
    return InvitationPreview(
      email: json['email'] as String,
      account: json['account'] as String,
      userLevel: UserLevel.values.byName(json['userLevel'] as String),
      accepted: json['accepted'] as bool? ?? false,
    );
  }
}

@riverpod
Future<InvitationPreview> userInvitation(
  Ref ref, {
  required String email,
  required String securityCode,
}) async {
  final functions = FirebaseFunctions.instanceFor(region: "europe-north1");
  try {
    final response = await functions
        .httpsCallable("get_user_invitation_db")
        .call({"email": email, "securityCode": securityCode});
    final data = Map<String, dynamic>.from(response.data as Map);
    return InvitationPreview.fromJson(data);
  } catch (e, s) {
    BasicLogger().error(
      "Error fetching user invitation",
      error: e,
      stackTrace: s,
    );
    rethrow;
  }
}
