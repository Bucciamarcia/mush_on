import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/custom_field.dart';
import 'package:mush_on/shared/dog_filter/filter_operations.dart';
import 'package:mush_on/shared/dog_filter/riverpod.dart';
import "enums.dart";

class DogFilterWidget extends ConsumerWidget {
  final Function(List<Dog>) onResult;

  /// List of dogs to use for flitering
  final List<Dog> dogs;
  final List<CustomFieldTemplate> templates;
  const DogFilterWidget(
      {super.key,
      required this.dogs,
      required this.onResult,
      required this.templates});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var filterConditions = ref.watch(filterConditionsProvider);
    var filterConditionsNotifier = ref.read(filterConditionsProvider.notifier);
    return Column(
      spacing: 10,
      children: [
        ConditionGroup(
          allDogs: dogs,
          templates: templates,
          conditionSelected: (filterConditions.conditions.isEmpty)
              ? null
              : filterConditions.conditions.firstOrNull?.conditionSelection,
          operationSelected: (filterConditions.conditions.isEmpty)
              ? null
              : filterConditions.conditions.firstOrNull?.operationSelection,
          onConditionSelected: (v) => filterConditionsNotifier.setCondition(
              position: 0, conditionSelection: v),
          onOperatorSelected: (v) => filterConditionsNotifier.setCondition(
              position: 0, operationSelection: v),
          onFilterChanged: (v) => filterConditionsNotifier.setCondition(
              position: 0, filterSelection: v),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            SubmitButton(
              dogs: dogs,
              conditions: filterConditions.conditions,
              conditionType: filterConditions.conditionType,
              onResult: (result) => onResult(result),
            ),
            ElevatedButton(
                child: const Text("Reset"),
                onPressed: () {
                  filterConditionsNotifier.resetConditions();
                  onResult(dogs);
                }),
          ],
        ),
      ],
    );
  }
}

class ConditionGroup extends StatelessWidget {
  final Function(ConditionSelection?) onConditionSelected;
  final Function(OperationSelection?) onOperatorSelected;
  final Function(dynamic) onFilterChanged;
  final List<CustomFieldTemplate> templates;
  final ConditionSelection? conditionSelected;
  final OperationSelection? operationSelected;
  final List<Dog> allDogs;
  const ConditionGroup(
      {super.key,
      required this.onConditionSelected,
      required this.templates,
      required this.onOperatorSelected,
      required this.onFilterChanged,
      required this.conditionSelected,
      required this.operationSelected,
      required this.allDogs});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ConditionRow(
        allDogs: allDogs,
        conditionSelected: conditionSelected,
        operationSelected: operationSelected,
        templates: templates,
        onConditionSelected: (v) => onConditionSelected(v),
        onOperatorSelected: (v) => onOperatorSelected(v),
        onFilterChanged: (v) => onFilterChanged(v),
      ),
    ));
  }
}

class ConditionRow extends StatelessWidget {
  final Function(ConditionSelection?) onConditionSelected;
  final Function(OperationSelection?) onOperatorSelected;
  final Function(dynamic) onFilterChanged;
  final ConditionSelection? conditionSelected;
  final OperationSelection? operationSelected;
  final List<Dog> allDogs;
  final List<CustomFieldTemplate> templates;
  const ConditionRow(
      {super.key,
      required this.onConditionSelected,
      required this.onOperatorSelected,
      required this.onFilterChanged,
      required this.conditionSelected,
      required this.operationSelected,
      required this.allDogs,
      required this.templates});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConditionSelector(onConditionSelected: (v) => onConditionSelected(v)),
        OperatorSelector(
          operationSelected: operationSelected,
          onOperatorSelected: (v) => onOperatorSelected(v),
          conditionSelected: conditionSelected,
        ),
        FilterField(
          allDogs: allDogs,
          onFilterFieldChanged: (v) => onFilterChanged(v),
          conditionSelected: conditionSelected,
          templates: templates,
        ),
      ],
    );
  }
}

class ConditionSelector extends StatelessWidget {
  final Function(ConditionSelection?) onConditionSelected;
  const ConditionSelector({super.key, required this.onConditionSelected});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<ConditionSelection>(
      key: const Key("Select condition"),
      label: const Text("Select condition"),
      onSelected: (v) => onConditionSelected(v),
      dropdownMenuEntries: ConditionSelection.values
          .map((v) => DropdownMenuEntry(value: v, label: v.name))
          .toList(),
    );
  }
}

