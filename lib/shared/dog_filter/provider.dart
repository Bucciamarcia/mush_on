import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';

class DogFilterProvider extends ChangeNotifier {
  BasicLogger logger = BasicLogger();
  List<Dog> _dogs = [];
  List<Dog> get dogs => _dogs;
  DogFilterProvider();
  void setDogs(List<Dog> newDogs) {
    _dogs = newDogs;
    notifyListeners();
  }
}
