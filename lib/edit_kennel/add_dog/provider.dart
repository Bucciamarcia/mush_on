import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models.dart';
import 'package:uuid/uuid.dart';

class AddDogProvider extends ChangeNotifier {
  BasicLogger logger = BasicLogger();
  String name = "";
  DogPositions positions = DogPositions();
  bool isLoadingImage = false;
  File? imageFile;
  Uint8List? image;
  String account = "";
  final TextEditingController nameController = TextEditingController();
  String id = "";

  Dog get dog => Dog(id: id, name: name, positions: positions);

  void init() async {
    account = await FirestoreService().getUserAccount();
    var uuid = Uuid();
    id = uuid.v4();
  }

  updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  updateNameController(String newName) {
    nameController.text = newName;
    notifyListeners();
  }

  void deleteImage() {
    image = null;
    imageFile = null;
    notifyListeners();
  }

  Future<void> editImage(File file) async {
    imageFile = file;
    image = await file.readAsBytes();
    notifyListeners();
  }

  void updatePositions(DogPositions newPositions) {
    logger.debug("New positions in provider: ${newPositions.toString()}");
    positions = newPositions;
    notifyListeners();
  }
}
