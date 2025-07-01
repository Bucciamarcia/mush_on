import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/services/firestore.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/services/models/teamgroup.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import 'services/models/settings/distance_warning.dart';
part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@Riverpod(keepAlive: true)
Future<String> account(Ref ref) async {
  String account = await FirestoreService().getUserAccount();
  return account;
}

@Riverpod(keepAlive: true)
Stream<SettingsModel> settings(Ref ref) async* {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/settings";
  var doc = FirebaseFirestore.instance.doc(path);
  yield* doc.snapshots().map((snapshot) {
    if (snapshot.data() != null) {
      return SettingsModel.fromJson(snapshot.data()!);
    } else {
      return SettingsModel();
    }
  });
}

@Riverpod(keepAlive: true)
Stream<List<Task>> tasksWithExpiration(Ref ref, int? days) async* {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/misc/tasks";
  var collection = FirebaseFirestore.instance.collection(path);
  yield* collection
      .where("expiration",
          isGreaterThanOrEqualTo:
              DateTime.now().subtract(Duration(days: days ?? 30)))
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((t) => Task.fromJson(t.data())).toList());
}

@Riverpod(keepAlive: true)
Stream<List<Task>> tasksNoExpiration(Ref ref) async* {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/misc/tasks";
  var collection = FirebaseFirestore.instance.collection(path);
  yield* collection.where("expiration", isNull: true).snapshots().map(
      (snapshot) => snapshot.docs.map((t) => Task.fromJson(t.data())).toList());
}

@Riverpod(keepAlive: true)
Stream<TasksInMemory> tasks(Ref ref, int? days) async* {
  final account = await ref.watch(accountProvider.future);
  final path = "accounts/$account/data/misc/tasks";
  final collection = FirebaseFirestore.instance.collection(path);

  // Query 1: Tasks with an expiration date
  final expirationStream = collection
      .where(
        "expiration",
        isGreaterThanOrEqualTo:
            DateTime.now().subtract(Duration(days: days ?? 30)),
      )
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((t) => Task.fromJson(t.data())).toList());

  // Query 2: Tasks with no expiration date
  final noExpirationStream = collection
      .where("expiration", isNull: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((t) => Task.fromJson(t.data())).toList());

  // Combine the latest results from both streams
  yield* Rx.combineLatest2(
    expirationStream,
    noExpirationStream,
    (List<Task> withExp, List<Task> noExp) {
      final combined = [...withExp, ...noExp]
        ..sort((a, b) => a.title.compareTo(b.title));

      return TasksInMemory(
        tasks: combined,
        oldestFetched: DateTime.now().subtract(Duration(days: days ?? 30)),
        noExpirationFetched: true,
      );
    },
  );
}

@Riverpod(keepAlive: true)
Stream<List<Dog>> dogs(Ref ref) async* {
  var db = FirebaseFirestore.instance;
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/kennel/dogs";
  var query = db.collection(path).orderBy("name");
  yield* query.snapshots().map(
      (snapshot) => snapshot.docs.map((d) => Dog.fromJson(d.data())).toList());
}

