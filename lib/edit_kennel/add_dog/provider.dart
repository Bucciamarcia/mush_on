import 'package:flutter/material.dart';

class AddDogProvider extends ChangeNotifier {
  String name = "";
  Map<String, bool> runPositions = {
    "lead": false,
    "swing": false,
    "team": false,
    "wheel": false,
  };
  final TextEditingController nameController = TextEditingController();

  updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  updatePositions(String position, bool value) {
    runPositions[position] = value;
    notifyListeners();
  }

  updateNameController(String newName) {
    nameController.text = newName;
    notifyListeners();
  }
}
