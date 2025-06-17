import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mush_on/kennel/dog/dog_photo_card.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/notes.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
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
  String account = "";
  List<CustomField> customFields = [];
  List<SingleDogNote> notes = [];
  static BasicLogger logger = BasicLogger();

  SingleDogProvider();

  void initDog(Dog newDog) async {
    id = newDog.id;
    name = newDog.name;
    sex = newDog.sex;
    positions = newDog.positions;
    tags = newDog.tags;
    birth = newDog.birth;
    customFields = newDog.customFields;
    notes = newDog.notes;
    account = await FirestoreService().getUserAccount();

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

  Future<void> addCustomField(CustomField newCf) async {
    List<CustomField> updatedCf = [];
    for (CustomField cf in customFields) {
      updatedCf.add(cf);
    }
    updatedCf.removeWhere((t) => t.templateId == newCf.templateId);
    updatedCf.add(newCf);
    try {
      await DogsDbOperations()
          .updateCustomFields(dogId: id, customFields: updatedCf);
      customFields = updatedCf;
      notifyListeners();
    } catch (e, s) {
      logger.error("Couldn't add custom field", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteCustomField(String templateId) async {
    List<CustomField> updatedCf = [];
    for (CustomField cf in customFields) {
      updatedCf.add(cf);
    }
    updatedCf.removeWhere((t) => t.templateId == templateId);
    try {
      await DogsDbOperations()
          .updateCustomFields(dogId: id, customFields: updatedCf);
      customFields = updatedCf;
      notifyListeners();
    } catch (e, s) {
      logger.error("Couldn't delete custom field", error: e, stackTrace: s);
      rethrow;
    }
  }

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

  Future<void> editImage(File file) async {
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

  Future<void> deleteImage() async {
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

  void updateDog(Dog newDog) {
    id = newDog.id;
    name = newDog.name;
    sex = newDog.sex;
    positions = newDog.positions;
    tags = newDog.tags;
    birth = newDog.birth;
    notes = newDog.notes;
    notifyListeners();
  }

  Future<void> updateImage() async {
    isLoadingImage = true;
    notifyListeners();
    image = await DogPhotoCardUtils(id: id, account: account).getImage();
    isLoadingImage = false;
    notifyListeners();
  }

  Future<void> updatePositions(DogPositions newPositions) async {
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

  Future<void> changeBirthday(DateTime birthday) async {
    try {
      await DogsDbOperations().changeBirthday(birthday: birthday, id: id);
    } catch (e, s) {
      logger.error("Couldn't change dog birthday", error: e, stackTrace: s);
      rethrow;
    }
    birth = birthday;
    logger.info("changed birthday");
    notifyListeners();
  }

  Future<void> changeSex(DogSex newSex) async {
    try {
      await DogsDbOperations().changeSex(sex: newSex, id: id);
    } catch (e, s) {
      logger.error("Couldn't change dog sex", error: e, stackTrace: s);
      rethrow;
    }
    sex = newSex;
    logger.info("changed sex");
    notifyListeners();
  }

  Future<void> deleteDog() async {
    try {
      await DogsDbOperations().deleteDog(id);
    } catch (e, s) {
      logger.error("Couldn't delete dog with id $id", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// First, checks if the note ID exists. If it does, it replaces the note.
  /// If it doesn't, it adds a new one.
  Future<void> addNote(SingleDogNote newNote) async {
    List<SingleDogNote> updatedNotes = [];
    for (SingleDogNote note in notes) {
      updatedNotes.add(note);
    }
    updatedNotes.removeWhere((note) => note.id == newNote.id);
    updatedNotes.add(newNote);
    try {
      await DogsDbOperations().updateNotes(dogId: id, notes: updatedNotes);
      notes = updatedNotes;
      notifyListeners();
    } catch (e, s) {
      logger.error("Coudn't update notes", error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteNote(String noteId) async {
    List<SingleDogNote> updatedNotes = [];
    for (SingleDogNote note in notes) {
      updatedNotes.add(note);
    }
    updatedNotes.removeWhere((note) => note.id == noteId);
    try {
      await DogsDbOperations().updateNotes(dogId: id, notes: updatedNotes);
      notes = updatedNotes;
      notifyListeners();
    } catch (e, s) {
      logger.error("Couldn't remove note", error: e, stackTrace: s);
      rethrow;
    }
  }
}
