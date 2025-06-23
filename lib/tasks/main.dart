import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/tasks/tab_bar_widget.dart';
import 'package:provider/provider.dart';
import 'tab_bar_widgets/main.dart';
import 'task_editor.dart';

class TasksMainWidget extends StatelessWidget {
  static BasicLogger logger = BasicLogger();
  const TasksMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    MainProvider provider = context.watch<MainProvider>();
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          SizedBox(height: 10),
          AddTaskElevatedButton(provider: provider, logger: logger),
          TabBarWidget(),
          Expanded(
            child: TabBarViewWidget(
              onFetchOlderTasks: (d) => provider.fetchOlderTasks(d),
              tasks: provider.tasks,
              dogs: provider.dogs,
              onTaskEdited: (t) async {
                try {
                  await provider.editTask(t);
                  if (t.isDone) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 5),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () async => await provider
                                  .editTask(t.copyWith(isDone: false))),
                          content: Text(
                            "Task completed: ${t.title}",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          confirmationSnackbar(
                              context, "Task edited successfully: ${t.title}"));
                    }
                  }
                } catch (e, s) {
                  logger.error("Couldn't edit task", error: e, stackTrace: s);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        errorSnackBar(context, "Couldn't edit task"));
                  }
                }
              },
              onTaskAdded: (t) async {
                await provider.addTask(t);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      confirmationSnackbar(context, "Task added successfully"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
