import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/shared/dog_filter/date_range_picker/main.dart';
import 'package:mush_on/stats/insights/main.dart';
import 'package:mush_on/stats/riverpod.dart';
import 'package:mush_on/teams_history/riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'grid_row_processor.dart';
import 'sf_data_grid.dart';

// Assuming BasicLogger, DateTimeUtils, calculateOldestTeamGroup are defined elsewhere
// and are accessible.
// Also assuming Task, RecurringType, TaskRepository, accountProvider, tasksProvider,
// TasksInMemory, confirmationSnackbar, errorSnackBar are defined elsewhere.

class StatsMain extends ConsumerWidget {
  const StatsMain({super.key});
  static final BasicLogger logger = BasicLogger();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dogsAsync = ref.watch(dogsProvider);

    return dogsAsync.when(
      data: (dogs) {
        var dates = ref.watch(statsDatesProvider);
        var teamGroupsAsync = ref.watch(teamGroupsProvider(
            earliestDate: DateTimeUtils.today().subtract(Duration(days: 360)),
            finalDate: DateTimeUtils.today()));

        return teamGroupsAsync.when(
          data: (teams) {
            GridRowProcessor dataManipulator = GridRowProcessor(
                teams: teams,
                dogs: dogs,
                startDate: dates.startDate,
                finishDate: dates.endDate);
            GridRowProcessorResult gridData = dataManipulator.run();

            StatsDataSource statsDataSource =
                StatsDataSource(gridData: gridData);

            // Wrap the entire content with DefaultTabController
            return DefaultTabController(
              length: 2, // We have two tabs: "Averages" and "Insights"
              child: Column(
                children: [
                  // 1. Filter section (always on top)
                  Card(
                    margin: const EdgeInsets.all(
                        8.0), // Add some margin for better visual
                    child: ExpansionTile(
                      title: Text("Filter date"),
                      children: [
                        DateRangePicker(
                          maxDate: DateTimeUtils.today(),
                          minDate: calculateOldestTeamGroup(teams)
                                  .isBefore(DateTimeUtils.today())
                              ? calculateOldestTeamGroup(teams)
                              : DateTimeUtils.today(),
                          onSelectionChanged: (r) => _onSelectionChanged(
                            r: r,
                            onNewEndDate: (date) => ref
                                .read(statsDatesProvider.notifier)
                                .changeEndDate(date),
                            onNewStartDate: (date) => ref
                                .read(statsDatesProvider.notifier)
                                .changeStartDate(date),
                          ),
                        )
                      ],
                    ),
                  ),
                  // 2. TabBar
                  const TabBar(
                    tabs: [
                      Tab(text: "Averages"),
                      Tab(text: "Insights"),
                    ],
                  ),
                  // 3. TabBarView (takes remaining space)
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Content for "Averages" tab
                        SfDataGridClass(
                            statsDataSource: statsDataSource, dogs: dogs),
                        // Content for "Insights" tab (empty for now)
                        InsightsMain(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          error: (e, s) {
            logger.error("Couldn't get teamgroups", error: e, stackTrace: s);
            return Center(child: Text("Couldn't fetch teams"));
          },
          loading: () => Center(child: CircularProgressIndicator.adaptive()),
        );
      },
      error: (e, s) {
        logger.error("couldn't load dogs.", error: e, stackTrace: s);
        return Center(child: Text("Couldn't load dogs"));
      },
      loading: () => Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  void _onSelectionChanged({
    required DateRangePickerSelectionChangedArgs r,
    required Function(DateTime) onNewStartDate,
    required Function(DateTime) onNewEndDate,
  }) {
    PickerDateRange range = r.value;
    if (range.startDate != null) onNewStartDate(range.startDate!);
    if (range.endDate != null) onNewEndDate(range.endDate!);
  }
}
