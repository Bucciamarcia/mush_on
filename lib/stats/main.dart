import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
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
    _statsDataSource = StatsDataSource(teams: [], dogs: []);
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = context.watch<StatsProvider>();
    final dogs = Provider.of<DogProvider>(context, listen: true).dogs;

    _statsDataSource = StatsDataSource(teams: statsProvider.teams, dogs: dogs);

    return SfDataGridClass(statsDataSource: _statsDataSource, dogs: dogs);
  }
}
