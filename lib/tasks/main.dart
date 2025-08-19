import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/tasks/tab_bar_widget.dart';
import 'tab_bar_widgets/main.dart';
import 'task_editor.dart';

class TasksMainWidget extends ConsumerWidget {
  static BasicLogger logger = BasicLogger();
  const TasksMainWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TasksInMemory tasks =
        ref.watch(tasksProvider(365)).value ?? const TasksInMemory();
    List<Dog> dogs = ref.watch(dogsProvider).value ?? [];
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          const SizedBox(height: 10),
          const AddTaskElevatedButton(),
          const TabBarWidget(),
          Expanded(
            child: TabBarViewWidget(
              onFetchOlderTasks: (d) {
                final daysToRemove = DateTimeUtils.today().difference(d);
                tasks = ref.watch(tasksProvider(daysToRemove.inDays)).value ??
                    const TasksInMemory();
              },
              tasks: tasks,
              dogs: dogs,
              onTaskEdited: (t) async {
                try {
                  await TaskRepository.addOrUpdate(
                      t, await ref.watch(accountProvider.future));
                  if (t.isDone &&
                      t.expiration != null &&
                      t.recurring != RecurringType.none) {
                    // Create new task for next occurrence
                    Task nextOccurrence = t.copyWith(
                      id: '', // Let the repository generate a new ID
                      isDone: false, // Next occurrence starts as not done
                      expiration: t.expiration!.add(
                        (Duration(days: t.recurring.interval)),
                      ),
                    );
                    TaskRepository.addOrUpdate(
                      nextOccurrence,
                      await ref.watch(accountProvider.future),
                    );
                  }
                  if (t.isDone) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 5),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () async {
                                await TaskRepository.addOrUpdate(
                                  t.copyWith(isDone: false),
                                  await ref.watch(accountProvider.future),
                                );
                              }),
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
                await TaskRepository.addOrUpdate(
                    t, await ref.watch(accountProvider.future));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      confirmationSnackbar(context, "Task added successfully"));
                }
              },
              onTaskDeleted: (t) async {
                await TaskRepository.delete(
                    t, await ref.watch(accountProvider.future));
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