class OperatorSelector extends StatelessWidget {
  final ConditionSelection? conditionSelected;
  final OperationSelection? operationSelected;
  final Function(OperationSelection?) onOperatorSelected;
  const OperatorSelector(
      {super.key,
      required this.onOperatorSelected,
      required this.conditionSelected,
      required this.operationSelected});

  @override
  Widget build(BuildContext context) {
    List<OperationSelection> allowedOperations = (conditionSelected == null)
        ? OperationSelection.values
        : conditionSelected!.allowedOperations;
    return DropdownMenu<OperationSelection>(
        key: Key("Operator Selector DropDown - $operationSelected"),
        initialSelection: operationSelected,
        label: const Text("Operator"),
        onSelected: (v) => onOperatorSelected(v),
        dropdownMenuEntries: allowedOperations
            .map((v) => DropdownMenuEntry(value: v, label: v.symbol))
            .toList());
  }
}

class FilterField extends StatelessWidget {
  final Function(dynamic) onFilterFieldChanged;
  final ConditionSelection? conditionSelected;
  final OperationSelection? operationSelected;
  final List<Dog> allDogs;
  final List<CustomFieldTemplate> templates;
  const FilterField(
      {super.key,
      required this.onFilterFieldChanged,
      required this.conditionSelected,
      required this.allDogs,
      this.operationSelected,
      required this.templates});

  @override
  Widget build(BuildContext context) {
    if (conditionSelected == null) return textWidgetField();
    switch (conditionSelected!.type) {
      case const (String):
        return textWidgetField();
      case const (int):
        return intWidgetField();
      case const (Tag):
        return tagWidgetField();
      case const (DogSex):
        return sexWidgetField();
      case const (DogPositions):
        return dogPositionField();
      case const (CustomFieldTemplate):
        return FilterCustomFieldRowWidget(
            templates: templates, onFilterFieldChanged: onFilterFieldChanged);
    }
    throw Exception("Couldn't find the appropriate widget");
  }

  Flexible dogPositionField() {
    return Flexible(
      child: DropdownMenu<String>(
        dropdownMenuEntries: DogPositions.toList
            .map(
              (p) => DropdownMenuEntry(value: p, label: p),
            )
            .toList(),
        onSelected: (v) => onFilterFieldChanged(v),
      ),
    );
  }

  Flexible textWidgetField() {
    return Flexible(
      key: Key("Filter key - $conditionSelected"),
      child: TextField(
        decoration: const InputDecoration(labelText: "Filter"),
        onChanged: (v) => onFilterFieldChanged(v),
      ),
    );
  }

  Flexible intWidgetField() {
    return Flexible(
      child: TextField(
        keyboardType: const TextInputType.numberWithOptions(),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(labelText: "Filter"),
        onChanged: (v) => onFilterFieldChanged(int.parse(v)),
      ),
    );
  }

  Flexible tagWidgetField() {
    List<Tag> allTags = TagRepository.getAllTagsFromDogs(allDogs);
    return Flexible(
      child: Autocomplete<Tag>(
        displayStringForOption: (Tag tag) => tag.name,
        optionsBuilder: (TextEditingValue textEditingValue) {
          return allTags
              .where((Tag tag) => tag.name.contains(textEditingValue.text));
        },
        onSelected: (v) => onFilterFieldChanged(v),
      ),
    );
  }

  Flexible sexWidgetField() {
    return Flexible(
      child: DropdownMenu<DogSex>(
        dropdownMenuEntries: DogSex.values
            .map((DogSex sex) => DropdownMenuEntry(value: sex, label: sex.name))
            .toList(),
        onSelected: (v) => onFilterFieldChanged(v),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  static final BasicLogger logger = BasicLogger();
  final List<Dog> dogs;
  final List<ConditionSelectionElement> conditions;
  final ConditionType conditionType;
  final Function(List<Dog>) onResult;
  const SubmitButton({
    super.key,
    required this.dogs,
    required this.conditions,
    required this.conditionType,
    required this.onResult,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        try {
          for (ConditionSelectionElement condition in conditions) {
            if (condition.conditionSelection == null ||
                condition.operationSelection == null ||
                condition.filterSelection == null ||
                condition.filterSelection == "") {
              throw NoOperatorSelectedError(
                  message: "An operator is missing: $condition");
            }
          }
          if (conditions.isEmpty) {
            throw EmptyConditionListError(message: "Empty list");
          }
          List<Dog> filteredList = FilterOperations(
                  dogs: dogs,
                  conditionSelection: conditions.first.conditionSelection!,
                  operationSelection: conditions.first.operationSelection!,
                  filter: conditions[0].filterSelection)
              .run();
          onResult(filteredList);
        } on NoOperatorSelectedError catch (e, s) {
          logger.warning(e.toString(), error: e, stackTrace: s);
          ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBar(context, "You need to fill all the filter data"));
        } on EmptyConditionListError catch (e, s) {
          logger.warning(e.toString(), error: e, stackTrace: s);
          ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBar(context, "You need at least one condition"));
        } on IllegalFilterException catch (e, s) {
          logger.warning(e.toString(), error: e, stackTrace: s);
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar(context, "Error: ${e.toString()}"));
        } catch (e, s) {
          logger.error("Error in the submit filter button",
              error: e, stackTrace: s);
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar(context, "An error occurred"));
        }
      },
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
        foregroundColor:
            WidgetStateProperty.all(Theme.of(context).colorScheme.onPrimary),
      ),
      child: const Text("Search"),
    );
  }
}

