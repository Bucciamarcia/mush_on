import 'package:flutter/material.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/stats/insights/models.dart';
import 'package:mush_on/stats/riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InsightsDataSource extends DataGridSource {
  InsightsDataSource(
      {required List<Dog> dogs,
      required StatsDateRange dateRange,
      required List<HealthEvent> healthEvents,
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
              DataGridCell(
                columnName: "reliability",
                value: _getReliability(dog.id, healthEvents, dateRange),
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

  String _getReliability(
      String id, List<HealthEvent> healthEvents, StatsDateRange dateRange) {
    double totalDays =
        dateRange.endDate.difference(dateRange.startDate).inDays.toDouble();
    if (totalDays == 0) return "0";

    List<HealthEvent> filteredHealthEvents =
        healthEvents.where((event) => event.dogId == id).toList();

    Set<DateTime> injuryDates = {};
    BasicLogger().debug("Processing getReliability: ${healthEvents.length}");

    for (var event in filteredHealthEvents) {
      // If event was resolved before our date range started, ignore it
      if (event.resolvedDate != null &&
          event.resolvedDate!.isBefore(dateRange.startDate)) {
        continue;
      }

      // Determine the effective start date (either event start or range start, whichever is later)
      DateTime effectiveStartDate = event.date.isAfter(dateRange.startDate)
          ? event.date
          : dateRange.startDate;

      // Determine the effective end date
      DateTime effectiveEndDate;
      if (event.resolvedDate != null &&
          event.resolvedDate!.isBefore(dateRange.endDate)) {
        // Event resolved within our date range
        effectiveEndDate = event.resolvedDate!;
      } else {
        // Event still ongoing or resolved after our date range
        effectiveEndDate = dateRange.endDate;
      }

      // Add each day of the event to the set (automatically handles overlaps)
      if (effectiveEndDate.isAfter(effectiveStartDate)) {
        DateTime current = effectiveStartDate;
        while (current.isBefore(effectiveEndDate)) {
          injuryDates.add(DateTime(current.year, current.month, current.day));
          current = current.add(Duration(days: 1));
        }
      }
    }

    double injuryDays = injuryDates.length.toDouble();

    // Get injury rate
    double injuryRate = injuryDays / totalDays;
    // Get percentage of injury rate
    injuryRate = injuryRate * 100;
    // Return reliability
    double reliability = 100.toDouble() - injuryRate;

    if (reliability % 1 == 0) {
      return "${reliability.toInt().toString()}%";
    } else {
      return "${reliability.toStringAsFixed(2)}%";
    }
  }
}
