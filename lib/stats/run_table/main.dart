import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RunTable extends StatelessWidget {
  final List<Dog> dogs;
  final List<TeamGroupWorkspace> teamGroups;
  const RunTable({super.key, required this.dogs, required this.teamGroups});

  @override
  Widget build(BuildContext context) {
    final sortedTeamGroups = [...teamGroups]
      ..sort((a, b) => a.date.compareTo(b.date));
    return SfDataGrid(
        source: DogsDataSource(dogs: dogs, teamGroups: sortedTeamGroups),
        columns: _fetchGridcolumns());
  }

  List<GridColumn> _fetchGridcolumns() {
    List<GridColumn> toReturn = [
      GridColumn(columnName: "Date", label: const Text("Date")),
      ...dogs
          .map((dog) => GridColumn(columnName: dog.name, label: Text(dog.name)))
    ];
    return toReturn;
  }
}

class DogsDataSource extends DataGridSource {
  final List<Dog> dogs;
  final List<TeamGroupWorkspace> teamGroups;
  List<DataGridRow> dataGridRows = [];
  DogsDataSource({required this.dogs, required this.teamGroups}) {
    final allDates = _getAllDates();
    final runTableByDog = _getRunTableByDog(allDates);
    dataGridRows = _buildDataGridRows(allDates, runTableByDog);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: (dataGridCell.columnName == 'id' ||
                  dataGridCell.columnName == 'salary')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  List<DataGridRow> _buildDataGridRows(
    List<DateTime> allDates,
    Map<DateTime, Map<String, double>> runTableByDog,
  ) {
    final List<DataGridRow> toReturn = [];
    if (allDates.isEmpty) return toReturn;

    var previousDate = allDates.first;

    // Summary for the first month
    toReturn.add(_buildMonthSummaryRow(
      runTableByDog: runTableByDog,
      month: previousDate.month,
      year: previousDate.year,
    ));

    for (final date in allDates) {
      if (previousDate.month != date.month || previousDate.year != date.year) {
        // Month (or year) changed → summary row for the new month
        toReturn.add(_buildMonthSummaryRow(
          runTableByDog: runTableByDog,
          month: date.month,
          year: date.year,
        ));
      }

      toReturn.add(DataGridRow(cells: [
        DataGridCell(columnName: "Date", value: date.toString()),
        ...dogs.map((dog) => DataGridCell(
              columnName: dog.name,
              value: runTableByDog[date]?[dog.name] ?? 0.0,
            )),
      ]));

      previousDate = date;
    }

    return toReturn;
  }

  DataGridRow _buildMonthSummaryRow(
      {required Map<DateTime, Map<String, double>> runTableByDog,
      required int month,
      required int year}) {
    Map<String, double> dogTotals = {};
    for (final dog in dogs) {
      dogTotals[dog.name] = 0.0;
    }
    runTableByDog.forEach((date, runMap) {
      if (date.month == month && date.year == year) {
        for (final dog in dogs) {
          if (runMap[dog.name] != null) {
            final distanceRan = runMap[dog.name]!;
            dogTotals[dog.name] = dogTotals[dog.name]! + distanceRan;
          }
        }
      }
    });
    final firstOfMonth = DateTime(year, month, 1);
    List<DataGridCell> cells = [];
    dogTotals.forEach((dogName, ran) {
      cells.add(DataGridCell(columnName: dogName, value: ran.toString()));
    });

    return DataGridRow(cells: [
      DataGridCell(
          columnName: "Date", value: DateFormat("MMM yy").format(firstOfMonth)),
      ...cells
    ]);
  }

  List<DateTime> _getAllDates() {
    var toReturn = <DateTime>[];
    if (teamGroups.isEmpty) return [];
    final firstDate = teamGroups.first.date;
    var iteratorDate = DateTime(firstDate.year, firstDate.month, firstDate.day);
    final lastDate = teamGroups.last.date;
    final lastDateMidnight =
        DateTime(lastDate.year, lastDate.month, lastDate.day);
    while (true) {
      toReturn.add(iteratorDate);
      if (iteratorDate.isAtSameMomentAs(lastDateMidnight) ||
          iteratorDate.isAfter(lastDateMidnight)) {
        break;
      }
      iteratorDate = iteratorDate.add(const Duration(days: 1));
    }
    toReturn.sort((a, b) => b.compareTo(a));
    return toReturn;
  }

  /// Returns a table of how much each dog has run each day.
  /// To be used to generate the table faster.
  /// Example table:
  /// {
  ///   2024-01-01: { "Dog A": 10.
  ///   5, "Dog B": 8.0 },
  ///   2024-01-02: { "Dog A": 12.
  ///   0, "Dog B": 9.5 },
  /// }
  /// Optimized: Pre-group teamGroups by date
  Map<DateTime, Map<String, double>> _getRunTableByDog(
      List<DateTime> allDates) {
    // Sort newest to oldest for display
    allDates.sort((a, b) => b.compareTo(a));

    // Pre-calculate dogs per teamGroup (called once per teamGroup instead of once per date)
    final Map<TeamGroupWorkspace, List<Dog>> dogsPerTeam = {};
    for (final tg in teamGroups) {
      dogsPerTeam[tg] = _findDogsInTg(tg);
    }

    // Group teamGroups by date
    final Map<DateTime, List<TeamGroupWorkspace>> teamGroupsByDate = {};
    for (final tg in teamGroups) {
      final dateKey = DateTime(tg.date.year, tg.date.month, tg.date.day);
      teamGroupsByDate.putIfAbsent(dateKey, () => []).add(tg);
    }

    // Build the result table
    Map<DateTime, Map<String, double>> toReturn = {};
    for (final date in allDates) {
      toReturn[date] = {};
      final tgsOnThisDate = teamGroupsByDate[date] ?? [];

      for (final tg in tgsOnThisDate) {
        final tourDistance = tg.distance;
        final dogsInTg = dogsPerTeam[tg]!;

        for (final dog in dogsInTg) {
          toReturn[date]![dog.name] =
              (toReturn[date]![dog.name] ?? 0.0) + tourDistance;
        }
      }
    }

    return toReturn;
  }

  List<Dog> _findDogsInTg(TeamGroupWorkspace tg) {
    final teams = tg.teams;
    Set<Dog> toReturn = {};
    for (final team in teams) {
      final dogPairs = team.dogPairs;
      for (final dp in dogPairs) {
        List<Dog> dogsToAdd = [];
        if (dp.firstDogId != null &&
            dogs.getDogFromId(dp.firstDogId!) != null) {
          dogsToAdd.add(dogs.getDogFromId(dp.firstDogId!)!);
        }
        if (dp.secondDogId != null &&
            dogs.getDogFromId(dp.secondDogId!) != null) {
          dogsToAdd.add(dogs.getDogFromId(dp.secondDogId!)!);
        }
        toReturn.addAll(dogsToAdd);
      }
    }
    return toReturn.toList();
  }
}
