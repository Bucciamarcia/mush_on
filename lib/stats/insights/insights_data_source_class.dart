import 'package:flutter/material.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/stats/insights/models.dart';
import 'package:mush_on/stats/riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InsightsDataSource extends DataGridSource {
  InsightsDataSource(
      {required List<Dog> dogs,
      required StatsDateRange dateRange,
      required Map<String, List<DogDailyStats>> dogDailyStats}) {
    dataGridRows = dogs
        .map(
          (dog) => DataGridRow(
            cells: [
              DataGridCell(columnName: "dog", value: dog.name),
              DataGridCell(
                columnName: "totalRan",
                value: _getTotalRanForDog(dogDailyStats[dog.id]!),
              ),
              DataGridCell(
                columnName: "runRate",
                value: _getRunRate(dogDailyStats[dog.id]!, dateRange),
              ),
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

  String _getTotalRanForDog(List<DogDailyStats> dogDailyStats) {
    double returnValue = 0;
    for (var stat in dogDailyStats) {
      returnValue = returnValue + stat.distanceRan;
    }
    if (returnValue % 1 == 0) {
      return returnValue.toInt().toString();
    } else {
      return returnValue.toString();
    }
  }

  String _getRunRate(List<DogDailyStats> list, StatsDateRange dateRange) {
    Duration interval = dateRange.endDate.difference(dateRange.startDate);
    double days = interval.inDays.toDouble();
    double runDays = list.length.toDouble();
    double runRate = runDays / days;
    runRate = runRate * 100;
    if (runRate % 1 == 0) {
      return "${runRate.toInt().toString()}%";
    }
    return "${runRate.toStringAsFixed(2)}%";
  }
}
