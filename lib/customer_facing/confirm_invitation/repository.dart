import 'package:cloud_functions/cloud_functions.dart';
import 'package:mush_on/services/error_handling.dart';

class ConfirmInvitationRepository {
  final FirebaseFunctions functions;
  final logger = BasicLogger();

  ConfirmInvitationRepository({FirebaseFunctions? functions})
    : functions =
          functions ?? FirebaseFunctions.instanceFor(region: "europe-north1");

  Future<void> acceptInvitation({
    required String email,
    required String securityCode,
  }) async {
    try {
      await functions.httpsCallable("accept_invitation").call({
        "email": email,
        "securityCode": securityCode,
      });
    } catch (e, s) {
      logger.error("Couldn't set the new user", error: e, stackTrace: s);
      rethrow;
    }
  }
}
