import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mush_on/services/auth.dart';
import 'package:mush_on/services/models.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Iterable<Map<String, dynamic>>> getCollection(
      String collectionPath) async {
    var ref = db.collection(collectionPath);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    return data;
  }

  Future<void> addDogToDb(String name) async {
    var uuid = Uuid();
    String uuidRef = uuid.v4();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    String account = await FirestoreService().getUserAccount() ?? "";
    String path = "accounts/$account/data/kennel/dogs/$uuidRef";
    var ref = db.doc(path);

    var data = {"name": name, "id": uuidRef};

    await ref.set(
      data,
    );
  }

  Future<void> userLoginActions() async {
    User user = AuthService().user!;
    var ref = db.collection("users").doc(user.uid);
    var data = {"last_login": DateTime.now().toUtc()};
    return ref.set(data, SetOptions(merge: true));
  }

  /// Get the user's account name if it exists.
  /// If it doesn't, return null.
  Future<String?> getUserAccount() async {
    User user = AuthService().user!;
    var ref = db.doc("users/${user.uid}");
    var snapshot = await ref.get();

    // Check if document exists first
    if (!snapshot.exists) {
      return null;
    }

    var data = snapshot.data();
    if (data == null || data.isEmpty) {
      return null;
    }

    UserName userName = UserName.fromJson(data);
    return userName.account;
  }
}

class DogsDbOperations {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Future<Dog> getDog(String dogId) async {
    String account = await FirestoreService().getUserAccount() ?? "";
    if (account.isEmpty) throw Exception("User account not found");
    String path = "accounts/$account/data/kennel/dogs/$dogId";
    var doc = await db.doc(path).get();

    if (doc.exists && doc.data() != null) {
      return Dog.fromJson(doc.data()!);
    } else {
      // Dog not found or data is unexpectedly null
      throw Exception("Dog with Id $dogId not found or data is missing.");
    }
  }
}
