import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/shared/dog_filter/filter_operations.dart';
import "enums.dart";
import 'package:mush_on/shared/dog_filter/provider.dart';
import 'package:provider/provider.dart';

class DogFilterWidget extends StatelessWidget {
  final Function(List<Dog>) onResult;
  const DogFilterWidget({super.key, required this.onResult});

  @override
  Widget build(BuildContext context) {
    DogFilterProvider provider = context.watch<DogFilterProvider>();
    return Column(
      children: [
        ConditionGroup(
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
        SubmitButton(
          dogs: provider.dogs,
          conditions: provider.conditions,
          conditionType: provider.conditionType,
          onResult: (result) => onResult(result),
        ),
      ],
    );
  }
}

class ConditionGroup extends StatelessWidget {
  final Function(ConditionSelection?) onConditionSelected;
  final Function(OperationSelection?) onOperatorSelected;
  final Function(String?) onFilterChanged;
  final ConditionSelection? conditionSelected;
  final OperationSelection? operationSelected;
  const ConditionGroup(
      {super.key,
      required this.onConditionSelected,
      required this.onOperatorSelected,
      required this.onFilterChanged,
      required this.conditionSelected,
      required this.operationSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ConditionRow(
      conditionSelected: conditionSelected,
      operationSelected: operationSelected,
      onConditionSelected: (v) => onConditionSelected(v),
      onOperatorSelected: (v) => onOperatorSelected(v),
      onFilterChanged: (v) => onFilterChanged(v),
    ));
  }
}

class ConditionRow extends StatelessWidget {
  final Function(ConditionSelection?) onConditionSelected;
  final Function(OperationSelection?) onOperatorSelected;
  final Function(String?) onFilterChanged;
  final ConditionSelection? conditionSelected;
  final OperationSelection? operationSelected;
  const ConditionRow(
      {super.key,
      required this.onConditionSelected,
      required this.onOperatorSelected,
      required this.onFilterChanged,
      required this.conditionSelected,
      required this.operationSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConditionSelector(onConditionSelected: (v) => onConditionSelected(v)),
        OperatorSelector(
          operationSelected: operationSelected,
          onOperatorSelected: (v) => onOperatorSelected(v),
          conditionSelected: conditionSelected,
        ),
        FilterField(onFilterFieldChanged: (v) => onFilterChanged(v)),
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

class FilterField extends StatefulWidget {
  final Function(String) onFilterFieldChanged;
  const FilterField({super.key, required this.onFilterFieldChanged});

  @override
  State<FilterField> createState() => _FilterFieldState();
}

class _FilterFieldState extends State<FilterField> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextField(
        decoration: InputDecoration(labelText: "Filter"),
        onChanged: (v) => widget.onFilterFieldChanged(v),
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
