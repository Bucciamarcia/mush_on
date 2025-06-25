import 'package:flutter/foundation.dart';
import 'package:mush_on/provider.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mush_on/services/models/teamgroup.dart';

class HomePageProvider extends ChangeNotifier {
  final MainProvider _mainProvider;

  /// The main provider.
  MainProvider get mainProvider => _mainProvider;

  DogsWithWarnings _dogsWithWarnings = DogsWithWarnings();

  /// Dogs with warnings for display.
  /// It's private and exposed via a getter to prevent direct modification.
  DogsWithWarnings get dogsWithWarnings => _dogsWithWarnings;

  bool _isLoading = false;

  /// Flag to indicate if warnings are being calculated.
  bool get isLoading => _isLoading;

  HomePageProvider(this._mainProvider) {
    // Initial fetch of warning dogs when the provider is created.
    _getWarningDogs();
  }

  /// Refreshes the warning dogs data. Can be called from the UI to re-run the check.
  Future<void> refreshWarningDogs() async {
    await _getWarningDogs();
  }

  /// Main method to fetch data and calculate which dogs have distance warnings.
  /// It updates the state at the end.
  Future<void> _getWarningDogs() async {
    _isLoading = true;
    notifyListeners();

    // Determine the furthest date back we need to look for team data.
    final DateTime earliestWarningDate = _getEarliestWarningDate();

    // Fetch all relevant team history from Firestore since that date.
    final Set<TeamGroup> teamsAfterEarliestWarning =
        await _fetchTeamsAfter(earliestWarningDate);

    final Set<String> warningDogIds = {};
    final Set<String> fatalDogIds = {};

    // Process global and dog-specific warnings to populate the ID sets.
    _processAllWarnings(
      teams: teamsAfterEarliestWarning,
      warningDogIds: warningDogIds,
      fatalDogIds: fatalDogIds,
    );

    // Using the populated ID sets, create lists of the actual Dog objects.
    final List<Dog> warningDogs = [];
    final List<Dog> fatalDogs = [];

    for (final dog in _mainProvider.dogs) {
      if (fatalDogIds.contains(dog.id)) {
        fatalDogs.add(dog);
      } else if (warningDogIds.contains(dog.id)) {
        // A dog with a fatal warning shouldn't also be in the regular warning list.
        warningDogs.add(dog);
      }
    }

    // Update the state with the new lists.
    _dogsWithWarnings =
        DogsWithWarnings(warning: warningDogs, fatal: fatalDogs);
    _isLoading = false;
    notifyListeners();
  }

  /// Combines the logic from `_buildEarliestGlobalDate` and `_buildEarliestDogDate`.
  DateTime _getEarliestWarningDate() {
    int maxInterval = 0;

    // Find the longest interval from global warnings
    for (final warning in _mainProvider.settings.globalDistanceWarnings) {
      if (warning.daysInterval > maxInterval) {
        maxInterval = warning.daysInterval;
      }
    }

    // Find the longest interval from all dog-specific warnings
    for (final dog in _mainProvider.dogs) {
      for (final warning in dog.distanceWarnings) {
        if (warning.daysInterval > maxInterval) {
          maxInterval = warning.daysInterval;
        }
      }
    }

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    return today.subtract(Duration(days: maxInterval));
  }

  /// Fetches team history from Firestore after a given cutoff date.
  /// Replaces `_getTeamsAfterEarliestWarning`.
  Future<Set<TeamGroup>> _fetchTeamsAfter(DateTime cutOff) async {
    // This assumes you have a way to get the current user's account ID.
    // Replace with your actual implementation if it differs.
    final String account = _mainProvider.account; // Example
    final FirebaseFirestore db = FirebaseFirestore.instance;

    Query<Map<String, dynamic>> ref = db
        .collection("accounts/$account/data/teams/history")
        .where("date", isGreaterThanOrEqualTo: cutOff);

    try {
      final results = await ref.get();
      return results.docs.map((doc) => TeamGroup.fromJson(doc.data())).toSet();
    } catch (e) {
      // Handle potential Firestore errors
      debugPrint("Error fetching teams: $e");
      return {};
    }
  }

