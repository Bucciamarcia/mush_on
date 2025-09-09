import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/shared/dog_filter/date_range_picker/main.dart';
import 'package:mush_on/shared/dog_filter/main.dart';
import 'package:mush_on/stats/riverpod.dart';
import 'package:mush_on/teams_history/riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'grid_row_processor.dart';
import 'sf_data_grid.dart';
import 'constants.dart';

class StatsMain extends ConsumerWidget {
  const StatsMain({super.key});
  static final BasicLogger logger = BasicLogger();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dogsAsync = ref.watch(dogsProvider);
    return dogsAsync.when(
      data: (allDogs) {
        final filteredDogs = ref.watch(filteredDogsProvider);
        var dates = ref.watch(statsDatesProvider);
        var teamGroupsAsync = ref.watch(teamGroupsProvider(
            earliestDate:
                DateTimeUtils.today().subtract(const Duration(days: 360)),
            finalDate: DateTimeUtils.endOfToday()));
        return teamGroupsAsync.when(
          data: (teams) {
            GridRowProcessor dataManipulator = GridRowProcessor(
                teams: teams,
                dogs: filteredDogs.isEmpty ? allDogs : filteredDogs,
                startDate: dates.startDate,
                finishDate: dates.endDate,
                ref: ref);
            GridRowProcessorResult gridData = dataManipulator.run();

            StatsDataSource statsDataSource =
                StatsDataSource(gridData: gridData);

            return Column(
              children: [
                Card(
                  child: ExpansionTile(
                    maintainState: true,
                    title: const Text("Filter date"),
                    children: [
                      DateRangePicker(
                        key: const PageStorageKey("daterangepicker stats"),
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
                Card(
                    child: ExpansionTile(
                  maintainState: true,
                  title: const Text("Filter dogs"),
                  children: [
                    DogFilterWidget(
                        dogs: allDogs,
                        onResult: (changedDogs) => ref
                            .read(filteredDogsProvider.notifier)
                            .changeFilteredDogs(changedDogs),
                        templates: null)
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.download),
                        label: const Text('Export CSV'),
                        onPressed: () async {
                          try {
                            final dogsToUse =
                                filteredDogs.isEmpty ? allDogs : filteredDogs;
                            final csv = _buildCsv(
                              gridData: gridData,
                              dogs: dogsToUse,
                            );
                            await Clipboard.setData(
                                ClipboardData(text: csv));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'CSV copied to clipboard. Paste it into a file (e.g., stats.csv).'),
                                ),
                              );
                            }
                          } catch (e, s) {
                            logger.error('CSV export failed',
                                error: e, stackTrace: s);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to export CSV'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Flexible(
                    child: SfDataGridClass(
                        statsDataSource: statsDataSource,
                        dogs: filteredDogs.isEmpty ? allDogs : filteredDogs)),
              ],
            );
          },
          error: (e, s) {
            logger.error("Couldn't get teamgroups");
            return const Text("Couldn't fetch teams");
          },
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
        );
      },
      error: (e, s) {
        logger.error("couldn't load dogs.", error: e, stackTrace: s);
        return const Text("Couldn't load dogs");
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
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

String _buildCsv({
  required GridRowProcessorResult gridData,
  required List<Dog> dogs,
}) {
  final buffer = StringBuffer();

  // Header row: Date + each dog name in the same order used by the grid
  final headers = <String>['Date', ...dogs.map((d) => d.name)];
  buffer.writeln(headers.map(_csvEscape).join(','));

  // Build an index from columnName to position for quick lookup per row
  // We know the grid rows are created as: Date, Month-Year (hidden), then dog.id for each dog in order.
  for (final row in gridData.dataGridRows) {
    final cells = row.getCells();

    // Map for quick lookup by columnName
    final byColumn = {for (final c in cells) c.columnName: c.value};

    final dateLabel = byColumn[dateColumnName]?.toString() ?? '';

    final dogValues = dogs.map((dog) {
      final value = byColumn[dog.id];
      if (value is num) {
        final v = value.toDouble();
        if (v == 0) return '';
        return _formatDouble(v);
      } else if (value is String) {
        return value; // Should not happen for dog columns, but safe.
      }
      return '';
    }).toList();

    final rowValues = <String>[dateLabel, ...dogValues];
    buffer.writeln(rowValues.map(_csvEscape).join(','));
  }

  return buffer.toString();
}

String _formatDouble(double value) {
  if (value == value.truncate()) {
    return value.toInt().toString();
  } else {
    return value.toString();
  }
}

String _csvEscape(String input) {
  final needsQuoting =
      input.contains(',') || input.contains('"') || input.contains('\n');
  var out = input.replaceAll('"', '""');
  if (needsQuoting) {
    out = '"$out"';
  }
  return out;
}
