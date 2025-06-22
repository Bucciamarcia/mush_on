import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:uuid/uuid.dart';
import 'custom_converters.dart';
part "tasks.g.dart";
part "tasks.freezed.dart";

@freezed

/// A task of the todo system
abstract class Task with _$Task {
  @JsonSerializable(explicitToJson: true)
  const factory Task({
    /// The uuid of the task.
    @Default("") String id,

    /// The title of the task.
    @Default("") String title,

    /// The more lengthy description of the title.
    @Default("") String description,

    /// The expiration date of the task (if present).
    @TimestampConverter() DateTime? expiration,

    /// Has the task been completed?
    @Default(false) bool isDone,

    /// Mark for "all day" task?
    @Default(true) bool isAllDay,

    /// Is this task urgent?
    @Default(false) bool isUrgent,

    /// If this is a recurring task, and how often it repeats.
    @Default(RecurringType.none) RecurringType recurring,

    /// If recurring, the dates that are checked.
    @TimestampListConverter()
    @Default(<DateTime>[])
    List<DateTime> recurringDone,

    /// The ID of the dog this task relates to.
    String? dogId,
  }) = _Task;
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

@JsonEnum()
enum RecurringType {
  @JsonValue("daily")
  daily,
  @JsonValue("weekly")
  weekly,
  @JsonValue("monthly")
  monthly,
  @JsonValue("yearly")
  yearly,
  @JsonValue("none")
  none;
}

/// All the operations on the Task class.
class TaskRepository {
  /// Adds a task to the db if it doesn't exist, or overwrites it completely if it doesn't.
  static Future<void> addOrUpdate(Task task, String account) async {
    var db = FirebaseFirestore.instance;
    if (account.isEmpty) {
      account = await FirestoreService().getUserAccount();
    }
    String path = "accounts/$account/data/misc/tasks";
    var collection = db.collection(path);
    Task taskToSave = task;
    if (task.id.isEmpty) {
      taskToSave = task.copyWith(id: Uuid().v4());
    }
    var doc = collection.doc(taskToSave.id);
    var payload = taskToSave.toJson();
    try {
      await doc.set(payload);
    } catch (e, s) {
      BasicLogger().error(
          "Couldn't set the document: addOrUpdate TaskRespository",
          error: e,
          stackTrace: s);
      rethrow;
    }
  }
}

extension TaskListExtension on List<Task> {
  /// Filters only tasks that are due today.
  List<Task> get dueToday {
    final now = DateTime.now();
    return where((t) {
      bool hasExpiration = t.expiration != null;
      bool isToday = hasExpiration &&
          t.expiration!.year == now.year &&
          t.expiration!.month == now.month &&
          t.expiration!.day == now.day;

      return hasExpiration && isToday;
    }).toList();
  }

  /// Filters only tasks that are due today or overdue.
  List<Task> get dueTodayOrOverdue {
    final now = DateTime.now();
    return where((t) {
      bool hasExpiration = t.expiration != null;
      bool isToday = hasExpiration &&
          t.expiration!.year == now.year &&
          t.expiration!.month == now.month &&
          t.expiration!.day == now.day;

      bool hasExpirationAndToday = hasExpiration && isToday;

      bool isOverdue = t.expiration != null &&
          t.expiration!.isBefore(DateTime.now()) &&
          t.isDone == false;

      return hasExpirationAndToday || isOverdue;
    }).toList();
  }

  /// Filters and keeps only the tasks with no expiration.
  List<Task> get dontExpire => where((t) => t.expiration == null).toList();

  /// Filters and keeps only the tasks that are not done yet.
  List<Task> get notDone => where((t) => t.isDone == false).toList();

  /// Filters only the urgent tasks.
  List<Task> get urgent => where((t) => t.isUrgent).toList();

  /// Filter tasks that have an expiration date (expiration != null).
  List<Task> get haveExpiration => where((t) => t.expiration != null).toList();

  /// Gets the date of the oldest task expiration.
  DateTime get oldestExpiration {
    List<Task> tasksCopy = List.from(this);
    tasksCopy.removeWhere((t) => t.expiration == null);
    tasksCopy.sort((a, b) => a.expiration!.compareTo(b.expiration!));
    return tasksCopy.first.expiration!;
  }

  /// Returns the same list but with urgent tasks first.
  List<Task> urgentFirst() {
    List<Task> urgentTasks = [];
    List<Task> normalTasks = [];

    for (Task task in this) {
      if (task.isUrgent) {
        urgentTasks.add(task);
      } else {
        normalTasks.add(task);
      }
    }
    return [...urgentTasks, ...normalTasks];
  }

  /// Returns the tasks of the next X days, excluding today.
  List<Task> nextDays(int n) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(Duration(days: 1));
    DateTime endDate = tomorrow.add(Duration(days: n));

    return where((t) {
      if (t.expiration == null) {
        return false;
      }
      return t.expiration!.compareTo(tomorrow) >= 0 &&
          t.expiration!.compareTo(endDate) < 0;
    }).toList();
  }
}

@freezed

/// Holds the tasks fetched from the db alongside the date range fetched.
abstract class TasksInMemory with _$TasksInMemory {
  const factory TasksInMemory({
    /// The list of tasks
    @Default(<Task>[]) List<Task> tasks,

    /// The oldest expiration fetched. Null if fetched from the beginning.
    DateTime? oldestFetched,

    /// The newest expiration fetched (also in the future). Null if fetched until the end.
    DateTime? newestFetched,

    /// Have the tasks with no expiration been fetched?
    @Default(false) bool noExpirationFetched,
  }) = _TasksInMemory;
}
