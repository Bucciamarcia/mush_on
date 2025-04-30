import 'package:flutter/material.dart';
import "enums.dart";
import 'package:mush_on/shared/dog_filter/provider.dart';
import 'package:provider/provider.dart';

class DogFilterWidget extends StatelessWidget {
  const DogFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    DogFilterProvider provider = context.watch<DogFilterProvider>();
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
  ConditionOperation? operator;
  ConditionSelection? selector;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ConditionSelector(
          onConditionSelected: (v) => setState(() {
            selector = v;
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
    return IntrinsicWidth(
      child: DropdownMenu<ConditionSelection>(
        onSelected: (v) => onConditionSelected(v),
        dropdownMenuEntries: ConditionSelection.values
            .map((v) => DropdownMenuEntry(value: v, label: v.name))
            .toList(),
      ),
    );
  }
}
