import 'package:flutter/material.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/tasks/tab_bar_widgets/now_tab_view.dart';

class TabBarViewWidget extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onTaskEdited;
  const TabBarViewWidget({
    super.key,
    required this.tasks,
    required this.onTaskEdited,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        NowTabView(
          tasks: tasks,
          onTaskEdited: (t) => onTaskEdited(t),
        ),
        Text("2"),
      ],
    );
  }
}