  /// Processes both global and dog-specific warnings efficiently.
  void _processAllWarnings({
    required Set<TeamGroup> teams,
    required Set<String> warningDogIds,
    required Set<String> fatalDogIds,
  }) {
    final List<DistanceWarning> globalWarnings =
        _mainProvider.settings.globalDistanceWarnings;
    final List<Dog> allDogs = _mainProvider.dogs;
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    // Collect all unique time intervals from both global and dog-specific warnings
    final Set<int> uniqueIntervals = {};
    for (final warning in globalWarnings) {
      uniqueIntervals.add(warning.daysInterval);
    }
    for (final dog in allDogs) {
      for (final warning in dog.distanceWarnings) {
        uniqueIntervals.add(warning.daysInterval);
      }
    }

    // Pre-calculate distance maps for each unique interval to avoid redundant calculations.
    final Map<int, Map<String, double>> distancesByInterval = {};
    for (final int days in uniqueIntervals) {
      final DateTime cutoff = today.subtract(Duration(days: days));
      distancesByInterval[days] = _buildDogDistanceMap(cutoff, teams);
    }

    // --- Check Global Warnings ---
    for (final warning in globalWarnings) {
      final Map<String, double> distances =
          distancesByInterval[warning.daysInterval]!;
      for (final dog in allDogs) {
        final double distanceRan = distances[dog.id] ?? 0;
        if (distanceRan > warning.distance) {
          if (warning.distanceWarningType == DistanceWarningType.soft) {
            warningDogIds.add(dog.id);
          } else {
            fatalDogIds.add(dog.id);
          }
        }
      }
    }

    // --- Check Dog-Specific Warnings ---
    for (final dog in allDogs) {
      for (final warning in dog.distanceWarnings) {
        final Map<String, double> distances =
            distancesByInterval[warning.daysInterval]!;
        final double distanceRan = distances[dog.id] ?? 0;

        if (distanceRan > warning.distance) {
          if (warning.distanceWarningType == DistanceWarningType.soft) {
            warningDogIds.add(dog.id);
          } else {
            fatalDogIds.add(dog.id);
          }
        }
      }
    }
  }

  /// Builds a map of {dogId: totalDistance} for all dogs run since a cutoff date.
  /// This is a highly efficient way to calculate distances for multiple dogs at once.
  Map<String, double> _buildDogDistanceMap(
      DateTime cutoff, Set<TeamGroup> teamGroups) {
    final Map<String, double> distanceMap = {};

    for (final teamGroup in teamGroups) {
      if (!teamGroup.date.isBefore(cutoff)) {
        final Set<String> dogsInGroup = {};
        // Collect all unique dogs in this team run
        for (final team in teamGroup.teams) {
          for (final pair in team.dogPairs) {
            if (pair.firstDogId != null && pair.firstDogId!.isNotEmpty) {
              dogsInGroup.add(pair.firstDogId!);
            }
            if (pair.secondDogId != null && pair.secondDogId!.isNotEmpty) {
              dogsInGroup.add(pair.secondDogId!);
            }
          }
        }
        // Add the distance of this run to each dog that participated.
        for (final dogId in dogsInGroup) {
          distanceMap[dogId] = (distanceMap[dogId] ?? 0) + teamGroup.distance;
        }
      }
    }
    return distanceMap;
  }
}

/// A simple data class to hold categorized lists of dogs with warnings.
class DogsWithWarnings {
  final List<Dog> warning;
  final List<Dog> fatal;

  DogsWithWarnings({List<Dog>? warning, List<Dog>? fatal})
      : warning = warning ?? [],
        fatal = fatal ?? [];
}
