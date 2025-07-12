import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mush_on/services/error_handling.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/extensions.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/services/riverpod/tags.dart';
import 'package:mush_on/shared/distance_warning_widget/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import 'models.dart';
part 'riverpod.g.dart';

@riverpod

/// Just for the home page
Stream<HomePageRiverpodResults> homePageRiverpod(Ref ref) async* {
  BasicLogger().debug("Creating home page riverpod provider with rxDart");
  yield* Rx.combineLatest6(
      dogsWithWarnings(ref),
      dogs(ref),
      tasks(ref, null),
      healthEvents(ref, null),
      heatCycles(ref, null),
      todayWhiteboard(ref), (a, b, c, d, e, f) {
    return HomePageRiverpodResults(
        dogsWithWarnings: a,
        dogs: b,
        tasks: c,
        healthEvents: d,
        heatCycles: e,
        whiteboardElements: f);
  });
}

@riverpod

/// Streams the list of today's whiteboard elements from the db.
Stream<List<WhiteboardElement>> todayWhiteboard(Ref ref) async* {
  String account = await ref.watch(accountProvider.future);
  String path = "accounts/$account/data/homePage/whiteboardElements";
  final db = FirebaseFirestore.instance;
  var dbRef = db
      .collection(path)
      .where("date", isEqualTo: DateTimeUtils.today())
      .orderBy("title", descending: false);
  yield* dbRef.snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => WhiteboardElement.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );
}

@riverpod

/// Simply returns the dogs with warnigns and errors, no other info.
Stream<DogsWithWarnings> dogsWithWarnings(Ref ref) async* {
  List<Dog> dogs = await ref.watch(dogsProvider.future);
  var distanceWarnings = await ref.watch(
      distanceWarningsProvider(latestDate: DateTimeUtils.today()).future);
  var dogsWithBlockingTags =
      await ref.watch(dogsWithBlockingTagsProvider.future);
  var healthEvents = await ref.watch(healthEventsProvider(null).future);
  var heatCycles = await ref.watch(heatCyclesProvider(null).future);

  // Use Sets to avoid duplicates automatically
  final warningDogs = <Dog>{};
  final fatalDogs = <Dog>{};

  // Distance warnings
  for (final warning in distanceWarnings) {
    if (warning.distanceWarning.distanceWarningType ==
        DistanceWarningType.soft) {
      warningDogs.add(warning.dog);
    } else {
      fatalDogs.add(warning.dog);
    }
  }

  // Blocking tags
  fatalDogs.addAll(dogsWithBlockingTags);

  // Active health events that prevent running
  for (var event in healthEvents.active
      .where((e) => e.isOngoing && e.preventFromRunning)) {
    final dog = dogs.getDogFromId(event.dogId);
    if (dog != null) fatalDogs.add(dog);
  }

  for (var heat in heatCycles.active) {
    final dog = dogs.getDogFromId(heat.dogId);
    if (heat.preventFromRunning == true && dog != null) {
      fatalDogs.add(dog);
    } else if (heat.preventFromRunning == false && dog != null) {
      warningDogs.add(dog);
    }
  }

  // Active heat cycles that prevent running
  for (var heat
      in heatCycles.where((h) => h.endDate == null && h.preventFromRunning)) {
    final dog = dogs.getDogFromId(heat.dogId);
    if (dog != null) fatalDogs.add(dog);
  }

  yield DogsWithWarnings(
    warning: warningDogs.toList(),
    fatal: fatalDogs.toList(),
  );
}

/// A simple data class to hold categorized lists of dogs with warnings.
class DogsWithWarnings {
  final List<Dog> warning;
  final List<Dog> fatal;

  DogsWithWarnings({List<Dog>? warning, List<Dog>? fatal})
      : warning = warning ?? [],
        fatal = fatal ?? [];

  void add(DogsWithWarningAddType type, Dog dog) {
    switch (type) {
      case DogsWithWarningAddType.warning:
        warning.add(dog);
      case DogsWithWarningAddType.fatal:
        fatal.add(dog);
    }
  }
}

enum DogsWithWarningAddType { warning, fatal }
