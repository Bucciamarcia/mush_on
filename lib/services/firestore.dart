import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Iterable<Map<String, dynamic>>> getCollection(
      String collectionPath) async {
    var ref = db.collection(collectionPath);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    return data;
  }
}
