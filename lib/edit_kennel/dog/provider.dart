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

  // Add these new methods:
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
}
