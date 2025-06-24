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

  MainProvider() {
    _fetchDogs();
    _fetchAccount();
    _fetchSettings();
    _fetchTasks();
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
      // Calculate next occurrence date
      DateTime nextDate = _calculateNextOccurrence(
          editedTask.expiration!, editedTask.recurring);

      // Create new task for next occurrence
      Task nextOccurrence = editedTask.copyWith(
        id: '', // Let the repository generate a new ID
        isDone: false, // Next occurrence starts as not done
        expiration: nextDate,
      );

      // Add the next occurrence
      await addTask(nextOccurrence);
    }

    notifyListeners();
  }

// Helper method to calculate next occurrence date
  DateTime _calculateNextOccurrence(
      DateTime currentDate, RecurringType recurring) {
    switch (recurring) {
      case RecurringType.daily:
        return currentDate.add(Duration(days: 1));
      case RecurringType.weekly:
        return currentDate.add(Duration(days: 7));
      case RecurringType.monthly:
        // Handle month-end edge cases
        DateTime nextMonth = DateTime(
          currentDate.year,
          currentDate.month + 1,
          currentDate.day,
        );
        // If the day doesn't exist in next month (e.g., Jan 31 -> Feb 31),
        // use the last day of the next month
        if (nextMonth.month > currentDate.month + 1 ||
            nextMonth.year > currentDate.year) {
          nextMonth = DateTime(
            currentDate.month == 12 ? currentDate.year + 1 : currentDate.year,
            currentDate.month == 12 ? 1 : currentDate.month + 1 + 1,
            0, // 0 gives us the last day of the previous month
          );
        }
        return nextMonth;
      case RecurringType.yearly:
        return DateTime(
          currentDate.year + 1,
          currentDate.month,
          currentDate.day,
        );
      case RecurringType.none:
        return currentDate; // Should never reach here
    }
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

  /// Initial fetch of tasks. Only gets the last 30 days.
  void _fetchTasks() async {
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
