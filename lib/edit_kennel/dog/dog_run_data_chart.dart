import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DogRunDataChart extends StatelessWidget {
  final List<DogTotal> totals;
  const DogRunDataChart(this.totals, {super.key});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries<DogTotal, String>>[
        ColumnSeries(
          dataSource: totals,
          xValueMapper: (DogTotal total, _) =>
              DateFormat("yy-MM-dd").format(total.date),
          yValueMapper: (DogTotal total, _) => total.distance,
          sortFieldValueMapper: (DogTotal total, _) => total.fromtoday,
          sortingOrder: SortingOrder.descending,
        )
      ],
    );
  }
}
