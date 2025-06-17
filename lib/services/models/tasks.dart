import 'package:freezed_annotation/freezed_annotation.dart';

part "tasks.g.dart";
part "tasks.freezed.dart";

@freezed

/// A task of the checklist
abstract class Task with _$Task {
  const factory Task({
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
