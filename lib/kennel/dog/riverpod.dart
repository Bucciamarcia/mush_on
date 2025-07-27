import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/kennel/dog/dog_photo_card.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/riverpod/teamgroup.dart';
import 'package:mush_on/services/storage.dart';
import 'package:mush_on/teams_history/riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';

@riverpod
Stream<Dog> singleDog(Ref ref, String dogId) async* {
  String account = await ref.read(accountProvider.future);
  var db = FirebaseFirestore.instance;
  String path = "accounts/$account/data/kennel/dogs/$dogId";
  yield* db.doc(path).snapshots().map(
        (snapshot) => Dog.fromJson(
          snapshot.data() ?? {},
        ),
      );
}

@riverpod
class SingleDogImage extends _$SingleDogImage {
  // The build method now directly returns the future.
  // The state is automatically managed by AsyncNotifier.
  @override
  Future<Uint8List?> build(String account, String dogId) async {
    return await DogPhotoCardUtils(id: dogId, account: account).getImage();
  }

  // A public method to handle the image edit.
  // It optimistically updates the state or handles errors.
  Future<void> editImage({required File file}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      DogPhotoCardUtils utils =
          DogPhotoCardUtils(id: dogId, account: this.account); // Correct
      String extension = path.extension(file.path);

      await utils.deleteCurrentImage();
      await StorageService().uploadFromFile(
          file: file,
          path: "accounts/${this.account}/dogs/$dogId/image$extension");

      // Your excellent optimistic update
      return file.readAsBytesSync();
    });
  }

  // A public method to handle image deletion.
  Future<void> deleteImage() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await DogPhotoCardUtils(id: dogId, account: this.account)
          .deleteCurrentImage();
      // After deleting, the state becomes null (no image).
      return null;
    });
  }
}

@riverpod

/// Gets the run totals for a single dog in the specified period.
///
/// Defaults to 30 days.
@riverpod
Stream<List<DogTotal>> dogTotal(
  Ref ref, {
  required String dogId,
  DateTime? cutoff,
}) async* {
  final effectiveCutoff =
      cutoff ?? DateTime.now().subtract(const Duration(days: 30));

  final teamGroups = await ref.watch(
    teamGroupsProvider(earliestDate: effectiveCutoff, finalDate: null).future,
  );

  final Map<DateTime, double> ranByDay = {};

  for (final teamGroup in teamGroups) {
    final date = DateTime.utc(
        teamGroup.date.year, teamGroup.date.month, teamGroup.date.day);
    double distance = 0.0;

    List<Team> teams =
        await ref.watch(teamsInTeamgroupProvider(teamGroup.id).future);
    bool isDogInTeam = false;
    for (final team in teams) {
      try {
        // Now you can safely await inside the loop
        List<DogPair> dogPairs = await ref
            .watch(dogPairsInTeamProvider(teamGroup.id, team.id).future);

        if (dogPairs.any(
            (pair) => pair.firstDogId == dogId || pair.secondDogId == dogId)) {
          isDogInTeam = true;
          // Exit the loop early since we found the dog, mimicking .any() behavior
          break;
        }
      } catch (e, s) {
        BasicLogger()
            .error("Couldn't get dogpairs in dog", error: e, stackTrace: s);
        // Continue to the next team if this one fails
        continue;
      }
    }

    if (isDogInTeam) {
      distance = teamGroup.distance;
    }

    ranByDay.update(date, (value) => value + distance,
        ifAbsent: () => distance);
  }

  final result = ranByDay.entries.map((entry) {
    return DogTotal(date: entry.key, distance: entry.value);
  }).toList();

  result.sort((a, b) => a.date.compareTo(b.date));

  yield result;
}
