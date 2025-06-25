import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:mush_on/tasks/tab_bar_widgets/now_tab_view.dart';
import 'package:mush_on/tasks/tab_bar_widgets/sf_schedule_view.dart';

class DogTasksWidget extends StatelessWidget {
  final Dog dog;
  final TasksInMemory tasksInMemory;
  final Function(Task) onTaskEdited;
  final Function(String) onTaskDeleted;
  static final BasicLogger logger = BasicLogger();
  const DogTasksWidget(
      {super.key,
      required this.dog,
      required this.tasksInMemory,
      required this.onTaskEdited,
      required this.onTaskDeleted});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: TextTitle("Tasks"),
      children: [
        SfScheduleView(
          tasks: _fetchTasks(),
          daysToDisplay: 14,
          onFetchOlderTasks: (_) => {},
          dogs: [dog],
          date: DateTimeUtils.today(),
          onTaskEdited: (t) => onTaskEdited(t),
          onTaskDeleted: (tid) => onTaskDeleted(tid),
        ),
        ..._fetchNonExpiringTasks().map((t) => TaskElement(
            task: t,
            onTaskEdited: (t) => onTaskEdited(t),
            dogs: [dog],
            onTaskDeleted: (tid) => onTaskDeleted(tid)))
      ],
    );
  }

  /// From all the tasks, only filters the one for this dog.
  TasksInMemory _fetchTasks() {
    List<Task> listOfTasks =
        tasksInMemory.tasks.where((t) => t.dogId == dog.id).toList();
    return tasksInMemory.copyWith(tasks: listOfTasks.notDone);
  }

  List<Task> _fetchNonExpiringTasks() {
    return tasksInMemory.tasks
        .where((t) {
          if (t.expiration != null) return false;
          return t.dogId == dog.id;
        })
        .toList()
        .notDone;
  }
}
