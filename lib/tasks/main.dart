import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/theme.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

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
            dogs: provider.dogs,
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
  final List<Dog> dogs;
  const AddTaskDialog(
      {super.key, required this.onTaskAdded, required this.dogs});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _expiration;
  late bool _isDone;
  Dog? _selectedDog;
  late TextEditingController _dogIdController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _dogIdController = TextEditingController();
    _isDone = false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dogIdController.dispose();
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
          _selectDog(colorScheme),
        ],
      ),
      actions: [
        _cancelTextButton(colorScheme, context),
        _confirmTextButton(colorScheme, context),
      ],
    );
  }

  Row _selectDog(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        _selectedDog == null
            ? Expanded(
                child: SearchField<Dog>(
                  searchInputDecoration: SearchInputDecoration(
                      hint: Text("Dog this task refers to")),
                  suggestions: widget.dogs
                      .map((dog) => SearchFieldListItem(dog.name, item: dog))
                      .toList(),
                  controller: _dogIdController,
                  onSuggestionTap: (x) {
                    if (x.item != null) {
                      setState(() {
                        _dogIdController.text = x.item!.name;
                        _selectedDog = x.item!;
                      });
                    }
                  },
                ),
              )
            : Chip(
                label: Text(
                  _selectedDog!.name,
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
                backgroundColor: colorScheme.primary,
              ),
        IconButton.outlined(
          onPressed: () {
            setState(() {
              _dogIdController.text = "";
              _selectedDog = null;
            });
          },
          icon: Icon(
            Icons.remove,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  TextButton _confirmTextButton(ColorScheme colorScheme, BuildContext context) {
    return TextButton(
      style: CustomThemeOptions.responsiveButtonStylePrimary(context),
      onPressed: _titleController.text.isNotEmpty
          ? () {
              widget.onTaskAdded(
                Task(
                  description: _descriptionController.text,
                  title: _titleController.text,
                  dogId: _selectedDog?.id,
                  isDone: _isDone,
                  expiration: _expiration == null
                      ? null
                      : DateTime.utc(_expiration!.year, _expiration!.month,
                          _expiration!.day),
                ),
              );
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

  Column _selectDateRow(ColorScheme colorScheme, BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Text(_expiration != null
            ? DateFormat("EEE, dd/MM/yyyy").format(_expiration!)
            : "No date selected: the task never expires"),
        Row(
          spacing: 10,
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
