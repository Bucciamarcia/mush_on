import 'package:flutter/material.dart';

class AddDogProvider extends ChangeNotifier {
  String name = "";
  final TextEditingController nameController = TextEditingController();

  updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  updateNameController(String newName) {
    nameController.text = newName;
    notifyListeners();
  }
}
