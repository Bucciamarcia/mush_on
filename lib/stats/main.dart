import 'package:flutter/material.dart';
import 'package:mush_on/provider.dart';
import 'package:provider/provider.dart';
import 'provider.dart';
import 'sf_data_grid.dart';

class StatsMain extends StatelessWidget {
  const StatsMain({super.key});

  @override
  Widget build(BuildContext context) {
    final statsProvider = context.watch<StatsProvider>();
    final dogs = Provider.of<DogProvider>(context, listen: true).dogs;

    StatsDataSource statsDataSource =
        StatsDataSource(teams: statsProvider.teams, dogs: dogs);

    return SfDataGridClass(statsDataSource: statsDataSource, dogs: dogs);
  }
}
