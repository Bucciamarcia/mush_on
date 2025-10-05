import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/riverpod/teamgroup.dart';
import 'package:mush_on/shared/dog_filter/date_range_picker/main.dart';
import 'package:mush_on/stats/grid_row_processor.dart';
import 'package:mush_on/stats/insights/models.dart';
import 'package:mush_on/stats/insights/riverpod.dart';
import 'package:mush_on/stats/riverpod.dart';
import 'package:mush_on/teams_history/riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
// Calculate days from 90 days before start date to end date
    int daysToFetch = dateRange.endDate
        .difference(dateRange.startDate.subtract(const Duration(days: 90)))
        .inDays;

    List<HealthEvent> healthEvents = ref
            .watch(
              healthEventsProvider(daysToFetch),
            )
            .value ??
        [];
    List<TeamGroup> teamGroups = ref
            .watch(teamGroupsProvider(
                earliestDate:
                    dateRange.startDate.subtract(const Duration(days: 30)),
                finalDate: DateTimeUtils.today()))
            .value ??
        [];
    List<TeamGroup> filteredTeamGroups = teamGroups
        .where((teamGroup) =>
            teamGroup.date.isAfter(dateRange.startDate) &&
            teamGroup.date
                .isBefore(dateRange.endDate.add(const Duration(days: 1))))
        .toList();
    Map<String, List<DogDailyStats>> dogDailyStats =
        _getDogDailyStats(dogs, filteredTeamGroups, ref);
    List<DataGridRow> insightsData = ref.watch(insightsDataProvider(
        dogs: dogs,
        dateRange: dateRange,
        healthEvents: healthEvents,
        dogDailyStats: dogDailyStats));
    List<ReliabilityMatrixChartData> realiabilityData = ref.watch(
        reliabilityMatrixDataProvider(
            dogDailyStats: dogDailyStats,
            dogs: dogs,
            dateRange: dateRange,
            healthEvents: healthEvents));
    return Column(
      spacing: 20,
      children: [
        Card(
          child: ExpansionTile(
            title: const Text("Filter date"),
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
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: "Insights"),
                    Tab(text: "Reliability matrix"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SfDataGrid(
                        columnWidthMode: ColumnWidthMode.auto,
                        source: _getDataSource(
                          dateRange,
                          dogs,
                          dogDailyStats,
                          healthEvents
                              .where(
                                (event) => event.preventFromRunning == true,
                              )
                              .toList(),
                          insightsData,
                        ),
                        columns: _getGridColumns(),
                      ),
                      SfCartesianChart(
                        primaryXAxis: const NumericAxis(
                          title: AxisTitle(text: "Km ran"),
                          plotOffset: 20,
                        ),
                        primaryYAxis: const NumericAxis(
                          title: AxisTitle(text: "Reliability %"),
                          plotOffset: 20,
                        ),
                        series: [
                          ScatterSeries<ReliabilityMatrixChartData, double>(
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                            dataLabelMapper: (data, _) =>
                                dogs.getNameFromId(data.dogId),
                            markerSettings:
                                const MarkerSettings(width: 25, height: 25),
                            dataSource: realiabilityData,
                            xValueMapper: (data, _) => data.x,
                            yValueMapper: (data, _) => data.y,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
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
      StatsDateRange dateRange,
      List<Dog> dogs,
      Map<String, List<DogDailyStats>> dogDailyStats,
      List<HealthEvent> healthEvents,
      List<DataGridRow> insightsData) {
    logger.info("Building insights data source");
    return InsightsDataSource(insightsData: insightsData);
  }

  List<GridColumn> _getGridColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: "dog",
        label: const Center(
          child: Text("Dog"),
        ),
      ),
      GridColumn(
        columnName: "totalRan",
        label: const Center(
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
        label: const Center(
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
      GridColumn(
        columnName: "reliability",
        label: const Center(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  "Reliability",
                ),
              ),
              Tooltip(
                showDuration: Duration(seconds: 5),
                triggerMode: TooltipTriggerMode.tap,
                message:
                    "Percentage of days in the selected period that the dog was available to run (i.e., not sidelined by a health event).",
                child: Icon(Icons.question_mark),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Map<String, List<DogDailyStats>> _getDogDailyStats(
      List<Dog> dogs, List<TeamGroup> teamGroups, WidgetRef ref) {
    Map<String, Map<DateTime, double>> tempDailyDistances = {
      for (var dog in dogs) dog.id: {}
    };

    for (final teamGroup in teamGroups) {
      final day = DateTime(
          teamGroup.date.year, teamGroup.date.month, teamGroup.date.day);
      List<Team> teams =
          ref.watch(teamsInTeamgroupProvider(teamGroup.id)).value ?? [];
      for (final team in teams) {
        List<DogPair> dogPairs =
            ref.watch(dogPairsInTeamProvider(teamGroup.id, team.id)).value ??
                [];
        for (final pair in dogPairs) {
          if (pair.firstDogId != null) {
            tempDailyDistances[pair.firstDogId]?[day] =
                (tempDailyDistances[pair.firstDogId]![day] ?? 0) +
                    teamGroup.distance;
          }
          if (pair.secondDogId != null) {
            tempDailyDistances[pair.secondDogId]?[day] =
                (tempDailyDistances[pair.secondDogId]![day] ?? 0) +
                    teamGroup.distance;
          }
        }
      }
    }

    Map<String, List<DogDailyStats>> toReturn = {};
    for (final dogId in tempDailyDistances.keys) {
      final dogDailies = tempDailyDistances[dogId]!
          .entries
          .map((entry) =>
              DogDailyStats(date: entry.key, distanceRan: entry.value))
          .toList();
      dogDailies.sort((a, b) => a.date.compareTo(b.date));
      toReturn[dogId] = dogDailies;
    }
    return toReturn;
  }
}
