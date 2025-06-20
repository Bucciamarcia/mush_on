import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/tasks/tab_bar_view_widget.dart';
import 'package:mush_on/tasks/tab_bar_widget.dart';
import 'package:provider/provider.dart';

import 'add_task.dart';

class TasksMainWidget extends StatelessWidget {
  static BasicLogger logger = BasicLogger();
  const TasksMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    MainProvider provider = context.watch<MainProvider>();
    return DefaultTabController(
      length: 2,
      child: Column(
        spacing: 10,
        children: [
          SizedBox(height: 10),
          AddTaskElevatedButton(provider: provider, logger: logger),
          TabBarWidget(),
          Expanded(
            child: TabBarViewWidget(),
          ),
        ],
      ),
    );
  }
}
