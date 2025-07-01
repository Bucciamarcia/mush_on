import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/home_page/provider.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models/dog.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/services/models/tasks.dart';
import 'package:mush_on/services/riverpod/tags.dart';
import 'package:mush_on/shared/distance_warning_widget/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'riverpod.g.dart';
part 'riverpod.freezed.dart';

@freezed

/// Just a class that contains all the riverpod results that Homepage needs
abstract class HomePageRiverpodResults with _$HomePageRiverpodResults {
  const factory HomePageRiverpodResults({
    required DogsWithWarnings dogsWithWarnings,
    required List<Dog> dogs,
    required TasksInMemory tasks,
  }) = _HomePageRiverpodResults;
}

@riverpod

/// Just for the home page
Stream<HomePageRiverpodResults> homePageRiverpod(Ref ref) async* {
  var dww = await ref.watch(dogsWithWarningsProvider.future);
  var dogs = await ref.watch(dogsProvider.future);
  var tasks = await ref.watch(tasksProvider(null).future);
  yield HomePageRiverpodResults(
      dogsWithWarnings: dww, dogs: dogs, tasks: tasks);
}

@riverpod

/// Simply returns the dogs with warnigns and errors, no other info.
Stream<DogsWithWarnings> dogsWithWarnings(Ref ref) async* {
  List<Dog> dogs = await ref.watch(dogsProvider.future);
  var distanceWarnings = await ref.watch(distanceWarningsProvider.future);
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
  for (var event
      in healthEvents.where((e) => e.isOngoing && e.preventFromRunning)) {
    final dog = dogs.getDogFromId(event.dogId);
    if (dog != null) fatalDogs.add(dog);
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
