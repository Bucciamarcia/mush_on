import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:provider/provider.dart';

class TasksMainWidget extends StatelessWidget {
  static BasicLogger logger = BasicLogger();
  const TasksMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    MainProvider provider = context.watch<MainProvider>();
    return ElevatedButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) => AddTaskDialog(
            onTaskAdded: (newTask) async {
              try {
                await provider.addTask(newTask);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    confirmationSnackbar(context, "Task added successfully!"),
                  );
                }
              } catch (e, s) {
                logger.error("Couldn't add the task", error: e, stackTrace: s);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    errorSnackBar(context, "Couldn't add the task."),
                  );
                }
              }
            },
          ),
        );
      },
      child: Text("Add a task"),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onTaskAdded;
  const AddTaskDialog({super.key, required this.onTaskAdded});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _expiration;
  late bool _isDone;
  String? _dogId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _isDone = false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return AlertDialog.adaptive(
      title: Text("Add task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          _selectTitleTextField(),
          _selectDescriptionTextField(),
          _selectDateRow(colorScheme, context),
        ],
      ),
      actions: [
        _cancelTextButton(colorScheme, context),
        _confirmTextButton(colorScheme, context),
      ],
    );
  }

  TextButton _confirmTextButton(ColorScheme colorScheme, BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.primary.withValues(alpha: 0.4);
            }
            return colorScheme.primary;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onPrimary.withValues(alpha: 0.4);
            }
            return colorScheme.onPrimary;
          },
        ),
      ),
      onPressed: _titleController.text.isNotEmpty
          ? () {
              widget.onTaskAdded(Task(description: "no moi"));
              Navigator.of(context).pop();
            }
          : null,
      child: Text(
        "Add Task",
        style: TextStyle(color: colorScheme.onPrimary),
      ),
    );
  }

  TextButton _cancelTextButton(ColorScheme colorScheme, BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(colorScheme.error),
      ),
      onPressed: () => Navigator.of(context).pop(),
      child: Text(
        "Cancel",
        style: TextStyle(color: colorScheme.onError),
      ),
    );
  }

  TextField _selectDescriptionTextField() {
    return TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
        label: Text("Description (optional)"),
      ),
    );
  }

  TextField _selectTitleTextField() {
    return TextField(
      onChanged: (_) {
        setState(() {});
      },
      controller: _titleController,
      decoration: InputDecoration(
        label: Text("Title"),
      ),
    );
  }

  Row _selectDateRow(ColorScheme colorScheme, BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _expiration = null;
            });
          },
          label: Text(
            "Remove expiration",
            style: TextStyle(color: colorScheme.onError),
          ),
          icon: Icon(
            Icons.remove,
            color: colorScheme.onError,
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(colorScheme.error),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            await _selectDate(
                context: context,
                onDatePicked: (newDate) {
                  setState(() {
                    _expiration = newDate;
                  });
                });
          },
          icon: Icon(
            Icons.add,
            color: colorScheme.onPrimary,
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          ),
          label: Text(
            "Pick date",
            style: TextStyle(color: colorScheme.onPrimary),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
      {required BuildContext context,
      required Function(DateTime) onDatePicked}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 900)));
    if (picked != null) {
      onDatePicked(picked);
    }
  }
}
