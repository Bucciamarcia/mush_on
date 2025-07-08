import 'package:intl/intl.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/teamgroup.dart';
import 'package:mush_on/stats/group_summary.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../services/models.dart';
import 'constants.dart';
import 'daily_dog_stats.dart';

class GridRowProcessor {
  static final BasicLogger logger = BasicLogger();
  List<TeamGroup> teams;
  List<Dog> dogs;
  DateTime startDate;
  DateTime finishDate;
  GridRowProcessor(
      {required this.teams,
      required this.dogs,
      required this.startDate,
      required this.finishDate});
  GridRowProcessorResult run() {
    Map<String, Dog> dogsMap = _generateDogsMap();
    // Get daily aggregated data
    List<DailyDogStats> aggregatedStats =
        _aggregateData(dogsMap, startDate, finishDate);

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

  Map<String, Dog> _generateDogsMap() {
    Map<String, Dog> toReturn = {};
    for (Dog dog in dogs) {
      toReturn.addAll({dog.id: dog});
    }
    return toReturn;
  }

  List<DailyDogStats> _aggregateData(
      Map<String, Dog> dogsMap, DateTime startDate, DateTime finishDate) {
    List<DailyDogStats> toReturn = [];
    Map<String, List<TeamGroup>> teamsByDay = getTeamsByDay();
    DateTime startDateOrBeginning = findOldestDate(startDate);

    List<DateTime> allDates = [];

    addCurrentDate(startDateOrBeginning, finishDate, allDates);

    allDates.sort((a, b) =>
        b.compareTo(a)); // Should now correctly have Apr 2 00:00 first

    for (DateTime day in allDates) {
      String dateKey = _formatDateKey(day);
      bool hasData = teamsByDay.containsKey(dateKey); // Check containsKey

      if (hasData) {
        List<TeamGroup>? dayTeams = teamsByDay[dateKey];
        // Add a null check just to be absolutely sure
        if (dayTeams == null) {
          continue; // Skip this day if something went very wrong
        }

        Map<String, double> dogDistances = {};
        try {
          // Add try-catch to catch potential errors in inner loops
          for (TeamGroup dayTeam in dayTeams) {
            for (Team team in dayTeam.teams) {
              for (DogPair dogPair in team.dogPairs) {
                if (dogPair.firstDogId != null) {
                  dogDistances[dogPair.firstDogId!] =
                      (dogDistances[dogPair.firstDogId!] ?? 0) +
                          dayTeam.distance;
                }
                if (dogPair.secondDogId != null) {
                  dogDistances[dogPair.secondDogId!] =
                      (dogDistances[dogPair.secondDogId!] ?? 0) +
                          dayTeam.distance;
                }
              }
            }
          }
          // If calculation succeeded, print before adding
          toReturn.add(DailyDogStats(date: day, distances: dogDistances));
        } catch (e, s) {
          logger.error("!!!! EXCEPTION during processing for $dateKey !!!!",
              error: e, stackTrace: s);
        }
      } else {
        // Print entry into the 'else' block for the first iteration
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
      dayStats.distances.forEach((dogId, distance) {
        if (dogTotals.containsKey(dogId)) {
          dogTotals[dogId] = dogTotals[dogId]! + distance;
        }
      });
    }
    return dogTotals;
  }

  List<MonthSummary> calculateMonthlySummaries(
      List<DailyDogStats> dailyDogStats) {
    // Outer key: DateTime representing the month (e.g., 2025-03-01)
    // Inner key: Dog ID (String)
    // Inner value: Accumulated distance (double)
    Map<DateTime, Map<String, double>> monthlyTotals = {};

    // Helper to initialize totals for a new month

    for (DailyDogStats dayStats in dailyDogStats) {
      DateTime monthYear = DateTime(dayStats.date.year, dayStats.date.month);

      // Get or create the map for the current month
      Map<String, double> currentMonthTotals =
          monthlyTotals.putIfAbsent(monthYear, _createEmptyDogTotalsMap);

      // Add current day's distances to the monthly totals
      dayStats.distances.forEach((dogId, distance) {
        if (currentMonthTotals.containsKey(dogId)) {
          currentMonthTotals[dogId] = currentMonthTotals[dogId]! + distance;
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
    return {for (var dog in dogs) dog.id: 0.0};
  }

  Map<String, double> _getEmptyDistanceRow() {
    Map<String, double> toReturn = {};
    for (Dog dog in dogs) {
      toReturn.putIfAbsent(dog.id, () => 0);
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
        logger.warning("Missing summary for month $monthKey");
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
          double total = monthSummary.distances[dog.id] ?? 0.0;
          return DataGridCell<double>(columnName: dog.id, value: total);
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
            double distance = dayStat.distances[dog.id] ?? 0.0;
            return DataGridCell<double>(columnName: dog.id, value: distance);
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

  /// Finds the oldest date for the list of teamgroups.
  /// If no teams exist, defaults to 30 days.
  DateTime findOldestDate(DateTime oldestDate) {
    DateTime oldestTeamGroup = calculateOldestTeamGroup(teams);

    if (oldestTeamGroup.isAfter(oldestDate)) {
      return oldestTeamGroup;
    } else {
      return oldestDate;
    }
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
    currentDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    while (!currentDate.isAfter(todayWithoutTime)) {
      allDates.add(currentDate); // Add the normalized date (e.g., 00:00:00)

      // Increment first, THEN normalize to avoid DST time shifts messing up the day
      DateTime nextDayIncrement = currentDate.add(Duration(days: 1));
      currentDate = DateTime(nextDayIncrement.year, nextDayIncrement.month,
          nextDayIncrement.day); // Re-normalize to midnight
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
          if (dogPair.firstDogId != null) {
            String dogId = dogPair.firstDogId!;
            dogDistances[dogId] = (dogDistances[dogId] ?? 0) + dayTeam.distance;
          }
          if (dogPair.secondDogId != null) {
            String dogId = dogPair.secondDogId!;
            dogDistances[dogId] = (dogDistances[dogId] ?? 0) + dayTeam.distance;
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
            columnName: dog.id,
            value: dogDistances[dog.id] ?? 0,
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
            columnName: dog.id,
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

DateTime calculateOldestTeamGroup(List<TeamGroup> teams) {
  DateTime oldestTeamGroup = DateTime.now().toUtc();
  for (TeamGroup team in teams) {
    // Strip time information, keep just the date
    final dateWithoutTime =
        DateTime(team.date.year, team.date.month, team.date.day);
    if (dateWithoutTime.isBefore(oldestTeamGroup)) {
      oldestTeamGroup = dateWithoutTime;
    }
  }
  return oldestTeamGroup;
}
