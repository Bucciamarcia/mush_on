import 'package:flutter/material.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RunTable extends StatelessWidget {
  final List<Dog> dogs;
  final List<TeamGroupWorkspace> teamGroups;
  const RunTable({super.key, required this.dogs, required this.teamGroups});

  @override
  Widget build(BuildContext context) {
    teamGroups.sort((a, b) => a.date.compareTo(b.date));
    return SfDataGrid(
        source: DogsDataSource(dogs: dogs, teamGroups: teamGroups),
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
  final List<Dog> dogs; // ← Now accessible everywhere
  final List<TeamGroupWorkspace> teamGroups; // ← Now accessible everywhere
  List<DataGridRow> dataGridRows = [];
  DogsDataSource({required this.dogs, required this.teamGroups}) {
    /// All the dates (rows) that will be displayed. These are all set at midnight,
    /// as they represent the day only, not the exact time.
    final allDates = _getAllDates();
    final runTableByDog = _getRunTableByDog(allDates);
    dataGridRows = allDates
        .map((date) => DataGridRow(cells: [
              DataGridCell(columnName: "Date", value: date.toString()),
              ...dogs.map((dog) => DataGridCell(
                  columnName: dog.name,
                  value:
                      runTableByDog[date]?[dog.name].toString() ?? "Not found"))
            ]))
        .toList();
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

  List<DateTime> _getAllDates() {
    var toReturn = <DateTime>[];
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
  Map<DateTime, Map<String, double>> _getRunTableByDog(

      /// All the dates (rows) of the table. These are the keys of the map.
      List<DateTime> allDates) {
    // Order from newest to oldest.
    allDates.sort((a, b) => b.compareTo(a));
    Map<DateTime, Map<String, double>> toReturn = {};
    for (final date in allDates) {}
    return toReturn;
  }
}
