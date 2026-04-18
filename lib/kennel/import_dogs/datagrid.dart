import 'package:flutter/material.dart';
import 'package:mush_on/kennel/import_dogs/riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ImportDogsDatagrid extends StatelessWidget {
  final List<DogToImport> dogsToImport;
  const ImportDogsDatagrid({super.key, required this.dogsToImport});

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: _dogsDataGrid(),
      columns: [
        GridColumn(columnName: "import", label: const Text("Import")),
        GridColumn(columnName: "dogName", label: const Text("Dog name")),
      ],
    );
  }

  DataGridSource _dogsDataGrid() {
    return DogsDataSource(dogsToImport: dogsToImport);
  }
}

class DogsDataSource extends DataGridSource {
  DogsDataSource({required List<DogToImport> dogsToImport}) {
    dataGridRows = dogsToImport.map((d) {
      return DataGridRow(
        cells: [
          DataGridCell<bool>(columnName: "import", value: d.import),
          DataGridCell(columnName: "dogName", value: d.dog.name),
        ],
      );
    }).toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: dataGridCell.columnName == "import"
              ? Checkbox(value: dataGridCell.value, onChanged: (v) {})
              : Text(dataGridCell.value),
        );
      }).toList(),
    );
  }
}
