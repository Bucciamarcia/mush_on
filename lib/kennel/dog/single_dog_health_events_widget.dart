import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mush_on/health/display_cards/health_event.dart';
import 'package:mush_on/health/display_cards/heat_cycle.dart';
import 'package:mush_on/health/display_cards/vaccination.dart';
import 'package:mush_on/health/models.dart';
import 'package:mush_on/shared/text_title.dart';

import 'riverpod.dart';
part 'single_dog_health_events_widget.freezed.dart';

class SingleDogHealthEventsWidget extends ConsumerWidget {
  final String dogId;
  const SingleDogHealthEventsWidget({super.key, required this.dogId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<SingleDogHealthEvent> events =
        _getSingleDogHealthEvents(dogId: dogId, ref: ref);

    return Column(
      children: [
        const Align(
          alignment: Alignment.topCenter,
          child: TextTitle("Health events"),
        ),
        ...events.map(
          (e) => DisplaySingleEvent(event: e),
        ),
      ],
    );
  }

  DateTime _getCreatedAt(SingleDogHealthEvent event) {
    switch (event) {
      case HealthEventWrapper(event: final e):
        return e.createdAt;
      case VaccinationWrapper(event: final e):
        return e.createdAt;
      case HeatCycleWrapper(event: final e):
        return e.createdAt;
    }
  }

  List<SingleDogHealthEvent> _getSingleDogHealthEvents(
      {required String dogId, required WidgetRef ref}) {
    List<HealthEvent> healthEvents =
        ref.watch(dogHealthEventsProvider(dogId: dogId, cutoff: null)).value ??
            [];
    List<Vaccination> vaccinations =
        ref.watch(dogVaccinationsProvider(dogId: dogId, cutoff: null)).value ??
            [];
    List<HeatCycle> heats =
        ref.watch(dogHeatsProvider(dogId: dogId, cutoff: null)).value ?? [];
    List<SingleDogHealthEvent> events = [
      ...healthEvents.map((h) => SingleDogHealthEvent.healthEvent(h)),
      ...vaccinations.map((v) => SingleDogHealthEvent.vaccination(v)),
      ...heats.map((h) => SingleDogHealthEvent.heat(h)),
    ];
    events.sort((a, b) => _getCreatedAt(b).compareTo(_getCreatedAt(a)));
    return events;
  }
}

class DisplaySingleEvent extends StatelessWidget {
  final SingleDogHealthEvent event;
  const DisplaySingleEvent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    switch (event) {
      case HealthEventWrapper(event: final e):
        return HealthEventDisplayCard(event: e);
      case VaccinationWrapper(event: final e):
        return VaccinationDisplayCard(event: e);
      case HeatCycleWrapper(event: final e):
        return HeatCycleDisplayCard(event: e);
    }
  }
}

@freezed

/// Union type class that only allows events related to the health of a dog.
sealed class SingleDogHealthEvent with _$SingleDogHealthEvent {
  const factory SingleDogHealthEvent.healthEvent(HealthEvent event) =
      HealthEventWrapper;
  const factory SingleDogHealthEvent.vaccination(Vaccination event) =
      VaccinationWrapper;
  const factory SingleDogHealthEvent.heat(HeatCycle event) = HeatCycleWrapper;
}
