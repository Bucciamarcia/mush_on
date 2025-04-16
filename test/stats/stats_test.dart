import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/services/models.dart'; // Assuming DogPositions is here
import 'package:mush_on/stats/grid_row_processor.dart';
// Make sure constants are imported or defined if they live elsewhere
// import 'package:mush_on/stats/constants.dart';
import 'package:mush_on/stats/sf_data_grid.dart'; // Your SfDataGridClass and StatsDataSource
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// --- Test Setup ---

// Assuming these constants are defined somewhere accessible by both
// SfDataGridClass and this test file. Define them here if not imported.
const String dateColumnName = 'Date';
const String monthYearName = 'MonthYear';

// Test Dog Data
final List<Dog> testDogs = [
  Dog(name: "Fido", id: "id_Fido", positions: DogPositions(lead: true)),
  Dog(name: "Fluffy", id: "id_Fluffy", positions: DogPositions(swing: true)),
  Dog(name: "Wheeler", id: "id_Wheeler", positions: DogPositions(wheel: true)),
];

// Test Data Source with corrected structure and updated totals
final StatsDataSource testStatsDataSource = StatsDataSource(
  gridData: GridRowProcessorResult(
    dataGridRows: [
      // First Row
      DataGridRow(cells: [
        DataGridCell(columnName: dateColumnName, value: '16/04/2025'),
        DataGridCell(columnName: monthYearName, value: 'Apr 2025'),
        DataGridCell(columnName: "id_Fido", value: 10.5), // Double value
        DataGridCell(
            columnName: "id_Fluffy", value: 20.0), // Integer double value
        DataGridCell(columnName: "id_Wheeler", value: 0.0), // Zero value
      ]),
      // Second Row
      DataGridRow(cells: [
        DataGridCell(columnName: dateColumnName, value: '17/04/2025'),
        DataGridCell(columnName: monthYearName, value: 'Apr 2025'),
        DataGridCell(columnName: "id_Fido", value: 5.0), // Integer double value
        DataGridCell(columnName: "id_Fluffy", value: 0.0), // Zero value
        DataGridCell(columnName: "id_Wheeler", value: 35.7), // Double value
      ]),
    ],
    // User's updated grand totals
    dogGrandTotals: {"id_Fido": 100.0, "id_Fluffy": 200.0, "id_Wheeler": 300.0},
  ),
);

