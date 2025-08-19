import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/kennel/dog/dog_photo_card.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/notes.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/services/storage.dart';
import 'package:path/path.dart' as path;
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

  Future<void> addDogToDb(Dog dog, File? imageFile, String account) async {
    if (dog.id == "") {
      dog = dog.copyWith(id: const Uuid().v4());
    }
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
}

class DogsDbOperations {
  BasicLogger logger = BasicLogger();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Dog> getDog(String dogId, String account) async {
    try {
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

  Future<String?> getDogNameFromId(String dogId, String account) async {
    try {
      Dog dog = await getDog(dogId, account);
      return dog.name;
    } catch (e) {
      logger.warning("Couldn't get dog name from id");
      return null;
    }
  }

  /// Gets a list of all dog names in alphabetical order.
  Future<List<String>> getAllDogNames(String account) async {
    try {
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
  Future<Map<String, Dog>> getDogsByIds(
      List<String> dogIds, String account) async {
    try {
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

  Future<TeamGroupWorkspace> getTeamGroupWorkspace(
      {required String account, required String id}) async {
    var doc = db.doc("accounts/$account/data/teams/history/$id");
    var snapshot = await doc.get();
    var tg = snapshot.data() ?? {};
    var toReturn = TeamGroupWorkspace.fromJson(tg);

    // Now get the teams with its dogpairs.
    var collection = db
        .collection("accounts/$account/data/teams/history/$id/teams")
        .orderBy("rank");
    var teamsSnapshot = await collection.get();
    var teamsDocs = teamsSnapshot.docs;
    List<TeamWorkspace> teams = [];
    for (var team in teamsDocs) {
      var tempTeam = TeamWorkspace.fromJson(team.data());

      // Now handle all its dogpairs
      var dpCollection = db
          .collection(
              "accounts/$account/data/teams/history/$id/teams/${tempTeam.id}/dogPairs")
          .orderBy("rank");
      var dpSnapshot = await dpCollection.get();
      var dpDocs = dpSnapshot.docs;
      for (var dp in dpDocs) {
        tempTeam = tempTeam.copyWith(dogPairs: [
          ...tempTeam.dogPairs,
          DogPairWorkspace.fromJson(dp.data())
        ]);
      }
      teams = [...teams, tempTeam];
    }
    toReturn = toReturn.copyWith(teams: teams);
    return toReturn;
  }

  Future<void> updateDogPositions(
      {required DogPositions newPositions,
      required String id,
      required String account}) async {
    try {} catch (e, s) {
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
      {required String newName,
      required String id,
      required String account}) async {
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
      {required List<Tag> tags,
      required String id,
      required String account}) async {
    try {} catch (e, s) {
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
      {required Tag tag, required String id, required String account}) async {
    try {} catch (e, s) {
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
      {required Tag tag, required String id, required String account}) async {
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
      {required Tag tag, required String id, required String account}) async {
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
      {required DateTime birthday,
      required String id,
      required String account}) async {
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
      {required DogSex sex,
      required String id,
      required String account}) async {
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
  Future<void> deleteDog(String dogId, String account) async {
    // Delete the dog's data on storage
    var imagesPath = "accounts/$account/dogs/$dogId";
    try {
      logger.info("Getting files");
      var files = await StorageService().listFilesInFolder(imagesPath);
      logger.info("Files: $files");
      for (var file in files) {
        logger.info("Deleting file: $file");
        await StorageService().deleteFile("$imagesPath/$file");
      }
    } catch (e, s) {
      BasicLogger()
          .error("Couldn't delete dog's files", error: e, stackTrace: s);
      rethrow;
    }
    // Reference to the 'dogs' collection
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
