import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider.dart';
import 'sf_data_grid.dart';

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
    _statsDataSource = StatsDataSource(teams: []);
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = context.watch<StatsProvider>();
    Provider.of<StatsProvider>(context, listen: false).getTeams();
    _statsDataSource = StatsDataSource(teams: statsProvider.teams);

    return SfDataGridClass(statsDataSource: _statsDataSource);
  }
}
