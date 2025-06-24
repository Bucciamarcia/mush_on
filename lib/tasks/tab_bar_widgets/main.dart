import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/shared/text_title.dart';
import 'package:mush_on/tasks/tab_bar_widgets/now_tab_view.dart';

import 'calendar/main.dart';

class TabBarViewWidget extends StatelessWidget {
  final TasksInMemory tasks;
  final List<Dog> dogs;
  final Function(Task) onTaskEdited;
  final Function(DateTime) onFetchOlderTasks;
  final Function(Task) onTaskAdded;
  final Function(String) onTaskDeleted;
  const TabBarViewWidget({
    super.key,
    required this.tasks,
    required this.onTaskEdited,
    required this.dogs,
    required this.onTaskAdded,
    required this.onFetchOlderTasks,
    required this.onTaskDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        NowTabView(
          onFetchOlderTasks: (date) => onFetchOlderTasks(date),
          tasksInMemory: tasks,
          dogs: dogs,
          onTaskEdited: (t) => onTaskEdited(t),
          onTaskDeleted: (t) => onTaskDeleted(t),
        ),
        Column(
          children: [
            TextTitle(
                "Non-expiring tasks (${tasks.tasks.dontExpire.notDone.length})"),
            ...tasks.tasks.notDone.dontExpire.urgentFirst().map(
                  (t) => TaskElement(
                    dogs: dogs,
                    key: ValueKey(t.id),
                    dog: dogs.firstWhereOrNull((d) => d.id == t.dogId),
                    task: t,
                    onTaskDeleted: (t) => onTaskDeleted(t),
                    onTaskEdited: (t) => onTaskEdited(t),
                  ),
                )
          ],
        ),
        CalendarTabWidget(
          onFetchOlderTasks: (d) => onFetchOlderTasks(d),
          tasks: tasks,
          dogs: dogs,
          onTaskEdited: (t) => onTaskEdited(t),
          onTaskDeleted: (t) => onTaskDeleted(t),
          onTaskAdded: (t) => onTaskAdded(t),
        )
      ],
    );
  }
}
