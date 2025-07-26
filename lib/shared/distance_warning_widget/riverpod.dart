import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/services/models/settings/settings.dart';
import 'package:mush_on/services/riverpod/teamgroup.dart';
import 'package:mush_on/teams_history/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@freezed

/// A class that holds a distance warning for a single dog. It means that dog X has warning Y right now.
abstract class DogDistanceWarning with _$DogDistanceWarning {
  const factory DogDistanceWarning({
    /// The dog that has this warning.
    required Dog dog,

    /// The distance warning that triggered this dog warning.
    required DistanceWarning distanceWarning,

    /// How many km this dog has run in the distanceWarning period (must be > distance warning km).
    required double distanceRan,
  }) = _DogDistanceWarning;
}

@riverpod

/// A list of distance warnings for dogs that ran too much.
Stream<List<DogDistanceWarning>> distanceWarnings(Ref ref,
    {DateTime? latestDate}) async* {
  // Watch the providers to get automatic updates
  final dogsAsync = await ref.watch(dogsProvider.future);
  final settingsAsync = await ref.watch(settingsProvider.future);
  final finalDate = latestDate ?? DateTimeUtils.today();

  // Calculate earliest date needed
  final earliestDate = _calculateEarliestDate(dogsAsync, settingsAsync);

  // Get the teams stream
  final teamGroups = await ref.watch(
      teamGroupsProvider(earliestDate: earliestDate, finalDate: finalDate)
          .future);
  // Listen to the teams stream and process warnings for each update
  yield await _processWarnings(
      teamGroups.toSet(), dogsAsync, settingsAsync, ref);
}

Future<List<DogDistanceWarning>> _processWarnings(
  Set<TeamGroup> teams,
  List<Dog> dogs,
  SettingsModel settings,
  Ref ref,
) async {
  final List<DogDistanceWarning> allWarnings = [];

  // Process global warnings
  allWarnings.addAll(await _processGlobalWarnings(teams, dogs, settings, ref));

  // Process dog-specific warnings
  allWarnings.addAll(await _processDogSpecificWarnings(teams, dogs, ref));

  return allWarnings;
}

Future<List<DogDistanceWarning>> _processDogSpecificWarnings(
  Set<TeamGroup> teams,
  List<Dog> dogs,
  Ref ref,
) async {
  final List<DogDistanceWarning> warnings = [];

  for (final dog in dogs) {
    for (final warning in dog.distanceWarnings) {
      final dogWarning = await _checkWarning(dog, warning, teams, ref);
      if (dogWarning != null) {
        warnings.add(dogWarning);
      }
    }
  }

  return warnings;
}

Future<DogDistanceWarning?> _checkWarning(
  Dog dog,
  DistanceWarning warning,
  Set<TeamGroup> teams,
  Ref ref,
) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final cutoffDate = today.subtract(Duration(days: warning.daysInterval));

  final distanceRan = await _calculateDogDistance(dog, cutoffDate, teams, ref);

  if (distanceRan > warning.distance) {
    return DogDistanceWarning(
      dog: dog,
      distanceWarning: warning,
      distanceRan: distanceRan,
    );
  }

  return null;
}

Future<double> _calculateDogDistance(
  Dog dog,
  DateTime cutoffDate,
  Set<TeamGroup> teams,
  Ref ref,
) async {
  double totalDistance = 0;

  for (final teamGroup in teams) {
    if (teamGroup.date.isAfter(cutoffDate) ||
        teamGroup.date.isAtSameMomentAs(cutoffDate)) {
      // Check if dog is in this team group
      bool dogFound = false;

      List<Team> teams =
          await ref.watch(teamsInTeamgroupProvider(teamGroup.id).future);
      for (final team in teams) {
        List<DogPair> dogPairs = await ref
            .watch(dogPairsInTeamProvider(teamGroup.id, team.id).future);
        for (final pair in dogPairs) {
          if (pair.firstDogId == dog.id || pair.secondDogId == dog.id) {
            totalDistance += teamGroup.distance;
            dogFound = true;
            break;
          }
        }
        if (dogFound) break;
      }
    }
  }

  return totalDistance;
}

