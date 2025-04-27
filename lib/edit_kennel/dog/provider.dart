import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mush_on/edit_kennel/dog/dog_photo_card.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/storage.dart';
import 'package:path/path.dart' as path;

class SingleDogProvider extends ChangeNotifier {
  String id = "";
  String name = "";
  DogSex sex = DogSex.none;
  DogPositions positions = DogPositions();
  List<Tag> tags = [];
  DateTime? birth;
  List<DogTotal> runTotals = [];
  bool isLoadingTotals = false;
  Uint8List? image;
  bool isLoadingImage = false;
  static BasicLogger logger = BasicLogger();

  SingleDogProvider();

  Future<void> changeName(String newName) async {
    try {
      await DogsDbOperations().changeDogName(newName: newName, id: id);
    } catch (e, s) {
      logger.error("Couldn't change dog name in provider",
          error: e, stackTrace: s);
      rethrow;
    }
    name = newName;
    notifyListeners();
  }

  Future<void> editImage(File file, String account) async {
    isLoadingImage = true;
    notifyListeners();

    try {
      DogPhotoCardUtils utils = DogPhotoCardUtils(id: id, account: account);
      String extension = path.extension(file.path);

      await utils.deleteCurrentImage();
      await StorageService().uploadFromFile(
          file: file, path: "accounts/$account/dogs/$id/image$extension");

      // Update the image after successful edit
      await updateImage();
    } catch (e, s) {
      logger.error("Can't edit image", error: e, stackTrace: s);
      isLoadingImage = false;
      notifyListeners();
      // You could add an error state property here if needed
      rethrow; // Optional: rethrow to let UI handle specific errors if needed
    }
  }

  Future<void> deleteImage(String account) async {
    isLoadingImage = true;
    notifyListeners();

    try {
      await DogPhotoCardUtils(id: id, account: account).deleteCurrentImage();
      // After successful deletion, update image (which will likely be null)
      await updateImage();
    } catch (e, s) {
      logger.error("Image couldn't be deleted", error: e, stackTrace: s);
      isLoadingImage = false;
      notifyListeners();
      rethrow; // Optional: rethrow to let UI handle specific errors if needed
    }
  }

  void initDog(Dog newDog) async {
    id = newDog.id;
    name = newDog.name;
    sex = newDog.sex;
    positions = newDog.positions;
    tags = newDog.tags;
    birth = newDog.birth;

    updateImage();

    // Start loading totals
    isLoadingTotals = true;
    notifyListeners();

    // Fetch totals asynchronously
    await DogTotal.getDogTotals(id: newDog.id).then((totals) {
      runTotals = totals;
      isLoadingTotals = false;
      notifyListeners();
    }).catchError((e, s) {
      logger.error("Couldn't get distances for provider",
          error: e, stackTrace: s);
      isLoadingTotals = false;
      notifyListeners();
    });
  }

  void updateDog(Dog newDog) {
    id = newDog.id;
    name = newDog.name;
    sex = newDog.sex;
    positions = newDog.positions;
    tags = newDog.tags;
    birth = newDog.birth;
    notifyListeners();
  }

  Future<void> updateImage() async {
    isLoadingImage = true;
    notifyListeners();
    String account = await FirestoreService().getUserAccount();
    image = await DogPhotoCardUtils(id: id, account: account).getImage();
    isLoadingImage = false;
    notifyListeners();
  }

  Future<void> updatePositions(
      DogPositions newPositions, String account) async {
    try {
      logger.debug("New positions in provider: ${newPositions.toString()}");
      await DogsDbOperations().updateDogPositions(
          newPositions: newPositions, id: id, account: account);
    } catch (e, s) {
      logger.error("Provider couldn't update positions",
          error: e, stackTrace: s);
      rethrow;
    }
    positions = newPositions;
    notifyListeners();
  }

  Future<void> updateTags(List<Tag> newTags) async {
    try {
      await DogsDbOperations().changeDogTags(tags: newTags, id: id);
    } catch (e, s) {
      logger.error("Couldn't update tags in provider", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> addTag(Tag tag) async {
    try {
      await DogsDbOperations().addTag(tag: tag, id: id);
    } catch (e, s) {
      logger.error("Couldn't update tags in provider", error: e, stackTrace: s);
      rethrow;
    }
    tags = List<Tag>.from(tags)..add(tag);
    notifyListeners();
  }

  Future<void> deleteTag(Tag tag) async {
    try {
      await DogsDbOperations().deleteTag(tag: tag, id: id);
    } catch (e, s) {
      logger.error("Couldn't delete tag ${tag.id}", error: e, stackTrace: s);
      rethrow;
    }
    tags = List<Tag>.from(tags)..remove(tag);
    notifyListeners();
  }

  /// Will find a tag with the same ID, and replace all values.
  Future<void> editTag(Tag newTag) async {
    try {
      await DogsDbOperations().editTag(tag: newTag, id: id);
    } catch (e, s) {
      logger.error("Couldn't update tag ${newTag.id}", error: e, stackTrace: s);
      rethrow;
    }
    List<Tag> newTags = [newTag];
    for (Tag oldTag in tags) {
      if (oldTag.id != newTag.id) {
        newTags.add(oldTag);
      }
    }
    tags = newTags;
    notifyListeners();
  }
}