class NoOperatorSelectedError implements Exception {
  final String message;
  NoOperatorSelectedError({required this.message});
  @override
  String toString() => "NoOperatorSelected: $message";
}

class EmptyConditionListError implements Exception {
  final String message;
  EmptyConditionListError({required this.message});
  @override
  String toString() => "EmptyConditionListError: $message";
}

class FilterCustomFieldRowWidget extends StatefulWidget {
  final List<CustomFieldTemplate> templates;
  final Function(dynamic) onFilterFieldChanged;

  const FilterCustomFieldRowWidget(
      {super.key, required this.templates, required this.onFilterFieldChanged});

  @override
  State<FilterCustomFieldRowWidget> createState() =>
      _FilterCustomFieldRowWidgetState();
}

class _FilterCustomFieldRowWidgetState
    extends State<FilterCustomFieldRowWidget> {
  late CustomFieldTemplate selectedTemplate;
  late TextEditingController _controller;
  static final BasicLogger logger = BasicLogger();

  @override
  void initState() {
    super.initState();
    selectedTemplate = widget.templates[0];
    _controller = TextEditingController();
    logger.info(
        "FilterCustomFieldRowWidget initialized with template: ${selectedTemplate.name}");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          DropdownMenu(
            dropdownMenuEntries: widget.templates
                .map((t) => DropdownMenuEntry(value: t, label: t.name))
                .toList(),
            onSelected: (st) {
              setState(() {
                selectedTemplate = st ?? widget.templates[0];
              });
              logger.info("Template changed to: ${selectedTemplate.name}");

              try {
                final value = CustomFieldValue.formatCustomFieldValue(
                    selectedTemplate, _controller.text);
                logger.info("Sending filter update after template change:");
                logger.info(
                    "- Template: ${selectedTemplate.name} (ID: ${selectedTemplate.id})");
                logger.info("- Value: $value");
                logger.info("- Value type: ${value.runtimeType}");

                widget.onFilterFieldChanged(
                  FilterCustomFieldResults(
                      template: selectedTemplate, value: value),
                );
              } catch (e) {
                logger.warning("Failed to parse value on template change: $e");
              }
            },
            initialSelection: selectedTemplate,
          ),
          Flexible(
            child: TextField(
              controller: _controller,
              keyboardType: selectedTemplate.type == CustomFieldType.typeString
                  ? null
                  : TextInputType.number,
              inputFormatters:
                  selectedTemplate.type == CustomFieldType.typeString
                      ? null
                      : [FilteringTextInputFormatter.digitsOnly],
              onChanged: (v) {
                logger.info("TextField changed: '$v'");

                try {
                  final value = CustomFieldValue.formatCustomFieldValue(
                      selectedTemplate, v);
                  logger.info("Sending filter update:");
                  logger.info(
                      "- Template: ${selectedTemplate.name} (ID: ${selectedTemplate.id})");
                  logger.info("- Value: $value");
                  logger.info("- Value type: ${value.runtimeType}");

                  widget.onFilterFieldChanged(FilterCustomFieldResults(
                      template: selectedTemplate, value: value));
                } catch (e) {
                  logger.warning("Failed to parse value: $e");
                  // For empty string on int/double fields
                  if (v.isEmpty &&
                      selectedTemplate.type != CustomFieldType.typeString) {
                    logger.info(
                        "Empty value for numeric field, not updating filter");
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
