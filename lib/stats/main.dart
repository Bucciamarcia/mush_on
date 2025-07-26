import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/shared/dog_filter/date_range_picker/main.dart';
import 'package:mush_on/stats/riverpod.dart';
import 'package:mush_on/teams_history/riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'grid_row_processor.dart';
import 'sf_data_grid.dart';

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
                finishDate: dates.endDate,
                ref: ref);
            return FutureBuilder(
                future: dataManipulator.run(),
                builder: (context, v) {
                  if (v.connectionState == ConnectionState.waiting ||
                      v.data == null) {
                    return CircularProgressIndicator();
                  } else if (v.hasError) {
                    return Text("Error");
                  } else {
                    GridRowProcessorResult gridData = v.data!;

                    StatsDataSource statsDataSource =
                        StatsDataSource(gridData: gridData);

                    return Column(
                      children: [
                        Card(
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
                        Flexible(
                            child: SfDataGridClass(
                                statsDataSource: statsDataSource, dogs: dogs)),
                      ],
                    );
                  }
                });
          },
          error: (e, s) {
            logger.error("Couldn't get teamgroups");
            return Text("Couldn't fetch teams");
          },
          loading: () => Center(child: CircularProgressIndicator.adaptive()),
        );
      },
      error: (e, s) {
        logger.error("couldn't load dogs.", error: e, stackTrace: s);
        return Text("Couldn't load dogs");
      },
      loading: () => Center(child: CircularProgressIndicator.adaptive()),
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
