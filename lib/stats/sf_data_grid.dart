import 'package:flutter/material.dart';
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
        Provider.of<StatsProvider>(context, listen: false);
    List<TeamGroup> teams = statsProvider.teams;
    return SfDataGrid(
      source: _statsDataSource,
      columns: [
        GridColumn(
          columnName: 'teamName',
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text(
              'Team Name',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GridColumn(
          columnName: 'teamDate',
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: const Text(
              'Team Date',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

class StatsDataSource extends DataGridSource {
  @override
  List<DataGridRow> rows = [];

  // Constructor directly transforms data to rows
  StatsDataSource({required List<TeamGroup> teams}) {
    rows = teams
        .map<DataGridRow>((TeamGroup team) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'teamName', value: team.name),
              DataGridCell<String>(
                  columnName: 'teamDate', value: team.date.toString()),
            ]))
        .toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row
          .getCells()
          .map<Widget>((cell) => Text(cell.value.toString()))
          .toList(),
    );
  }
}
