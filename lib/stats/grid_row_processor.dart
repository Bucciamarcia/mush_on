import 'package:intl/intl.dart';
import 'package:mush_on/stats/group_summary.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../services/models.dart';
import 'constants.dart';
import 'daily_dog_stats.dart';

class GridRowProcessor {
  List<TeamGroup> teams;
  List<Dog> dogs;
  GridRowProcessor({required this.teams, required this.dogs});
  GridRowProcessorResult run() {
    // Get daily aggregated data
    List<DailyDogStats> aggregatedStats = _aggregateData();

    // Calculate monthly summary data
    List<MonthSummary> monthlySummariesList =
        calculateMonthlySummaries(aggregatedStats); // Renamed for clarity

    // Convert monthly summaries List to Map for efficient lookup
    Map<DateTime, MonthSummary> monthlySummariesMap = {
      for (var summary in monthlySummariesList) (summary).month: summary
    };

    // Group daily stats by month
    Map<DateTime, List<DailyDogStats>> ddsByMonth =
        getDdsByMonth(aggregatedStats);

    // Build the final list including injected rows (using the maps)
    List<DataGridRow> allRowsCombined =
        _buildFinalRows(ddsByMonth, monthlySummariesMap);

    // Calculate grand totals
    Map<String, double> dogGrandTotals = _buildDogTotals(aggregatedStats);

    // Return final results
    return GridRowProcessorResult(
        dataGridRows: allRowsCombined, dogGrandTotals: dogGrandTotals);
  }

  List<DailyDogStats> _aggregateData() {
    List<DailyDogStats> toReturn = [];
    final today = DateTime.now();
    final todayWithoutTime = DateTime(today.year, today.month, today.day);
    Map<String, List<TeamGroup>> teamsByDay = getTeamsByDay();
    DateTime oldestDate = findOldestDate();

    List<DateTime> allDates = [];
    DateTime currentDate = oldestDate;

    currentDate = addCurrentDate(currentDate, todayWithoutTime, allDates);

    allDates.sort((a, b) => b.compareTo(a));
    for (DateTime day in allDates) {
      String dateKey = _formatDateKey(day);
      if (teamsByDay.containsKey(dateKey)) {
        List<TeamGroup>? dayTeams = teamsByDay[dateKey];
        Map<String, double> dogDistances = {};
        for (TeamGroup dayTeam in dayTeams!) {
          for (Team team in dayTeam.teams) {
            for (DogPair dogPair in team.dogPairs) {
              if (dogPair.firstDog != null) {
                String dogName = dogPair.firstDog!.name;
                dogDistances[dogName] =
                    (dogDistances[dogName] ?? 0) + dayTeam.distance;
              }
              if (dogPair.secondDog != null) {
                String dogName = dogPair.secondDog!.name;
                dogDistances[dogName] =
                    (dogDistances[dogName] ?? 0) + dayTeam.distance;
              }
            }
          }
        }
        toReturn.add(DailyDogStats(date: day, distances: dogDistances));
      } else {
        toReturn
            .add(DailyDogStats(date: day, distances: _getEmptyDistanceRow()));
      }
    }
    return toReturn;
  }

  /// Returns a list of the grand total km ran by every dog.
  Map<String, double> _buildDogTotals(List<DailyDogStats> aggregatedStats) {
    Map<String, double> dogTotals = _createEmptyDogTotalsMap();
    for (DailyDogStats dayStats in aggregatedStats) {
      dayStats.distances.forEach((dogName, distance) {
        if (dogTotals.containsKey(dogName)) {
          dogTotals[dogName] = dogTotals[dogName]! + distance;
        }
      });
    }
    return dogTotals;
  }