@riverpod
Stream<DogsWithWarnings> warningDogs(Ref ref) async* {
  // 1. Depend on and await your data providers
  final List<Dog> allDogs = await ref.watch(dogsProvider.future);
  final SettingsModel settings = await ref.watch(settingsProvider.future);
  final String account = await ref.watch(accountProvider.future);

  // 2. Determine the furthest date back we need to look for team data.
  final DateTime earliestWarningDate = _getEarliestWarningDate(
    allDogs: allDogs,
    settings: settings,
  );

  // 3. Fetch all relevant team history from Firestore since that date.
  final Set<TeamGroup> teamsAfterEarliestWarning = await _fetchTeamsAfter(
    earliestWarningDate,
    account,
  );

  // 4. Initialize ID sets to store unique dog IDs with warnings
  final Set<String> warningDogIds = {};
  final Set<String> fatalDogIds = {};

  // 5. Process distance warnings (this now populates the ID sets)
  _processDistanceWarnings(
    teams: teamsAfterEarliestWarning,
    warningDogIds: warningDogIds,
    fatalDogIds: fatalDogIds,
    allDogs: allDogs,
    settings: settings,
  );

  // 6. NEW: Process blocking tags (restores missing functionality)
  _processTagWarnings(
    allDogs: allDogs,
    fatalDogIds: fatalDogIds,
  );

  // 7. Using the populated ID sets, create the final lists of Dog objects.
  final List<Dog> warningDogs = [];
  final List<Dog> fatalDogs = [];

  for (final dog in allDogs) {
    // A dog with a fatal warning should not also be in the regular warning list.
    if (fatalDogIds.contains(dog.id)) {
      fatalDogs.add(dog);
    } else if (warningDogIds.contains(dog.id)) {
      warningDogs.add(dog);
    }
  }

  // 8. Return the final, correctly assembled state.
  yield DogsWithWarnings(warning: warningDogs, fatal: fatalDogs);
}

// --- Helper Functions (Pure and Testable) ---

/// Processes both global and dog-specific distance warnings.
/// This function MUTATES the ID sets, which is the same pattern as the original provider.
void _processDistanceWarnings({
  required Set<TeamGroup> teams,
  required List<Dog> allDogs,
  required SettingsModel settings,
  required Set<String> warningDogIds, // Mutated
  required Set<String> fatalDogIds, // Mutated
}) {
  final List<DistanceWarning> globalWarnings = settings.globalDistanceWarnings;
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);

  final Set<int> uniqueIntervals = {};
  for (final warning in globalWarnings) {
    uniqueIntervals.add(warning.daysInterval);
  }
  for (final dog in allDogs) {
    for (final warning in dog.distanceWarnings) {
      uniqueIntervals.add(warning.daysInterval);
    }
  }

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
      final double distanceRan = distances[dog.id] ?? 0.0;
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
      final double distanceRan = distances[dog.id] ?? 0.0;
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

/// Processes dog tags to find any that prevent running.
void _processTagWarnings({
  required List<Dog> allDogs,
  required Set<String> fatalDogIds, // Mutated
}) {
  for (final dog in allDogs) {
    for (final tag in dog.tags) {
      if (tag.preventFromRun) {
        fatalDogIds.add(dog.id);
        break; // Move to the next dog once a fatal tag is found
      }
    }
  }
}

DateTime _getEarliestWarningDate(
    {required List<Dog> allDogs, required SettingsModel settings}) {
  int maxInterval = 0;
  // Find the longest interval from global warnings
  for (final warning in settings.globalDistanceWarnings) {
    if (warning.daysInterval > maxInterval) {
      maxInterval = warning.daysInterval;
    }
  }

  // Find the longest interval from all dog-specific warnings
  for (final dog in allDogs) {
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
Future<Set<TeamGroup>> _fetchTeamsAfter(DateTime cutOff, String account) async {
  // This assumes you have a way to get the current user's account ID.
  // Replace with your actual implementation if it differs.
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Query<Map<String, dynamic>> ref = db
      .collection("accounts/$account/data/teams/history")
      .where("date", isGreaterThanOrEqualTo: cutOff);

  try {
    final results = await ref.get();
    return results.docs.map((doc) => TeamGroup.fromJson(doc.data())).toSet();
  } catch (e) {
    // Handle potential Firestore errors
    return {};
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

/// A simple data class to hold categorized lists of dogs with warnings.
@freezed
abstract class DogsWithWarnings with _$DogsWithWarnings {
  const factory DogsWithWarnings({
    @Default([]) List<Dog> warning,
    @Default([]) List<Dog> fatal,
  }) = _DogsWithWarnings;
}

enum DogsWithWarningAddType { warning, fatal }
