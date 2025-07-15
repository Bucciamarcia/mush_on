import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/stats/riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'insights_data_source_class.dart';

class InsightsMain extends ConsumerWidget {
  static final logger = BasicLogger();
  const InsightsMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StatsDateRange dateRange = ref.watch(statsDatesProvider);
    List<Dog> dogs = ref.watch(dogsProvider).value ?? [];
    return SfDataGrid(
      source: _getDataSource(dateRange, dogs),
      columns: dogs
          .map(
            (dog) => GridColumn(
              columnName: dog.name,
              label: Center(child: Text(dog.name)),
            ),
          )
          .toList(),
    );
  }

  DataGridSource _getDataSource(StatsDateRange dateRange, List<Dog> dogs) {
    logger.info("Building insights data source");
    return InsightsDataSource(dateRange: dateRange, dogs: dogs);
  }
}
