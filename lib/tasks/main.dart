import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(Icons.add_task, color: colorScheme.primary),
          const SizedBox(width: 12),
          const Text("Add New Task"),
        ],
      ),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            _buildTitleTextField(),
            _buildDescriptionTextField(),
            _buildDateSection(colorScheme, context),
            _buildDogSelector(colorScheme),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        _buildCancelButton(colorScheme, context),
        _buildConfirmButton(colorScheme, context),
      ],
    );
  }

  Widget _buildDogSelector(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            children: [
              Icon(Icons.pets, size: 20, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                "Assign to Dog",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Row(
            spacing: 12,
            children: [
              if (_selectedDog == null)
                Expanded(
                  child: SearchField<Dog>(
                    searchInputDecoration: SearchInputDecoration(
                      hint: const Text("Search for a dog..."),
                      prefixIcon:
                          Icon(Icons.search, color: colorScheme.primary),
                      filled: true,
                      fillColor: colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
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
              else
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.pets,
                            size: 20, color: colorScheme.onPrimaryContainer),
                        const SizedBox(width: 8),
                        Text(
                          _selectedDog!.name,
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              IconButton.filledTonal(
                onPressed: () {
                  setState(() {
                    _dogIdController.text = "";
                    _selectedDog = null;
                  });
                },
                icon: const Icon(Icons.clear),
                tooltip: "Clear selection",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(ColorScheme colorScheme, BuildContext context) {
    final isEnabled = _titleController.text.isNotEmpty;
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: isEnabled
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
      icon: const Icon(Icons.add),
      label: const Text("Add Task"),
    );
  }

  Widget _buildCancelButton(ColorScheme colorScheme, BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () => Navigator.of(context).pop(),
      child: Text(
        "Cancel",
        style: TextStyle(color: colorScheme.error),
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return TextField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: "Description (optional)",
        hintText: "Additional details",
        prefixIcon: const Icon(Icons.description_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }

  Widget _buildTitleTextField() {
    return TextField(
      onChanged: (_) {
        setState(() {});
      },
      controller: _titleController,
      decoration: InputDecoration(
        labelText: "Task Title",
        hintText: "Enter task title",
        prefixIcon: const Icon(Icons.title),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }

  Widget _buildDateSection(ColorScheme colorScheme, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                "Due Date",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _expiration != null
                  ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _expiration != null ? Icons.event : Icons.event_busy,
                  size: 18,
                  color: _expiration != null
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _expiration != null
                        ? DateFormat("EEEE, MMMM d, yyyy").format(_expiration!)
                        : "No due date set",
                    style: TextStyle(
                      color: _expiration != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                      fontWeight: _expiration != null
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            spacing: 12,
            children: [
              if (_expiration != null)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _expiration = null;
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text("Clear"),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.error,
                  ),
                ),
              FilledButton.tonalIcon(
                onPressed: () async {
                  await _selectDate(
                      context: context,
                      onDatePicked: (newDate) {
                        setState(() {
                          _expiration = newDate;
                        });
                      });
                },
                icon: Icon(_expiration != null ? Icons.edit : Icons.add),
                label: Text(_expiration != null ? "Change Date" : "Set Date"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
      {required BuildContext context,
      required Function(DateTime) onDatePicked}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 900)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              dialogBackgroundColor: Theme.of(context).colorScheme.surface,
            ),
            child: child!,
          );
        });
    if (picked != null) {
      onDatePicked(picked);
    }
  }
}
