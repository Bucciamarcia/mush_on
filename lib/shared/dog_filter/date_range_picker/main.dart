import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePicker extends StatelessWidget {
  final DateTime? maxDate;
  final DateTime? minDate;
  final Function(DateRangePickerSelectionChangedArgs) onSelectionChanged;
  const DateRangePicker(
      {super.key,
      required this.minDate,
      required this.maxDate,
      required this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      maxDate: maxDate,
      minDate: minDate,
      selectionMode: DateRangePickerSelectionMode.range,
      onSelectionChanged: (r) => onSelectionChanged(r),
      monthViewSettings:
          const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
    );
  }
}
