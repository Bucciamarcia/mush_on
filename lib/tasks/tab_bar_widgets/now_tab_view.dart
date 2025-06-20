import 'package:flutter/material.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/shared/text_title.dart';

class NowTabView extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onTaskEdited;
  const NowTabView(
      {super.key, required this.tasks, required this.onTaskEdited});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            TextTitle("Today"),
            ...tasks.dueToday.urgentFirst().map(
                  (t) => TaskElement(
                    key: ValueKey(t.id),
                    task: t,
                    onTaskEdited: (t) => onTaskEdited(t),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class TaskElement extends StatelessWidget {
  final Task task;
  final Function(Task) onTaskEdited;
  const TaskElement(
      {super.key, required this.task, required this.onTaskEdited});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile.adaptive(
      title: Text(task.title),
      subtitle: Text(task.description),
      value: task.isDone,
      onChanged: (b) {
        if (b != null) {
          onTaskEdited(task.copyWith(isDone: b));
        }
      },
    );
  }
}
