import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:uuid/uuid.dart';
import 'services/models.dart';

class MainProvider extends ChangeNotifier {
  final BasicLogger _logger = BasicLogger();
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

  TasksInMemory _tasks = TasksInMemory();

  /// The list of tasks.
  TasksInMemory get tasks => _tasks;

  bool loaded = false;

  MainProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Await all initial data fetches together.
      // They will run in parallel, which is very efficient.
      await Future.wait([
        _fetchDogs(),
        _fetchAccount(),
        _fetchSettings(),
        _fetchTasks(),
      ]);
    } catch (e, s) {
      _logger.error("An error occurred during initial data load",
          error: e, stackTrace: s);
      throw Exception("Error: couldn't initialize the app.");
    } finally {
      // Once all fetches are complete (or have failed), update the state.
      loaded = true;
      notifyListeners();
    }
  }

  Future<void> addTask(Task newTask) async {
    Task taskToSave = newTask.copyWith(id: Uuid().v4());
    try {
      await TaskRepository.addOrUpdate(taskToSave, _account);
    } catch (e, s) {
      _logger.error("Couldn't add task to db", error: e, stackTrace: s);
      rethrow;
    }
    List<Task> newTasks = [..._tasks.tasks, taskToSave];
    newTasks.sort((a, b) => a.title.compareTo(b.title));
    _tasks = _tasks.copyWith(tasks: newTasks);
    notifyListeners();
  }

  Future<void> deleteTask(String tid) async {
    try {
      await TaskRepository.delete(tid, _account);
    } catch (e, s) {
      _logger.error("Couldn't add task to db", error: e, stackTrace: s);
      rethrow;
    }
    var newTasks = List<Task>.from(_tasks.tasks);
    newTasks.removeWhere((t) => t.id == tid);
    _tasks = _tasks.copyWith(tasks: newTasks);
    notifyListeners();
  }

  Future<void> editTask(Task editedTask) async {
    try {
      await TaskRepository.addOrUpdate(editedTask, _account);
    } catch (e, s) {
      _logger.error("Couldn't edit task", error: e, stackTrace: s);
      rethrow;
    }

    // Update the task in the list
    List<Task> newTasks = List.from(_tasks.tasks);
    newTasks.removeWhere((t) => t.id == editedTask.id);
    newTasks.add(editedTask);
    newTasks.sort((a, b) => a.title.compareTo(b.title));
    _tasks = _tasks.copyWith(tasks: newTasks);

    // Create next occurrence for recurring tasks when marked as done
    if (editedTask.isDone &&
        editedTask.expiration != null &&
        editedTask.recurring != RecurringType.none) {
      // Create new task for next occurrence
      Task nextOccurrence = editedTask.copyWith(
        id: '', // Let the repository generate a new ID
        isDone: false, // Next occurrence starts as not done
        expiration: editedTask.expiration!.add(
          (Duration(days: editedTask.recurring.interval)),
        ),
      );

      // Add the next occurrence
      await addTask(nextOccurrence);
    }

    notifyListeners();
  }

  Future<void> _fetchAccount() async {
    if (_account.isEmpty) {
      _account = await FirestoreService().getUserAccount();
    }
    notifyListeners();
  }

  Future<void> _fetchSettings() async {
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
  Future<void> _fetchDogs() async {
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

  /// Initial fetch of tasks. Only gets the last 30 days.
  Future<void> _fetchTasks() async {
    List<Task> newTasks = [];
    if (_account.isEmpty) {
      _account = await FirestoreService().getUserAccount();
    }
    String path = "accounts/$account/data/misc/tasks";
    var collection = FirebaseFirestore.instance.collection(path);
    var snapshot = await collection
        .where("expiration",
            isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 30)))
        .get();
    var docs = snapshot.docs;
    for (var doc in docs) {
      Map<String, dynamic> data = doc.data();
      newTasks.add(Task.fromJson(data));
    }
    var snapshotNoExpirtion =
        await collection.where("expiration", isNull: true).get();
    var docsNoExpiration = snapshotNoExpirtion.docs;
    for (var docNoExpiration in docsNoExpiration) {
      Map<String, dynamic> dataNoExpiration = docNoExpiration.data();
      newTasks.add(Task.fromJson(dataNoExpiration));
    }
    newTasks.sort((a, b) => a.title.compareTo(b.title));
    _tasks = TasksInMemory(
      tasks: newTasks,
      oldestFetched: DateTime.now().subtract(Duration(days: 30)),
      noExpirationFetched: true,
    );
    notifyListeners();
  }

  void _fetchDogsById(List<Dog> fetchedDogs) {
    _dogsById.clear();
    for (Dog dog in fetchedDogs) {
      _dogsById.addAll({dog.id: dog});
    }
  }

  Future<void> fetchOlderTasks(DateTime date) async {
    // If oldestFetched is null, it's already got everything.
    // Can safely return.
    if (_tasks.oldestFetched == null) {
      return;
    }
    List<Task> newTasks = [];
    if (_account.isEmpty) {
      _account = await FirestoreService().getUserAccount();
    }
    String path = "accounts/$account/data/misc/tasks";
    var collection = FirebaseFirestore.instance.collection(path);
    var snapshot = await collection
        .where("expiration", isGreaterThanOrEqualTo: date)
        .where("expiration",
            isLessThan:
                _tasks.oldestFetched!) // No need to fetch docs we already have.
        .get();
    var docs = snapshot.docs;
    for (var doc in docs) {
      Map<String, dynamic> data = doc.data();
      newTasks.add(Task.fromJson(data));
    }

    // Now we sort again
    List<Task> tasksToSort = [..._tasks.tasks, ...newTasks];
    tasksToSort.sort((a, b) => a.title.compareTo((b.title)));
    _tasks = _tasks.copyWith(tasks: tasksToSort, oldestFetched: date);
    notifyListeners();
  }
}
