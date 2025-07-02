import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/shared/dog_filter/date_range_picker/main.dart';
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
    final dogs = Provider.of<MainProvider>(context, listen: true).dogs;

    GridRowProcessor dataManipulator = GridRowProcessor(
        teams: statsProvider.teams,
        dogs: dogs,
        startDate: statsProvider.startDate,
        finishDate: statsProvider.endDate);
    GridRowProcessorResult gridData = dataManipulator.run();

    StatsDataSource statsDataSource = StatsDataSource(gridData: gridData);

    return Column(
      children: [
        Card(
          child: ExpansionTile(
            title: Text("Filter date"),
            children: [
              DateRangePicker(
                maxDate: DateTimeUtils.today(),
                minDate: calculateOldestTeamGroup(statsProvider.teams)
                        .isBefore(DateTimeUtils.today())
                    ? calculateOldestTeamGroup(statsProvider.teams)
                    : DateTimeUtils.today(),
                onSelectionChanged: (r) => _onSelectionChanged(
                  r: r,
                  onNewEndDate: (date) => statsProvider.changeEndDate(date),
                  onNewStartDate: (date) => statsProvider.changeStartDate(date),
                ),
              )
            ],
          ),
        ),
        Flexible(
            child:
                SfDataGridClass(statsDataSource: statsDataSource, dogs: dogs)),
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
