import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/home_page/models.dart';
import 'package:mush_on/services/error_handling.dart';

class WhiteboardElementRepository {
  final FirebaseFirestore _db;
  final String collection;
  static final logger = BasicLogger();

  WhiteboardElementRepository({required String account})
      : _db = FirebaseFirestore.instance,
        collection = "accounts/$account/data/homePage/whiteboardElements";

  /// Adds an element to the database. If it exists, it will be OVERWRITTEN.
  Future<void> addElement(WhiteboardElement element) async {
    String id = element.id;
    var doc = _db.doc("$collection/$id");
    try {
      await doc.set(element.toJson());
    } catch (e, s) {
      logger.error("Failed to add whiteboard element.",
          error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteElement(String id) async {
    var doc = _db.doc("$collection/$id");
    try {
      await doc.delete();
    } catch (e, s) {
      logger.error("Failed to delete whiteboard element.",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}
