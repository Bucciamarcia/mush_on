import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';

class ConfirmInvitationRepository {
  final db = FirebaseFirestore.instance;
  final logger = BasicLogger();
  Future<void> createAccount(UserName user) async {
    final path = "users/${user.uid}";
    try {
      await db.doc(path).set(user.toJson());
    } catch (e, s) {
      logger.error("Couldn't set the new user", error: e, stackTrace: s);
      rethrow;
    }
  }
}
