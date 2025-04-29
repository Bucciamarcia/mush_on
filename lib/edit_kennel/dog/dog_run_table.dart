import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DogrunTableWidget extends StatelessWidget {
  final List<DogTotal> dogTotals;
  const DogrunTableWidget(this.dogTotals, {super.key});

  @override
  Widget build(BuildContext context) {
    dogTotals.sort((a, b) => b.date.compareTo(a.date));
    var dataSource = DogTotalDataSource(dogTotals);
    return Card(
      child: ExpansionTile(title: Text("View data"), children: [
        SfDataGrid(
          shrinkWrapRows: true,
          source: dataSource,
          columnWidthMode: ColumnWidthMode.fill,
          columns: [
            GridColumn(columnName: "Date", label: Center(child: Text("Date"))),
            GridColumn(columnName: "Run", label: Center(child: Text("Run"))),
          ],
          // These are correct for nested scrolling -
          // they tell the grid NOT to scroll itself.
          verticalScrollPhysics: NeverScrollableScrollPhysics(),
          horizontalScrollPhysics: NeverScrollableScrollPhysics(),
        ),
      ]),
    );
  }
}

class DogTotalDataSource extends DataGridSource {
  DogTotalDataSource(List<DogTotal> dogTotals) {
    dataGridRows = dogTotals
        .map(
          (dogTotal) => DataGridRow(
            cells: [
              DataGridCell<String>(
                  columnName: "Date",
                  value: DateFormat("yyyy-MM-dd").format(dogTotal.date)),
              DataGridCell<double>(columnName: "Run", value: dogTotal.distance),
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
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            formatCell(dataGridCell.value.toString()),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  String formatCell(String n) {
    if (n == "0.0") return "0";
    if (n.endsWith(".0")) return n.substring(0, n.length - 2);
    return n;
  }
}