Future<List<DogDistanceWarning>> _processGlobalWarnings(
  Set<TeamGroup> teams,
  List<Dog> dogs,
  SettingsModel settings,
  Ref ref,
) async {
  final List<DogDistanceWarning> warnings = [];

  // Pre-calculate distances for all unique warning periods
  final distancesByPeriod = <int, Map<String, double>>{};
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Get unique warning periods
  final uniquePeriods =
      settings.globalDistanceWarnings.map((w) => w.daysInterval).toSet();

  // Calculate distances for each period
  for (final days in uniquePeriods) {
    final cutoff = today.subtract(Duration(days: days));
    distancesByPeriod[days] = await _buildDogDistanceMap(cutoff, teams, ref);
  }

  // Check warnings using pre-calculated distances
  for (final warning in settings.globalDistanceWarnings) {
    final distances = distancesByPeriod[warning.daysInterval]!;

    for (final dog in dogs) {
      final distanceRan = distances[dog.id] ?? 0;
      if (distanceRan > warning.distance) {
        warnings.add(DogDistanceWarning(
          dog: dog,
          distanceWarning: warning,
          distanceRan: distanceRan,
        ));
      }
    }
  }

  return warnings;
}

Future<Map<String, double>> _buildDogDistanceMap(
  DateTime cutoff,
  Set<TeamGroup> teams,
  Ref ref,
) async {
  final distanceMap = <String, double>{};

  for (final teamGroup in teams) {
    if (teamGroup.date.isAfter(cutoff) ||
        teamGroup.date.isAtSameMomentAs(cutoff)) {
      final dogsInGroup = <String>{};

      // Collect all unique dogs in this group
      List<Team> teams =
          await ref.watch(teamsInTeamgroupProvider(teamGroup.id).future);
      for (final team in teams) {
        List<DogPair> dogPairs = await ref
            .watch(dogPairsInTeamProvider(teamGroup.id, team.id).future);
        for (final pair in dogPairs) {
          if (pair.firstDogId != null && pair.firstDogId!.isNotEmpty) {
            dogsInGroup.add(pair.firstDogId!);
          }
          if (pair.secondDogId != null && pair.secondDogId!.isNotEmpty) {
            dogsInGroup.add(pair.secondDogId!);
          }
        }
      }

      // Add distance once per dog
      for (final dogId in dogsInGroup) {
        distanceMap[dogId] = (distanceMap[dogId] ?? 0) + teamGroup.distance;
      }
    }
  }

  return distanceMap;
}

DateTime _calculateEarliestDate(List<Dog> dogs, SettingsModel settings) {
  final earliestGlobalDate = _buildEarliestGlobalDate(settings);
  final earliestDogDate = _buildEarliestDogDate(dogs);

  return earliestGlobalDate.isBefore(earliestDogDate)
      ? earliestGlobalDate
      : earliestDogDate;
}

DateTime _buildEarliestDogDate(List<Dog> dogs) {
  int maxInterval = 0;

  for (final dog in dogs) {
    if (dog.distanceWarnings.isEmpty) continue;

    final sortedWarnings = List<DistanceWarning>.from(dog.distanceWarnings)
      ..sort((a, b) => b.daysInterval.compareTo(a.daysInterval));

    if (sortedWarnings.first.daysInterval > maxInterval) {
      maxInterval = sortedWarnings.first.daysInterval;
    }
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return today.subtract(Duration(days: maxInterval));
}

DateTime _buildEarliestGlobalDate(SettingsModel settings) {
  if (settings.globalDistanceWarnings.isEmpty) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  final sortedWarnings =
      List<DistanceWarning>.from(settings.globalDistanceWarnings)
        ..sort((a, b) => b.daysInterval.compareTo(a.daysInterval));

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final longestDaysInterval = sortedWarnings.first.daysInterval;

  return today.subtract(Duration(days: longestDaysInterval));
}
