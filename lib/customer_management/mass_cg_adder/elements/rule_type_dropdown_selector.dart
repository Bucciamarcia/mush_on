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
    final selectedRuleType = ref.watch(selectedRuleTypeProvider);

    return SegmentedButton<AddCgRuleType>(
      segments: AddCgRuleType.values
          .map((v) => ButtonSegment(
                value: v,
                label: Text(v.description),
              ))
          .toList(),
      selected: {selectedRuleType},
      onSelectionChanged: (Set<AddCgRuleType> selection) {
        if (selection.isNotEmpty) {
          ref
              .read(selectedRuleTypeProvider.notifier)
              .changeRuleType(selection.first);
        }
      },
    );
  }
}