  List<MonthSummary> calculateMonthlySummaries(
      List<DailyDogStats> dailyDogStats) {
    // Outer key: DateTime representing the month (e.g., 2025-03-01)
    // Inner key: Dog name (String)
    // Inner value: Accumulated distance (double)
    Map<DateTime, Map<String, double>> monthlyTotals = {};

    // Helper to initialize totals for a new month

    for (DailyDogStats dayStats in dailyDogStats) {
      DateTime monthYear = DateTime(dayStats.date.year, dayStats.date.month);

      // Get or create the map for the current month
      Map<String, double> currentMonthTotals =
          monthlyTotals.putIfAbsent(monthYear, _createEmptyDogTotalsMap);

      // Add current day's distances to the monthly totals
      dayStats.distances.forEach((dogName, distance) {
        if (currentMonthTotals.containsKey(dogName)) {
          currentMonthTotals[dogName] = currentMonthTotals[dogName]! + distance;
        }
        // Optional: handle dogs in dayStats not in main 'dogs' list if necessary
      });
    }

    // Convert the results map into the List<MonthSummary>
    List<MonthSummary> summaries = [];
    monthlyTotals.forEach((month, totals) {
      summaries.add(MonthSummary(month: month, distances: totals));
    });

    // Optional: Sort summaries if needed
    summaries.sort((a, b) => b.month.compareTo(a.month));

    return summaries;
  }

  Map<String, double> _createEmptyDogTotalsMap() {
    return {for (var dog in dogs) dog.name: 0.0};
  }

  Map<String, double> _getEmptyDistanceRow() {
    Map<String, double> toReturn = {};
    for (Dog dog in dogs) {
      toReturn.putIfAbsent(dog.name, () => 0);
    }
    return toReturn;
  }

  List<DataGridRow> _buildFinalRows(
      Map<DateTime, List<DailyDogStats>> ddsByMonth,
      Map<DateTime, MonthSummary>
          groupSummariesMap // Receive Map for easy lookup
      ) {
    List<DataGridRow> finalRows = [];

    // 1. Get the months and sort them (e.g., newest first)
    List<DateTime> sortedMonths = ddsByMonth.keys.toList();
    sortedMonths.sort((a, b) => b.compareTo(a)); // Sort descending

    // 2. Iterate through sorted months
    for (DateTime monthKey in sortedMonths) {
      // 3. Get the summary for this month
      MonthSummary? monthSummary = groupSummariesMap[monthKey];
      if (monthSummary == null) {
        print("Warning: Missing summary for month $monthKey");
        continue; // Skip if summary data is missing
      }

      // 4. Create and add the "Total" Row for this month
      finalRows.add(DataGridRow(cells: [
        DataGridCell<String>(
          // Use String type for marker
          columnName: dateColumnName,
          // Marker value to identify total rows
          value: "Summary for ${DateFormat("MMMM yyyy").format(monthKey)}",
        ),
        DataGridCell<String>(
          // Value needed for grouping
          columnName: monthYearName,
          value: DateFormat("MMMM yyyy").format(monthKey),
        ),
        // Add dog total cells (using CORRECT order)
        ...dogs.map((dog) {
          double total = monthSummary.distances[dog.name] ?? 0.0;
          return DataGridCell<double>(columnName: dog.name, value: total);
        }),
      ]));

      // 5. Get the daily stats for this month
      List<DailyDogStats> daysInMonth = ddsByMonth[monthKey] ?? [];
      // Optional: Sort daily rows within the month if needed
      daysInMonth.sort((a, b) => b.date.compareTo(a.date)); // Descending date

      // 6. Create and add the "Daily" Rows for this month
      for (DailyDogStats dayStat in daysInMonth) {
        finalRows.add(DataGridRow(cells: [
          DataGridCell<String>(
            // Use String type
            columnName: dateColumnName,
            value: _formatDateForDisplay(dayStat.date), // Normal date display
          ),
          DataGridCell<String>(
            // Value needed for grouping
            columnName: monthYearName,
            value: DateFormat("MMMM yyyy").format(dayStat.date),
          ),
          // Add daily dog cells (using CORRECT order)
          ...dogs.map((dog) {
            double distance = dayStat.distances[dog.name] ?? 0.0;
            return DataGridCell<double>(columnName: dog.name, value: distance);
          }),
        ]));
      }
    } // End loop through months

    return finalRows;
  }

