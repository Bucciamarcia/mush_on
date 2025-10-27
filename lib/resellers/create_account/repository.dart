import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/resellers/models.dart';
import 'package:mush_on/services/error_handling.dart';

class CreateResellerAccountDataRepository {
  final db = FirebaseFirestore.instance;
  final logger = BasicLogger();

  Future<void> putData(
      {required String uid, required ResellerData data}) async {
    final path = "users/$uid/reseller/data";
    final doc = db.doc(path);
    try {
      await doc.set(data.toJson());
    } catch (e, s) {
      logger.error("Couldn't put data in reseller data",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}
