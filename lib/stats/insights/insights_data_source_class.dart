import 'package:flutter/material.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/stats/riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InsightsDataSource extends DataGridSource {
  InsightsDataSource(
      {required List<Dog> dogs,
      required StatsDateRange dateRange,
      required List<TeamGroup> teamGroups}) {
    dataGridRows = dogs
        .map(
          (dog) => DataGridRow(
            cells: [
              DataGridCell(columnName: "dog", value: dog.name),
              DataGridCell(columnName: "totalRan", value: dog.name),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (dataGridCell) {
          return Align(
              alignment: Alignment.center,
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.fade,
              ));
        },
      ).toList(),
    );
  }
}
