import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:searchfield/searchfield.dart';

class AddTaskElevatedButton extends ConsumerWidget {
  final Task? task;
  static final BasicLogger logger = BasicLogger();
  const AddTaskElevatedButton({
    super.key,
    this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton.icon(
        style: const ButtonStyle(alignment: Alignment.topCenter),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) => TaskEditorDialog(
              taskEditorType: TaskEditorType.newTask,
              task: task,
              dogs: ref.watch(dogsProvider).value ?? [],
              onTaskAdded: (newTask) async {
                try {
                  await TaskRepository.addOrUpdate(
                    newTask,
                    await ref.watch(accountProvider.future),
                  );
                  if (newTask.isDone &&
                      newTask.expiration != null &&
                      newTask.recurring != RecurringType.none) {
                    // Create new task for next occurrence
                    Task nextOccurrence = newTask.copyWith(
                      id: '', // Let the repository generate a new ID
                      isDone: false, // Next occurrence starts as not done
                      expiration: newTask.expiration!.add(
                        (Duration(days: newTask.recurring.interval)),
                      ),
                    );
                    TaskRepository.addOrUpdate(
                      nextOccurrence,
                      await ref.watch(accountProvider.future),
                    );
                  }
                  if (context.mounted) {
                    if (task == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        confirmationSnackbar(
                            context, "Task added successfully!"),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        confirmationSnackbar(context,
                            "Task edited successfully: ${task?.title}"),
                      );
                    }
                  }
                } catch (e, s) {
                  logger.error("Couldn't add the task",
                      error: e, stackTrace: s);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar(context, "Couldn't add the task."),
                    );
                  }
                }
              },
              onTaskDeleted: (tid) async {
                try {
                  await TaskRepository.delete(
                      tid, await ref.watch(accountProvider.future));

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      confirmationSnackbar(
                          context, "Task removed successfully."),
                    );
                  }
                } catch (e, s) {
                  logger.error("Couldn't delete task", error: e, stackTrace: s);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      errorSnackBar(context, "Couldn't remove the task."),
                    );
                  }
                }
              },
            ),
          );
        },
        label: const Text("Add a task"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class TaskEditorDialog extends StatefulWidget {
  final Function(Task) onTaskAdded;
  final List<Dog> dogs;
  final Task? task;
  final TaskEditorType taskEditorType;
  final Function(String) onTaskDeleted;
  const TaskEditorDialog(
      {super.key,
      required this.onTaskAdded,
      required this.dogs,
      this.task,
      required this.taskEditorType,
      required this.onTaskDeleted});

  @override
  State<TaskEditorDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<TaskEditorDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _expiration;
  late bool _isDone;
  Dog? _selectedDog;
  late RecurringType _recurringType;
  late bool _isUrgent;
  late TextEditingController _dogIdController;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      if (widget.task!.expiration != null) {
        _expiration = widget.task!.expiration;
      }
    }
    _titleController = TextEditingController(text: widget.task?.title ?? "");
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? "");
    _dogIdController = TextEditingController(text: widget.task?.dogId ?? "");
    if (widget.task != null) {
      if (widget.task!.dogId != null) {
        Dog? foundDog = widget.dogs.getDogFromId(widget.task!.dogId!);
        _selectedDog = foundDog;
      }
    }
    _isDone = widget.task?.isDone ?? false;
    _isUrgent = widget.task?.isUrgent ?? false;
    _recurringType = widget.task?.recurring ?? RecurringType.none;
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
          Text(widget.taskEditorType == TaskEditorType.newTask
              ? "Add New Task"
              : "Edit task"),
        ],
      ),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              _buildTitleTextField(),
              _buildDescriptionTextField(),
              _buildIsdoneCheckmark(),
              _buildDateSection(colorScheme, context),
              _buildIsRecurring(colorScheme),
              _buildDogSelector(colorScheme),
              _buildIsUrgent(colorScheme),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        _buildCancelButton(colorScheme, context),
        widget.task != null
            ? _buildDeleteTaskButton(
                onTaskDeleted: () => widget.onTaskDeleted(widget.task!.id),
              )
            : const SizedBox.shrink(),
        _buildConfirmButton(colorScheme, context),
      ],
    );
  }

  Widget _buildIsdoneCheckmark() {
    return CheckboxListTile.adaptive(
      value: _isDone,
      title: const Text("Mark as done"),
      onChanged: (v) {
        if (v != null) {
          setState(() {
            _isDone = v;
          });
        }
      },
    );
  }

  Widget _buildIsUrgent(ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: SwitchListTile(
        title: const Text("Urgent Task",
            style: TextStyle(fontWeight: FontWeight.w600)),
        secondary: Icon(Icons.priority_high,
            color: _isUrgent ? colorScheme.error : colorScheme.primary),
        value: _isUrgent,
        onChanged: (v) => setState(() => _isUrgent = v),
        activeThumbColor: colorScheme.error,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildIsRecurring(ColorScheme colorScheme) {
    if (_expiration == null) return const SizedBox.shrink();

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: ListTile(
        leading: Icon(Icons.repeat, color: colorScheme.primary),
        title:
            const Text("Repeat", style: TextStyle(fontWeight: FontWeight.w600)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<RecurringType>(
            value: _recurringType,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(8),
            onChanged: (value) {
              if (value != null) setState(() => _recurringType = value);
            },
            items: RecurringType.values
                .map((v) => DropdownMenuItem(
                      value: v,
                      child:
                          Text(v.name[0].toUpperCase() + v.name.substring(1)),
                    ))
                .toList(),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      ),
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
                  id: widget.taskEditorType == TaskEditorType.newTask
                      ? ""
                      : widget.task?.id ?? "",
                  description: _descriptionController.text,
                  title: _titleController.text,
                  dogId: _selectedDog?.id,
                  isDone: _isDone,
                  isUrgent: _isUrgent,
                  recurring:
                      // If there is no expiration, recurring type must be none.
                      _expiration == null ? RecurringType.none : _recurringType,
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
      label: Text(widget.taskEditorType == TaskEditorType.newTask
          ? "Add Task"
          : "Edit task"),
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
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextField(
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
          Wrap(
            spacing: 12,
            children: [
              if (_expiration != null)
                Center(
                  child: TextButton.icon(
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
                ),
              Center(
                child: FilledButton.tonalIcon(
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
              dialogTheme: DialogThemeData(
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
            ),
            child: child!,
          );
        });
    if (picked != null) {
      onDatePicked(picked);
    }
  }

  TextButton _buildDeleteTaskButton({required Function() onTaskDeleted}) {
    return TextButton(
        onPressed: () {
          onTaskDeleted();
          Navigator.of(context).pop();
        },
        child: const Text("Delete task"));
  }
}

enum TaskEditorType { newTask, editTask }
