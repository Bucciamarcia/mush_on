import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InsightsDataSource extends DataGridSource {
  InsightsDataSource({required this.insightsData});
  final List<DataGridRow> insightsData;

  @override
  List<DataGridRow> get rows => insightsData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (dataGridCell) {
          String textValue;
          if (dataGridCell.columnName == "dog") {
            textValue = dataGridCell.value.toString();
          } else if (dataGridCell.columnName == "totalRan") {
            double v = dataGridCell.value as double;
            if (v % 1 == 0) {
              textValue = v.toInt().toString();
            } else {
              textValue = v.toStringAsFixed(2);
            }
          } else if (dataGridCell.columnName == "runRate") {
            double v = dataGridCell.value as double;
            if (v % 1 == 0) {
              textValue = "${v.toInt().toString()}%";
            } else {
              textValue = "${v.toStringAsFixed(2)}%";
            }
          } else if (dataGridCell.columnName == "reliability") {
            double v = dataGridCell.value as double;
            if (v % 1 == 0) {
              textValue = "${v.toInt().toString()}%";
            } else {
              textValue = "${v.toStringAsFixed(2)}%";
            }
          } else {
            textValue = dataGridCell.value.toString();
          }
          return Align(
              alignment: Alignment.center,
              child: Text(
                textValue,
                overflow: TextOverflow.fade,
              ));
        },
      ).toList(),
    );
  }
}