  /// Takes the list of daily dog stats, and splits them in a map where the key is the DateTime
  /// month and year for those daily stats.
  Map<DateTime, List<DailyDogStats>> getDdsByMonth(
      List<DailyDogStats> dailyDogStats) {
    Map<DateTime, List<DailyDogStats>> groupedByMonth = {};
    for (DailyDogStats dayStats in dailyDogStats) {
      // Use the DateTime representing the first day of the month as the key
      DateTime monthKey = DateTime(dayStats.date.year, dayStats.date.month);
      groupedByMonth
          .putIfAbsent(
              monthKey, () => <DailyDogStats>[]) // Use the efficient way
          .add(dayStats);
    }
    return groupedByMonth;
  }

  bool _isLastDayOfMonth(DateTime date) {
    // Create a new DateTime for the first day of the next month
    DateTime nextMonth = DateTime(date.year, date.month + 1, 1);

    // Subtract one day to get the last day of the current month
    DateTime lastDay = nextMonth.subtract(Duration(days: 1));

    // Check if the day of the given date matches the last day of the month
    return date.day == lastDay.day;
  }

  /// Finds the oldest date for the list of teamgroups.
  /// If no teams exist, defaults to 30 days.
  DateTime findOldestDate() {
    DateTime? oldestDate;
    for (TeamGroup team in teams) {
      if (oldestDate == null || team.date.isBefore(oldestDate)) {
        // Strip time information, keep just the date
        final dateWithoutTime =
            DateTime(team.date.year, team.date.month, team.date.day);
        if (oldestDate == null || dateWithoutTime.isBefore(oldestDate)) {
          oldestDate = dateWithoutTime;
        }
      }
    }

    // Default to 30 days ago if no teams exist
    oldestDate ??= DateTime.now().subtract(Duration(days: 30));
    return oldestDate;
  }

  Map<String, List<TeamGroup>> getTeamsByDay() {
    Map<String, List<TeamGroup>> teamsByDay = {};

    for (TeamGroup team in teams) {
      String dateKey = _formatDateKey(team.date);
      teamsByDay.putIfAbsent(dateKey, () => []).add(team);
    }
    return teamsByDay;
  }

  /// Helper method to create a consistent date key
  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  DateTime addCurrentDate(DateTime currentDate, DateTime todayWithoutTime,
      List<DateTime> allDates) {
    while (!currentDate.isAfter(todayWithoutTime)) {
      allDates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }
    return currentDate;
  }

  DataGridRow constructFilledRow(
      Map<String, List<TeamGroup>> teamsByDay, String dateKey, DateTime day) {
    List<TeamGroup> dayTeams = teamsByDay[dateKey]!;
    Map<String, double> dogDistances = {};

    for (TeamGroup dayTeam in dayTeams) {
      for (Team team in dayTeam.teams) {
        for (DogPair dogPair in team.dogPairs) {
          if (dogPair.firstDog != null) {
            String dogName = dogPair.firstDog!.name;
            dogDistances[dogName] =
                (dogDistances[dogName] ?? 0) + dayTeam.distance;
          }
          if (dogPair.secondDog != null) {
            String dogName = dogPair.secondDog!.name;
            dogDistances[dogName] =
                (dogDistances[dogName] ?? 0) + dayTeam.distance;
          }
        }
      }
    }

    DataGridRow row = DataGridRow(
      cells: <DataGridCell>[
        DataGridCell(
            columnName: dateColumnName, value: _formatDateForDisplay(day)),
        ...dogs.map(
          (dog) => DataGridCell(
            columnName: dog.name,
            value: dogDistances[dog.name] ?? 0,
          ),
        )
      ],
    );
    return row;
  }

  DataGridRow constructEmptyRow(DateTime day) {
    DataGridRow row = DataGridRow(
      cells: <DataGridCell>[
        DataGridCell(
            columnName: dateColumnName, value: _formatDateForDisplay(day)),
        ...dogs.map(
          (dog) => DataGridCell(
            columnName: dog.name,
            value: 0.0,
          ),
        )
      ],
    );
    return row;
  }

  /// Helper method to format date for display
  String _formatDateForDisplay(DateTime date) {
    // You can customize this format based on your preferences
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}

class GridRowProcessorResult {
  /// All of the rows, already injected with te monthly summaries
  final List<DataGridRow> dataGridRows;

  /// The grand total kms ran by each dog;
  final Map<String, double> dogGrandTotals;

  GridRowProcessorResult(
      {required this.dataGridRows, required this.dogGrandTotals});
}
