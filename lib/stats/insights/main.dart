import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/shared/dog_filter/date_range_picker/main.dart';
import 'package:mush_on/stats/grid_row_processor.dart';
import 'package:mush_on/stats/insights/models.dart';
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
    List<TeamGroup> filteredTeamGroups = teamGroups
        .where((teamGroup) =>
            teamGroup.date.isAfter(dateRange.startDate) &&
            teamGroup.date.isBefore(dateRange.endDate.add(Duration(days: 1))))
        .toList();
    Map<String, List<DogDailyStats>> dogDailyStats =
        _getDogDailyStats(dogs, filteredTeamGroups);
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
        Expanded(
          child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.auto,
            source: _getDataSource(dateRange, dogs, dogDailyStats),
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

  DataGridSource _getDataSource(StatsDateRange dateRange, List<Dog> dogs,
      Map<String, List<DogDailyStats>> dogDailyStats) {
    logger.info("Building insights data source");
    return InsightsDataSource(
        dateRange: dateRange, dogs: dogs, dogDailyStats: dogDailyStats);
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
              Flexible(child: Text("Total run")),
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
      GridColumn(
        columnName: "runRate",
        label: Center(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  "Run rate",
                ),
              ),
              Tooltip(
                showDuration: Duration(seconds: 5),
                triggerMode: TooltipTriggerMode.tap,
                message: "How many days the dog has run in % of the total",
                child: Icon(Icons.question_mark),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Map<String, List<DogDailyStats>> _getDogDailyStats(
      List<Dog> dogs, List<TeamGroup> teamGroups) {
    Map<String, List<DogDailyStats>> toReturn = {};

    for (Dog dog in dogs) {
      Map<DateTime, double> dailyDistances = {};

      for (TeamGroup teamGroup in teamGroups) {
        DateTime day = DateTime(
            teamGroup.date.year, teamGroup.date.month, teamGroup.date.day);

        bool dogFound = false;
        for (var team in teamGroup.teams) {
          for (var pair in team.dogPairs) {
            if (pair.firstDogId == dog.id || pair.secondDogId == dog.id) {
              dailyDistances[day] =
                  (dailyDistances[day] ?? 0) + teamGroup.distance;
              dogFound = true;
              break;
            }
          }
          if (dogFound) break;
        }
      }

      List<DogDailyStats> dogDailies = dailyDistances.entries
          .map((entry) =>
              DogDailyStats(date: entry.key, distanceRan: entry.value))
          .toList();
      dogDailies.sort((a, b) => a.date.compareTo(b.date));

      toReturn[dog.id] = dogDailies;
    }

    return toReturn;
  }
}
