import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:provider/provider.dart';

class TasksMainWidget extends StatelessWidget {
  const TasksMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    MainProvider provider = context.watch<MainProvider>();
    return ElevatedButton(
      onPressed: () async => await _showAddTaskDialog(
          context: context,
          onTaskAdded: (newTask) async {
            await provider.addTask(newTask);
          }),
      child: Text("Add a task"),
    );
  }

  Future<AlertDialog> _showAddTaskDialog(
      {required BuildContext context,
      required Function(Task) onTaskAdded}) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: Text("Add task"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  onTaskAdded(Task());
                  Navigator.of(context).pop();
                },
                child: Text("Save new task"),
              ),
            ],
          );
        });
  }
}
