import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mush_on/services/auth.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final BasicLogger logger = BasicLogger();
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
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      String account = await FirestoreService().getUserAccount();
      String path = "accounts/$account/data/kennel/dogs/$uuidRef";
      var ref = db.doc(path);

      var data = {"name": name, "id": uuidRef};

      await ref.set(
        data,
      );
    } catch (e, s) {
      logger.error("Couldn't add dog to db", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> userLoginActions() async {
    User user = AuthService().user!;
    var ref = db.collection("users").doc(user.uid);
    var data = {"last_login": DateTime.now().toUtc()};
    return ref.set(data, SetOptions(merge: true));
  }

  /// Get the user's account name if it exists.
  /// If it doesn't, return null.
  Future<String> getUserAccount() async {
    User user = AuthService().user!;
    var ref = db.doc("users/${user.uid}");
    var snapshot = await ref.get();

    // Check if document exists first
    if (!snapshot.exists) {
      throw Exception("Snapshot doesn't exist");
    }

    var data = snapshot.data();
    if (data == null || data.isEmpty) {
      throw Exception("Snapshot doesn't exist");
    }

    UserName userName = UserName.fromJson(data);
    return userName.account!;
  }
}

class DogsDbOperations {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Dog> getDog(String dogId) async {
    String account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/kennel/dogs/$dogId";
    var doc = await db.doc(path).get();

    if (doc.exists && doc.data() != null) {
      return Dog.fromJson(doc.data()!);
    } else {
      // Dog not found or data is unexpectedly null
      throw Exception("Dog with Id $dogId not found or data is missing.");
    }
  }

  Future<String?> getDogNameFromId(String dogId) async {
    try {
      Dog dog = await getDog(dogId);
      return dog.name;
    } catch (e) {
      return null;
    }
  }

  /// Gets a list of all dog names in alphabetical order.
  Future<List<String>> getAllDogNames() async {
    String account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/kennel/dogs";
    List<String> toReturn = [];
    var ref = db.collection(path);
    ref.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        toReturn.add(doc.get("name"));
      }
    });
    toReturn.sort((a, b) => a.compareTo(b));
    return toReturn;
  }

  /// Gets a Map with a list of dog ID -> Dog object starting from
  /// just a list of Dog Ids.
  Future<Map<String, Dog>> getDogsByIds(List<String> dogIds) async {
    String account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/kennel/dogs";
    List<List<String>> batches = [];
    for (var i = 0; i < dogIds.length; i += 30) {
      batches.add(
          dogIds.sublist(i, i + 30 > dogIds.length ? dogIds.length : i + 30));
    }
    Map<String, Dog> toReturn = {};

    for (var batch in batches) {
      var ref = db.collection(path);
      var query = ref.where(FieldPath.documentId, whereIn: batch);
      await query.get().then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            toReturn[docSnapshot.id] = Dog.fromJson(docSnapshot.data());
          }
        },
      );
    }
    return toReturn;
  }

  /// Gets a Map with a list of dog ID -> Dog object with all dogs.
  Future<Map<String, Dog>> getAllDogsById() async {
    String account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/kennel/dogs";
    Map<String, Dog> toReturn = {};
    try {
      QuerySnapshot querySnapshot = await db.collection(path).get();
      for (var docSnapshot in querySnapshot.docs) {
        try {
          Dog dogObj = Dog.fromJson(docSnapshot.data() as Map<String, dynamic>);
          toReturn[docSnapshot.id] = dogObj;
        } catch (e) {
          print("Error parsing Dog with ID ${docSnapshot.id}: $e");
        }
      }
    } catch (e) {
      print("Error fetching dogs from $path: $e");
      rethrow;
    }
    return toReturn;
  }
}
