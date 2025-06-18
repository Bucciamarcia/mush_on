import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/firestore.dart';

part "tasks.g.dart";
part "tasks.freezed.dart";

@freezed

/// A task of the todo system
abstract class Task with _$Task {
  const factory Task({
    /// The uuid of the task.
    @Default("") String id,

    /// The title of the task.
    @Default("") String title,

    /// The more lengthy description of the title.
    @Default("") String description,

    /// The expiration date of the task (if present).
    DateTime? expiration,

    /// The ID of the dog this task relates to.
    String? dogId,
  }) = _Task;
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
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
    var doc = collection.doc(task.id);
    var payload = task.toJson();
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
