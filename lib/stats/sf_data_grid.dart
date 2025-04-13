import 'package:flutter/material.dart';
import 'package:mush_on/stats/grid_row_processor.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../services/models.dart';
import 'constants.dart';

class SfDataGridClass extends StatelessWidget {
  final List<Dog> _dogs;
  const SfDataGridClass({
    super.key,
    required StatsDataSource statsDataSource,
    required List<Dog> dogs,
  })  : _statsDataSource = statsDataSource,
        _dogs = dogs;

  final StatsDataSource _statsDataSource;

  @override
  Widget build(BuildContext context) {
    _statsDataSource
        .addColumnGroup(ColumnGroup(name: monthYearName, sortGroupRows: false));
    return SfDataGrid(
      isScrollbarAlwaysShown: true,
      allowExpandCollapseGroup: true,
      source: _statsDataSource,
      columns: [
        GridColumn(
          columnName: dateColumnName,
          label: const DataGridCellFormatter(text: dateColumnName),
        ),
        GridColumn(
          columnName: monthYearName,
          label: const DataGridCellFormatter(text: monthYearName),
          visible: false,
        ),
        ..._dogs.map<GridColumn>((Dog dog) {
          return GridColumn(
            columnName: dog.id,
            label: DataGridCellFormatter(text: dog.name),
          );
        })
      ],
      frozenColumnsCount: 1,
      tableSummaryRows: [
        GridTableSummaryRow(
            showSummaryInRow: false,
            columns: _dogs.map((dog) {
              return GridSummaryColumn(
                  name: dog.name,
                  columnName: dog.id,
                  summaryType: GridSummaryType.sum);
            }).toList(),
            position: GridTableSummaryRowPosition.top)
      ],
    );
  }
}

class DataGridCellFormatter extends StatelessWidget {
  final String text;
  const DataGridCellFormatter({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.center,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class StatsDataSource extends DataGridSource {
  late List<DataGridRow> dataGridRows;
  late Map<String, double> dogTotals;
  StatsDataSource({required GridRowProcessorResult gridData}) {
    dataGridRows = gridData.dataGridRows;
    dogTotals = gridData.dogGrandTotals;
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  Widget? buildGroupCaptionCellWidget(
      RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      // Put in a row because I want it to start at column 2.
      child: Row(
        children: [
          SizedBox(width: 100),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(summaryValue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row
          .getCells()
          .map<Widget>(
            (cell) => Center(
              child: Text(_formatCellValue(cell.value)),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Text(
          summaryValue,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  @override
  String calculateSummaryValue(GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex) {
    if (summaryColumn == null) {
      return "";
    }
    String dogName = summaryColumn.columnName;
    double dogDistance = dogTotals[dogName] ?? 0.0;
    return formatDouble(dogDistance);
  }

  String _formatCellValue(dynamic value) {
    if (value is double) {
      if (value == 0) return "";
      return formatDouble(value);
    } else {
      return value?.toString() ?? '';
    }
  }

  String formatDouble(double value) {
    if (value == value.truncate()) {
      return value.toInt().toString();
    } else {
      return value.toString();
    }
  }
}
