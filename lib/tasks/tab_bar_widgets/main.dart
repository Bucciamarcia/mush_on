import 'package:flutter/material.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/tasks/tab_bar_widgets/now_tab_view.dart';

import 'calendar/main.dart';

class TabBarViewWidget extends StatelessWidget {
  final List<Task> tasks;
  final List<Dog> dogs;
  final Function(Task) onTaskEdited;
  final Function(Task) onTaskAdded;
  const TabBarViewWidget({
    super.key,
    required this.tasks,
    required this.onTaskEdited,
    required this.dogs,
    required this.onTaskAdded,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        SingleChildScrollView(
          child: NowTabView(
            tasks: tasks,
            dogs: dogs,
            onTaskEdited: (t) => onTaskEdited(t),
          ),
        ),
        CalendarTabWidget(
          tasks: tasks,
          dogs: dogs,
          onTaskEdited: (t) => onTaskEdited(t),
          onTaskAdded: (t) => onTaskAdded(t),
        )
      ],
    );
  }
}
