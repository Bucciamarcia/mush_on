import 'package:flutter/material.dart';
import 'package:mush_on/kennel/import_dogs/riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ImportDogsDatagrid extends StatelessWidget {
  final List<DogToImport> dogsToImport;
  final bool enabled;

  /// An "import" value has been flipped on or off in the checkbox toggle for a dog.
  final Function(int, bool) onValueFlipped;
  const ImportDogsDatagrid({
    super.key,
    required this.dogsToImport,
    this.enabled = true,
    required this.onValueFlipped,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SfDataGrid(
        columnWidthMode: ColumnWidthMode.fill,
        headerRowHeight: 52,
        rowHeight: 58,
        gridLinesVisibility: GridLinesVisibility.none,
        headerGridLinesVisibility: GridLinesVisibility.none,
        selectionMode: SelectionMode.none,
        shrinkWrapRows: true,
        source: _dogsDataGrid(),
        columns: [
          GridColumn(
            width: 120,
            columnName: "import",
            label: _HeaderCell(
              alignment: Alignment.center,
              child: Text(
                "Import",
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          GridColumn(
            columnName: "dogName",
            label: _HeaderCell(
              child: Text(
                "Dog name",
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataGridSource _dogsDataGrid() {
    return DogsDataSource(
      dogsToImport: dogsToImport,
      enabled: enabled,
      onValueFlipped: (i, v) => onValueFlipped(i, v),
    );
  }
}

class DogsDataSource extends DataGridSource {
  Function(int, bool) onValueFlipped;
  final bool enabled;
  DogsDataSource({
    required List<DogToImport> dogsToImport,
    required this.enabled,
    required this.onValueFlipped,
  }) {
    dataGridRows = dogsToImport.map((d) {
      return DataGridRow(
        cells: [
          DataGridCell<bool>(columnName: "import", value: d.import),
          DataGridCell<String>(columnName: "dogName", value: d.dog.name),
          DataGridCell<bool>(
            columnName: "isNameDuplicate",
            value: d.isNameDuplicate,
          ),
        ],
      );
    }).toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final importCell = row.getCells().firstWhere(
      (cell) => cell.columnName == "import",
    );
    final dogNameCell = row.getCells().firstWhere(
      (cell) => cell.columnName == "dogName",
    );
    final duplicateCell = row.getCells().firstWhere(
      (cell) => cell.columnName == "isNameDuplicate",
    );
    final isDuplicate = duplicateCell.value as bool;

    return DataGridRowAdapter(
      color: isDuplicate
          ? const Color.fromARGB(255, 255, 246, 233)
          : const Color.fromARGB(255, 247, 250, 252),
      cells: [
        Center(
          child: Checkbox(
            value: importCell.value,
            onChanged: !enabled
                ? null
                : (v) {
                    if (v != null) {
                      onValueFlipped(dataGridRows.indexOf(row), v);
                    }
                  },
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  dogNameCell.value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              if (isDuplicate)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 208, 120),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    "Already exists",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 113, 63, 18),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final Widget child;
  final Alignment alignment;

  const _HeaderCell({
    required this.child,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: child,
    );
  }
}
