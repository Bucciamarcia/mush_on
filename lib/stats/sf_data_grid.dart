import 'package:flutter/material.dart';
import 'package:mush_on/stats/daily_dog_stats.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../services/models.dart';

class SfDataGridClass extends StatelessWidget {
  final List<Dog> _dogs;
  const SfDataGridClass({
    super.key,
    required StatsDataSource statsDataSource,
    required List<Dog> dogs,
  })  : _statsDataSource = statsDataSource,
        _dogs = dogs;

  final StatsDataSource _statsDataSource;

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      isScrollbarAlwaysShown: true,
      source: _statsDataSource,
      columns: [
        GridColumn(
            columnName: "Date",
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: Text(
                "Date",
                overflow: TextOverflow.ellipsis,
              ),
            )),
        ..._dogs.map<GridColumn>((Dog dog) {
          return GridColumn(
              columnName: dog.name,
              label: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: Text(
                  dog.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ));
        })
      ],
      frozenColumnsCount: 1,
      tableSummaryRows: [
        GridTableSummaryRow(
            showSummaryInRow: false,
            columns: _dogs.map((dog) {
              return GridSummaryColumn(
                  name: dog.name,
                  columnName: dog.name,
                  summaryType: GridSummaryType.sum);
            }).toList(),
            position: GridTableSummaryRowPosition.top)
      ],
    );
  }
}

