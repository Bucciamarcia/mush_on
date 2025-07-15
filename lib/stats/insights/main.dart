import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/shared/dog_filter/date_range_picker/main.dart';
import 'package:mush_on/stats/grid_row_processor.dart';
import 'package:mush_on/stats/riverpod.dart';
import 'package:mush_on/teams_history/riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'insights_data_source_class.dart';

class InsightsMain extends ConsumerWidget {
  static final logger = BasicLogger();
  const InsightsMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StatsDateRange dateRange = ref.watch(statsDatesProvider);
    List<Dog> dogs = ref.watch(dogsProvider).value ?? [];
    List<TeamGroup> teamGroups = ref
            .watch(teamGroupsProvider(
                earliestDate:
                    DateTimeUtils.today().subtract(Duration(days: 360)),
                finalDate: DateTimeUtils.today()))
            .value ??
        [];
    return Column(
      spacing: 20,
      children: [
        Card(
          child: ExpansionTile(
            title: Text("Filter date"),
            children: [
              DateRangePicker(
                maxDate: DateTimeUtils.today(),
                minDate: calculateOldestTeamGroup(teamGroups)
                        .isBefore(DateTimeUtils.today())
                    ? calculateOldestTeamGroup(teamGroups)
                    : DateTimeUtils.today(),
                onSelectionChanged: (r) => _onSelectionChanged(
                  r: r,
                  onNewEndDate: (date) =>
                      ref.read(statsDatesProvider.notifier).changeEndDate(date),
                  onNewStartDate: (date) => ref
                      .read(statsDatesProvider.notifier)
                      .changeStartDate(date),
                ),
              )
            ],
          ),
        ),
        Text(
            "Date selected: ${DateFormat("dd-MM-yyyy").format(dateRange.startDate)} - ${DateFormat("dd-MM-yyyy").format(dateRange.endDate)}"),
        Flexible(
          child: SfDataGrid(
            source: _getDataSource(dateRange, dogs, teamGroups),
            columns: _getGridColumns(),
          ),
        ),
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

  DataGridSource _getDataSource(
      StatsDateRange dateRange, List<Dog> dogs, List<TeamGroup> teamGroups) {
    logger.info("Building insights data source");
    return InsightsDataSource(
        dateRange: dateRange, dogs: dogs, teamGroups: teamGroups);
  }

  List<GridColumn> _getGridColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: "dog",
        label: Center(
          child: Text("Dog"),
        ),
      ),
      GridColumn(
        columnName: "totalRan",
        label: Center(
          child: Row(
            spacing: 3,
            children: [
              Text("Total run"),
              Tooltip(
                showDuration: Duration(seconds: 5),
                triggerMode: TooltipTriggerMode.tap,
                message:
                    "The total distance run by this dog in the selected period.",
                child: Icon(Icons.question_mark),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
