import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TeamsHistoryDateSelector extends ConsumerWidget {
  final Function(DateTime, DateTime) onDateRangeSelected;
  const TeamsHistoryDateSelector(
      {super.key, required this.onDateRangeSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionTile(
      title: const Text(
        "Pick date range (default last 30 days)",
        style: TextStyle(overflow: TextOverflow.ellipsis),
      ),
      children: [
        SfDateRangePicker(
          onSelectionChanged: (args) {
            PickerDateRange range = args.value;
            onDateRangeSelected(
                range.startDate ??
                    DateTimeUtils.today().subtract(const Duration(days: 30)),
                range.endDate == null
                    ? DateTimeUtils.endOfToday()
                    : DateTime(range.endDate!.year, range.endDate!.month,
                        range.endDate!.day, 23, 59, 59));
          },
          selectionMode: DateRangePickerSelectionMode.range,
        )
      ],
    );
  }
}