class StatsDataSource extends DataGridSource {
  late List<DataGridRow> dataGridRows;
  StatsDataSource({required List<DataGridRow> gridData}) {
    dataGridRows = gridData;
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row
          .getCells()
          .map<Widget>(
            (cell) => Center(
              child: Text(_formatCellValue(cell.value)),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Text(
          summaryValue,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  String _formatCellValue(dynamic value) {
    if (value is double) {
      if (value == 0) return "";
      return formatDouble(value);
    } else {
      return value?.toString() ?? '';
    }
  }

  String formatDouble(double value) {
    if (value == value.truncate()) {
      return value.toInt().toString();
    } else {
      return value.toString();
    }
  }
}

/// Operations that StatsDataSource constructor must perform.
class GridRowProcessor {
  List<TeamGroup> teams;
  List<Dog> dogs;
  GridRowProcessor({required this.teams, required this.dogs});

  List<DataGridRow> run() {
    List<DailyDogStats> aggregatedStats = _aggregateData();
    List<DataGridRow> dataGridRows = _buildGridRows(aggregatedStats);
    return dataGridRows;
  }

  List<DailyDogStats> _aggregateData() {
    List<DailyDogStats> toReturn = [];
    final today = DateTime.now();
    final todayWithoutTime = DateTime(today.year, today.month, today.day);
    Map<String, List<TeamGroup>> teamsByDay = getTeamsByDay();
    DateTime oldestDate = findOldestDate();

    List<DateTime> allDates = [];
    DateTime currentDate = oldestDate;

    currentDate = addCurrentDate(currentDate, todayWithoutTime, allDates);

    allDates.sort((a, b) => b.compareTo(a));
    for (DateTime day in allDates) {
      String dateKey = _formatDateKey(day);
      if (teamsByDay.containsKey(dateKey)) {
        List<TeamGroup>? dayTeams = teamsByDay[dateKey];
        Map<String, double> dogDistances = {};
        for (TeamGroup dayTeam in dayTeams!) {
          for (Team team in dayTeam.teams) {
            for (DogPair dogPair in team.dogPairs) {
              if (dogPair.firstDog != null) {
                String dogName = dogPair.firstDog!.name;
                dogDistances[dogName] =
                    (dogDistances[dogName] ?? 0) + dayTeam.distance;
              }
              if (dogPair.secondDog != null) {
                String dogName = dogPair.secondDog!.name;
                dogDistances[dogName] =
                    (dogDistances[dogName] ?? 0) + dayTeam.distance;
              }
            }
          }
        }
        toReturn.add(DailyDogStats(date: day, distances: dogDistances));
      } else {
        toReturn
            .add(DailyDogStats(date: day, distances: _getEmptyDistanceRow()));
      }
    }
    return toReturn;
  }

  Map<String, double> _getEmptyDistanceRow() {
    Map<String, double> toReturn = {};
    for (Dog dog in dogs) {
      toReturn.putIfAbsent(dog.name, () => 0);
    }
    return toReturn;
  }

  List<DataGridRow> _buildGridRows(List<DailyDogStats> dailyDogStats) {
    List<DataGridRow> toReturn = [];

    // Sort by date descending HERE for explicit display order control
    dailyDogStats.sort((a, b) => b.date.compareTo(a.date));

    for (DailyDogStats dailyStat in dailyDogStats) {
      toReturn.add(
        DataGridRow(
          cells: [
            // Create the list of cells directly
            // 1. Date Cell (Correct)
            DataGridCell(
              columnName: "Date",
              value: _formatDateForDisplay(dailyStat.date),
            ),

            // 2. Dog Cells (Generate by mapping over the 'dogs' list)
            ...dogs.map((dog) {
              // Iterate over the main 'dogs' list to ensure order
              // Look up this dog's distance in the current day's stats.
              // Use ?? 0.0 as a fallback.
              double distance = dailyStat.distances[dog.name] ?? 0.0;
              return DataGridCell(columnName: dog.name, value: distance);
            })
          ], // end cell list
        ), // end DataGridRow
      ); // end add
    } // end loop
    return toReturn;
  }

  /// Finds the oldest date for the list of teamgroups.
  /// If no teams exist, defaults to 30 days.
  DateTime findOldestDate() {
    DateTime? oldestDate;
    for (TeamGroup team in teams) {
      if (oldestDate == null || team.date.isBefore(oldestDate)) {
        // Strip time information, keep just the date
        final dateWithoutTime =
            DateTime(team.date.year, team.date.month, team.date.day);
        if (oldestDate == null || dateWithoutTime.isBefore(oldestDate)) {
          oldestDate = dateWithoutTime;
        }
      }
    }

    // Default to 30 days ago if no teams exist
    oldestDate ??= DateTime.now().subtract(Duration(days: 30));
    return oldestDate;
  }

  Map<String, List<TeamGroup>> getTeamsByDay() {
    Map<String, List<TeamGroup>> teamsByDay = {};

    for (TeamGroup team in teams) {
      String dateKey = _formatDateKey(team.date);
      teamsByDay.putIfAbsent(dateKey, () => []).add(team);
    }
    return teamsByDay;
  }

  /// Helper method to create a consistent date key
  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  DateTime addCurrentDate(DateTime currentDate, DateTime todayWithoutTime,
      List<DateTime> allDates) {
    while (!currentDate.isAfter(todayWithoutTime)) {
      allDates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }
    return currentDate;
  }

  DataGridRow constructFilledRow(
      Map<String, List<TeamGroup>> teamsByDay, String dateKey, DateTime day) {
    List<TeamGroup> dayTeams = teamsByDay[dateKey]!;
    Map<String, double> dogDistances = {};

    for (TeamGroup dayTeam in dayTeams) {
      for (Team team in dayTeam.teams) {
        for (DogPair dogPair in team.dogPairs) {
          if (dogPair.firstDog != null) {
            String dogName = dogPair.firstDog!.name;
            dogDistances[dogName] =
                (dogDistances[dogName] ?? 0) + dayTeam.distance;
          }
          if (dogPair.secondDog != null) {
            String dogName = dogPair.secondDog!.name;
            dogDistances[dogName] =
                (dogDistances[dogName] ?? 0) + dayTeam.distance;
          }
        }
      }
    }

    DataGridRow row = DataGridRow(
      cells: <DataGridCell>[
        DataGridCell(columnName: "Date", value: _formatDateForDisplay(day)),
        ...dogs.map(
          (dog) => DataGridCell(
            columnName: dog.name,
            value: dogDistances[dog.name] ?? 0,
          ),
        )
      ],
    );
    return row;
  }

  DataGridRow constructEmptyRow(DateTime day) {
    DataGridRow row = DataGridRow(
      cells: <DataGridCell>[
        DataGridCell(columnName: "Date", value: _formatDateForDisplay(day)),
        ...dogs.map(
          (dog) => DataGridCell(
            columnName: dog.name,
            value: 0.0,
          ),
        )
      ],
    );
    return row;
  }

  /// Helper method to format date for display
  String _formatDateForDisplay(DateTime date) {
    // You can customize this format based on your preferences
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
