import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'services/models.dart';

class MainProvider extends ChangeNotifier {
  BasicLogger _logger = BasicLogger();
  List<Dog> _dogs = [];

  /// A list of dogs in alphabetica order.
  List<Dog> get dogs => _dogs;
  final Map<String, Dog> _dogsById = {};
  Map<String, Dog> get dogsById => _dogsById;
  String _account = "";

  /// The name of the account.
  String get account => _account;

  SettingsModel _settings = SettingsModel();

  /// The account settings.
  SettingsModel get settings => _settings;

  List<Task> _tasks = [];

  /// The list of tasks.
  List<Task> get tasks => _tasks;

  MainProvider() {
    _fetchDogs();
    _fetchAccount();
    _fetchSettings();
    _fetchTasks();
  }

  Future<void> addTask(Task newTask) async {
    try {
      await TaskRepository.addOrUpdate(newTask, _account);
    } catch (e, s) {
      _logger.error("Couldn't add task to db", error: e, stackTrace: s);
      rethrow;
    }
    _tasks = [..._tasks, newTask];
    notifyListeners();
  }

  void _fetchAccount() async {
    if (_account.isEmpty) {
      _account = await FirestoreService().getUserAccount();
    }
    notifyListeners();
  }

  void _fetchSettings() async {
    if (_account.isEmpty) {
      _account = await FirestoreService().getUserAccount();
    }
    String path = "accounts/$account/data/settings";
    var doc = FirebaseFirestore.instance.doc(path);
    doc.snapshots().listen((s) {
      if (s.exists && s.data() != null) {
        _settings = SettingsModel.fromJson(s.data()!);
        notifyListeners();
      }
    });
  }

  /// Returns a list of dogs ordere by alphabetical order
  void _fetchDogs() async {
    String account = await FirestoreService().getUserAccount();
    FirebaseFirestore.instance
        .collection("accounts/$account/data/kennel/dogs")
        .snapshots()
        .listen((snapshot) {
      _dogs = snapshot.docs.map((doc) => Dog.fromJson(doc.data())).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      _fetchDogsById(_dogs);
      notifyListeners();
    });
  }

  void _fetchTasks() async {
    if (_account.isEmpty) {
      _account = await FirestoreService().getUserAccount();
    }
    String path = "accounts/$account/data/misc/tasks";
    var collection = FirebaseFirestore.instance.collection(path);
    var snapshot = await collection.get();
    var docs = snapshot.docs;
    for (var doc in docs) {
      Map<String, dynamic> data = doc.data();
      _tasks.add(Task.fromJson(data));
    }
    notifyListeners();
  }

  void _fetchDogsById(List<Dog> fetchedDogs) {
    _dogsById.clear();
    for (Dog dog in fetchedDogs) {
      _dogsById.addAll({dog.id: dog});
    }
  }
}
