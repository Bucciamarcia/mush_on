import 'package:flutter/material.dart';
import 'package:mush_on/services/error_handling.dart';
import '../../services/models/dog.dart';
import "enums.dart";
import 'package:mush_on/shared/dog_filter/provider.dart';
import 'package:provider/provider.dart';

class DogFilterWidget extends StatelessWidget {
  const DogFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    DogFilterProvider provider = context.watch<DogFilterProvider>();
    List<Dog> dogs = provider.dogs;
    return ConditionGroup();
  }
}

class ConditionGroup extends StatelessWidget {
  const ConditionGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(child: ConditionRow());
  }
}

class ConditionRow extends StatefulWidget {
  const ConditionRow({super.key});

  @override
  State<ConditionRow> createState() => _ConditionRowState();
}

class _ConditionRowState extends State<ConditionRow> {
  OperationSelection? operation;
  ConditionSelection? selector;
  String? filter;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConditionSelector(
          onConditionSelected: (v) => setState(() {
            selector = v;
          }),
        ),
        OperatorSelector(
          onOperatorSelected: (v) => setState(() {
            operation = v;
          }),
        ),
        FilterField(
          onFilterFieldChanged: (v) => setState(() {
            filter = v;
          }),
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
  final Function(OperationSelection?) onOperatorSelected;
  const OperatorSelector({super.key, required this.onOperatorSelected});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<OperationSelection>(
        label: Text("Operator"),
        dropdownMenuEntries: OperationSelection.values
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
