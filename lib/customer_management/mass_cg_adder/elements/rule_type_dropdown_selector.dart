import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/mass_cg_adder/models.dart';
import 'package:mush_on/customer_management/mass_cg_adder/riverpod.dart';

class RuleTypeDropdownSelector extends ConsumerWidget {
  const RuleTypeDropdownSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownMenu(
        controller: TextEditingController(
            text: ref.watch(selectedRuleTypeProvider).description),
        onSelected: (newRuleType) {
          if (newRuleType != null) {
            ref
                .read(selectedRuleTypeProvider.notifier)
                .changeRuleType(newRuleType);
          }
        },
        dropdownMenuEntries: AddCgRuleType.values
            .map((valueType) => DropdownMenuEntry(
                value: valueType, label: valueType.description))
            .toList());
  }
}
