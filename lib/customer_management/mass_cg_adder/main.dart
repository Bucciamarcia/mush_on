import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/mass_cg_adder/elements/days_of_month_selector.dart';
import 'package:mush_on/customer_management/mass_cg_adder/models.dart';
import 'package:mush_on/customer_management/mass_cg_adder/repository.dart';
import 'package:mush_on/customer_management/mass_cg_adder/riverpod.dart';
import 'package:mush_on/customer_management/tours/models.dart';
import 'package:mush_on/customer_management/tours/riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';

import 'elements/days_of_week_selector.dart';
import 'elements/rule_type_dropdown_selector.dart';

class MassAddCg extends ConsumerWidget {
  const MassAddCg({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool canAddCgs = ref.watch(canAddCgsProvider);
    String account = ref.watch(accountProvider).value ?? "";
    List<TourType> tours =
        ref.watch(allTourTypesProvider(showArchived: false)).value ?? [];
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
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 15,
          children: [
            Text("This rule should"),
            RuleTypeDropdownSelector(),
          ],
        ),
        _pickSelectorBasedOnRule(ref.watch(selectedRuleTypeProvider)),
        TextField(
          onChanged: (s) {
            ref.read(massCgEditorCgNameProvider.notifier).change(s);
          },
          decoration: InputDecoration(
            labelText: "Customer Group Name",
            hintText: "Internal name (not shown to customers)",
            prefixIcon: const Icon(Icons.edit),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
        ),
        Text("Selected time: ${ref.watch(massCgEditorCgTimeProvider)}"),
        ElevatedButton(
            onPressed: () async {
              final TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: ref.read(massCgEditorCgTimeProvider));
              if (newTime != null) {
                ref.read(massCgEditorCgTimeProvider.notifier).change(newTime);
              }
            },
            child: const Text("Pick time")),
        TextField(
          onChanged: (v) => ref
              .read(massCgEditorCgCapacityProvider.notifier)
              .change(int.tryParse(v)),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            labelText: "Max Capacity",
            hintText: "Maximum number of people in this group",
            prefixIcon: const Icon(Icons.people),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
        ),
        DropdownMenu<TourType>(
          label: const Text("Select tour type"),
          expandedInsets: EdgeInsets.zero,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
          onSelected: (s) {
            if (s != null) {
              ref.read(massCgEditorTourTypeProvider.notifier).change(s);
            }
          },
          dropdownMenuEntries: tours
              .map(
                (tour) => DropdownMenuEntry(
                    value: tour, label: "${tour.name} - ${tour.distance} km"),
              )
              .toList(),
        ),
        ElevatedButton(
          onPressed: canAddCgs
              ? () async {
                  final repo = MassCgAdderRepository(
                    ruleType: ref.read(selectedRuleTypeProvider),
                    daysOfWeekSelected: ref.read(daysOfWeekSelectedProvider),
                    dateRangeSelection:
                        ref.read(dateRangeSelectedForWeekSelectionProvider),
                    onSelectedDaysSelected:
                        ref.read(onSelectedDaysSelectedProvider),
                    cgName: ref.read(massCgEditorCgNameProvider),
                    time: ref.read(massCgEditorCgTimeProvider),
                    maxCapacity: ref.read(massCgEditorCgCapacityProvider)!,
                    tourType: ref.read(massCgEditorTourTypeProvider)!,
                    account: account,
                  );
                  try {
                    await repo.add();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          confirmationSnackbar(
                              context, "All Customer Groups added"));
                      Navigator.of(context).pop();
                    }
                  } on TooManyDatesException catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(errorSnackBar(context, e.toString()));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          errorSnackBar(context, "Error: couldn't add batch"));
                    }
                  }
                }
              : null,
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(
              canAddCgs
                  ? Theme.of(context).colorScheme.onPrimary
                  : Colors.black,
            ),
            backgroundColor: WidgetStateProperty.all(
              canAddCgs
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[400],
            ),
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 16),
            ),
          ),
          child: const Text("Add Customer Groups"),
        )
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
