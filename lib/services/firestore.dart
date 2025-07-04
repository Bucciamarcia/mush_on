import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mush_on/kennel/dog/dog_photo_card.dart';
import 'package:mush_on/services/auth.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/notes.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/services/storage.dart';
import 'package:path/path.dart' as path;

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

  Future<Map<String, dynamic>?> getDocument(String path) async {
    try {
      var ref = db.doc(path);
      var snapshot = await ref.get();
      return snapshot.data();
    } catch (e, s) {
      logger.error("Couldn't fetch document", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Adds a doc to the db.
  Future<void> addDocToDb(
      {required Map<String, dynamic> payload,
      required String path,
      required bool merge}) async {
    try {
      await db.doc(path).set(payload, SetOptions(merge: merge));
    } catch (e, s) {
      logger.error("Couldn't add doc to db.", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> addDogToDb(Dog dog, File? imageFile) async {
    String account = await FirestoreService().getUserAccount();
    try {
      if (imageFile != null) {
        DogPhotoCardUtils utils =
            DogPhotoCardUtils(id: dog.id, account: account);
        String extension = path.extension(imageFile.path);

        await utils.deleteCurrentImage();
        await StorageService().uploadFromFile(
            file: imageFile,
            path: "accounts/$account/dogs/${dog.id}/image$extension");
      }
      String dogpath = "accounts/$account/data/kennel/dogs/${dog.id}";
      logger.debug("path: $dogpath");
      var ref = db.doc(dogpath);

      var data = dog.toJson();

      await ref.set(
        data,
      );
    } catch (e, s) {
      logger.error("Couldn't add dog to db", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> userLoginActions() async {
    // Skip App Check when offline - it's causing issues
    try {
      // Only do App Check if we might be online
      // Quick timeout to avoid hanging
      await AppCheckInterceptor.ensureAppCheck().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          logger.info('App Check timed out - likely offline');
        },
      );
    } catch (e) {
      logger.info('App Check failed: $e');
      // Continue anyway
    }

    late final User? user;
    try {
      user = AuthService().user;
    } catch (e, s) {
      logger.error("Couldn't fetch user", error: e, stackTrace: s);
      rethrow;
    }

    try {
      var ref = db.collection("users").doc(user?.uid ?? "");
      var data = {"last_login": DateTime.now().toUtc()};

      // Use a timeout to avoid hanging when offline
      await ref.set(data, SetOptions(merge: true)).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Login update timed out - likely offline');
        },
      );
    } catch (e, s) {
      if (e is TimeoutException) {
        logger.info("Login update timed out - continuing offline");
        // Don't rethrow - we can continue offline
      } else {
        logger.error("Couldn't log in", error: e, stackTrace: s);
        // Don't rethrow for offline-related errors
        if (e.toString().contains('offline') ||
            e.toString().contains('network') ||
            e.toString().contains('UNAVAILABLE')) {
          logger.info("Offline - skipping login update");
        } else {
          rethrow;
        }
      }
    }
  }

  /// Get the user's account name if it exists.
  /// If it doesn't, return null.
  Future<String> getUserAccount() async {
    try {
      late final User? user;
      try {
        user = AuthService().user;
      } catch (e, s) {
        logger.error("Couldn't fetch user", error: e, stackTrace: s);
        rethrow;
      }
      var ref = db.doc("users/${user?.uid ?? ""}");
      var snapshot = await ref.get();

      // Check if document exists first
      if (!snapshot.exists) {
        logger.error("Snapshot doesn't exist");
        throw Exception("Snapshot doesn't exist");
      }

      var data = snapshot.data();
      if (data == null || data.isEmpty) {
        logger.error("Snapshot is empty");
        throw Exception("Snapshot is empty");
      }

      UserName userName = UserName.fromJson(data);
      return userName.account ?? "";
    } catch (e, s) {
      logger.error("Couldn't get user account", error: e, stackTrace: s);
      rethrow;
    }
  }
}

class DogsDbOperations {
  BasicLogger logger = BasicLogger();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Dog> getDog(String dogId) async {
    try {
      String account = await FirestoreService().getUserAccount();
      String path = "accounts/$account/data/kennel/dogs/$dogId";
      var doc = await db.doc(path).get();

      if (doc.exists && doc.data() != null) {
        return Dog.fromJson(doc.data()!);
      } else {
        // Dog not found or data is unexpectedly null
        logger.error("Dog with Id $dogId not found or data is missing.");
        throw Exception("Dog with Id $dogId not found or data is missing.");
      }
    } catch (e, s) {
      logger.error("Couldn't get dog", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<String?> getDogNameFromId(String dogId) async {
    try {
      Dog dog = await getDog(dogId);
      return dog.name;
    } catch (e) {
      logger.warning("Couldn't get dog name from id");
      return null;
    }
  }

  /// Gets a list of all dog names in alphabetical order.
  Future<List<String>> getAllDogNames() async {
    try {
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
    } catch (e, s) {
      logger.error("Couldn't get all dog names", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Gets a Map with a list of dog ID -> Dog object starting from
  /// just a list of Dog Ids.
  Future<Map<String, Dog>> getDogsByIds(List<String> dogIds) async {
    try {
      String account = await FirestoreService().getUserAccount();
      String path = "accounts/$account/data/kennel/dogs";
      List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocSnapshots = [];
      List<List<String>> batches = [];
      for (var i = 0; i < dogIds.length; i += 30) {
        batches.add(
          dogIds.sublist(i, i + 30 > dogIds.length ? dogIds.length : i + 30),
        );
      }

      for (var batch in batches) {
        var ref = db.collection(path);
        var query = ref.where(FieldPath.documentId, whereIn: batch);
        var toAdd = await query.get();
        allDocSnapshots
            .addAll(toAdd.docs); // Directly add to the flattened list
      }

      return _processGetDogsByIds(allDocSnapshots);
    } catch (e, s) {
      logger.error("Couldn't get dog by ids", error: e, stackTrace: s);
      rethrow;
    }
  }

  Map<String, Dog> _processGetDogsByIds(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docSnapshots) {
    Map<String, Dog> toReturn = {};
    for (var doc in docSnapshots) {
      toReturn[doc.id] = Dog.fromJson(doc.data());
    }
    return toReturn;
  }

  Future<List<TeamGroup>> getTeamgroups(DateTime? cutoff) async {
    cutoff ??= DateTime.now().toUtc().subtract(Duration(days: 30));
    String account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/teams/history";
    var ref = db.collection(path);
    var snapshot =
        await ref.where("date", isGreaterThanOrEqualTo: cutoff).get();
    var docs = snapshot.docs;
    return docs.map((var doc) => TeamGroup.fromJson(doc.data())).toList();
  }

  Future<void> updateDogPositions(
      {required DogPositions newPositions,
      required String id,
      String? account}) async {
    try {
      account ??= await FirestoreService().getUserAccount();
    } catch (e, s) {
      logger.error("Couldn't fetch account in updateDogPositions",
          error: e, stackTrace: s);
      rethrow;
    }
    String path = "accounts/$account/data/kennel/dogs/$id";
    var doc = db.doc(path);
    Map<String, dynamic> positionsMap = newPositions.toJson();
    try {
      Map<String, dynamic> updates = {};
      positionsMap.forEach((key, value) {
        updates['positions.$key'] = value;
      });
      await doc.update(updates);
      logger.info("Successfully updated dog positions for $id");
    } catch (e, s) {
      logger.error("Couldn't update dog positions", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> changeDogName(
      {required String newName, required String id, String? account}) async {
    try {
      account ??= await FirestoreService().getUserAccount();
    } catch (e, s) {
      logger.error("Couldn't fetch account in changeDogName",
          error: e, stackTrace: s);
      rethrow;
    }
    String path = "accounts/$account/data/kennel/dogs/$id";
    var doc = db.doc(path);
    try {
      await doc.update({"name": newName});
    } catch (e, s) {
      logger.error("Couldn't update dog name in db", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> changeDogTags(
      {required List<Tag> tags, required String id, String? account}) async {
    try {
      account ??= await FirestoreService().getUserAccount();
    } catch (e, s) {
      logger.error("Couldn't fetch account in changeDogName",
          error: e, stackTrace: s);
      rethrow;
    }
    String path = "accounts/$account/data/kennel/dogs/$id";
    var doc = db.doc(path);
    try {
      await doc.update({"tags": tags.map((Tag tag) => tag.toJson()).toList()});
    } catch (e, s) {
      logger.error("Couldn't update tags in db", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> addTag(
      {required Tag tag, required String id, String? account}) async {
    try {
      account ??= await FirestoreService().getUserAccount();
    } catch (e, s) {
      logger.error("Couldn't fetch account in addTag", error: e, stackTrace: s);
      rethrow;
    }

    String path = "accounts/$account/data/kennel/dogs/$id";
    var doc = db.doc(path);

    try {
      var currentDog = await doc.get();
      if (!currentDog.exists) {
        throw Exception("Dog with ID $id not found");
      }

      var dogData = currentDog.data();
      Dog dog = Dog.fromJson(dogData!);
      List<Tag> dogTags = [];
      for (Tag etag in dog.tags) {
        dogTags.add(etag);
      }
      dogTags.add(tag);

      List<Map<String, dynamic>> tagsList =
          dogTags.map((t) => t.toJson()).toList();

      await doc.update({"tags": tagsList});
    } catch (e, s) {
      logger.error("Error updating tags for dog $id", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteTag(
      {required Tag tag, required String id, String? account}) async {
    try {
      account ??= await FirestoreService().getUserAccount();
    } catch (e, s) {
      logger.error("Couldn't fetch account in addTag", error: e, stackTrace: s);
      rethrow;
    }

    String path = "accounts/$account/data/kennel/dogs/$id";
    var doc = db.doc(path);
    try {
      var currentDog = await doc.get();
      if (!currentDog.exists) {
        throw Exception("Dog with ID $id not found");
      }

      var dogData = currentDog.data();
      Dog dog = Dog.fromJson(dogData!);
      List<Tag> dogTags = [];
      for (Tag etag in dog.tags) {
        dogTags.add(etag);
      }
      dogTags.remove(tag);

      List<Map<String, dynamic>> tagsList =
          dogTags.map((t) => t.toJson()).toList();

      await doc.update({"tags": tagsList});
      logger.debug("Tag ${tag.name} removed successfully");
    } catch (e, s) {
      logger.error("Error updating tags for dog $id", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> editTag(
      {required Tag tag, required String id, String? account}) async {
    try {
      account ??= await FirestoreService().getUserAccount();
    } catch (e, s) {
      logger.error("Couldn't fetch account in addTag", error: e, stackTrace: s);
      rethrow;
    }

    String path = "accounts/$account/data/kennel/dogs/$id";
    var doc = db.doc(path);

    try {
      var currentDog = await doc.get();
      if (!currentDog.exists) {
        throw Exception("Dog with ID $id not found");
      }

      var dogData = currentDog.data();
      Dog dog = Dog.fromJson(dogData!);
      List<Tag> newTags = [tag];
      for (Tag oldTag in dog.tags) {
        if (oldTag.id != tag.id) {
          newTags.add(oldTag);
        }
      }
      List<Map<String, dynamic>> tagsList =
          newTags.map((t) => t.toJson()).toList();
      await doc.update({"tags": tagsList});
    } catch (e, s) {
      logger.error("Couldn't edit tag", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> changeBirthday(
      {required DateTime birthday, required String id, String? account}) async {
    try {
      account ??= await FirestoreService().getUserAccount();
    } catch (e, s) {
      logger.error("Couldn't fetch account in addTag", error: e, stackTrace: s);
      rethrow;
    }

    String path = "accounts/$account/data/kennel/dogs/$id";
    var doc = db.doc(path);

    try {
      await doc.update({"birth": birthday});
    } catch (e, s) {
      logger.error("Couldn't change dog birthday", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> changeSex(
      {required DogSex sex, required String id, String? account}) async {
    try {
      account ??= await FirestoreService().getUserAccount();
    } catch (e, s) {
      logger.error("Couldn't fetch account in addTag", error: e, stackTrace: s);
      rethrow;
    }

    String path = "accounts/$account/data/kennel/dogs/$id";
    var doc = db.doc(path);

    try {
      await doc.update({"sex": sex.name});
    } catch (e, s) {
      logger.error("Couldn't change dog birthday", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Deletes a dog from the db
  Future<void> deleteDog(String dogId) async {
    // Reference to the 'dogs' collection
    var account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/kennel/dogs";
    var dogsRef = FirebaseFirestore.instance.collection(path);
    var doc = dogsRef.doc(dogId);
    try {
      await doc.delete();
    } catch (e, s) {
      BasicLogger().error("Can't delete dog", error: e, stackTrace: s);
      throw Exception("Can't delete dog in deleteDog()");
    }
  }

  Future<void> updateCustomFields(
      {required String dogId, required List<CustomField> customFields}) async {
    var account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/kennel/dogs";
    var dogsRef = FirebaseFirestore.instance.collection(path);
    var doc = dogsRef.doc(dogId);
    List<Map<String, dynamic>> payload = [];
    for (CustomField cf in customFields) {
      payload.add(cf.toJson());
    }
    try {
      await doc.update({"customFields": payload});
    } catch (e, s) {
      logger.error("Db error in update custom fields", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateNotes(
      {required String dogId, required List<SingleDogNote> notes}) async {
    var account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/kennel/dogs";
    var dogsRef = FirebaseFirestore.instance.collection(path);
    var doc = dogsRef.doc(dogId);
    List<Map<String, dynamic>> payload = [];
    for (SingleDogNote note in notes) {
      payload.add(note.toJson());
    }
    try {
      await doc.update({"notes": payload});
    } catch (e, s) {
      logger.error("Db error in update notes", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateDistanceWarnings(
      {required List<DistanceWarning> warnings, required String dogId}) async {
    var account = await FirestoreService().getUserAccount();
    String path = "accounts/$account/data/kennel/dogs";
    var dogsRef = FirebaseFirestore.instance.collection(path);
    var doc = dogsRef.doc(dogId);
    List<Map<String, dynamic>> payload = [];
    for (DistanceWarning warning in warnings) {
      payload.add(warning.toJson());
    }
    try {
      await doc.update({"distanceWarnings": payload});
    } catch (e, s) {
      logger.error("Couldn't update distance warnings",
          error: e, stackTrace: s);
      rethrow;
    }
  }
}

class AppCheckInterceptor {
  static Future<void> ensureAppCheck() async {
    if (!kDebugMode) {
      try {
        final token = await FirebaseAppCheck.instance.getToken(false);
        if (token == null) {
          // Force token generation if missing
          await FirebaseAppCheck.instance.getToken(true);
        }
      } catch (e) {
        BasicLogger().error('App Check token error: $e');
      }
    }
  }
}