void main() {
  group('SfDataGrid rendering', () {
    // Helper to build the widget
    Future<void> buildGrid(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            // Ensure the grid has enough space to render summaries etc.
            body: SizedBox(
              height: 600, // Adjust if needed
              width: 800, // Adjust if needed
              child: SfDataGridClass(
                statsDataSource: testStatsDataSource,
                dogs: testDogs,
              ),
            ),
          ),
        ),
      );
      // Wait for the grid to settle after the initial build
      await tester.pumpAndSettle();
    }

    testWidgets('renders correct visible column headers', (tester) async {
      await buildGrid(tester);

      // Check for visible headers
      expect(find.widgetWithText(DataGridCellFormatter, dateColumnName),
          findsOneWidget,
          reason: "Should find '$dateColumnName' header");
      expect(find.widgetWithText(DataGridCellFormatter, 'Fido'), findsOneWidget,
          reason: "Should find 'Fido' header");
      expect(
          find.widgetWithText(DataGridCellFormatter, 'Fluffy'), findsOneWidget,
          reason: "Should find 'Fluffy' header");
      expect(
          find.widgetWithText(DataGridCellFormatter, 'Wheeler'), findsOneWidget,
          reason: "Should find 'Wheeler' header");
    });

    testWidgets('does not render hidden column header', (tester) async {
      await buildGrid(tester);

      // Check that the hidden column's text is not found as a header
      // Note: DataGridCellFormatter might still be created but not visible.
      // A more robust check might involve finding the specific header widget and checking visibility,
      // but checking for the text is often sufficient if the label isn't used elsewhere.
      expect(find.widgetWithText(DataGridCellFormatter, monthYearName),
          findsNothing,
          reason: "Should NOT find '$monthYearName' header text");
    });

    testWidgets('renders data cells with correct formatting', (tester) async {
      await buildGrid(tester);

      // --- Check First Row Cells ---
      expect(find.text('16/04/2025'), findsOneWidget,
          reason: "Should find date cell from row 1");
      // Fido (10.5) -> "10.5"
      expect(find.text('10.5'), findsOneWidget,
          reason: "Should find Fido's value (10.5) in row 1");
      // Fluffy (20.0) -> "20" (integer format)
      expect(find.text('20'), findsOneWidget,
          reason: "Should find Fluffy's value (20) in row 1");
      // Wheeler (0.0) -> "" (empty string format) - Check it's not finding "0" or "0.0" literally
      // Need to be careful here, find.text('') finds many empty text widgets.
      // A better approach might be finding the cell container and checking its child count/type,
      // or ensuring "0" and "0.0" are NOT present for that specific cell location.
      // For simplicity, let's check "0" and "0.0" aren't present in the grid (adjust if 0 can appear elsewhere)
      expect(find.text('0'), findsNothing,
          reason:
              "Wheeler's value (0.0) in row 1 should render as empty, not '0'");
      expect(find.text('0.0'), findsNothing,
          reason:
              "Wheeler's value (0.0) in row 1 should render as empty, not '0.0'");

      // --- Check Second Row Cells ---
      expect(find.text('17/04/2025'), findsOneWidget,
          reason: "Should find date cell from row 2");
      // Fido (5.0) -> "5"
      expect(find.text('5'), findsOneWidget,
          reason: "Should find Fido's value (5) in row 2");
      // Fluffy (0.0) -> ""
      expect(find.text('0'), findsNothing,
          reason:
              "Fluffy's value (0.0) in row 2 should render as empty, not '0'");
      expect(find.text('0.0'), findsNothing,
          reason:
              "Fluffy's value (0.0) in row 2 should render as empty, not '0.0'");
      // Wheeler (35.7) -> "35.7"
      expect(find.text('35.7'), findsOneWidget,
          reason: "Should find Wheeler's value (35.7) in row 2");

      // Verify we have the correct number of date cells displayed
      expect(
          find.textContaining(RegExp(r'\d{2}/\d{2}/\d{4}')), findsNWidgets(2),
          reason: "Should find two date cells");
    });

    testWidgets('renders table summary row with correct totals and style',
        (tester) async {
      await buildGrid(tester);

      // Find summary values based on dogGrandTotals and formatDouble logic
      final fidoTotal = "100"; // 100.0 formats to "100"
      final fluffyTotal = "200"; // 200.0 formats to "200"
      final wheelerTotal = "300"; // 300.0 formats to "300"

      // Function to check summary cell text and style
      void checkSummaryCell(String totalValue) {
        final summaryTextFinder = find.text(totalValue);
        // Ensure the text is found (could be multiple times if value exists in data rows too)
        expect(summaryTextFinder, findsWidgets,
            reason: "Should find summary text '$totalValue'");

        // Find the specific Text widget within the Summary Row Structure
        // We know buildTableSummaryCellWidget wraps the Text in Center -> Container
        // Let's find the Text widget that has an ancestor Container with specific padding
        final specificSummaryFinder = find.descendant(
            of: find.ancestor(
                of: find.byType(Text), // Find Text widgets
                matching: find.byWidgetPredicate(
                    // Whose ancestor is a Container...
                    (widget) =>
                        widget is Container &&
                        widget.padding == const EdgeInsets.all(15.0))),
            matching: find.text(totalValue) // ...and match the specific text
            );

        expect(specificSummaryFinder, findsOneWidget,
            reason:
                "Should find '$totalValue' specifically within a summary cell structure");

        // Verify the style is bold
        final textWidget = tester.widget<Text>(specificSummaryFinder);
        expect(textWidget.style?.fontWeight, equals(FontWeight.w700),
            reason: "Summary text '$totalValue' should be bold (w700)");
      }

      // Check each dog's summary total
      checkSummaryCell(fidoTotal);
      checkSummaryCell(fluffyTotal);
      checkSummaryCell(wheelerTotal);
    });

    // Add more tests if needed:
    // - Test grouping behaviour if more complex data is used
    // - Test scrolling if specific scroll interactions need verification
    // - Test specific cell interactions if applicable (tapping, etc.)
  });
}

// Dummy DogPositions class if not imported from services/models.dart
// class DogPositions { final bool lead; final bool swing; final bool wheel; DogPositions({this.lead=false, this.swing=false, this.wheel=false}); }
