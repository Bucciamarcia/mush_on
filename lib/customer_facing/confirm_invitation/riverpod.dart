import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/settings/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'riverpod.g.dart';

@riverpod
Future<UserInvitation> userInvitation(Ref ref, {required String email}) async {
  final functions = FirebaseFunctions.instanceFor(region: "europe-north1");
  try {
    final response = await functions
        .httpsCallable("get_user_invitation_db")
        .call({"email": email});
    final data = response.data as Map<String, dynamic>;
    return UserInvitation.fromJson(data);
  } catch (e, s) {
    BasicLogger()
        .error("Error fetching user invitation", error: e, stackTrace: s);
    rethrow;
  }
}
