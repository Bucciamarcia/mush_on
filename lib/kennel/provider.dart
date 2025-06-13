import 'package:flutter/cupertino.dart';
import '../services/models/dog.dart';

class KennelProvider extends ChangeNotifier {
  List<Dog> displayDogList = [];

  void setDisplayDogList(List<Dog> d) {
    d.sort((a, b) => a.name.compareTo(b.name));
    displayDogList = d;
    notifyListeners();
  }
}
