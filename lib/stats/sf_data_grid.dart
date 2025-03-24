import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/stats/provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../services/models.dart';

class SfDataGridClass extends StatelessWidget {
  const SfDataGridClass({
    super.key,
    required StatsDataSource statsDataSource,
  }) : _statsDataSource = statsDataSource;

  final StatsDataSource _statsDataSource;

  @override
  Widget build(BuildContext context) {
    StatsProvider statsProvider =
        Provider.of<StatsProvider>(context, listen: true);
    List<TeamGroup> teams = statsProvider.teams;
    List<Dog> dogs = Provider.of<DogProvider>(context, listen: true).dogs;
    return SfDataGrid(
        source: _statsDataSource,
        columns: dogs.map<GridColumn>((Dog dog) {
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
        }).toList());
  }
}

class StatsDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  // Constructor directly transforms data to rows
  StatsDataSource({required List<TeamGroup> teams, required List<Dog> dogs}) {
    List<DataGridCell> dataGridCells = [];
    for (Dog dog in dogs) {
      dataGridCells.add(DataGridCell(value: dog.name, columnName: dog.name));
    }
    dataGridRows = [DataGridRow(cells: dataGridCells)];
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row
          .getCells()
          .map<Widget>((cell) => Text(cell.value.toString()))
          .toList(),
    );
  }

  @override
  bool shouldRecalculateColumnWidths() {
    return true;
  }
}
