import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:searchfield/searchfield.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';
import 'repository.dart';

class HealthEventEditorAlert extends ConsumerStatefulWidget {
  final HealthEvent? event;
  final List<Dog>? dogs;
  const HealthEventEditorAlert({super.key, this.event, this.dogs});

  @override
  ConsumerState<HealthEventEditorAlert> createState() =>
      HealtheventEditorAlertState();
}

class HealtheventEditorAlertState
    extends ConsumerState<HealthEventEditorAlert> {
  String? _id;
  Dog? _selectedDog;
  late TextEditingController _nameController;
  late TextEditingController _notesController;
  late TextEditingController _selectedDogNameController;
  late DateTime _eventStartDate;
  DateTime? _eventFinishDate;
  late bool _isOneshot;
  late bool _preventsFromRunning;
  late bool _isSaving;
  late HealthEventType _healthEventType;
  late TextEditingController _hetController;
  @override
  void initState() {
    super.initState();
    _id = widget.event?.id;
    _selectedDog = widget.dogs?.getDogFromId(widget.event?.dogId ?? "");
    _nameController = TextEditingController(text: widget.event?.title);
    _notesController = TextEditingController(text: widget.event?.notes);
    _selectedDogNameController = TextEditingController(
        text: widget.dogs?.getNameFromId(widget.event?.dogId ?? ""));
    _eventStartDate = widget.event?.date ?? DateTimeUtils.today();
    _isOneshot = widget.event?.isOneShot ?? false;
    _eventFinishDate = widget.event?.resolvedDate;
    _preventsFromRunning = widget.event?.preventFromRunning ?? false;
    _isSaving = false;
    _healthEventType = widget.event?.eventType ?? HealthEventType.observation;
    _hetController = TextEditingController(text: _healthEventType.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _selectedDogNameController.dispose();
    _hetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Dog>? dogs = ref.watch(dogsProvider).valueOrNull;
    final colorScheme = Theme.of(context).colorScheme;
    if (dogs == null) {
      return AlertDialog.adaptive(
        title: Text("Add health event"),
        content: CircularProgressIndicator(),
      );
    }
    return AlertDialog.adaptive(
      scrollable: true,
      title: Text("Add health event"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add spacing between elements
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Event name",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.event_note),
            ),
          ),
          SizedBox(height: 16),

          // Better visual grouping
          Card(
            child: Column(
              children: [
                CheckboxListTile(
                  value: _isOneshot,
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        _isOneshot = v;
                      });
                    }
                  },
                  title: Text("Single day event"),
                  subtitle: Text("Event happens on one day only"),
                  secondary: Icon(Icons.today),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Better search field
          SearchField<Dog>(
            searchInputDecoration: SearchInputDecoration(
              hintText: "Select dog",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.pets),
            ),
            controller: _selectedDogNameController,
            suggestions: dogs
                .map((dog) => SearchFieldListItem(dog.name, item: dog))
                .toList(),
            onSuggestionTap: (x) {
              if (x.item != null) {
                setState(() {
                  _selectedDog = x.item;
                  _selectedDogNameController.text = x.item!.name;
                });
              }
            },
          ),
          SizedBox(height: 16),

          // Date section with better layout
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isOneshot ? "Event date" : "Start date",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            DateFormat("MMM dd, yyyy").format(_eventStartDate),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      IconButton.filledTonal(
                        onPressed: () async {
                          await _selectDate(
                              context: context,
                              onDatePicked: (DateTime newDate) {
                                setState(() {
                                  _eventStartDate = newDate;
                                });
                              });
                        },
                        icon: Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                  if (!_isOneshot) ...[
                    Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End date",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              _eventFinishDate == null
                                  ? "Ongoing"
                                  : DateFormat("MMM dd, yyyy")
                                      .format(_eventFinishDate!),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: _eventFinishDate == null
                                        ? colorScheme.primary
                                        : null,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (_eventFinishDate != null)
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _eventFinishDate = null;
                                  });
                                },
                                icon:
                                    Icon(Icons.clear, color: colorScheme.error),
                              ),
                            IconButton.filledTonal(
                              onPressed: () async {
                                await _selectDate(
                                    minDate: _eventStartDate,
                                    context: context,
                                    onDatePicked: (DateTime newDate) {
                                      setState(() {
                                        _eventFinishDate = newDate;
                                      });
                                    });
                              },
                              icon: Icon(Icons.calendar_today),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Better dropdown with width constraint
          SizedBox(
            width: double.infinity,
            child: DropdownMenu(
              controller: _hetController,
              label: Text("Event type"),
              leadingIcon: Icon(Icons.category),
              width: double.infinity,
              onSelected: (v) {
                if (v != null) {
                  setState(() {
                    _hetController.text = v.name;
                    _healthEventType = v;
                  });
                }
              },
              dropdownMenuEntries: HealthEventType.values
                  .map((het) => DropdownMenuEntry(
                        value: het,
                        label: het.name.substring(0, 1).toUpperCase() +
                            het.name.substring(1),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: 16),

          // Notes field
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: "Notes (optional)",
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
              prefixIcon: Padding(
                padding: EdgeInsets.only(bottom: 60),
                child: Icon(Icons.notes),
              ),
            ),
            maxLines: 3,
            minLines: 2,
          ),
          SizedBox(height: 8),

          // Prevents running checkbox with better styling
          Card(
            color: _preventsFromRunning ? colorScheme.errorContainer : null,
            child: CheckboxListTile(
              value: _preventsFromRunning,
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _preventsFromRunning = v;
                  });
                }
              },
              title: Text("Dog can't run"),
              subtitle:
                  Text("This condition prevents the dog from training/racing"),
              secondary: Icon(
                Icons.block,
                color: _preventsFromRunning ? colorScheme.error : null,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        FilledButton(
          onPressed: _checkFields() && !_isSaving
              ? () async {
                  setState(() {
                    _isSaving = true;
                  });
                  var repository = ref.read(healthEventRepositoryProvider);
                  try {
                    await repository.addEvent(HealthEvent(
                        id: _id ?? Uuid().v4(),
                        dogId: _selectedDog!.id,
                        title: _nameController.text,
                        date: _eventStartDate,
                        preventFromRunning: _preventsFromRunning,
                        notes: _notesController.text,
                        resolvedDate:
                            _isOneshot ? _eventStartDate : _eventFinishDate,
                        createdAt:
                            widget.event?.createdAt ?? DateTimeUtils.today(),
                        eventType: _healthEventType,
                        lastUpdated: DateTimeUtils.today()));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        confirmationSnackbar(context, "Health event added"),
                      );
                    }
                    if (context.mounted) Navigator.of(context).pop();
                  } catch (e, s) {
                    BasicLogger().error("Couldn't add new event",
                        error: e, stackTrace: s);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        errorSnackBar(context, "Couldn't add new event"),
                      );
                    }
                  } finally {
                    if (context.mounted) {
                      setState(() {
                        _isSaving = false;
                      });
                    }
                  }
                }
              : null,
          child: _isSaving
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onPrimary,
                  ),
                )
              : Text("Add event"),
        ),
      ],
    );
  }

  Future<void> _selectDate(
      {required BuildContext context,
      required Function(DateTime) onDatePicked,
      DateTime? minDate}) async {
    final DateTime? picked = await showDatePicker(
        initialDate: minDate,
        context: context,
        firstDate:
            minDate ?? DateTimeUtils.today().subtract(Duration(days: 900)),
        lastDate: DateTimeUtils.today().add(const Duration(days: 900)),
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

  bool _checkFields() {
    if (_selectedDog != null && _nameController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
