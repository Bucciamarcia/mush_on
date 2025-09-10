import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/customer_management/mass_cg_adder/riverpod.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SelectedDaysSelector extends ConsumerWidget {
  const SelectedDaysSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SfDateRangePicker(
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.multiple,
          minDate: DateTimeUtils.today(),
          onSelectionChanged: (args) {
            if (args.value is List<DateTime>) {
              final selectedDates = args.value as List<DateTime>;
              ref
                  .read(onSelectedDaysSelectedProvider.notifier)
                  .changeSelected(selectedDates);
            }
          },
        ),
        Text(ref.watch(onSelectedDaysSelectedProvider).toString()),
      ],
    );
  }
}
