import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'grid_row_processor.dart';
import 'provider.dart';
import 'sf_data_grid.dart';

class StatsMain extends StatelessWidget {
  const StatsMain({super.key});
  static final BasicLogger logger = BasicLogger();

  @override
  Widget build(BuildContext context) {
    final statsProvider = context.watch<StatsProvider>();
    final dogs = Provider.of<DogProvider>(context, listen: true).dogs;

    GridRowProcessor dataManipulator = GridRowProcessor(
        teams: statsProvider.teams,
        dogs: dogs,
        startDate: statsProvider.startDate,
        finishDate: statsProvider.endDate);
    GridRowProcessorResult gridData = dataManipulator.run();

    StatsDataSource statsDataSource = StatsDataSource(gridData: gridData);

    return Column(
      children: [
        SfDateRangePicker(
          selectionMode: DateRangePickerSelectionMode.range,
          onSelectionChanged: (r) => _onSelectionChanged(
              r: r,
              onNewEndDate: (date) => statsProvider.changeEndDate(date),
              onNewStartDate: (date) => statsProvider.changeStartDate(date)),
          monthViewSettings:
              DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
        ),
        SfDataGridClass(statsDataSource: statsDataSource, dogs: dogs),
      ],
    );
  }

  void _onSelectionChanged(
      {required DateRangePickerSelectionChangedArgs r,
      required Function(DateTime) onNewStartDate,
      required Function(DateTime) onNewEndDate}) {
    PickerDateRange range = r.value;
    if (range.startDate != null) onNewStartDate(range.startDate!);
    if (range.endDate != null) onNewEndDate(range.endDate!);
  }
}
