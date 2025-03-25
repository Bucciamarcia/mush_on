import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../services/models.dart';

class SfDataGridClass extends StatelessWidget {
  const SfDataGridClass({
    super.key,
    required StatsDataSource statsDataSource,
    required List<Dog> dogs,
  }) : _statsDataSource = statsDataSource;

  final StatsDataSource _statsDataSource;

  @override
  Widget build(BuildContext context) {
    List<Dog> dogs = Provider.of<DogProvider>(context, listen: true).dogs;
    return SfDataGrid(
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
        ...dogs.map<GridColumn>((Dog dog) {
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
            columns: dogs.map((dog) {
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
  List<DataGridRow> dataGridRows = [];

  StatsDataSource({required List<TeamGroup> teams, required List<Dog> dogs}) {
    // Step 1: Find the oldest date in the data
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

    // Step 2: Create a map to group TeamGroups by day
    Map<String, List<TeamGroup>> teamsByDay = {};

    for (TeamGroup team in teams) {
      String dateKey = _formatDateKey(team.date);
      teamsByDay.putIfAbsent(dateKey, () => []).add(team);
    }

    // Step 3: Generate list of all dates from oldest to today
    final today = DateTime.now();
    final todayWithoutTime = DateTime(today.year, today.month, today.day);

    // Create a list of all days between oldest date and today
    List<DateTime> allDates = [];
    DateTime currentDate = oldestDate;

    while (!currentDate.isAfter(todayWithoutTime)) {
      allDates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    allDates.sort((a, b) => b.compareTo(a));

    // Step 4: Process each day, whether we have data or not
    for (DateTime day in allDates) {
      String dateKey = _formatDateKey(day);

      // Create a row for this day
      DataGridRow row;

      // Check if we have data for this day
      if (teamsByDay.containsKey(dateKey)) {
        // Process teams for this day
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

        // Create row with actual data
        row = DataGridRow(
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
      } else {
        // Create an empty row for this day
        row = DataGridRow(
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
      }

      dataGridRows.add(row);
    }
  }

  // Helper method to create a consistent date key
  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Helper method to format date for display
  String _formatDateForDisplay(DateTime date) {
    // You can customize this format based on your preferences
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
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
