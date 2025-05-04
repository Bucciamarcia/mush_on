import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/shared/dog_filter/filter_operations.dart';
import "enums.dart";
import 'package:mush_on/shared/dog_filter/provider.dart';
import 'package:provider/provider.dart';

class DogFilterWidget extends StatelessWidget {
  final Function(List<Dog>) onResult;

  /// List of dogs to use for flitering
  final List<Dog> dogs;
  const DogFilterWidget(
      {super.key, required this.dogs, required this.onResult});

  @override
  Widget build(BuildContext context) {
    DogFilterProvider provider = context.watch<DogFilterProvider>();
    return Column(
      spacing: 10,
      children: [
        ConditionGroup(
          allDogs: dogs,
          conditionSelected: (provider.conditions.isEmpty)
              ? null
              : provider.conditions.firstOrNull?.conditionSelection,
          operationSelected: (provider.conditions.isEmpty)
              ? null
              : provider.conditions.firstOrNull?.operationSelection,
          onConditionSelected: (v) =>
              provider.setCondition(position: 0, conditionSelection: v),
          onOperatorSelected: (v) =>
              provider.setCondition(position: 0, operationSelection: v),
          onFilterChanged: (v) =>
              provider.setCondition(position: 0, filterSelection: v),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            SubmitButton(
              dogs: dogs,
              conditions: provider.conditions,
              conditionType: provider.conditionType,
              onResult: (result) => onResult(result),
            ),
            ElevatedButton(
                child: Text("Reset"),
                onPressed: () {
                  provider.resetConditions();
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
  final ConditionSelection? conditionSelected;
  final OperationSelection? operationSelected;
  final List<Dog> allDogs;
  const ConditionGroup(
      {super.key,
      required this.onConditionSelected,
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
  const ConditionRow(
      {super.key,
      required this.onConditionSelected,
      required this.onOperatorSelected,
      required this.onFilterChanged,
      required this.conditionSelected,
      required this.operationSelected,
      required this.allDogs});

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
      label: Text("Selec"),
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
        label: Text("Operator"),
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
  const FilterField(
      {super.key,
      required this.onFilterFieldChanged,
      required this.conditionSelected,
      required this.allDogs,
      this.operationSelected});

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
    }
    throw Exception("Couldn't find the appropriate widget");
  }

  Flexible textWidgetField() {
    return Flexible(
      key: Key("Filter key - $conditionSelected"),
      child: TextField(
        decoration: InputDecoration(labelText: "Filter"),
        onChanged: (v) => onFilterFieldChanged(v),
      ),
    );
  }

  Flexible intWidgetField() {
    return Flexible(
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(labelText: "Filter"),
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
              throw NoOperatorSelectedError(message: "An operator is missing");
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
              ErrorSnackbar("You need to fill all the filter data"));
        } on EmptyConditionListError catch (e, s) {
          logger.warning(e.toString(), error: e, stackTrace: s);
          ScaffoldMessenger.of(context)
              .showSnackBar(ErrorSnackbar("You need at least one condition"));
        } catch (e, s) {
          logger.error("Error in the submit filter button",
              error: e, stackTrace: s);
          ScaffoldMessenger.of(context)
              .showSnackBar(ErrorSnackbar("An error occurred"));
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.green[400]),
        foregroundColor: WidgetStateProperty.all(Colors.black87),
      ),
      child: Text("Search"),
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
