import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mush_on/services/auth.dart';
import 'package:mush_on/services/models.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Iterable<Map<String, dynamic>>> getCollection(
      String collectionPath) async {
    var ref = db.collection(collectionPath);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    return data;
  }

  Future<void> userLoginActions() async {
    User user = AuthService().user!;
    var ref = db.collection("users").doc(user.uid);
    var data = {"last_login": DateTime.now().toUtc()};
    return ref.set(data, SetOptions(merge: true));
  }

  Future<String> getUserAccount() async {
    User user = AuthService().user!;
    var ref = db.doc("users/${user.uid}");
    var snapshot = await ref.get();
    UserName userName = UserName.fromJson(snapshot.data() ?? {});
    return userName.account ?? "";
  }
}
