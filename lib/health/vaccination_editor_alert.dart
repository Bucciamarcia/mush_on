import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/health/repository.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';

class VaccinationEditorAlert extends ConsumerStatefulWidget {
  final Vaccination? event;
  final List<Dog>? dogs;
  const VaccinationEditorAlert({super.key, this.event, this.dogs});

  @override
  ConsumerState<VaccinationEditorAlert> createState() =>
      _VaccinationEditorAlertState();
}

class _VaccinationEditorAlertState
    extends ConsumerState<VaccinationEditorAlert> {
  String? _id;
  late bool _isSaving;
  late Dog? _selectedDog;
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late TextEditingController _vaccinationTypeController;
  late TextEditingController _selectedDogNameController;
  late TextEditingController _daysBeforeExpirationReminderController;
  late DateTime _dateAdministered;
  late DateTime? _expirationDate;
  late bool _addReminderCheckboxValue;
  @override
  void initState() {
    super.initState();
    _id = widget.event?.id;
    _isSaving = false;
    _selectedDog = widget.dogs?.getDogFromId(widget.event?.dogId ?? "");
    _titleController = TextEditingController(text: widget.event?.title);
    _notesController = TextEditingController(text: widget.event?.notes);
    _vaccinationTypeController =
        TextEditingController(text: widget.event?.vaccinationType);
    _selectedDogNameController = TextEditingController(
        text: widget.dogs?.getNameFromId(widget.event?.dogId ?? ""));
    _daysBeforeExpirationReminderController = TextEditingController(text: "0");
    _dateAdministered = widget.event?.dateAdministered ?? DateTimeUtils.today();
    _expirationDate = widget.event?.expirationDate;
    _addReminderCheckboxValue = false;
  }

  @override
  void dispose() {
    super.dispose();
    _notesController.dispose();
    _vaccinationTypeController.dispose();
    _titleController.dispose();
    _selectedDogNameController.dispose();
    _daysBeforeExpirationReminderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dogs = ref.watch(dogsProvider).valueOrNull ?? [];
    var colorScheme = Theme.of(context).colorScheme;
    var provider = context.watch<MainProvider>();
    return AlertDialog.adaptive(
      scrollable: true,
      title: Text("Add Vaccination"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Vaccination name
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "Vaccination name",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.vaccines),
            ),
          ),
          SizedBox(height: 16),

          // Dog selection
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

          // Vaccination type
          TextField(
            controller: _vaccinationTypeController,
            decoration: InputDecoration(
              labelText: "Vaccination type",
              hintText: "e.g., Rabies, DHPP, Bordetella",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.medical_services),
            ),
          ),
          SizedBox(height: 16),

          // Date cards
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  // Administration date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date administered",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            DateFormat("MMM dd, yyyy")
                                .format(_dateAdministered),
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
                                _dateAdministered = newDate;
                              });
                            },
                          );
                        },
                        icon: Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                  Divider(height: 24),

                  // Expiration date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expiration date",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            _expirationDate == null
                                ? "No expiration"
                                : DateFormat("MMM dd, yyyy")
                                    .format(_expirationDate!),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: _expirationDate == null
                                      ? Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                      : null,
                                ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (_expirationDate != null)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _expirationDate = null;
                                  _addReminderCheckboxValue = false;
                                });
                              },
                              icon: Icon(Icons.clear, color: colorScheme.error),
                            ),
                          IconButton.filledTonal(
                            onPressed: () async {
                              await _selectDate(
                                context: context,
                                minDate: _dateAdministered,
                                onDatePicked: (DateTime newDate) {
                                  setState(() {
                                    _expirationDate = newDate;
                                  });
                                },
                              );
                            },
                            icon: Icon(Icons.calendar_today),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (_expirationDate != null) ...[
            SizedBox(height: 16),
            Card(
              color: _addReminderCheckboxValue
                  ? colorScheme.primaryContainer
                  : null,
              child: Column(
                children: [
                  CheckboxListTile(
                    title: Text("Add reminder task"),
                    subtitle: Text("Create a task before expiration"),
                    secondary: Icon(Icons.notification_add),
                    value: _addReminderCheckboxValue,
                    onChanged: (v) {
                      setState(() {
                        if (v != null) {
                          _addReminderCheckboxValue = v;
                          if (v &&
                              _daysBeforeExpirationReminderController
                                  .text.isEmpty) {
                            _daysBeforeExpirationReminderController.text = "30";
                          }
                        }
                      });
                    },
                  ),
                  if (_addReminderCheckboxValue)
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: TextField(
                        controller: _daysBeforeExpirationReminderController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        decoration: InputDecoration(
                          labelText: "Days before expiration",
                          helperText: "When to remind about renewal",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.schedule),
                          suffixText: "days",
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],

          SizedBox(height: 16),

          // Notes field
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: "Notes (optional)",
              hintText: "Batch number, veterinarian, etc.",
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
                  var repository = ref.read(vaccinationRepositoryProvider);
                  try {
                    await repository.addVaccination(Vaccination(
                        title: _titleController.text,
                        dateAdministered: _dateAdministered,
                        vaccinationType: _vaccinationTypeController.text,
                        expirationDate: _expirationDate,
                        id: _id ?? Uuid().v4(),
                        dogId: _selectedDog!.id,
                        notes: _notesController.text,
                        createdAt:
                            widget.event?.createdAt ?? DateTimeUtils.today(),
                        lastUpdated: DateTimeUtils.today()));
                    if (_expirationDate != null &&
                        _addReminderCheckboxValue == true) {
                      await provider.addTask(
                        Task(
                            id: Uuid().v4(),
                            title: "Vaccination expiration",
                            dogId: _selectedDog!.id,
                            isDone: false,
                            isAllDay: true,
                            isUrgent: false,
                            recurring: RecurringType.none,
                            expiration: _expirationDate!.subtract(
                              Duration(
                                days: int.parse(
                                    _daysBeforeExpirationReminderController
                                        .text),
                              ),
                            ),
                            description:
                                "Automatically added vaccination expiration: ${_titleController.text} - Expires on: ${DateFormat("yyyy-MM-dd").format(_expirationDate!)} - Vaccination type: ${_vaccinationTypeController.text}"),
                      );
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        confirmationSnackbar(context, "Vaccination added"),
                      );
                    }
                    Navigator.of(context).pop();
                  } catch (e, s) {
                    BasicLogger().error("Couldn't add new vaccination",
                        error: e, stackTrace: s);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        errorSnackBar(context, "Couldn't add new vaccination"),
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
              : Text("Add Vaccination"),
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
    if (_titleController.text.isNotEmpty &&
        _vaccinationTypeController.text.isNotEmpty &&
        _selectedDog != null) {
      return true;
    } else {
      return false;
    }
  }
}
