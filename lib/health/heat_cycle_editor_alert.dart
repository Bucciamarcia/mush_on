import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/health/repository.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:searchfield/searchfield.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';

class HeatCycleEditorAlert extends ConsumerStatefulWidget {
  final HeatCycle? event;
  final List<Dog>? dogs;
  const HeatCycleEditorAlert({super.key, this.event, this.dogs});

  @override
  ConsumerState<HeatCycleEditorAlert> createState() =>
      _HeatCycleEditorAlertState();
}

class _HeatCycleEditorAlertState extends ConsumerState<HeatCycleEditorAlert> {
  String? _id;
  late bool _isSaving;
  Dog? _selectedDog;
  late TextEditingController _notesController;
  late TextEditingController _selectedDogNameController;
  late DateTime _startDate;
  late DateTime? _endDate;
  late bool _preventFromRunning;

  @override
  void initState() {
    super.initState();
    _isSaving = false;
    _id = widget.event?.id;
    _selectedDog = widget.dogs?.getDogFromId(widget.event?.dogId ?? "");
    _notesController = TextEditingController(text: widget.event?.notes);
    _selectedDogNameController = TextEditingController(
        text: widget.dogs?.getNameFromId(widget.event?.dogId ?? ""));
    _startDate = widget.event?.startDate ?? DateTimeUtils.today();
    _endDate = widget.event?.endDate;
    _preventFromRunning = widget.event?.preventFromRunning ?? true;
  }

  @override
  void dispose() {
    _notesController.dispose();
    _selectedDogNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dogs = ref.watch(dogsProvider).valueOrNull ?? [];
    dogs = dogs.where((dog) => dog.sex != DogSex.male).toList();
    var colorScheme = Theme.of(context).colorScheme;

    return AlertDialog.adaptive(
      scrollable: true,
      title: const Text("Add Heat Cycle"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dog selection
          SearchField<Dog>(
            searchInputDecoration: SearchInputDecoration(
              hintText: "Select dog",
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.pets),
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
          const SizedBox(height: 16),

          // Date section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Start date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Start date",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            DateFormat("MMM dd, yyyy").format(_startDate),
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
                                _startDate = newDate;
                                // If end date is before start date, clear it
                                if (_endDate != null &&
                                    _endDate!.isBefore(_startDate)) {
                                  _endDate = null;
                                }
                              });
                            },
                          );
                        },
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // End date
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
                            _endDate == null
                                ? "Ongoing"
                                : DateFormat("MMM dd, yyyy").format(_endDate!),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: _endDate == null
                                      ? colorScheme.primary
                                      : null,
                                ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (_endDate != null)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _endDate = null;
                                });
                              },
                              icon: Icon(Icons.clear, color: colorScheme.error),
                            ),
                          IconButton.filledTonal(
                            onPressed: () async {
                              await _selectDate(
                                context: context,
                                minDate: _startDate,
                                onDatePicked: (DateTime newDate) {
                                  setState(() {
                                    _endDate = newDate;
                                  });
                                },
                              );
                            },
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Duration info
                  if (_endDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Duration: ${_endDate!.difference(_startDate).inDays} days",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Prevent from running checkbox
          Card(
            color: _preventFromRunning ? Colors.orange : null,
            child: CheckboxListTile(
              value: _preventFromRunning,
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _preventFromRunning = v;
                  });
                }
              },
              title: const Text("Prevent from running"),
              subtitle:
                  const Text("Dog should not participate in training or races"),
              secondary: Icon(
                Icons.block,
                color: _preventFromRunning ? Colors.orange : null,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notes field
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: "Notes (optional)",
              hintText: "Behavioral changes, observations, etc.",
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
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: _checkFields() && !_isSaving
              ? () async {
                  setState(() {
                    _isSaving = true;
                  });
                  var repository = ref.read(heatCycleRepositoryProvider);
                  try {
                    await repository.addHeatCycle(HeatCycle(
                      id: _id ?? const Uuid().v4(),
                      dogId: _selectedDog!.id,
                      startDate: _startDate,
                      endDate: _endDate,
                      preventFromRunning: _preventFromRunning,
                      notes: _notesController.text,
                      createdAt:
                          widget.event?.createdAt ?? DateTimeUtils.today(),
                      lastUpdated: DateTimeUtils.today(),
                    ));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        confirmationSnackbar(context, "Heat cycle added"),
                      );
                      Navigator.of(context).pop();
                    }
                  } catch (e, s) {
                    BasicLogger().error("Couldn't add heat cycle",
                        error: e, stackTrace: s);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        errorSnackBar(context, "Couldn't add heat cycle"),
                      );
                    }
                  } finally {
                    if (mounted) {
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
              : const Text("Add Heat Cycle"),
        ),
      ],
    );
  }

  Future<void> _selectDate({
    required BuildContext context,
    required Function(DateTime) onDatePicked,
    DateTime? minDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      initialDate: minDate ?? _startDate,
      context: context,
      firstDate:
          minDate ?? DateTimeUtils.today().subtract(const Duration(days: 900)),
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
      },
    );
    if (picked != null) {
      onDatePicked(picked);
    }
  }

  bool _checkFields() {
    return _selectedDog != null;
  }
}
