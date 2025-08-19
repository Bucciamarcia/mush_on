import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/home_page/models.dart';
import 'package:mush_on/services/error_handling.dart';

class PermanentWhiteboardRepository {
  final String account;
  static final logger = BasicLogger();
  PermanentWhiteboardRepository({required this.account});

  /// Sets an element, replacing it if one with the same ID is already there.
  Future<void> setElement(WhiteboardElement element) async {
    String path = "accounts/$account/data/whiteboard/elements";
    final db = FirebaseFirestore.instance;
    final collection = db.collection(path);
    try {
      await collection.doc(element.id).set(element.toJson());
    } catch (e, s) {
      logger.error("Couldn't set permanent element", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Deletes an element by its id.
  Future<void> deleteElement(String id) async {
    String path = "accounts/$account/data/whiteboard/elements";
    final db = FirebaseFirestore.instance;
    final collection = db.collection(path);
    try {
      await collection.doc(id).delete();
    } catch (e, s) {
      logger.error("Couldn't delete permanent element",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}
