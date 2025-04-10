import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/services/firestore.dart';
import 'services/models.dart';

class DogProvider extends ChangeNotifier {
  List<Dog> _dogs = [];
  List<Dog> get dogs => _dogs;
  final Map<String, Dog> _dogsById = {};
  Map<String, Dog> get dogsById => _dogsById;

  DogProvider() {
    _fetchDogs();
  }

  void _fetchDogs() async {
    String account = await FirestoreService().getUserAccount();
    FirebaseFirestore.instance
        .collection("accounts/$account/data/kennel/dogs")
        .snapshots()
        .listen((snapshot) {
      _dogs = snapshot.docs.map((doc) => Dog.fromJson(doc.data())).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      _fetchDogsById(_dogs);
      notifyListeners(); // Notify UI to rebuild
    });
  }

  void _fetchDogsById(List<Dog> fetchedDogs) {
    _dogsById.clear();
    for (Dog dog in fetchedDogs) {
      _dogsById.addAll({dog.id: dog});
    }
  }
}
