import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/mass_cg_adder/elements/days_of_month_selector.dart';
import 'package:mush_on/customer_management/mass_cg_adder/models.dart';
import 'package:mush_on/customer_management/mass_cg_adder/riverpod.dart';

import 'elements/days_of_week_selector.dart';
import 'elements/rule_type_dropdown_selector.dart';

class MassAddCg extends ConsumerWidget {
  const MassAddCg({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
        child: Column(
      spacing: 25,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Select the repeat rule",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 15,
          children: [
            Text("This rule should"),
            RuleTypeDropdownSelector(),
          ],
        ),
        _pickSelectorBasedOnRule(ref.watch(selectedRuleTypeProvider)),
      ],
    ));
  }

  Widget _pickSelectorBasedOnRule(AddCgRuleType rule) {
    switch (rule) {
      case AddCgRuleType.weeklyOnDays:
        return const DayOfWeekSelector();
      case AddCgRuleType.onSelectedDays:
        return const SelectedDaysSelector();
    }
  }
}
