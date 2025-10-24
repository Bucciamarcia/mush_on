import 'package:cloud_functions/cloud_functions.dart';
import 'package:mush_on/services/error_handling.dart';

class ResellerSettingsRepository {
  final functions = FirebaseFunctions.instanceFor(region: "europe-north1");
  final logger = BasicLogger();
  Future<void> inviteReseller(
      String email, int discount, String account) async {
    try {
      await functions.httpsCallable("invite_reseller").call({
        "account": account,
        "discount": discount.toString(),
        "email": email
      });
    } catch (e, s) {
      logger.error("Couldn't invite reseller", error: e, stackTrace: s);
      rethrow;
    }
  }
}
