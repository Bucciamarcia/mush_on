import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mush_on/create_team/models.dart';
import 'package:mush_on/create_team/riverpod.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/riverpod.dart';
import 'package:mush_on/services/models.dart';
import 'package:mush_on/services/models/settings/distance_warning.dart';
import 'package:mush_on/shared/distance_warning_widget/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'dog_notes.g.dart';

@riverpod
List<DogNote> dogNotes(Ref ref) {
  final dogs = ref.watch(dogsProvider).value ?? [];
  final distanceWarnings =
      ref.watch(distanceWarningsProvider(latestDate: null)).value ?? [];
  final duplicateDogs = ref.watch(duplicateDogsProvider);

  final dogNotesMap = <String, DogNote>{};

  // Process distance warnings
  for (final warning in distanceWarnings) {
    final noteType =
        warning.distanceWarning.distanceWarningType == DistanceWarningType.soft
            ? DogNoteType.distanceWarning
            : DogNoteType.distanceError;

    final details = "${warning.distanceRan.toStringAsFixed(0)}/"
        "${warning.distanceWarning.distance}km "
        "${warning.distanceWarning.daysInterval}d";

    dogNotesMap.update(
      warning.dog.id,
      (existing) => existing.copyWith(
        dogNoteMessage: [
          ...existing.dogNoteMessage,
          DogNoteMessage(type: noteType, details: details),
        ],
      ),
      ifAbsent: () => DogNote(
        dogId: warning.dog.id,
        dogNoteMessage: [DogNoteMessage(type: noteType, details: details)],
      ),
    );
  }

  // Process duplicate dogs
  for (final dogId in duplicateDogs) {
    dogNotesMap.update(
      dogId,
      (existing) => existing.copyWith(
        dogNoteMessage: [
          ...existing.dogNoteMessage,
          DogNoteMessage(type: DogNoteType.duplicate),
        ],
      ),
      ifAbsent: () => DogNote(
        dogId: dogId,
        dogNoteMessage: [DogNoteMessage(type: DogNoteType.duplicate)],
      ),
    );
  }

  // Process tags (errors and notes)
  for (final dog in dogs) {
    for (final tag in dog.tags.available) {
      if (tag.preventFromRun == true) {
        dogNotesMap.update(
          dog.id,
          (existing) => existing.copyWith(
            dogNoteMessage: [
              ...existing.dogNoteMessage,
              DogNoteMessage(type: DogNoteType.tagPreventing, details: tag.name)
            ],
          ),
          ifAbsent: () => DogNote(
            dogId: dog.id,
            dogNoteMessage: [
              DogNoteMessage(type: DogNoteType.tagPreventing, details: tag.name)
            ],
          ),
        );
      }
      if (tag.showInTeamBuilder == true) {
        dogNotesMap.update(
          dog.id,
          (existing) => existing.copyWith(dogNoteMessage: [
            ...existing.dogNoteMessage,
            DogNoteMessage(
                type: DogNoteType.showTagInBuilder, details: tag.name)
          ]),
          ifAbsent: () => DogNote(
            dogId: dog.id,
            dogNoteMessage: [
              DogNoteMessage(
                  type: DogNoteType.showTagInBuilder, details: tag.name)
            ],
          ),
        );
      }
    }
  }

  // Process health events
  List<HealthEvent>? healthEvents = ref.watch(healthEventsProvider(365)).value;
  if (healthEvents != null) {
    for (final event in healthEvents.active) {
      if (event.preventFromRunning == true) {
        dogNotesMap.update(
          event.dogId,
          (existing) => existing.copyWith(
            dogNoteMessage: [
              ...existing.dogNoteMessage,
              DogNoteMessage(
                  type: DogNoteType.healthEventError, details: event.title),
            ],
          ),
          ifAbsent: () => DogNote(
            dogId: event.dogId,
            dogNoteMessage: [
              DogNoteMessage(
                  type: DogNoteType.healthEventError, details: event.title),
            ],
          ),
        );
      }
    }
  }

  // Process heats
  List<HeatCycle> heatCycles = ref.watch(heatCyclesProvider(60)).value ?? [];
  for (final heat in heatCycles.active) {
    if (heat.preventFromRunning == true) {
      dogNotesMap.update(
        heat.dogId,
        (existing) => existing.copyWith(
          dogNoteMessage: [
            ...existing.dogNoteMessage,
            DogNoteMessage(
              type: DogNoteType.heat,
              details: DateFormat("dd-MM-yyyy").format(heat.startDate),
            ),
          ],
        ),
        ifAbsent: () => DogNote(
          dogId: heat.dogId,
          dogNoteMessage: [
            DogNoteMessage(
              type: DogNoteType.heat,
              details: DateFormat("dd-MM-yyyy").format(heat.startDate),
            ),
          ],
        ),
      );
    } else {
      dogNotesMap.update(
        heat.dogId,
        (existing) => existing.copyWith(
          dogNoteMessage: [
            ...existing.dogNoteMessage,
            DogNoteMessage(
              type: DogNoteType.heatLight,
            ),
          ],
        ),
        ifAbsent: () => DogNote(
          dogId: heat.dogId,
          dogNoteMessage: [
            DogNoteMessage(
              type: DogNoteType.heatLight,
            ),
          ],
        ),
      );
    }
  }

  return dogNotesMap.values.toList();
}
