import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:uuid/uuid.dart';

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
    DateTime? expiration,

    /// Has the task been completed?
    @Default(false) bool isDone,

    /// Is this task urgent?
    @Default(false) bool isUrgent,

    /// If this is a recurring task, and how often it repeats.
    @Default(RecurringType.none) RecurringType recurring,

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
