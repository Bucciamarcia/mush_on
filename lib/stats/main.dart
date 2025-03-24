import 'package:flutter/material.dart';
import 'package:mush_on/services/models.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'provider.dart';

class StatsMain extends StatefulWidget {
  const StatsMain({super.key});

  @override
  State<StatsMain> createState() => _StatsMainState();
}

class _StatsMainState extends State<StatsMain> {
  late StatsDataSource _statsDataSource;

  @override
  void initState() {
    super.initState();
    // Initialize with empty data
    _statsDataSource = StatsDataSource(teams: []);
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = context.watch<StatsProvider>();
    Provider.of<StatsProvider>(context, listen: false).getTeams();
    _statsDataSource = StatsDataSource(teams: statsProvider.teams);

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
  List<DataGridRow> dataGridRows = [];

  // Constructor directly transforms data to rows
  StatsDataSource({required List<TeamGroup> teams}) {
    dataGridRows = teams
        .map<DataGridRow>((TeamGroup team) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'teamName', value: team.name),
              DataGridCell<String>(
                  columnName: 'teamDate', value: team.date.toString()),
            ]))
        .toList();
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
}
