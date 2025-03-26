import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'provider.dart';
import 'sf_data_grid.dart';

class StatsMain extends StatelessWidget {
  const StatsMain({super.key});

  @override
  Widget build(BuildContext context) {
    final statsProvider = context.watch<StatsProvider>();
    final dogs = Provider.of<DogProvider>(context, listen: true).dogs;

    GridRowProcessor dataManipulator =
        GridRowProcessor(teams: statsProvider.teams, dogs: dogs);
    List<DataGridRow> gridData = dataManipulator.run();

    StatsDataSource statsDataSource = StatsDataSource(gridData: gridData);

    return SfDataGridClass(statsDataSource: statsDataSource, dogs: dogs);
  }
}
